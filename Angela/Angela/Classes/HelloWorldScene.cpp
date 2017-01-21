#include "HelloWorldScene.h"
#include "CCStore.h"
#include "CCStoreProduct.h"
#include "CCStorePaymentTransaction.h"
#include "CCShareEngine.h"

USING_NS_CC;

static const char* const APPSTORE_PRODUCT_ONE = "gwsoft.legendring.one";
static const char* const SHARE_CONTENT = "叮咚上门，生活便捷好帮手";
static const char* const SHARE_URL = "http://www.91dingdong.com/";

CCScene* HelloWorld::scene()
{
    // 'scene' is an autorelease object
    CCScene *scene = CCScene::create();
    
    // 'layer' is an autorelease object
    HelloWorld *layer = HelloWorld::create();

    // add layer as a child to scene
    scene->addChild(layer);

    // return the scene
    return scene;
}

// on "init" you need to initialize your instance
bool HelloWorld::init()
{
    //////////////////////////////
    // 1. super init first
    if ( !CCLayer::init() )
    {
        return false;
    }
    
    CCSize visibleSize = CCDirector::sharedDirector()->getVisibleSize();
    CCPoint origin = CCDirector::sharedDirector()->getVisibleOrigin();

    //－－－－CCMenuItemFont
    CCMenuItemFont*  sinaMenu = CCMenuItemFont::create("新浪微博", this,menu_selector(HelloWorld::menuSinaShareFun));
    sinaMenu->setPosition(ccp(origin.x + visibleSize.width/2 - sinaMenu->getContentSize().width,
                              origin.y + visibleSize.height/2));
    
    CCMenuItemFont*  sinaLogoutMenu = CCMenuItemFont::create("取消授权", this,menu_selector(HelloWorld::menuSinaLoginOutFun));
    sinaLogoutMenu->setPosition(ccp(origin.x + visibleSize.width/2 + sinaLogoutMenu->getContentSize().width,
                              origin.y + visibleSize.height/2));
    
    CCMenuItemFont*  tcMenu = CCMenuItemFont::create("腾讯微博", this,menu_selector(HelloWorld::menuTcShareFun));
    tcMenu->setPosition(ccp(sinaMenu->getPosition().x,
                              origin.y + visibleSize.height/2 - 40));
    
    CCMenuItemFont*  tcLoginOutMenu = CCMenuItemFont::create("取消授权", this,menu_selector(HelloWorld::menuTcLoginOutFun));
    tcLoginOutMenu->setPosition(ccp(sinaLogoutMenu->getPosition().x,
                              origin.y + visibleSize.height/2 - 40));
    
    CCMenuItemFont*  weChatMenu = CCMenuItemFont::create("微信", this,menu_selector(HelloWorld::menuWeChatShareFun));
    weChatMenu->setPosition(ccp(sinaMenu->getPosition().x,
                              origin.y + visibleSize.height/2 - 80));
    
    CCMenuItemFont*  weChatFriendMenu = CCMenuItemFont::create("微信朋友圈", this,menu_selector(HelloWorld::menuWeChatFriendFun));
    weChatFriendMenu->setPosition(ccp(sinaLogoutMenu->getPosition().x,
                              origin.y + visibleSize.height/2 - 80));
    
    CCMenuItemFont*  loadItemMenu = CCMenuItemFont::create("获得商品数据", this,menu_selector(HelloWorld::menuLoadItemFun));
    loadItemMenu->setPosition(ccp(sinaMenu->getPosition().x,
                                origin.y + visibleSize.height/2 - 120));
    
    CCMenuItemFont*  purchaseItemMenu = CCMenuItemFont::create("购买商品", this,menu_selector(HelloWorld::menuPurchaseItemFun));
    purchaseItemMenu->setPosition(ccp(sinaLogoutMenu->getPosition().x,
                                      origin.y + visibleSize.height/2 - 120));
    
    CCMenuItemImage *pCloseItem = CCMenuItemImage::create(
                                        "CloseNormal.png",
                                        "CloseSelected.png",
                                        this,
                                        menu_selector(HelloWorld::menuCloseCallback));
    
	pCloseItem->setPosition(ccp(origin.x + visibleSize.width - pCloseItem->getContentSize().width/2 ,
                                origin.y + pCloseItem->getContentSize().height/2));

    // create menu, it's an autorelease object
    CCMenu* pMenu = CCMenu::create(sinaMenu, sinaLogoutMenu, tcMenu, tcLoginOutMenu, weChatMenu, weChatFriendMenu, loadItemMenu, purchaseItemMenu, pCloseItem, NULL);
    pMenu->setPosition(CCPointZero);
    this->addChild(pMenu, 1);
    
    icoSprite = CCSprite::create("Icon-57.png");
    icoSprite->setPosition(ccp(origin.x + visibleSize.width/2,
                               origin.y + visibleSize.height/2));
    this->addChild(icoSprite,2);
    
    
    CCStore::sharedStore()->postInitWithTransactionDelegate(this);
    CCStore::sharedStore()->setReceiptVerifyMode(CCStoreReceiptVerifyModeDevice);
    //CCShareEngine::sharedInstance()->setDelegate(this);
    
    return true;
}


