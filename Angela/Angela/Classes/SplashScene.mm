
#include "SplashScene.h"
//#include "SimpleAudioEngine.h"
//#include "GameOverScene.h"

USING_NS_CC;
USING_NS_CC_EXT;

//const char* atlas_sel[] = {"quirk_sel.png","zap_sel.png","munch_sel.png","dragon_sel.png","phoenix_sel.png"};
// there's no 'id' in cpp, so we recommend returning the class instance pointer
CCScene* Splash::scene(int level)
{
	CCScene *scene = CCScene::create();

	Splash *splash = Splash::create(level);

	scene->addChild(splash);

	return scene;

}
Splash* Splash::create(int level)
{
	// 'layer' is an autorelease object  
	Splash *layer =new Splash();
	if(layer && layer->init(level))
	{
		layer->autorelease();
		return layer;
	}
	else
	{
		delete layer;
		layer = NULL;
		return NULL;
	}
}
/*
void Splash::gameLogic(float dt)
{
	this->addMonster();
}
*/
// Here's a difference. Method 'init' in cocos2d-x returns bool, instead of returning 'id' in cocos2d-iphone
bool Splash::init(int level)
{
	if(! CCLayer::init())
	{
		return false;
	}
	//this->level = level;
	basicSetup();
	this->setTouchEnabled(true);
	
	for(int i = BUILDING_NUM;i<BUILDING_NUM+SPRITE_NUM;i++)
	{
		values[0][i] = 0;
		values[1][i] = 0;
		decks[i].selection = false;
	}
	//_monstersDestroyed = 0;
	return true;
}


