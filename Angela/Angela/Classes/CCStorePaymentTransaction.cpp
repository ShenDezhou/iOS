//
//  CCStorePaymentTransaction.cpp
//  HelloCpp
//
//  Created by 陈欢 on 13-10-31.
//
//

#include "CCStorePaymentTransaction.h"

CCStorePaymentTransaction*
CCStorePaymentTransaction::transactionWithState(CCStorePaymentTransactionWrapper* transactionWapper,
                                                CCStorePaymentTransactionState state,
                                                const char* transactionId,
                                                const char* productId,
                                                int quantity,
                                                double dateTime,
                                                int receiptDataLength,
                                                const void* receiptData,
                                                int errorCode,
                                                const char* errorDescription,
                                                CCStorePaymentTransaction* originalTransaction,
                                                CCStoreReceiptVerifyMode receiptVerifyMode,
                                                CCStoreReceiptVerifyStatus receiptVerifyStatus)
{
    CCStorePaymentTransaction* transaction = new CCStorePaymentTransaction();
    transaction->initWithState(transactionWapper,
                               state,
                               transactionId,
                               productId,
                               quantity,
                               dateTime,
                               receiptDataLength,
                               receiptData,
                               errorCode,
                               errorDescription,
                               originalTransaction,
                               receiptVerifyMode,
                               receiptVerifyStatus);
    transaction->autorelease();
    return transaction;
}

CCStorePaymentTransaction::~CCStorePaymentTransaction(void)
{
    CC_SAFE_RELEASE(m_originalTransaction);
    if (m_receiptData)
    {
        free(m_receiptData);
    }
    if (m_transactionWapper)
    {
        delete m_transactionWapper;
    }
    
    CCLOG("~~ CCStorePaymentTransaction::~CCStorePaymentTransaction()");
}

bool CCStorePaymentTransaction::initWithState(CCStorePaymentTransactionWrapper* transactionWapper,
                                              CCStorePaymentTransactionState state,
                                              const char* transactionId,
                                              const char* productId,
                                              int quantity,
                                              double dateTime,
                                              int receiptDataLength,
                                              const void* receiptData,
                                              int errorCode,
                                              const char* errorDescription,
                                              CCStorePaymentTransaction* originalTransaction,
                                              CCStoreReceiptVerifyMode receiptVerifyMode,
                                              CCStoreReceiptVerifyStatus receiptVerifyStatus)
{
    m_transactionWapper = transactionWapper;
    m_transactionState = state;
    m_transactionIdentifier = transactionId;
    m_productIdentifier = productId;
    m_quantity = quantity;
    m_dateTime = dateTime;
    m_receiptDataLength = receiptDataLength;
    if (receiptDataLength > 0)
    {
        m_receiptData = malloc(receiptDataLength + 1);
        memset(m_receiptData, 0, receiptDataLength + 1);
        memcpy(m_receiptData, receiptData, receiptDataLength);
    }
    else
    {
        m_receiptData = NULL;
    }
    m_errorCode = errorCode;
    m_errorDescription = errorDescription ? errorDescription : "";
    m_originalTransaction = originalTransaction;
    if (m_originalTransaction)
    {
        m_originalTransaction->retain();
    }
    
    m_receiptVerifyMode = receiptVerifyMode;
    m_receiptVerifyStatus = receiptVerifyStatus;
    
    return true;
}