void HelloWorld::menuCloseCallback(CCObject* pSender)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_WINRT) || (CC_TARGET_PLATFORM == CC_PLATFORM_WP8)
	CCMessageBox("You pressed the close button. Windows Store Apps do not implement a close button.","Alert");
#else
    CCDirector::sharedDirector()->end();
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    exit(0);
#endif
#endif
    
//    CCFiniteTimeAction *turnBigAction = CCScaleTo::create(.2f, 1.3f);
//    CCFiniteTimeAction *fadeOutAction = CCFadeTo::create(.2f, 100);
//    CCSpawn *actionOne = CCSpawn::createWithTwoActions(turnBigAction, fadeOutAction);
//    
//    CCFiniteTimeAction *turnNomalAction = CCScaleTo::create(.2f, 1.0f);
//    CCFiniteTimeAction *fadeInAction = CCFadeTo::create(.2f, 255);
//    CCSpawn *actionTwo = CCSpawn::createWithTwoActions(turnNomalAction, fadeInAction);
//    
//    CCSequence *sacleAnim = CCSequence::createWithTwoActions(actionOne, actionTwo);
//    icoSprite->runAction(CCRepeatForever::create(sacleAnim));
}
//
//void HelloWorld::menuSinaShareFun()
//{
//    if (false == CCShareEngine::sharedInstance()->isLogin(sinaWeibo))
//    {
//        CCShareEngine::sharedInstance()->loginWithType(sinaWeibo);
//    }
//    else
//    {
//        CCShareEngine::sharedInstance()->sendShareMessage((char*)SHARE_CONTENT, sinaWeibo);
//    }
//}
//
//void HelloWorld::menuTcShareFun()
//{
//    if (false == CCShareEngine::sharedInstance()->isLogin(tcWeibo))
//    {
//        CCShareEngine::sharedInstance()->loginWithType(tcWeibo);
//    }
//    else
//    {
//        CCShareEngine::sharedInstance()->sendShareMessage((char*)SHARE_CONTENT, tcWeibo);
//    }
//}
//
//void HelloWorld::menuWeChatShareFun()
//{
//    CCShareEngine::sharedInstance()->sendWeChatMessage((char*)SHARE_CONTENT, (char*)SHARE_URL, weChat);
//}
//
//void HelloWorld::menuSinaLoginOutFun()
//{
//    CCShareEngine::sharedInstance()->logOutWithType(sinaWeibo);
//}
//
//void HelloWorld::menuTcLoginOutFun()
//{
//    CCShareEngine::sharedInstance()->logOutWithType(tcWeibo);
//}
//
//void HelloWorld::menuWeChatFriendFun()
//{
//    CCShareEngine::sharedInstance()->sendWeChatMessage((char*)SHARE_CONTENT, (char*)SHARE_URL, weChatFriend);
//}
//
//void HelloWorld::menuLoadItemFun()
//{
//    testLoadProducts(Nil);
//}
//
//void HelloWorld::menuPurchaseItemFun()
//{
//    testPurchase(Nil);
//}

