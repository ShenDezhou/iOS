#ifndef __HELLOWORLD_SCENE_H__
#define __HELLOWORLD_SCENE_H__

#include "cocos2d.h"
#include "CCStoreTransactionDelegate.h"
#include "CCStoreProductsRequestDelegate.h"
//#include "ShareEngineDelegate.h"

class HelloWorld : public cocos2d::CCLayer, public CCStoreTransactionDelegate, public CCStoreProductsRequestDelegate//, public ShareEngineDelegate
{
public:
    // Here's a difference. Method 'init' in cocos2d-x returns bool, instead of returning 'id' in cocos2d-iphone
    virtual bool init();  

    // there's no 'id' in cpp, so we recommend returning the class instance pointer
    static cocos2d::CCScene* scene();
    
    // a selector callback
    void menuCloseCallback(CCObject* pSender);
    //void menuSinaShareFun();
    //void menuTcShareFun();
    //void menuWeChatShareFun();
    //void menuSinaLoginOutFun();
    //void menuTcLoginOutFun();
    //void menuWeChatFriendFun();
    //void menuLoadItemFun();
    //void menuPurchaseItemFun();
    
    void testLoadProducts(CCObject* pSender);
    void testPurchase(CCObject* pSender);
    
#pragma mark -
#pragma mark CCStoreTransactionObserver
    
    virtual void transactionCompleted(CCStorePaymentTransaction* transaction);
    virtual void transactionFailed(CCStorePaymentTransaction* transaction);
    virtual void transactionRestored(CCStorePaymentTransaction* transaction);
    
#pragma mark -
#pragma mark CCStoreProductsRequestDelegate
    
    virtual void requestProductsCompleted(cocos2d::CCArray* products, cocos2d::CCArray* invalidProductsId = NULL);
    virtual void requestProductsFailed(int errorCode, const char* errorString);
    
//#pragma mark -
//#pragma mark CCStoreProductsRequestDelegate
//    virtual void shareEngineDidLogIn(WeiboType weibotype);
//    virtual void shareEngineDidLogOut(WeiboType weibotype);
//    virtual void shareEngineSendSuccess();
//    virtual void shareEngineSendFail(int errorCode, const char* errorString);
//    
//protected:
    cocos2d::CCSprite *icoSprite;
    
    cocos2d::CCString* newCCString(const char* string);
    
    // implement the "static node()" method manually
    CREATE_FUNC(HelloWorld);
};

#endif // __HELLOWORLD_SCENE_H__
