//
//  CCStore_objc.cpp
//  HelloCpp
//
//  Created by 陈欢 on 13-10-31.
//
//


#import "CCStore_objc.h"
#import "CCStoreReceiptVerifyRequest_objc.h"
#import "SBJSON.h"
#import "NSString+SBJSON.h"

#include <string>

#ifndef utf8cstr
#define utf8cstr(nsstr) (nsstr ? [nsstr cStringUsingEncoding:NSUTF8StringEncoding] : "")
#endif

@implementation CCStore_objc

static CCStore_objc *s_sharedStore;
static const char* const APPSTORE_RECEIPT_VERIFY_URL = "https://buy.itunes.apple.com/verifyReceipt";
static const char* const SANDBOX_RECEIPT_VERIFY_URL = "https://sandbox.itunes.apple.com/verifyReceipt";

@synthesize isSandbox = isSandbox_;
@synthesize receiptVerifyMode = receiptVerifyMode_;
@synthesize receiptVerifyServerUrl = receiptVerifyServerUrl_;

#pragma mark -
#pragma mark init

+ (CCStore_objc *)sharedStore
{
    if (!s_sharedStore)
    {
        s_sharedStore = [[CCStore_objc alloc] init];
    }
    return s_sharedStore;
}

+ (void) purgeSharedStore
{
    if (s_sharedStore)
    {
        [s_sharedStore release];
    }
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        loadedProducts_ = [NSMutableDictionary dictionaryWithCapacity:50];
        [loadedProducts_ retain];
        receiptVerifyMode_ = CCStoreReceiptVerifyModeNone;
    }
    return self;
}

- (void)dealloc
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    [loadedProducts_ release];
    [productRequest_ release];
    [super dealloc];
    s_sharedStore = NULL;
}

- (void)postInitWithTransactionDelegate:(CCStoreTransactionDelegate *)delegate
{
    transactionDelegate_ = delegate;
}

#pragma mark -
#pragma mark Making a Purchase

- (BOOL)canMakePurchases
{
    return [SKPaymentQueue canMakePayments];
}

- (void)purchase:(SKProduct *)product
{
    CCLOG("[CCStore_obj] purchase() pid: %s", utf8cstr(product.productIdentifier));
    [[SKPaymentQueue defaultQueue] addPayment:[SKPayment paymentWithProduct:product]];
}

- (void)finishTransaction:(SKPaymentTransaction *)transaction
{
    CCLOG("[CCStore_obj] finishTransaction() tid: %s",  utf8cstr(transaction.transactionIdentifier));
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

#pragma mark -
#pragma mark Retrieving Product Information

- (void) requestProductData:(NSSet *)productsId andDelegate:(CCStoreProductsRequestDelegate *)delegate
{
    if (productRequest_)
    {
        delegate->requestProductsFailed(CCStoreProductsRequestErrorPreviousRequestNotCompleted,
                                        "CCStoreProductsRequestErrorPreviousRequestNotCompleted");
        return;
    }
    
#if COCOS2D_DEBUG > 0
    for (id productId in productsId)
    {
        CCLOG("[CCStore_obj] requestProductData() pid: %s", utf8cstr(productId));
    }
#endif
    
    productRequestDelegate_ = delegate;
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:productsId];
    request.delegate = self;
    [request autorelease];
    [request start];
    productRequest_ = request;
}

- (void)cancelRequestProductData
{
    if (productRequest_)
    {
        [productRequest_ cancel];
        productRequest_ = nil;
        productRequestDelegate_->requestProductsFailed(CCStoreProductsRequestErrorCancelled,
                                                       "CCStoreProductsRequestErrorCancelled");
        productRequestDelegate_ = nil;
    }
}

- (BOOL)isProductLoaded:(NSString *)productId
{
    return [loadedProducts_ objectForKey:productId] != nil;
}

- (SKProduct *)getProduct:(NSString *)productId
{
    return [loadedProducts_ objectForKey:productId];
}

