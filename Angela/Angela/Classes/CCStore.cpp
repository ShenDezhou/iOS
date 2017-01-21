//
//  CCStore.cpp
//  HelloCpp
//
//  Created by 陈欢 on 13-10-31.
//
//

#include "cocos2d.h"
#include "CCStore.h"

#import "CCStore_objc.h"


CCStore* CCStore::s_sharedStore = NULL;

CCStore* CCStore::sharedStore(void)
{
    if (!s_sharedStore)
    {
        s_sharedStore = new CCStore();
        s_sharedStore->init();
    }
    return s_sharedStore;
}

CCStore::~CCStore(void)
{
    for (CCStorePaymentTransactionsIterator it = m_transactions.begin(); it != m_transactions.end(); ++it)
    {
        it->second->release();
    }
}

bool CCStore::init(void)
{
    return true;
}

void CCStore::purgeSharedStore(void)
{
    [CCStore_objc purgeSharedStore];
    if (s_sharedStore)
    {
        delete s_sharedStore;
        s_sharedStore = NULL;
    }
}

void CCStore::postInitWithTransactionDelegate(CCStoreTransactionDelegate *delegate)
{
    m_delegate = delegate;
    [[CCStore_objc sharedStore] postInitWithTransactionDelegate:this];
}

bool CCStore::canMakePurchases(void)
{
    return [[CCStore_objc sharedStore] canMakePurchases];
}

void CCStore::loadProducts(cocos2d::CCArray* productsId, CCStoreProductsRequestDelegate* delegate)
{
    NSMutableSet* set = [NSMutableSet set];
    for (int i = 0; i < productsId->count(); ++i)
    {
        cocos2d::CCString* productId = static_cast<cocos2d::CCString*>(productsId->objectAtIndex(i));
        [set addObject:[NSString stringWithUTF8String: productId->m_sString.c_str()]];
    }
    [[CCStore_objc sharedStore] requestProductData:set andDelegate:delegate];
}

void CCStore::cancelLoadProducts(void)
{
    [[CCStore_objc sharedStore] cancelRequestProductData];
}

bool CCStore::isProductLoaded(const char* productId)
{
    if (!productId) return false;
    return [[CCStore_objc sharedStore] isProductLoaded:[NSString stringWithUTF8String:productId]];
}

bool CCStore::purchase(const char* productId)
{
    if (!productId) return false;
    SKProduct *product = [[CCStore_objc sharedStore] getProduct:[NSString stringWithUTF8String:productId]];
    if (product)
    {
        [[CCStore_objc sharedStore] purchase:product];
        return true;
    }
    return false;
}

void CCStore::finishTransaction(CCStorePaymentTransaction *transaction)
{
    CCStorePaymentTransactionWrapper* wrapper = transaction->getTransactionWrapper();
    [[CCStore_objc sharedStore] finishTransaction:(SKPaymentTransaction *)wrapper->getTransactionObj()];
    CCStorePaymentTransactionsIterator it = m_transactions.find(transaction->getTransactionIdentifier());
    if (it != m_transactions.end())
    {
        it->second->release();
        m_transactions.erase(it);
    }
}

CCStoreReceiptVerifyMode CCStore::getReceiptVerifyMode(void)
{
    return [CCStore_objc sharedStore].receiptVerifyMode;
}

void CCStore::setReceiptVerifyMode(CCStoreReceiptVerifyMode mode, CCStoreIsSandbox isSandbox)
{
    [CCStore_objc sharedStore].receiptVerifyMode = mode;
    [CCStore_objc sharedStore].isSandbox = isSandbox;
}

const char* CCStore::getReceiptVerifyServerUrl(void)
{
    return [[CCStore_objc sharedStore].receiptVerifyServerUrl cStringUsingEncoding:NSUTF8StringEncoding];
}

void CCStore::setReceiptVerifyServerUrl(const char* url)
{
    [CCStore_objc sharedStore].receiptVerifyServerUrl = [NSString stringWithUTF8String:url];
}

#pragma mark -
#pragma mark delegates

void CCStore::transactionCompleted(CCStorePaymentTransaction* transaction)
{
    m_transactions[transaction->getTransactionIdentifier()] = transaction;
    transaction->retain();
    
    if (m_delegate)
    {
        m_delegate->transactionCompleted(transaction);
    }
}

void CCStore::transactionFailed(CCStorePaymentTransaction* transaction)
{
    m_transactions[transaction->getTransactionIdentifier()] = transaction;
    transaction->retain();
    
    if (m_delegate)
    {
        m_delegate->transactionFailed(transaction);
    }
}

void CCStore::transactionRestored(CCStorePaymentTransaction* transaction)
{
    m_transactions[transaction->getTransactionIdentifier()] = transaction;
    transaction->retain();
    
    if (m_delegate)
    {
        m_delegate->transactionRestored(transaction);
    }
}

