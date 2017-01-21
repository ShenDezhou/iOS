#ifndef __UserPay_H__
#define __UserPay_H__
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
#include "cocos2d.h"
#include "CCStoreTransactionDelegate.h"
#include "CCStoreProductsRequestDelegate.h"
#include "Scenes.h"

NS_CC_BEGIN

class UserPay :	public CCLayer, public CCStoreTransactionDelegate, public CCStoreProductsRequestDelegate
{
public:
	CCSpriteBatchNode *_batchNodes;
    CCLabelTTF*  _price;
	CCMenu* menu;
	CCArray* products;
    // there's no 'id' in cpp, so we recommend returning the class instance pointer
     static cocos2d::CCScene* scene();
     // Here's a difference. Method 'init' in cocos2d-x returns bool, instead of returning 'id' in cocos2d-iphone
    virtual bool init();
 
    void basicSetup();
	void addPlayers();
    //void choose(int level);
	void levelButtonTapped(CCObject* obj) ;
	//void update(float delta);
	//void restartTapped(CCObject* obj);
	//void showRestartMenu(bool won);
	//void draw();

	void registerWithTouchDispatcher();
	bool ccTouchBegan(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent);
	  // implement the "static node()" method manually
    CREATE_FUNC(UserPay);
	void shopButtonTapped(CCObject* obj) ;
	void homeButtonTapped(CCObject* obj) ;
	void helpButtonTapped(CCObject* obj) ;
#pragma mark -
#pragma mark CCStoreTransactionObserver
    
    virtual void transactionCompleted(CCStorePaymentTransaction* transaction);
    virtual void transactionFailed(CCStorePaymentTransaction* transaction);
    virtual void transactionRestored(CCStorePaymentTransaction* transaction);
    
#pragma mark -
#pragma mark CCStoreProductsRequestDelegate
    
    virtual void requestProductsCompleted(cocos2d::CCArray* products, cocos2d::CCArray* invalidProductsId = NULL);
    virtual void requestProductsFailed(int errorCode, const char* errorString);

 };

NS_CC_END
#endif
#endif
