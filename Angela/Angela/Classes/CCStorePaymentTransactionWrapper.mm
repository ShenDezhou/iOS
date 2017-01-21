//
//  CCStorePaymentTransactionWrapper.c
//  HelloCpp
//
//  Created by 陈欢 on 13-10-31.
//
//

#import <StoreKit/StoreKit.h>
#include "CCStorePaymentTransactionWrapper.h"

CCStorePaymentTransactionWrapper* CCStorePaymentTransactionWrapper::createWithTransaction(void* transactionObj)
{
    CCStorePaymentTransactionWrapper* transaction = new CCStorePaymentTransactionWrapper();
    transaction->m_transactionObj = transactionObj;
    [(SKPaymentTransaction *)transactionObj retain];
    return transaction;
}

CCStorePaymentTransactionWrapper::~CCStorePaymentTransactionWrapper(void)
{
    [(SKPaymentTransaction *)m_transactionObj release];
}