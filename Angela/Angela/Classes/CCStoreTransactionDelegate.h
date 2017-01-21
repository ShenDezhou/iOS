//
//  CCStoreTransactionDelegate.h
//  HelloCpp
//
//  Created by 陈欢 on 13-10-30.
//
//

#ifndef __HelloCpp__CCStoreTransactionDelegate__
#define __HelloCpp__CCStoreTransactionDelegate__

#include "CCStorePaymentTransaction.h"

class CCStoreTransactionDelegate
{
public:
    virtual void transactionCompleted(CCStorePaymentTransaction* transaction) = 0;
    virtual void transactionFailed(CCStorePaymentTransaction* transaction) = 0;
    virtual void transactionRestored(CCStorePaymentTransaction* transaction) = 0;
};

#endif /* defined(__HelloCpp__CCStoreTransactionDelegate__) */