void Splash::basicSetup()
{
	deckscount = 0;

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

    //int columns = 3;
    //int spaceBetween = columns +1;
    //int rows = 3;
    //int spaceBetweenRows = rows +1;
    //int spacing = winSize.width/spaceBetween;
    //int rowSpacing = winSize.height/spaceBetweenRows;
#if SOUND   
    // Sounds
    //CocosDenshion::SimpleAudioEngine::sharedEngine()->playBackgroundMusic("Latin_Industries.mp3");
    CocosDenshion::SimpleAudioEngine::sharedEngine()->preloadEffect("menu_click.wav");
    //CocosDenshion::SimpleAudioEngine::sharedEngine()->preloadEffect("boom.wav");
    //CocosDenshion::SimpleAudioEngine::sharedEngine()->preloadEffect("pew.wav");
    //CocosDenshion::SimpleAudioEngine::sharedEngine()->preloadEffect("pew2.wav");
    //CocosDenshion::SimpleAudioEngine::sharedEngine()->preloadEffect("smallHit.wav");
    //CocosDenshion::SimpleAudioEngine::sharedEngine()->preloadEffect("attack.wav");
    //CocosDenshion::SimpleAudioEngine::sharedEngine()->preloadEffect("defend.wav");
    //CocosDenshion::SimpleAudioEngine::sharedEngine()->preloadEffect("spawn.wav");
#endif

    //CCPoint point = ccp(0,winSize.height-rowSpacing);
    page = 1;
    CCArray* items = CCArray::create();
 	CCSprite* craftinfo =CCSprite::createWithSpriteFrameName("craft_info.png");
    int rowSpacing = yMARGIN*0.5*1.57+craftinfo->getContentSize().height;
    CCPoint point = ccp(xMARGIN*1.5+craftinfo->getContentSize().width/2,winSize.height-yOffset/2*rowSpacing*3/winSize.height-yMARGIN*2.2*1.57);

    for(int i=0;i<STEP&& i<SPRITE_NUM;i++)
    {
        point.y = point.y - rowSpacing;
		
	
		int index = i+1;
		
		CCSprite* craftinfo =CCSprite::createWithSpriteFrameName("craft_info.png");
		AmendInfo(craftinfo,index);

		CCSprite* craftinfosel =CCSprite::createWithSpriteFrameName("craft_info_sel.png");
		AmendInfo(craftinfosel,index);
		CCMenuItemSprite* startButton = CCMenuItemSprite::create(craftinfo,craftinfosel,this,menu_selector(Splash::levelButtonTapped));
		startButton->retain();
		startButton->setPosition(point);
		startButton->setTag(BUILDING_NUM+i);
		 
        items->addObject(startButton);
		
    }

	for(int i=0;i<SPRITE_NUM;i++)
		decks[i].selection = false;

	CCSprite*	button = CCSprite::createWithSpriteFrameName("shortcut_home.png");
	point = ccp(winSize.width-button->getContentSize().width/2,winSize.height/2-button->getContentSize().height);
	CCMenuItemSprite* homeButton = CCMenuItemSprite::create(CCSprite::createWithSpriteFrameName("shortcut_home.png"),CCSprite::createWithSpriteFrameName("shortcut_home.png"),this,menu_selector(Splash::homeButtonTapped));
	homeButton->setPosition(point);
	items->addObject(homeButton);

	point.y += button->getContentSize().height;
	CCMenuItemSprite* shopButton = CCMenuItemSprite::create(CCSprite::createWithSpriteFrameName("shortcut_shop.png"),CCSprite::createWithSpriteFrameName("shortcut_shop.png"),this,menu_selector(Splash::shopButtonTapped));
	shopButton->setPosition(point);
	items->addObject(shopButton);

	point.y += button->getContentSize().height;
	CCMenuItemSprite* helpButton = CCMenuItemSprite::create(CCSprite::createWithSpriteFrameName("shortcut_help.png"),CCSprite::createWithSpriteFrameName("shortcut_help.png"),this,menu_selector(Splash::helpButtonTapped));
	helpButton->setPosition(point);
	items->addObject(helpButton);


    menu = CCMenu::createWithArray(items);
	//menu->alignItemsVerticallyWithPadding(MARGIN*0.25);
    //menu->setPosition(ccp(MARGIN*1.5+craftinfo->getContentSize().width/2,winSize.height/2));
    menu->setPosition(ccp(0,0-yMARGIN));
	this->addChild(menu);
	CCString *str = CCString::createWithFormat("%d/%d",page,(SPRITE_NUM+STEP-1)/STEP); 
	
	pagelabel = CCLabelTTF::create(str->getCString(), "Verdana-Bold", fontSizeTiny, ccp(xMARGIN,yMARGIN*0.5), kCCTextAlignmentCenter );
	pagelabel->setPosition(ccp(xMARGIN * 1.5,yMARGIN*1.8*1.57-0.77*yOffset));
	this->addChild(pagelabel);
	std::string pageword = CCUserDefault::sharedUserDefault()->getStringForKey("select4");

	CCString *decks = CCString::createWithFormat("%s:%d/%d",pageword.c_str(),deckscount,SPRITE_NUM);
	
	decksLabel = CCLabelTTF::create(decks->getCString(), fontname, fontSizeTiny, ccp(xMARGIN*5,yMARGIN*0.5), kCCTextAlignmentCenter );
	decksLabel->setPosition(ccp(xMARGIN * 9.7 ,yMARGIN*1.8*1.57-0.77*yOffset));
	this->addChild(decksLabel);

	CCSprite* left = CCSprite::createWithSpriteFrameName("arrow_left.png");
	left->setPosition(ccp(xMARGIN* 1 ,winSize.height * 0.5));
	this->addChild(left);

	CCSprite* right = CCSprite::createWithSpriteFrameName("arrow_right.png");
	right->setPosition(ccp(xMARGIN * 11,winSize.height * 0.5));
	this->addChild(right);

	std::string helpword = CCUserDefault::sharedUserDefault()->getStringForKey("home2");
	//CCString* message = CCString::create(text1);
    
    CCString* wdlevel = CCString::createWithFormat(pvp?"Duel WIFI/BT":"Level %d",g_level);
	CCLabelTTF* level =CCLabelTTF::create(wdlevel->getCString(), fontname, fontSizeBig, ccp(xMARGIN*4,yMARGIN), kCCTextAlignmentCenter );
    level->setPosition(ccp(xMARGIN*3,winSize.height-3*yMARGIN));
    level->setColor(ccc3(185,220,255));
    this->addChild(level);
	//	ttf1->setPosition(ccp(winSize.width/2,yoffset));

	//int yoffset = winSize.height/2 - MARGIN * (SLIDENUM/2);
	//for(int i =0; i< SLIDENUM; i++)
	//{
	//	CCLabelTTF* ttf1 = CCLabelTTF::create(sliderintro[i], "Helvetica", 12, ccp(MARGIN*4,MARGIN), kCCTextAlignmentRight );
	//	ttf1->setPosition(ccp(winSize.width/2,yoffset));
	//	this->addChild(ttf1);
	//	sliders[i] = CCControlSlider::create(CCSprite::createWithSpriteFrameName("slide.png"),CCSprite::createWithSpriteFrameName(slideratlas[i]),CCSprite::createWithSpriteFrameName("slide_center.png"));
	//	sliders[i]->setPosition(ccp(winSize.width/2+sliders[i]->getContentSize().width/2+MARGIN*2,yoffset+sliders[i]->getContentSize().height/2));
	//	yoffset += MARGIN;
	//	sliders[i]->setValue(0.9f);
	//    this->addChild(sliders[i]);
	//}
	
	

	//slider->setEnabled(true);
	//slider->setMaximumValue(150);

   CCMenuItemSprite *startButton =  CCMenuItemSprite::create(CCSprite::createWithSpriteFrameName("startbutton.png"),CCSprite::createWithSpriteFrameName("startbutton_sel.png"),this,menu_selector(Splash::startButtonTapped));
   CCSize contentSize =  startButton->getContentSize();
   startButton->setPosition (ccp(winSize.width/2+xMARGIN*4, winSize.height-yMARGIN*11.5*1.57));
 //   CCSprite* quirk = CCSprite::createWithSpriteFrameName(frameName);
	//quirk->setPosition(ccp(contentSize.width * 0.25, contentSize.height/2));
 //   startButton->addChild(quirk);

    //CCLabelBMFont* quirkLabel = CCLabelBMFont::create("Start","Courier.fnt");
    //quirkLabel->setPosition(ccp(contentSize.width * 0.5,contentSize.height*0.5));
    //startButton->addChild(quirkLabel);
	menu->addChild(startButton);
	//CCMenu* _menu->addChild(startButton);
	//menu_sel->setPosition(ccp(winSize.width/2,MARGIN));

	std::string selectword = CCUserDefault::sharedUserDefault()->getStringForKey("select1");
    guide = CCLabelTTF::create(selectword.c_str(), fontname, fontSizeBig, ccp(xMARGIN*4,7*yMARGIN), kCCTextAlignmentLeft );
	guide->setPosition(ccp(winSize.width/2+xMARGIN*4.5, winSize.height-yMARGIN*7.5*1.57));
 	guide->setColor(ccc3(229,205,84));
	this->addChild(guide);

}
void  Splash::homeButtonTapped(CCObject* obj) 
{
	CCDirector::sharedDirector()->replaceScene(ArmorHome::scene());
}
void  Splash::helpButtonTapped(CCObject* obj) 
{
	CCDirector::sharedDirector()->replaceScene(HelpLayer::scene());
}

