
#include "UserPayScene.h"
#include "CCStore.h"

USING_NS_CC;
USING_NS_CC_EXT;
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
pthread_mutex_t mutex;
pthread_cond_t condition;
bool     ready_to_go = true;

CCScene* UserPay::scene()
{
    pthread_mutex_init(&mutex, NULL);
    pthread_cond_init(&condition, NULL);
   // 'scene' is an autorelease object
    CCScene *scene = CCScene::create();
    
    // 'layer' is an autorelease object
    UserPay *layer = UserPay::create();

    // add layer as a child to scene
    scene->addChild(layer);

    // return the scene
    return scene;
}

// on "init" you need to initialize your instance
bool UserPay::init()
{
    //////////////////////////////
    // 1. super init first
    if ( !CCLayer::init() )
    {
	    return false;
    }
 	basicSetup();
	addPlayers();
    return true;
}

void UserPay::basicSetup()
{
    CCSize winSize = CCDirector::sharedDirector()->getWinSize();

	CCSize frameSize = CCEGLView::sharedOpenGLView()->getFrameSize();  
	 // In this demo, we select resource according to the frame's height.
	 // If the resource size is different from design resolution size, you need to set contentScaleFactor.    
	 // We use the ratio of resource's height to the height of design resolution,    
	 // this can make sure that the resource's height could fit for the height of design resolution.     
	 // if the frame's height is larger than the height of medium resource size, select large resource.    
    if(frameSize.width == ip5Resource.size.width)
    {
        CCSpriteFrameCache::sharedSpriteFrameCache()->addSpriteFramesWithFile("Sprites1-ip5.plist");
		_batchNodes = CCSpriteBatchNode::create("Sprites1-ip5.pvr.ccz");
        
    }else
    {
        if (frameSize.height > mediumResource.size.height)
        {
            CCSpriteFrameCache::sharedSpriteFrameCache()->addSpriteFramesWithFile("Sprites1-ipadhd.plist");
            _batchNodes = CCSpriteBatchNode::create("Sprites1-ipadhd.pvr.ccz");
            
//            CCSpriteFrameCache::sharedSpriteFrameCache()->addSpriteFramesWithFile("Sprites2-ipadhd.plist");
//            CCSpriteBatchNode* _nodes = CCSpriteBatchNode::create("Sprites2-ipadhd.pvr.ccz");
//            
//            for(int i=0;i<_nodes->getChildrenCount();i++)
//            {
//                _batchNodes->addChild((CCSprite*)_nodes->getChildren()->objectAtIndex(i));
//                
//            }
//
//            CCSpriteFrameCache::sharedSpriteFrameCache()->addSpriteFramesWithFile("Sprites3-ipadhd.plist");
//            _nodes = CCSpriteBatchNode::create("Sprites3-ipadhd.pvr.ccz");
//            for(int i=0;i<_nodes->getChildrenCount();i++)
//            {
//                _batchNodes->addChild((CCSprite*)_nodes->getChildren()->objectAtIndex(i));
//            }
            //CCFileUtils::sharedFileUtils()->setResourceDirectory(largeResource.directory);
            //pDirector->setContentScaleFactor(largeResource.size.height/designResolutionSize.height);
        }
        // if the frame's height is larger than the height of small resource size, select medium resource.
        else if (frameSize.height > smallResource.size.height)
        {
            CCSpriteFrameCache::sharedSpriteFrameCache()->addSpriteFramesWithFile("Sprites1-ipad.plist");
            _batchNodes = CCSpriteBatchNode::create("Sprites1-ipad.pvr.ccz");
            //CCFileUtils::sharedFileUtils()->setResourceDirectory(mediumResource.directory);
            //pDirector->setContentScaleFactor(mediumResource.size.height/designResolutionSize.height);
        }
        // if the frame's height is smaller than the height of medium resource size, select small resource.
        else  if (frameSize.height > tinyResource.size.height)
        {
            CCSpriteFrameCache::sharedSpriteFrameCache()->addSpriteFramesWithFile("Sprites1-hd.plist");
            _batchNodes = CCSpriteBatchNode::create("Sprites1-hd.pvr.ccz");
            
        }
        else
        {
            CCSpriteFrameCache::sharedSpriteFrameCache()->addSpriteFramesWithFile("Sprites1.plist");
            _batchNodes = CCSpriteBatchNode::create("Sprites1.pvr.ccz");
            //CCFileUtils::sharedFileUtils()->setResourceDirectory(smallResource.directory);        
            //pDirector->setContentScaleFactor(smallResource.size.height/designResolutionSize.height); 
        }
    }
	this->addChild(_batchNodes);
	//_particleNodes = CCDictionary::create();
	//_particleNodes->setObject(CCParticleBatchNode::create("bullet.png"),"bullet");
	//_particleNodes->setObject(CCParticleBatchNode::create("explosion1.png"),"explosion1");
	//_particleNodes->setObject(CCParticleBatchNode::create("explosion2.png"),"explosion2");
	//_particleNodes->setObject(CCParticleBatchNode::create("aoe1.png"),"aoe1");
	//_particleNodes->setObject(CCParticleBatchNode::create("aoe2.png"),"aoe2");
	//CCDictElement* object = NULL;
	//CCDICT_FOREACH(_particleNodes,object)
	//{
	//	this->addChild((CCParticleBatchNode*)object->getObject());
	//}
    
    
    // Sounds
    //CocosDenshion::SimpleAudioEngine::sharedEngine()->playBackgroundMusic("Latin_Industries.mp3");
    //CocosDenshion::SimpleAudioEngine::sharedEngine()->preloadEffect("bigHit.wav");
    //CocosDenshion::SimpleAudioEngine::sharedEngine()->preloadEffect("boom.wav");
    //CocosDenshion::SimpleAudioEngine::sharedEngine()->preloadEffect("pew.wav");
    //CocosDenshion::SimpleAudioEngine::sharedEngine()->preloadEffect("pew2.wav");
    //CocosDenshion::SimpleAudioEngine::sharedEngine()->preloadEffect("smallHit.wav");
    //CocosDenshion::SimpleAudioEngine::sharedEngine()->preloadEffect("attack.wav");
    //CocosDenshion::SimpleAudioEngine::sharedEngine()->preloadEffect("defend.wav");
    //CocosDenshion::SimpleAudioEngine::sharedEngine()->preloadEffect("spawn.wav");
    
	//other UI
	CCSprite *background =  CCSprite::createWithSpriteFrameName(backgrounds[0]);
    background->setPosition(ccp(winSize.width/2, winSize.height/2-yOffset/2));
    this->addChild(background,-1);

	//CCLabelBMFont* welcome = CCLabelBMFont::create("Welcome ","Courier.fnt");
 //   welcome->retain();
 //   welcome->setPosition(ccp(winSize.width/2-xMARGIN*4,winSize.height/2-yMARGIN*1.5));
	//this->addChild(welcome);
    bool vip = CCUserDefault::sharedUserDefault()->getBoolForKey("PAIDUSER");
    float rate = CCUserDefault::sharedUserDefault()->getFloatForKey("PAIDRATE");
	CCSprite* boardbg = CCSprite::createWithSpriteFrameName("button.png");

	CCString* message = CCString::createWithFormat("VIP:%s,Loyalty:%d",vip?"yes":"no",(int)rate);
    std::string descriptionword = CCUserDefault::sharedUserDefault()->getStringForKey("shop1");

	CCLabelTTF* board =CCLabelTTF::create(descriptionword.c_str(),fontname, fontSizeBig, boardbg->getContentSize(), kCCTextAlignmentCenter );
	board->setColor(ccc3(252,236,54));
	board->setPosition(ccp(xMARGIN*1.0+boardbg->getContentSize().width/2,winSize.height-yOffset/2*boardbg->getContentSize().height*1.1/winSize.height-yMARGIN*1.8*1.57));
    this->addChild(board);
    
    CCArray* items = CCArray::create();
	CCSprite*	button = CCSprite::createWithSpriteFrameName("shortcut_home.png");
	CCPoint point = ccp(winSize.width-button->getContentSize().width/2,winSize.height/2-button->getContentSize().height);
	CCMenuItemSprite* homeButton = CCMenuItemSprite::create(CCSprite::createWithSpriteFrameName("shortcut_home.png"),CCSprite::createWithSpriteFrameName("shortcut_home.png"),this,menu_selector(UserPay::homeButtonTapped));
	homeButton->setPosition(point);
	items->addObject(homeButton);

	point.y += button->getContentSize().height;
	CCMenuItemSprite* shopButton = CCMenuItemSprite::create(CCSprite::createWithSpriteFrameName("shortcut_shop.png"),CCSprite::createWithSpriteFrameName("shortcut_shop.png"),this,menu_selector(UserPay::shopButtonTapped));
	shopButton->setPosition(point);
	items->addObject(shopButton);

	point.y += button->getContentSize().height;
	CCMenuItemSprite* helpButton = CCMenuItemSprite::create(CCSprite::createWithSpriteFrameName("shortcut_help.png"),CCSprite::createWithSpriteFrameName("shortcut_help.png"),this,menu_selector(UserPay::helpButtonTapped));
	helpButton->setPosition(point);
	items->addObject(helpButton);


    menu = CCMenu::createWithArray(items);
	//menu->alignItemsVerticallyWithPadding(MARGIN*0.25);
    //menu->setPosition(ccp(MARGIN*1.5+craftinfo->getContentSize().width/2,winSize.height/2));
    menu->setPosition(ccp(0,0-yMARGIN));
	this->addChild(menu);

	products = CCArray::create();
	products->retain();
}

