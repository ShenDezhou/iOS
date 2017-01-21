#include "HelpScene.h"

USING_NS_CC;

//const char* atlas_sel[] = {"quirk_sel.png","zap_sel.png","munch_sel.png","dragon_sel.png","phoenix_sel.png"};
// there's no 'id' in cpp, so we recommend returning the class instance pointer
CCScene* HelpLayer::scene()
{
	CCScene *scene = CCScene::create();

	HelpLayer *splash = HelpLayer::create();

	scene->addChild(splash);

	return scene;

}

/*
void Splash::gameLogic(float dt)
{
	this->addMonster();
}
*/
// Here's a difference. Method 'init' in cocos2d-x returns bool, instead of returning 'id' in cocos2d-iphone
bool HelpLayer::init()
{
	if(! CCLayer::init())
	{
		return false;
	}
	//this->level = level;
	basicSetup();
	this->setTouchEnabled(true);
	
	return true;
}


void HelpLayer::basicSetup()
{

	//planes = CCArray::create();
	//planes->retain();
    CCSize winSize = CCDirector::sharedDirector()->getWinSize();
    
	//nodes
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
	
	CCSprite *background =  CCSprite::createWithSpriteFrameName(backgrounds[0]);
	background->retain();
    background->setPosition(ccp(winSize.width/2, winSize.height/2-yOffset/2));
    this->addChild(background,-1);

	CCSprite*	board = CCSprite::createWithSpriteFrameName("board.png");
	int _yOffset = yOffset/2* board->getContentSize().height/winSize.height;

	CCPoint point = ccp(winSize.width/2-xMARGIN,winSize.height/2-yMARGIN*1.57*1.5-_yOffset);
	board->setPosition(point);
	this->addChild(board,-1);
		std::string helpword = CCUserDefault::sharedUserDefault()->getStringForKey("help1");

	

	CCLabelTTF* tutlabel = CCLabelTTF::create(helpword.c_str(),fontname, fontSizeSmall,ccpSub( board->getContentSize(),ccp(10,10)), kCCTextAlignmentLeft );
	tutlabel->setPosition(ccpSub(point,ccp(0,yMARGIN)));
	tutlabel->setColor(ccc3(0,0,0x99));
	this->addChild(tutlabel,3);
 
    CCArray* items = CCArray::create();
	CCSprite* button = CCSprite::createWithSpriteFrameName("shortcut_home.png");
	point = ccp(winSize.width-button->getContentSize().width/2,winSize.height/2-button->getContentSize().height);
	CCMenuItemSprite* homeButton = CCMenuItemSprite::create(CCSprite::createWithSpriteFrameName("shortcut_home.png"),CCSprite::createWithSpriteFrameName("shortcut_home.png"),this,menu_selector(HelpLayer::homeButtonTapped));
	homeButton->setPosition(point);
	items->addObject(homeButton);

	point.y += button->getContentSize().height;
	CCMenuItemSprite* shopButton = CCMenuItemSprite::create(CCSprite::createWithSpriteFrameName("shortcut_shop.png"),CCSprite::createWithSpriteFrameName("shortcut_shop.png"),this,menu_selector(HelpLayer::shopButtonTapped));
	shopButton->setPosition(point);
	items->addObject(shopButton);

	point.y += button->getContentSize().height;
	CCMenuItemSprite* helpButton = CCMenuItemSprite::create(CCSprite::createWithSpriteFrameName("shortcut_help.png"),CCSprite::createWithSpriteFrameName("shortcut_help.png"),this,menu_selector(HelpLayer::helpButtonTapped));
	helpButton->setPosition(point);
	items->addObject(helpButton);


    CCMenu* menu = CCMenu::createWithArray(items);
    menu->setPosition(ccp(0,-yMARGIN));
    this->addChild(menu);

	//CCString *str = CCString::createWithFormat("%d/%d",page,(g_level+STEP-1)/STEP); 
	//
	//pagelabel = CCLabelTTF::create(str->getCString(), "Verdana-Bold", 16, ccp(MARGIN*3,MARGIN), kCCTextAlignmentCenter );
	//pagelabel->setPosition(ccp(MARGIN * 1.5,MARGIN*1.83));
	//this->addChild(pagelabel);
	//CCString *decks = CCString::createWithFormat("Crafts Selected:%d/%d",deckscount,g_level); 
	//
	//decksLabel = CCLabelTTF::create(decks->getCString(), "Verdana-Bold", 16, ccp(MARGIN*5,MARGIN), kCCTextAlignmentCenter );
	//decksLabel->setPosition(ccp(MARGIN * 9.7 ,MARGIN*1.83));
	//this->addChild(decksLabel);

	//CCSprite* left = CCSprite::createWithSpriteFrameName("arrow_left.png");
	//left->setPosition(ccp(MARGIN* 1 ,winSize.height * 0.5));
	//this->addChild(left);

	//CCSprite* right = CCSprite::createWithSpriteFrameName("arrow_right.png");
	//right->setPosition(ccp(MARGIN * 11,winSize.height * 0.5));
	//this->addChild(right);

	//

	////int yoffset = winSize.height/2 - MARGIN * (SLIDENUM/2);
	////for(int i =0; i< SLIDENUM; i++)
	////{
	////	CCLabelTTF* ttf1 = CCLabelTTF::create(sliderintro[i], "Helvetica", 12, ccp(MARGIN*4,MARGIN), kCCTextAlignmentRight );
	////	ttf1->setPosition(ccp(winSize.width/2,yoffset));
	////	this->addChild(ttf1);
	////	sliders[i] = CCControlSlider::create(CCSprite::createWithSpriteFrameName("slide.png"),CCSprite::createWithSpriteFrameName(slideratlas[i]),CCSprite::createWithSpriteFrameName("slide_center.png"));
	////	sliders[i]->setPosition(ccp(winSize.width/2+sliders[i]->getContentSize().width/2+MARGIN*2,yoffset+sliders[i]->getContentSize().height/2));
	////	yoffset += MARGIN;
	////	sliders[i]->setValue(0.9f);
	////    this->addChild(sliders[i]);
	////}
	//
	//

	////slider->setEnabled(true);
	////slider->setMaximumValue(150);

 //  CCMenuItemSprite *startButton =  CCMenuItemSprite::create(CCSprite::createWithSpriteFrameName("startbutton.png"),CCSprite::createWithSpriteFrameName("startbutton_sel.png"),this,menu_selector(Splash::startButtonTapped));
 //  CCSize contentSize =  startButton->getContentSize();
 //  startButton->setPosition (ccp(winSize.width/2+MARGIN*4, winSize.height-MARGIN*11.5));
 ////   CCSprite* quirk = CCSprite::createWithSpriteFrameName(frameName);
	////quirk->setPosition(ccp(contentSize.width * 0.25, contentSize.height/2));
 ////   startButton->addChild(quirk);

 //   //CCLabelBMFont* quirkLabel = CCLabelBMFont::create("Start","Courier.fnt");
 //   //quirkLabel->setPosition(ccp(contentSize.width * 0.5,contentSize.height*0.5));
 //   //startButton->addChild(quirkLabel);
	//menu->addChild(startButton);
	////CCMenu* _menu->addChild(startButton);
	////menu_sel->setPosition(ccp(winSize.width/2,MARGIN));

	//
 //   guide = CCLabelTTF::create("Click to select monsters to fight for you! Swipe left or right to go to prev or next page!", "Verdana-Bold", 18, ccp(MARGIN*3,5*MARGIN), kCCTextAlignmentLeft );
	//guide->setPosition(ccp(winSize.width/2+MARGIN*4, winSize.height-MARGIN*7.5));
 //   this->addChild(guide);

}
void  HelpLayer::homeButtonTapped(CCObject* obj) 
{
	CCDirector::sharedDirector()->replaceScene(ArmorHome::scene());
}
void  HelpLayer::helpButtonTapped(CCObject* obj) 
{
	CCDirector::sharedDirector()->replaceScene(HelpLayer::scene());
}

void HelpLayer::shopButtonTapped(CCObject* obj) 
{
	#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
	CCDirector::sharedDirector()->replaceScene(UserPay::scene());
#endif
}

void HelpLayer::registerWithTouchDispatcher()
{
	CCDirector::sharedDirector()->getTouchDispatcher()->addTargetedDelegate(this,0,true);
}

bool HelpLayer::ccTouchBegan(CCTouch *pTouch, CCEvent *pEvent)
{
	return true;
}