void Splash::shopButtonTapped(CCObject* obj) 
{
	#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
	CCDirector::sharedDirector()->replaceScene(UserPay::scene());
#endif
}
void Splash::AmendInfo(CCSprite* craftinfo,int index)
{    
	    CCSize winSize = CCDirector::sharedDirector()->getWinSize();
		int _yOffset = yOffset/2* craftinfo->getContentSize().height/winSize.height;
		CCSprite* typeimg;
		if(decks[index].fight.melee)
			typeimg = CCSprite::createWithSpriteFrameName("monstertype_melee.png");
		if(decks[index].fight.range)
			typeimg = CCSprite::createWithSpriteFrameName("monstertype_range.png");
		if(decks[index].fight.aoe)
			typeimg = CCSprite::createWithSpriteFrameName("monstertype_meleeaoe.png");
		typeimg->setPosition(ccp(xMARGIN * 2.25,yMARGIN*0.89*1.57+_yOffset));
		craftinfo->addChild(typeimg);
		
		CCSprite* craftimg = CCSprite::createWithSpriteFrameName(atlas[index-1]);
		craftimg->setPosition(ccp(craftimg->getContentSize().width/2+xMARGIN*0.1,craftimg->getContentSize().height/2+yMARGIN*0.1*1.57+_yOffset/2));
		craftinfo->addChild(craftimg);

		CCLabelTTF* namelabel = CCLabelTTF::create(decks[index].name, "Verdana-Bold", fontSizeSmall, ccp(xMARGIN*1.8,yMARGIN), kCCTextAlignmentLeft );
		namelabel->setPosition(ccp(xMARGIN * 3.5,yMARGIN*0.85*1.57+_yOffset/2));
		namelabel->setColor(ccc3(248,244,0));
		craftinfo->addChild(namelabel);

		CCString *hpstr = CCString::createWithFormat("%.0f",decks[index].fight.HitPoint); 
		CCLabelTTF* hplabel = CCLabelTTF::create(hpstr->getCString(), "Verdana-Bold", fontSizeTiny, ccp(xMARGIN,yMARGIN), kCCTextAlignmentCenter );
		hplabel->setPosition(ccp(xMARGIN * 3,yMARGIN*0.1*1.57+_yOffset/2));
		hplabel->setColor(ccc3(248,244,0));
		craftinfo->addChild(hplabel);

		CCString *attackstr = CCString::createWithFormat("%.0f",decks[index].fight.Damage); 
		CCLabelTTF* attacklabel = CCLabelTTF::create(attackstr->getCString(), "Verdana-Bold", fontSizeTiny, ccp(xMARGIN,yMARGIN), kCCTextAlignmentCenter );
		attacklabel->setPosition(ccp(xMARGIN * 4.2,yMARGIN*0.1*1.57+_yOffset/2));
		attacklabel->setColor(ccc3(248,244,0));
		craftinfo->addChild(attacklabel);

		CCString *speedstr = CCString::createWithFormat("%d",decks[index].fight.maxVelocity); 
		CCLabelTTF* speedlabel = CCLabelTTF::create(speedstr->getCString(), "Verdana-Bold", fontSizeTiny, ccp(xMARGIN,yMARGIN), kCCTextAlignmentCenter );
		speedlabel->setPosition(ccp(xMARGIN * 6.1,yMARGIN*0.1*1.57+_yOffset/2));
		speedlabel->setColor(ccc3(248,244,0));
		craftinfo->addChild(speedlabel);

		CCString *buildstr = CCString::createWithFormat("%.1f",decks[index].fight.FireRate);
		CCLabelTTF* buildlabel = CCLabelTTF::create(buildstr->getCString(), "Verdana-Bold", fontSizeTiny, ccp(xMARGIN,yMARGIN), kCCTextAlignmentCenter );
		buildlabel->setPosition(ccp(xMARGIN * 8.1,yMARGIN*0.1*1.57+_yOffset/2));
		buildlabel->setColor(ccc3(248,244,0));
		craftinfo->addChild(buildlabel);

		CCString *peoplestr = CCString::createWithFormat("%d",decks[index].fight.FoodCap); 
		CCLabelTTF* peoplelabel = CCLabelTTF::create(peoplestr->getCString(), "Verdana-Bold", fontSizeSmall, ccp(xMARGIN,yMARGIN), kCCTextAlignmentCenter );
		peoplelabel->setPosition(ccp(xMARGIN * 6.1,yMARGIN*0.85*1.57+_yOffset/2));
		peoplelabel->setColor(ccc3(248,244,0));
		craftinfo->addChild(peoplelabel);

		CCString *coinstr = CCString::createWithFormat("%d",decks[index].price); 
		CCLabelTTF* coinlabel = CCLabelTTF::create(coinstr->getCString(), "Verdana-Bold", fontSizeSmall, ccp(xMARGIN,yMARGIN), kCCTextAlignmentCenter );
		coinlabel->setPosition(ccp(xMARGIN * 8.1,yMARGIN*0.85*1.57+_yOffset/2));
		coinlabel->setColor(ccc3(248,244,0));
		craftinfo->addChild(coinlabel);

}
void Splash::levelButtonTapped(CCObject *object)
{
#if SOUND
    CocosDenshion::SimpleAudioEngine::sharedEngine()->playEffect("menu_click.wav");
#endif
	//menu_sel->removeChild((CCMenuItemSprite*)object,true);
	CCMenuItemSprite* item = (CCMenuItemSprite*)object;
	int tag = item->getTag();
	int index = tag - BUILDING_NUM;
	decks[tag].selection = !decks[tag].selection;
	if(decks[tag].selection)
	{
		if(deckscount>=MAX_SELECTED)
		{
			decks[tag].selection = !decks[tag].selection;
			std::string selectword = CCUserDefault::sharedUserDefault()->getStringForKey("select2");
    
			guide->setString(selectword.c_str());
			return;
		}
		CCSprite* craftinfosel =CCSprite::createWithSpriteFrameName("craft_info_sel.png");
		AmendInfo(craftinfosel,tag);
		CCSprite* craftinfo =CCSprite::createWithSpriteFrameName("craft_info.png");
		AmendInfo(craftinfo,tag);
		item->setNormalImage(craftinfosel);
		item->setSelectedImage(craftinfo);
		deckscount++;
			std::string selectword = CCUserDefault::sharedUserDefault()->getStringForKey("select4");

	CCString *decks = CCString::createWithFormat("%s:%d/%d",selectword.c_str(),deckscount,SPRITE_NUM);

	
		decksLabel->setString(decks->getCString());
	}
	else
	{
		CCSprite* craftinfosel =CCSprite::createWithSpriteFrameName("craft_info_sel.png");
		AmendInfo(craftinfosel,tag);
		CCSprite* craftinfo =CCSprite::createWithSpriteFrameName("craft_info.png");
		AmendInfo(craftinfo,tag);
		item->setNormalImage(craftinfo);
		item->setSelectedImage(craftinfosel);
		deckscount--;
				std::string selectword = CCUserDefault::sharedUserDefault()->getStringForKey("select4");

	CCString *decks = CCString::createWithFormat("%s:%d/%d",selectword.c_str(),deckscount,SPRITE_NUM);


		decksLabel->setString(decks->getCString());

	}
	//planes->addObject(CCInteger::create(tag));
	//sliders[0]->setValue(decks[tag].fight.HitPoint/maxDeck[0].fight.HitPoint);
	//sliders[1]->setValue(float(decks[tag].fight.maxVelocity)/maxDeck[0].fight.maxVelocity);
	//sliders[2]->setValue(float(decks[tag].buildtime)/maxDeck[0].buildtime);
	//sliders[3]->setValue(decks[tag].fight.Damage/maxDeck[0].fight.Damage);
	//sliders[4]->setValue(1/decks[tag].fight.FireRate/1/maxDeck[0].fight.FireRate);
	//sliders[5]->setValue(float(decks[tag].price)/maxDeck[0].price);
	//sliders[6]->setValue(float(decks[tag].fight.FoodCap)/maxDeck[0].fight.FoodCap);
}

