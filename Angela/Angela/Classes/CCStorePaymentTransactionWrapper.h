//
//  CCStorePaymentTransactionWrapper.h
//  HelloCpp
//
//  Created by 陈欢 on 13-10-31.
//
//

#ifndef HelloCpp_CCStorePaymentTransactionWrapper_h
#define HelloCpp_CCStorePaymentTransactionWrapper_h

class CCStorePaymentTransactionWrapper
{
public:
    static CCStorePaymentTransactionWrapper* createWithTransaction(void* transactionObj);
    ~CCStorePaymentTransactionWrapper(void);
    
    void* getTransactionObj(void)
    {
        return m_transactionObj;
    }
    
private:
    CCStorePaymentTransactionWrapper(void)
    : m_transactionObj(NULL)
    {
    }
    
    void* m_transactionObj;
    
};

#endif