- (void)cleanCachedProducts
{
    [loadedProducts_ removeAllObjects];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    cocos2d::CCArray* ccproducts = cocos2d::CCArray::createWithCapacity(response.products.count);
    for (int i = 0; i < response.products.count; ++i)
    {
        // cache loaded product
        SKProduct* product = [response.products objectAtIndex:i];
        [loadedProducts_ setObject:product forKey:product.productIdentifier];
        
        // convert SKProduct to CCStoreProduct
        CCStoreProduct* ccproduct = CCStoreProduct::productWithId(utf8cstr(product.productIdentifier),
                                                                  utf8cstr(product.localizedTitle),
                                                                  utf8cstr(product.localizedDescription),
                                                                  [product.price floatValue],
                                                                  utf8cstr(product.priceLocale.localeIdentifier));
        ccproducts->addObject(ccproduct);
        CCLOG("[CCStore_obj] productsRequestDidReceiveResponse() get pid: %s", utf8cstr(product.productIdentifier));
    }
    
    cocos2d::CCArray* ccinvalidProductsId = NULL;
    if (response.invalidProductIdentifiers.count > 0)
    {
        ccinvalidProductsId = cocos2d::CCArray::createWithCapacity(response.invalidProductIdentifiers.count);
        for (int i = 0; i < response.invalidProductIdentifiers.count; ++i)
        {
            NSString* productId = [response.invalidProductIdentifiers objectAtIndex:i];
            cocos2d::CCString* ccid = new cocos2d::CCString(utf8cstr(productId));
            ccid->autorelease();
            ccinvalidProductsId->addObject(ccid);
            CCLOG("[CCStore_obj] productsRequestDidReceiveResponse() invalid pid: %s", utf8cstr(productId));
        }
    }
    
    request.delegate = nil;
    productRequest_ = nil;
    productRequestDelegate_->requestProductsCompleted(ccproducts, ccinvalidProductsId);
    productRequestDelegate_ = NULL;
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    request.delegate = nil;
    productRequest_ = nil;
    productRequestDelegate_->requestProductsFailed(error.code, utf8cstr(error.localizedDescription));
    productRequestDelegate_ = NULL;
}

#pragma mark -
#pragma mark Handling Transactions

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (int i = 0; i < [transactions count]; ++i)
    {
        SKPaymentTransaction *transaction = [transactions objectAtIndex:i];
        if (transaction.transactionState != SKPaymentTransactionStatePurchasing)
        {
            CCLOG("[CCStore_obj] paymentQueueUpdatedTransactions() tid: %s",
                  utf8cstr(transaction.transactionIdentifier));
        }
        
        /**
         enum {
         SKPaymentTransactionStatePurchasing,
         SKPaymentTransactionStatePurchased,
         SKPaymentTransactionStateFailed,
         SKPaymentTransactionStateRestored
         };
         typedef NSInteger SKPaymentTransactionState;
         
         SKPaymentTransactionStatePurchasing:
         The transaction is being processed by the App Store.
         
         SKPaymentTransactionStatePurchased:
         The App Store successfully processed payment. Your application should provide
         the content the user purchased.
         
         SKPaymentTransactionStateFailed:
         The transaction failed. Check the error property to determine what happened.
         
         SKPaymentTransactionStateRestored:
         This transaction restores content previously purchased by the user.
         Read the originalTransaction property to obtain information about the original purchase.
         */
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                CCLOG("transaction '%s' SKPaymentTransactionStatePurchased",
                      [transaction.transactionIdentifier cStringUsingEncoding:NSUTF8StringEncoding]);
                if (receiptVerifyMode_ != CCStoreReceiptVerifyModeNone)
                {
                    [self verifyTransactionReceipt:transaction];
                }
                else
                {
                    [self transactionCompleted:transaction andReceiptVerifyStatus:CCStoreReceiptVerifyStatusNone];
                }
                break;
            case SKPaymentTransactionStateFailed:
                CCLOG("transaction '%s' SKPaymentTransactionStateFailed",
                      [transaction.transactionIdentifier cStringUsingEncoding:NSUTF8StringEncoding]);
                CCLOG("error: %s",
                      [[transaction.error localizedDescription] cStringUsingEncoding:NSUTF8StringEncoding]);
                [self transactionFailed:transaction andReceiptVerifyStatus:CCStoreReceiptVerifyStatusNone];
                break;
            case SKPaymentTransactionStateRestored:
                CCLOG("transaction '%s' SKPaymentTransactionStateRestored",
                      [transaction.transactionIdentifier cStringUsingEncoding:NSUTF8StringEncoding]);
                [self transactionRestored:transaction andReceiptVerifyStatus:CCStoreReceiptVerifyStatusNone];
                break;
        }
    }
}
- (void)transactionCompleted:(SKPaymentTransaction *)transaction
      andReceiptVerifyStatus:(int)receiptVerifyStatus
{
    transactionDelegate_->transactionCompleted([self createCCStorePaymentTransaction:transaction
                                                              andReceiptVerifyStatus:receiptVerifyStatus]);
}

