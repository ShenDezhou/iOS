//
//  CCStoreReceiptVerifyRequest_objc.cpp
//  HelloCpp
//
//  Created by 陈欢 on 13-10-31.
//
//

#include "CCStoreReceiptVerifyRequest_objc.h"

CCStoreReceiptVerifyRequest_objc* CCStoreReceiptVerifyRequest_objc::create(CCStore_objc* store,
                                                                           SKPaymentTransaction* transaction,
                                                                           const char* url)
{
    CCStoreReceiptVerifyRequest_objc* handler = new CCStoreReceiptVerifyRequest_objc();
    handler->init(store, transaction, url);
    handler->autorelease();
    handler->retain();
    return handler;
}

bool CCStoreReceiptVerifyRequest_objc::init(CCStore_objc* store,
                                            SKPaymentTransaction* transaction,
                                            const char* url)
{
    m_store = store;
    [m_store retain];
    m_transaction = transaction;
    [m_transaction retain];
    m_request = new CCHttpRequest();
    m_request->setRequestType(CCHttpRequest::kHttpPost);
    m_request->setUrl(url);
    m_request->retain();
    return true;
}

CCStoreReceiptVerifyRequest_objc::~CCStoreReceiptVerifyRequest_objc(void)
{
    [m_transaction release];
    CC_SAFE_RELEASE(m_request);
    CCLOG("~~ delete CCStoreReceiptVerifyRequest_objc");
}

//void CCStoreReceiptVerifyRequest_objc::requestFinished()
//{
//    [m_store verifyReceiptRequestFinished: this];
//    [m_store release];
//    release();
//}

//void CCStoreReceiptVerifyRequest_objc::requestFailed()
//{
//    [m_store verifyReceiptRequestFailed: this];
//    [m_store release];
//    release();
//}