void Splash::startButtonTapped(CCObject *object)
{
	
	if(	deckscount==0)
	{
		std::string selectword = CCUserDefault::sharedUserDefault()->getStringForKey("select3");
    
		guide->setString(selectword.c_str());
		return;
	}
    CCDirector::sharedDirector()->replaceScene(pvp?CCBattle::scene():CCLayerParent::scene());
	 
}



void Splash::registerWithTouchDispatcher()
{
	CCDirector::sharedDirector()->getTouchDispatcher()->addTargetedDelegate(this,0,true);
}

bool Splash::ccTouchBegan(CCTouch *pTouch, CCEvent *pEvent)
{
	return true;
}

void Splash::ccTouchEnded(CCTouch *pTouch, CCEvent *pEvent)
{
	
	CCPoint prev = pTouch->getStartLocationInView();
	CCPoint local = pTouch->getLocationInView();
	CCPoint vec = ccpSub(local,prev);
	CCLog("Moved ended %f,%f",vec.x,vec.y);
    CCSize winSize = CCDirector::sharedDirector()->getWinSize();
	//CCPoint current = menu->getPosition();
	//if(current.y + vec.y<winSize.height - MARGIN && current.y + vec.y>MARGIN)
	//	menu->setPosition(ccp(current.x,current.y + vec.y));
 	//	CCSprite* craftinfo =CCSprite::createWithSpriteFrameName("craft_info.png");
		//CCPoint point = ccp(xMARGIN*1.5+craftinfo->getContentSize().width/2,winSize.height-yMARGIN*2.5);
		//int rowSpacing = xMARGIN*0.5+craftinfo->getContentSize().height;
 	CCSprite* craftinfo =CCSprite::createWithSpriteFrameName("craft_info.png");
    int rowSpacing = yMARGIN*0.5*1.57+craftinfo->getContentSize().height;
    CCPoint point = ccp(xMARGIN*1.5+craftinfo->getContentSize().width/2,winSize.height-yOffset/2*rowSpacing*3/winSize.height-yMARGIN*2.2*1.57);

	if(vec.x>xMARGIN && page*STEP<SPRITE_NUM)
	{
		//cannot go to next page
		//if(g_level <= page* STEP) return;
		page++;
        
		menu->removeAllChildren();
		CCArray* items = CCArray::create();
		for(int i=(page-1)*STEP;i< page* STEP && i<SPRITE_NUM;i++)
		{
			point.y = point.y - rowSpacing;

			int index = i+1;
			CCSprite* craftinfo =CCSprite::createWithSpriteFrameName("craft_info.png");
			AmendInfo(craftinfo,index);

			CCSprite* craftinfosel =CCSprite::createWithSpriteFrameName("craft_info_sel.png");
			AmendInfo(craftinfosel,index);
			bool selection = decks[index].selection;
			CCMenuItemSprite* startButton = CCMenuItemSprite::create(selection?craftinfosel:craftinfo,selection?craftinfo:craftinfosel,this,menu_selector(Splash::levelButtonTapped));

			//CCMenuItemSprite* startButton = CCMenuItemSprite::create(CCSprite::createWithSpriteFrameName(decks[BUILDING_NUM+i].selection?atlas_sel[i]:atlas_deck[i]),CCSprite::createWithSpriteFrameName(decks[BUILDING_NUM+i].selection?atlas_deck[i]:atlas_sel[i]),this,menu_selector(Splash::levelButtonTapped));
			startButton->retain();
			startButton->setPosition(point);
			startButton->setTag(BUILDING_NUM+i);
		 
			items->addObject(startButton);
			//decks[i].selection = false;
			menu->addChild(startButton);
		}
			CCSprite*	button = CCSprite::createWithSpriteFrameName("shortcut_home.png");
			point = ccp(winSize.width-button->getContentSize().width/2,winSize.height/2-button->getContentSize().height);
			CCMenuItemSprite* homeButton = CCMenuItemSprite::create(CCSprite::createWithSpriteFrameName("shortcut_home.png"),CCSprite::createWithSpriteFrameName("shortcut_home.png"),this,menu_selector(Splash::shopButtonTapped));
			homeButton->setPosition(point);
			items->addObject(homeButton);
			menu->addChild(homeButton);

			point.y += button->getContentSize().height;
			CCMenuItemSprite* shopButton = CCMenuItemSprite::create(CCSprite::createWithSpriteFrameName("shortcut_shop.png"),CCSprite::createWithSpriteFrameName("shortcut_shop.png"),this,menu_selector(Splash::shopButtonTapped));
			shopButton->setPosition(point);
			items->addObject(shopButton);
			menu->addChild(shopButton);

			point.y += button->getContentSize().height;
			CCMenuItemSprite* helpButton = CCMenuItemSprite::create(CCSprite::createWithSpriteFrameName("shortcut_help.png"),CCSprite::createWithSpriteFrameName("shortcut_help.png"),this,menu_selector(Splash::shopButtonTapped));
			helpButton->setPosition(point);
			items->addObject(helpButton);
			menu->addChild(helpButton);

			   CCMenuItemSprite *startButton =  CCMenuItemSprite::create(CCSprite::createWithSpriteFrameName("startbutton.png"),CCSprite::createWithSpriteFrameName("startbutton_sel.png"),this,menu_selector(Splash::startButtonTapped));
		   CCSize contentSize =  startButton->getContentSize();
		   startButton->setPosition (ccp(winSize.width/2+xMARGIN*4, winSize.height-yMARGIN*11.5*1.57));
		   menu->addChild(startButton);
		CCSprite* craftinfo = CCSprite::createWithSpriteFrameName("craft_info.png");
		//menu = CCMenu::createWithArray(items);
		//menu->alignItemsVerticallyWithPadding(MARGIN*0.25);
		//menu->setPosition(ccp(MARGIN*1.5+craftinfo->getContentSize().width/2,winSize.height/2));

		CCString *str = CCString::createWithFormat("%d/%d",page,(SPRITE_NUM+STEP-1)/STEP);
		pagelabel->setString(str->getCString());
				std::string selectword = CCUserDefault::sharedUserDefault()->getStringForKey("select1");
    
		guide->setString(selectword.c_str());
		
	}
	if(vec.x<-xMARGIN && page>1)
	{
		page--;
		menu->removeAllChildren();
		CCArray* items = CCArray::create();
		for(int i=(page-1)*STEP;i< page* STEP && i<SPRITE_NUM;i++)
		{
			point.y = point.y - rowSpacing;
			int index = i+1;
			CCSprite* craftinfo =CCSprite::createWithSpriteFrameName("craft_info.png");
			AmendInfo(craftinfo,index);

			CCSprite* craftinfosel =CCSprite::createWithSpriteFrameName("craft_info_sel.png");
			AmendInfo(craftinfosel,index);
			bool selection = decks[index].selection;
			CCMenuItemSprite* startButton = CCMenuItemSprite::create(selection?craftinfosel:craftinfo,selection?craftinfo:craftinfosel,this,menu_selector(Splash::levelButtonTapped));

			//CCMenuItemSprite* startButton = CCMenuItemSprite::create(CCSprite::createWithSpriteFrameName(decks[BUILDING_NUM+i].selection?atlas_sel[i]:atlas_deck[i]),CCSprite::createWithSpriteFrameName(decks[BUILDING_NUM+i].selection?atlas_deck[i]:atlas_sel[i]),this,menu_selector(Splash::levelButtonTapped));
			startButton->retain();
			startButton->setPosition(point);
			startButton->setTag(BUILDING_NUM+i);
		 
			items->addObject(startButton);
			menu->addChild(startButton);
		}
			CCSprite*	button = CCSprite::createWithSpriteFrameName("shortcut_home.png");
			point = ccp(winSize.width-button->getContentSize().width/2,winSize.height/2-button->getContentSize().height);
			CCMenuItemSprite* homeButton = CCMenuItemSprite::create(CCSprite::createWithSpriteFrameName("shortcut_home.png"),CCSprite::createWithSpriteFrameName("shortcut_home.png"),this,menu_selector(Splash::shopButtonTapped));
			homeButton->setPosition(point);
			items->addObject(homeButton);
			menu->addChild(homeButton);

			point.y += button->getContentSize().height;
			CCMenuItemSprite* shopButton = CCMenuItemSprite::create(CCSprite::createWithSpriteFrameName("shortcut_shop.png"),CCSprite::createWithSpriteFrameName("shortcut_shop.png"),this,menu_selector(Splash::shopButtonTapped));
			shopButton->setPosition(point);
			items->addObject(shopButton);
			menu->addChild(shopButton);

			point.y += button->getContentSize().height;
			CCMenuItemSprite* helpButton = CCMenuItemSprite::create(CCSprite::createWithSpriteFrameName("shortcut_help.png"),CCSprite::createWithSpriteFrameName("shortcut_help.png"),this,menu_selector(Splash::shopButtonTapped));
			helpButton->setPosition(point);
			items->addObject(helpButton);
			menu->addChild(helpButton);

		   
		   CCMenuItemSprite *startButton =  CCMenuItemSprite::create(CCSprite::createWithSpriteFrameName("startbutton.png"),CCSprite::createWithSpriteFrameName("startbutton_sel.png"),this,menu_selector(Splash::startButtonTapped));
		   CCSize contentSize =  startButton->getContentSize();
		   startButton->setPosition (ccp(winSize.width/2+xMARGIN*4, winSize.height-yMARGIN*11.5*1.57));
		   menu->addChild(startButton);
		//CCSprite* craftinfo = CCSprite::createWithSpriteFrameName("craft_info.png");
		////menu = CCMenu::createWithArray(items);
		//menu->alignItemsVerticallyWithPadding(MARGIN*0.25);
		//menu->setPosition(ccp(MARGIN*1.5+craftinfo->getContentSize().width/2,winSize.height/2));

		CCString *str = CCString::createWithFormat("%d/%d",page,(SPRITE_NUM+STEP-1)/STEP);
		pagelabel->setString(str->getCString());
		std::string selectword = CCUserDefault::sharedUserDefault()->getStringForKey("select1");
    
		guide->setString(selectword.c_str());
	}
	
}