- (void)transactionFailed:(SKPaymentTransaction *)transaction
   andReceiptVerifyStatus:(int)receiptVerifyStatus
{
    transactionDelegate_->transactionFailed([self createCCStorePaymentTransaction:transaction
                                                           andReceiptVerifyStatus:receiptVerifyStatus]);
}

- (void)transactionRestored:(SKPaymentTransaction *)transaction
     andReceiptVerifyStatus:(int)receiptVerifyStatus;
{
    transactionDelegate_->transactionRestored([self createCCStorePaymentTransaction:transaction
                                                             andReceiptVerifyStatus:receiptVerifyStatus]);
}

#pragma mark -
#pragma mark Verifying Store Receipts

- (void)verifyTransactionReceipt:(SKPaymentTransaction *)transaction
{
    if (transaction.transactionState != SKPaymentTransactionStatePurchased) return;
    
    CCLOG("[CCStore_obj] verifyTransactionReceipt() tid: %s", utf8cstr(transaction.transactionIdentifier));
    
    // convert receipt to JSON string
//    int length = [transaction.transactionReceipt length];
//    unsigned char *buffer = NULL;
//    int dataUsed = cocos2d::base64Decode((unsigned char *)[transaction.transactionReceipt bytes], length,&buffer);
//    if (dataUsed <= 0)
//    {
//        [self transactionCompleted:transaction andReceiptVerifyStatus:CCStoreReceiptVerifyStatusUnknownError];
//        return;
//    }
//
//	NSDictionary* data = [NSDictionary dictionaryWithObjectsAndKeys:
//                          [NSString stringWithUTF8String:buffer],
//                          @"receipt-data",
//                          nil];
//
//    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
//    NSString *postData = [writer stringWithObject:data];
//    [writer release];
//    
//    // create request
//    const char* url = isSandbox_ ? SANDBOX_RECEIPT_VERIFY_URL : APPSTORE_RECEIPT_VERIFY_URL;
//    CCStoreReceiptVerifyRequest_objc* handler = CCStoreReceiptVerifyRequest_objc::create(self,transaction,url);
//    
//    handler->getRequest()->addRequestHeader("Content-Type", "application/json");
//    handler->getRequest()->setPostData([postData cStringUsingEncoding:NSUTF8StringEncoding]);
//    handler->getRequest()->start();
//    
    NSString *encodingStr = [transaction.transactionReceipt base64Encoding];
    if ([encodingStr length] <= 0)
    {
        [self transactionCompleted:transaction andReceiptVerifyStatus:CCStoreReceiptVerifyStatusUnknownError];
        return;
    }
    
    const char *url = isSandbox_ ? SANDBOX_RECEIPT_VERIFY_URL : APPSTORE_RECEIPT_VERIFY_URL;
    NSString *URL = [NSString stringWithUTF8String:url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];// autorelease];
    [request setURL:[NSURL URLWithString:URL]];
    [request setHTTPMethod:@"POST"];
    //设置contentType
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%d", [encodingStr length]] forHTTPHeaderField:@"Content-Length"];
    
    NSDictionary* body = [NSDictionary dictionaryWithObjectsAndKeys:encodingStr, @"receipt-data", nil];
    SBJsonWriter *writer = [SBJsonWriter new];
    [request setHTTPBody:[[writer stringWithObject:body] dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]];
    NSHTTPURLResponse *urlResponse=nil;
    NSError *errorr=nil;
    NSData *receivedData = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&urlResponse
                                                             error:&errorr];
    
    //解析
    NSString *results=[[NSString alloc]initWithBytes:[receivedData bytes] length:[receivedData length] encoding:NSUTF8StringEncoding];
    if ([results length] <= 0)
    {
        [self transactionCompleted:transaction andReceiptVerifyStatus:CCStoreReceiptVerifyStatusUnknownError];
        return;
    }
    [self verifyReceiptRequestFinished:transaction ResponseStirng:results];
}