void UserPay::addPlayers()
{
    if(CCStore::sharedStore()->canMakePurchases())
    {
		std::string helpword = CCUserDefault::sharedUserDefault()->getStringForKey("shop4");

        products->addObject(CCStoreProduct::productWithId("com.bangtech.angelplanet.vip", "VIP",helpword.c_str(), 0.00, "$-.-"));
        //requestProductsCompleted(products,NULL);
        pthread_mutex_lock(&mutex);
        ready_to_go = false;
        pthread_mutex_unlock(&mutex);

//        while(ready_to_go == false)
//        {
//            pthread_cond_wait(&condition, &mutex);
//        }

        CCStore::sharedStore()->postInitWithTransactionDelegate(this);
        CCStore::sharedStore()->setReceiptVerifyMode(CCStoreReceiptVerifyModeDevice);
        CCStore::sharedStore()->loadProducts(products, this);
        
        try{
            
            CCSize winSize = CCDirector::sharedDirector()->getWinSize();
            CCSprite* button = CCSprite::createWithSpriteFrameName("button.png");
            int columns = 1;
            float spaceBetween = columns +1;
            int rows = 4;
            int spaceBetweenRows = rows +1;
            int spacing = xMARGIN*3+button->getContentSize().width;
            int rowSpacing = yMARGIN*1.57*4+button->getContentSize().height;
            
            CCPoint point = ccp(0,winSize.height-yMARGIN*4*1.57);
            

            for (int i = 0; i < products->count(); ++i)
            {
                CCStoreProduct* product = static_cast<CCStoreProduct*>(products->objectAtIndex(i));
                
                point.x = point.x + spacing;
                if(point.x-spacing>= spacing*columns) {
                    point.x = spacing;
                    point.y = point.y - rowSpacing;
                }
                CCMenuItemSprite* quirkButton = CCMenuItemSprite::create(CCSprite::createWithSpriteFrameName("button_shop.png"),CCSprite::createWithSpriteFrameName("button_shop_sel.png"),this,menu_selector(UserPay::levelButtonTapped));
                quirkButton->retain();
                quirkButton->setPosition(point);
                
                CCSize contentSize =  quirkButton->getContentSize();
                
                CCString* message = CCString::createWithFormat("%s:%.2f",product->getLocalizedTitle().c_str(),product->getPrice());
                CCString* description = CCString::createWithFormat("%s",product->getLocalizedDescription().c_str());
				std::string shopword = CCUserDefault::sharedUserDefault()->getStringForKey("shop1");

                _price = CCLabelTTF::create(message->getCString(), fontname, fontSizeSmall, ccp(xMARGIN*16,yMARGIN), kCCTextAlignmentCenter );
                _price->setColor(ccc3(252,236,54));
                CCLabelTTF* descriptionLabel =CCLabelTTF::create(description->getCString(), fontname, fontSizeTiny, ccp(xMARGIN*16,yMARGIN*4), kCCTextAlignmentCenter );
                _price->setPosition(ccp(contentSize.width * 0.5,contentSize.height * 0.5));
                quirkButton->addChild(_price);
                descriptionLabel->setPosition(ccp(contentSize.width * 0.5,contentSize.height * 0.5 -3* yMARGIN));
                descriptionLabel->setColor(ccc3(0,0,0x99));
                quirkButton->addChild(descriptionLabel);
                
                quirkButton->setTag(i);
                menu->addChild(quirkButton);
            }
        }catch( ... ){
            
            CCStore::sharedStore()->cancelLoadProducts();
        }

	}else
    {
        CCMessageBox("Please enable Purchase for Angel Planet.","Cannot Make Purchase.");
        
    }
  
    
}