#pragma mark -
#pragma mark private method
void HelloWorld::testLoadProducts(CCObject* pSender)
{
    CCArray* productsId = new CCArray();
    productsId->autorelease();
    
    // SET IAP PRODUCTS ID
    productsId->addObject(newCCString(APPSTORE_PRODUCT_ONE));
    CCStore::sharedStore()->loadProducts(productsId, this);
}

void HelloWorld::testPurchase(CCObject* pSender)
{
    if (CCStore::sharedStore()->purchase(APPSTORE_PRODUCT_ONE))
    {
        
    }
    else
    {

    }
}

#pragma mark -
#pragma mark CCStoreTransactionDelegate

void HelloWorld::transactionCompleted(CCStorePaymentTransaction* transaction)
{
    CCLOG("\n");
    CCLOG("TransactionIdentifier: %s\n", transaction->getTransactionIdentifier().c_str());
    CCLOG("\n");
    
    CCMessageBox(transaction->getTransactionIdentifier().c_str(),"购买成功");
    
    CCStore::sharedStore()->finishTransaction(transaction);
}

void HelloWorld::transactionFailed(CCStorePaymentTransaction* transaction)
{
    CCMessageBox(NULL,"购买失败");
    CCStore::sharedStore()->finishTransaction(transaction);
}

void HelloWorld::transactionRestored(CCStorePaymentTransaction* transaction)
{
    CCLOG("\n");
    CCLOG("TransactionIdentifier: %s\n", transaction->getTransactionIdentifier().c_str());
    CCLOG("OriginTransactionIdentifier: %s\n",
           transaction->getOriginalTransaction()->getTransactionIdentifier().c_str());
    CCLOG("\n");
    
    CCStore::sharedStore()->finishTransaction(transaction);
}

#pragma mark -
#pragma mark CCStoreProductsRequestDelegate

void HelloWorld::requestProductsCompleted(CCArray* products, CCArray* invalidProductsId)
{
    
    CCLOG("\n");
    CCString *message = NULL;
    for (int i = 0; i < products->count(); ++i)
    {
        CCStoreProduct* product = static_cast<CCStoreProduct*>(products->objectAtIndex(i));
        CCLOG("PRODUCT ID: %s\n",              product->getProductIdentifier().c_str());
        CCLOG("  localizedTitle: %s\n",        product->getLocalizedTitle().c_str());
        CCLOG("  localizedDescription: %s\n",  product->getLocalizedDescription().c_str());
        CCLOG("  priceLocale: %s\n",           product->getPriceLocale().c_str());
        CCLOG("  price: %0.2f\n",              product->getPrice());
        
       message = message->createWithFormat("PRODUCT ID: %s,\nlocalizedTitle: %s,\nlocalizedDescription: %s,\npriceLocale: %s,\nprice: %0.2f", product->getProductIdentifier().c_str(),product->getLocalizedTitle().c_str(),product->getLocalizedDescription().c_str(),product->getPriceLocale().c_str(),product->getPrice());
    }
    
    if (NULL != message)
    {
        CCMessageBox(message->getCString(),"商品信息");
    }
    
    printf("\n");
    
    message = NULL;
    if (invalidProductsId && invalidProductsId->count() > 0)
    {
        printf("FOUND INVALID PRODUCTS ID\n");
        message = message->create("");
        for (int i = 0; i < invalidProductsId->count(); ++i)
        {
            CCString* ccid = static_cast<CCString*>(invalidProductsId->objectAtIndex(i));
            CCLOG("  %s\n", ccid->getCString());
            message = message->createWithFormat("%s%s",message->getCString(),ccid->getCString());
        }
        if (NULL != message)
        {
            CCMessageBox(message->getCString(),"无效商品信息商品信息");
        }
    }
    
    printf("\n");
}

void HelloWorld::requestProductsFailed(int errorCode, const char* errorString)
{
    CCMessageBox(errorString,"请求失败");
}

#pragma mark - 
#pragma mark helper
CCString* HelloWorld::newCCString(const char* string)
{
    CCString* str = new CCString(string);
    str->autorelease();
    return str;
}