- (void)verifyReceiptRequestFinished:(SKPaymentTransaction *)transaction ResponseStirng:(NSString *)responseString
{
    NSDictionary *jsonData = [responseString JSONValue];
    // check result
    if (jsonData == nil)
    {
        // invalid JSON string
        [self transactionFailed:transaction andReceiptVerifyStatus:CCStoreReceiptVerifyStatusInvalidResult];
    }
    else if ([[jsonData objectForKey:@"status"] intValue] == 0)
    {
        // status is ok, do more checks
        BOOL isValidReceipt = NO;
        /**
         AppStore receipt format, 2013-11-7:
         
        {
            "receipt":{
                "original_purchase_date_pst":"2013-11-07 00:01:30 America/Los_Angeles",
                "purchase_date_ms":"1383811290033",
                "unique_identifier":"2b725b1e297212567c7208856b5f31307ea17479",
                "original_transaction_id":"1000000092515054",
                "bvrs":"1.0",
                "transaction_id":"1000000092515054",
                "quantity":"1",
                "unique_vendor_identifier":"13BBF202-C0B2-4E65-8CB1-4A484C8DAA03",
                "item_id":"734264885",
                "product_id":"gwsoft.legendring.one",
                "purchase_date":"2013-11-07 08:01:30 Etc/GMT",
                "original_purchase_date":"2013-11-07 08:01:30 Etc/GMT",
                "purchase_date_pst":"2013-11-07 00:01:30 America/Los_Angeles",
                "bid":"gwsoft.legendring",
                "original_purchase_date_ms":"1383811290033"
            },
            "status":0
         }
         */
        do
        {
            NSDictionary *receiptData = [jsonData objectForKey:@"receipt"];
            if (receiptData == nil)
            {
                break;
            }
            
            //            SKPaymentTransaction *transaction = transaction;
            NSString *transactionId = [receiptData objectForKey:@"transaction_id"];
            if (!transactionId || [transaction.transactionIdentifier compare:transactionId] != NSOrderedSame)
            {
                // check failed
                break;
            }
            
            NSString *productIdentifier = [receiptData objectForKey:@"product_id"];
            if (!productIdentifier || [transaction.payment.productIdentifier compare:productIdentifier] != NSOrderedSame)
            {
                break;
            }
            
            // receipt is valid
            isValidReceipt = YES;
        } while (NO);
        
        if (isValidReceipt)
        {
            [self transactionCompleted:transaction
                andReceiptVerifyStatus:CCStoreReceiptVerifyStatusOK];
        }
        else
        {
            [self transactionFailed:transaction
             andReceiptVerifyStatus:CCStoreReceiptVerifyStatusInvalidReceipt];
        }
    }
    else
    {
        [self transactionFailed:transaction
         andReceiptVerifyStatus:[[jsonData objectForKey:@"status"] intValue]];
    }
}