void UserPay::registerWithTouchDispatcher()
{
	CCDirector::sharedDirector()->getTouchDispatcher()->addTargetedDelegate(this,0,true);
}
bool UserPay::ccTouchBegan(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent)
{
	return true;
}


#pragma mark -
#pragma mark CCStoreTransactionDelegate

void UserPay::transactionCompleted(CCStorePaymentTransaction* transaction)
{
    
    CCLOG("\n");
    CCLOG("TransactionIdentifier: %s\n", transaction->getTransactionIdentifier().c_str());
    CCLOG("\n");
    std::string prodid = transaction->getProductIdentifier();

    CCMessageBox(transaction->getTransactionIdentifier().c_str(),"Purchase completed.");
    PAIDUSER = true;
    if(prodid.find("vip")!=-1 && PAIDRATE<1)
        PAIDRATE += 1;
    CCUserDefault::sharedUserDefault()->setBoolForKey("PAIDUSER",PAIDUSER);
    CCUserDefault::sharedUserDefault()->setFloatForKey("PAIDRATE",PAIDRATE);

    CCStore::sharedStore()->finishTransaction(transaction);
}

void UserPay::transactionFailed(CCStorePaymentTransaction* transaction)
{
    CCMessageBox(NULL,"Purchase failed.");
    CCStore::sharedStore()->finishTransaction(transaction);
}

