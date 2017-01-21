//
//  CCStoreReceiptVerifyRequest_objc.h
//  HelloCpp
//
//  Created by 陈欢 on 13-10-31.
//
//

#ifndef __HelloCpp__CCStoreReceiptVerifyRequest_objc__
#define __HelloCpp__CCStoreReceiptVerifyRequest_objc__

#import <StoreKit/StoreKit.h>
#import "CCStore_objc.h"

#include "cocos2d.h"
#include "cocos-ext.h"

USING_NS_CC_EXT;

class CCStoreReceiptVerifyRequest_objc : public cocos2d::CCObject
{
public:
    static CCStoreReceiptVerifyRequest_objc* create(CCStore_objc* store,
                                                    SKPaymentTransaction* transaction,
                                                    const char* url);
    ~CCStoreReceiptVerifyRequest_objc(void);
    
    CCHttpRequest* getRequest(void) {
        return m_request;
    }
    
    SKPaymentTransaction* getTransaction(void) {
        return m_transaction;
    }
    
//    virtual void requestFinished();
//    virtual void requestFailed();
    
private:
    bool init(CCStore_objc* store,
              SKPaymentTransaction* transaction,
              const char* url);
    
    CCStore_objc*           m_store;
    CCHttpRequest*          m_request;
    SKPaymentTransaction*   m_transaction;
};

#endif /* defined(__HelloCpp__CCStoreReceiptVerifyRequest_objc__) */