- (void)verifyReceiptRequestFailed:(SKPaymentTransaction *)transaction
{
    [self transactionFailed:transaction andReceiptVerifyStatus:CCStoreReceiptVerifyStatusRequestFailed];
}


#pragma mark -
#pragma mark helper

- (CCStorePaymentTransaction *)createCCStorePaymentTransaction:(SKPaymentTransaction *)transaction
                                        andReceiptVerifyStatus:(int)receiptVerifyStatus
{
    CCStorePaymentTransactionWrapper* transactionWapper
    ;
    transactionWapper
    = CCStorePaymentTransactionWrapper::createWithTransaction(transaction);
    
    const char *ccid        = utf8cstr(transaction.transactionIdentifier);
    const char *ccproductId = utf8cstr(transaction.payment.productIdentifier);
    int quantity            = transaction.payment.quantity;
    double dateTime         = [transaction.transactionDate timeIntervalSince1970];
    int receiptDataLength   = 0;
    const void *receiptData = NULL;
    int errorCode           = 0;
    const char *errorDescription = NULL;
    
    CCStorePaymentTransactionState ccstate = CCStorePaymentTransactionStateNull;
    switch (transaction.transactionState)
    {
        case SKPaymentTransactionStateFailed:
            errorCode = transaction.error.code;
            /**
             enum {
             SKErrorUnknown,
             SKErrorClientInvalid,       // client is not allowed to issue the request, etc.
             SKErrorPaymentCancelled,    // user cancelled the request, etc.
             SKErrorPaymentInvalid,      // purchase identifier was invalid, etc.
             SKErrorPaymentNotAllowed    // this device is not allowed to make the payment
             };
             */
            if (errorCode == SKErrorPaymentCancelled)
            {
                ccstate = CCStorePaymentTransactionStateCancelled;
            }
            else
            {
                ccstate = CCStorePaymentTransactionStateFailed;
            }
            errorDescription = utf8cstr(transaction.error.localizedDescription);
            break;
        case SKPaymentTransactionStatePurchased:
            ccstate = CCStorePaymentTransactionStatePurchased;
            receiptDataLength = transaction.transactionReceipt.length;
            receiptData = transaction.transactionReceipt.bytes;
            break;
        case SKPaymentTransactionStatePurchasing:
            ccstate = CCStorePaymentTransactionStatePurchasing;
            break;
        case SKPaymentTransactionStateRestored:
            ccstate = CCStorePaymentTransactionStateRestored;
    }
    
    if (transaction.originalTransaction)
    {
        CCStorePaymentTransaction *ccoriginalTransaction;
        ccoriginalTransaction = [self createCCStorePaymentTransaction:transaction.originalTransaction
                                               andReceiptVerifyStatus:CCStoreReceiptVerifyStatusNone];
        return CCStorePaymentTransaction::transactionWithState(transactionWapper
                                                               ,
                                                               ccstate,
                                                               ccid,
                                                               ccproductId,
                                                               quantity,
                                                               dateTime,
                                                               receiptDataLength,
                                                               receiptData,
                                                               errorCode,
                                                               errorDescription,
                                                               ccoriginalTransaction,
                                                               receiptVerifyMode_,
                                                               receiptVerifyStatus);
    }
    else
    {
        return CCStorePaymentTransaction::transactionWithState(transactionWapper
                                                               ,
                                                               ccstate,
                                                               ccid,
                                                               ccproductId,
                                                               quantity,
                                                               dateTime,
                                                               receiptDataLength,
                                                               receiptData,
                                                               errorCode,
                                                               errorDescription,
                                                               NULL,
                                                               receiptVerifyMode_,
                                                               receiptVerifyStatus);
    }
}

@end