void UserPay::transactionRestored(CCStorePaymentTransaction* transaction)
{
    CCLOG("\n");
    CCLOG("TransactionIdentifier: %s\n", transaction->getTransactionIdentifier().c_str());
    CCLOG("OriginTransactionIdentifier: %s\n",
           transaction->getOriginalTransaction()->getTransactionIdentifier().c_str());
    CCLOG("\n");
    std::string prodid = transaction->getProductIdentifier();
    PAIDUSER = true;
    if(prodid.find("vip")!=-1)
        PAIDRATE += 1;
    CCUserDefault::sharedUserDefault()->setBoolForKey("PAIDUSER",PAIDUSER);
    CCUserDefault::sharedUserDefault()->setFloatForKey("PAIDRATE",PAIDRATE);

    CCStore::sharedStore()->finishTransaction(transaction);
}

#pragma mark -
#pragma mark CCStoreProductsRequestDelegate

void UserPay::requestProductsCompleted(CCArray* products, CCArray* invalidProductsId)
{
    CCLog("request start");
      pthread_mutex_lock(&mutex);
    
    ready_to_go = true;
    
    // Signal the other thread to begin work.
    pthread_cond_signal(&condition);
    
    pthread_mutex_unlock(&mutex);
    CCStoreProduct* product = static_cast<CCStoreProduct*>(products->objectAtIndex(0));
    //CCStoreProduct* productRef =static_cast<CCStoreProduct*>(this->products->objectAtIndex(0));
    this->products->removeLastObject();
	std::string description = product->getLocalizedDescription().c_str();
	//GBKToUTF8(description);
    this->products->addObject(CCStoreProduct::productWithId(product->getProductIdentifier().c_str(), product->getLocalizedTitle().c_str(),description.c_str(), product->getPrice(), product->getPriceLocale().c_str()));
    CCString* message = CCString::createWithFormat("%s:%.2f",product->getLocalizedTitle().c_str(),product->getPrice());

    _price->setString(message->getCString());
    CCLog("aaaa,%f",product->getPrice());
//    try{
//       
//    CCSize winSize = CCDirector::sharedDirector()->getWinSize();
//	CCSprite* button = CCSprite::createWithSpriteFrameName("button.png");
//    int columns = 1;
//    float spaceBetween = columns +1;
//    int rows = 4;
//    int spaceBetweenRows = rows +1;
//    int spacing = xMARGIN*3+button->getContentSize().width;
//    int rowSpacing = yMARGIN*1.57*4+button->getContentSize().height;
//    
//    CCPoint point = ccp(0,winSize.height-yMARGIN*4*1.57);
//    
//    for(int i = 0; i < products->count(); ++i)
//        menu->removeChildByTag(i);
//    for (int i = 0; i < products->count(); ++i)
//    {
//        CCStoreProduct* product = static_cast<CCStoreProduct*>(products->objectAtIndex(i));
//
//        point.x = point.x + spacing;
//        if(point.x-spacing>= spacing*columns) {
//            point.x = spacing;
//            point.y = point.y - rowSpacing;
//        }
//		CCMenuItemSprite* quirkButton = CCMenuItemSprite::create(CCSprite::createWithSpriteFrameName("button_shop.png"),CCSprite::createWithSpriteFrameName("button_shop_sel.png"),this,menu_selector(UserPay::levelButtonTapped));
//		quirkButton->retain();
//		quirkButton->setPosition(point);
//
//        CCSize contentSize =  quirkButton->getContentSize();
//        
//        //
//        CCString* message = CCString::createWithFormat("Become %s, Cost %.2f",product->getLocalizedTitle().c_str(),product->getPrice());
//        CCString* description = CCString::createWithFormat("%s",product->getLocalizedDescription().c_str());
//        CCLabelTTF* quirkLabel = CCLabelTTF::create(message->getCString(), "Georgia-Italic", fontSizeSmall, ccp(xMARGIN*16,yMARGIN), kCCTextAlignmentCenter );
//        quirkLabel->setColor(ccc3(252,236,54));
//        CCLabelTTF* descriptionLabel =CCLabelTTF::create(description->getCString(), "Georgia-Italic", fontSizeTiny, ccp(xMARGIN*16,yMARGIN*4), kCCTextAlignmentCenter );
//        quirkLabel->setPosition(ccp(contentSize.width * 0.5,contentSize.height * 0.5));
//        quirkButton->addChild(quirkLabel);
//        descriptionLabel->setPosition(ccp(contentSize.width * 0.5,contentSize.height * 0.5 -3* yMARGIN));
//        descriptionLabel->setColor(ccc3(0,0,0x99));
//       quirkButton->addChild(descriptionLabel);
//
//        quirkButton->setTag(i);
//        menu->addChild(quirkButton);
//    }
//    }catch( ... ){
//        
//        CCStore::sharedStore()->cancelLoadProducts();
//    }
    
}
void UserPay::requestProductsFailed(int errorCode, const char* errorString)
{
    pthread_mutex_lock(&mutex);
    ready_to_go = true;
    
    // Signal the other thread to begin work.
    pthread_cond_signal(&condition);
    
    pthread_mutex_unlock(&mutex);
    CCMessageBox(errorString,"Request failed.");
}

