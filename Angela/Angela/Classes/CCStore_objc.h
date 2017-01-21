//
//  CCStore_objc.h
//  HelloCpp
//
//  Created by 陈欢 on 13-10-31.
//
//

#ifndef __HelloCpp__CCStore_objc__
#define __HelloCpp__CCStore_objc__

#import <StoreKit/StoreKit.h>

#include "CCStore.h"
#include "CCStoreProductsRequestDelegate.h"
#include "support/base64.h"

class CCStoreReceiptVerifyRequest_objc;

@interface CCStore_objc : NSObject < SKPaymentTransactionObserver, SKProductsRequestDelegate >
{
    CCStoreIsSandbox isSandbox_;
    CCStoreReceiptVerifyMode receiptVerifyMode_;
    NSString *receiptVerifyServerUrl_;
    
    CCStoreTransactionDelegate *transactionDelegate_;
    CCStoreProductsRequestDelegate *productRequestDelegate_;
    NSMutableDictionary *loadedProducts_;
    SKProductsRequest *productRequest_;
}

@property (nonatomic, assign) CCStoreIsSandbox isSandbox;
@property (nonatomic, assign) CCStoreReceiptVerifyMode receiptVerifyMode;
@property (nonatomic, retain) NSString *receiptVerifyServerUrl;

#pragma mark -
#pragma mark init

+ (CCStore_objc *)sharedStore;
+ (void)purgeSharedStore;
- (id)init;
- (void)postInitWithTransactionDelegate:(CCStoreTransactionDelegate *)delegate;

#pragma mark -
#pragma mark Making a Purchase

- (BOOL)canMakePurchases;
- (void)purchase:(SKProduct *)product;
- (void)finishTransaction:(SKPaymentTransaction *)transaction;

#pragma mark -
#pragma mark Retrieving Product Information

- (void)requestProductData:(NSSet *)productsId andDelegate:(CCStoreProductsRequestDelegate *)delegate;
- (void)cancelRequestProductData;
- (BOOL)isProductLoaded:(NSString *)productId;
- (SKProduct *)getProduct:(NSString *)productId;
- (void)cleanCachedProducts;

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response;
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error;

#pragma mark -
#pragma mark Handling Transactions

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions;
- (void)transactionCompleted:(SKPaymentTransaction *)transaction andReceiptVerifyStatus:(int)receiptVerifyStatus;
- (void)transactionFailed:(SKPaymentTransaction *)transaction andReceiptVerifyStatus:(int)receiptVerifyStatus;
- (void)transactionRestored:(SKPaymentTransaction *)transaction andReceiptVerifyStatus:(int)receiptVerifyStatus;

#pragma mark -
#pragma mark Verifying Store Receipts

- (void)verifyTransactionReceipt:(SKPaymentTransaction *)transaction;

/* CCStoreReceiptVerifyRequest_objc */
- (void)verifyReceiptRequestFinished:(SKPaymentTransaction *)transaction ResponseStirng:(NSString *)responseString;
- (void)verifyReceiptRequestFailed:(SKPaymentTransaction *)transaction;

#pragma mark -
#pragma mark helper

- (CCStorePaymentTransaction *)createCCStorePaymentTransaction:(SKPaymentTransaction *)transaction
                                        andReceiptVerifyStatus:(int)receiptVerifyStatus;
@end

#endif /* defined(__HelloCpp__CCStore_objc__) */