void UserPay::levelButtonTapped(CCObject* obj){
    if(CCStore::sharedStore()->canMakePurchases())
    {
        CCMenuItemSprite* quirkButton = (CCMenuItemSprite* )obj;
        int  index = quirkButton->getTag();
        CCStoreProduct* product = static_cast<CCStoreProduct*>(products->objectAtIndex(index));
        if (CCStore::sharedStore()->purchase(product->getProductIdentifier().c_str()))
        {
			std::string shopword = CCUserDefault::sharedUserDefault()->getStringForKey("shop2");

			CCMessageBox(shopword.c_str(),"Purchase Start!");
        
        }
        else
        {
			std::string shopword = CCUserDefault::sharedUserDefault()->getStringForKey("shop3");
			CCMessageBox(shopword.c_str(),"Purchase failed!");
        
        }
    }else
    {
        CCMessageBox("Please enable Purchase for Angel Planet.","Cannot Make Purchase.");
        
    }
}

void  UserPay::homeButtonTapped(CCObject* obj) 
{
    // Lock the mutex.
    pthread_mutex_lock(&mutex);
    struct timeval now;
    struct timespec outtime;
 
    // If the predicate is already set, then the while loop is bypassed;
    // otherwise, the thread sleeps until the predicate is set.
    while(ready_to_go == false)
    {
        gettimeofday(&now, NULL);
        outtime.tv_sec = now.tv_sec + 5;
        outtime.tv_nsec = now.tv_usec * 1000;
        int error = pthread_cond_timedwait(&condition, &mutex,&outtime);
        if(ETIMEDOUT==error)
        {
        pthread_mutex_unlock(&mutex);
        return;
        }else
            break;
    }
    
    // Do work. (The mutex should stay locked.)
    
    // Reset the predicate and release the mutex.
    ready_to_go = true;
    pthread_mutex_unlock(&mutex);
    CCDirector::sharedDirector()->replaceScene(ArmorHome::scene());

}
void  UserPay::helpButtonTapped(CCObject* obj) 
{
    // Lock the mutex.
    pthread_mutex_lock(&mutex);
    struct timeval now;
    struct timespec outtime;
   
    // If the predicate is already set, then the while loop is bypassed;
    // otherwise, the thread sleeps until the predicate is set.
    while(ready_to_go == false)
    {
        gettimeofday(&now, NULL);
        outtime.tv_sec = now.tv_sec + 5;
        outtime.tv_nsec = now.tv_usec * 1000;
        int error = pthread_cond_timedwait(&condition, &mutex,&outtime);
        if(ETIMEDOUT==error)
        {
            pthread_mutex_unlock(&mutex);
            return;
        }else
            break;
    }
    
    
    // Reset the predicate and release the mutex.
    ready_to_go = true;
    pthread_mutex_unlock(&mutex);
    // Do work. (The mutex should stay locked.)
    CCDirector::sharedDirector()->replaceScene(HelpLayer::scene());

}

void UserPay::shopButtonTapped(CCObject* obj) 
{
    // Lock the mutex.
    pthread_mutex_lock(&mutex);
    struct timeval now;
    struct timespec outtime;
    
    // If the predicate is already set, then the while loop is bypassed;
    // otherwise, the thread sleeps until the predicate is set.
    while(ready_to_go == false)
    {
        gettimeofday(&now, NULL);
        outtime.tv_sec = now.tv_sec + 5;
        outtime.tv_nsec = now.tv_usec * 1000;
        int error = pthread_cond_timedwait(&condition, &mutex,&outtime);
        if(ETIMEDOUT==error)
        {
            pthread_mutex_unlock(&mutex);
            return;
        }else
            break;
    }
    
    // Reset the predicate and release the mutex.
    ready_to_go = true;
    pthread_mutex_unlock(&mutex);
    // Do work. (The mutex should stay locked.)
    CCDirector::sharedDirector()->replaceScene(UserPay::scene());
 
}
#endif