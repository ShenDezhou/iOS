#include "ArmorHomeScene.h"
#include "Scenes.h"
#include "KTPlayC.h"

USING_NS_CC;
USING_NS_CC_EXT;

CCScene* ArmorHome::scene()
{
    // 'scene' is an autorelease object
    CCScene *scene = CCScene::create();
    
    // 'layer' is an autorelease object
    ArmorHome *layer = ArmorHome::create();

    // add layer as a child to scene
    scene->addChild(layer);

    // return the scene
    return scene;
}

// on "init" you need to initialize your instance
bool ArmorHome::init()
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

void ArmorHome::basicSetup()
{
	int _level= CCUserDefault::sharedUserDefault()->getIntegerForKey("level",1);
	//_level = 8;
    CCSize winSize = CCDirector::sharedDirector()->getWinSize();

	CCSize frameSize = CCEGLView::sharedOpenGLView()->getFrameSize();  
	 // In this demo, we select resource according to the frame's height.
	 // If the resource size is different from design resolution size, you need to set contentScaleFactor.    
	 // We use the ratio of resource's height to the height of design resolution,    
	 // this can make sure that the resource's height could fit for the height of design resolution.     
	 // if the frame's height is larger than the height of medium resource size, select large resource.
	char* mapname;
    if(frameSize.width == ip5Resource.size.width)
    {
        CCSpriteFrameCache::sharedSpriteFrameCache()->addSpriteFramesWithFile("Sprites1-ip5.plist");
		_batchNodes = CCSpriteBatchNode::create("Sprites1-ip5.pvr.ccz");
//		mapname = "background@2.tmx";
    }else
    {
	 if (frameSize.height > mediumResource.size.height)
	 { 
		CCSpriteFrameCache::sharedSpriteFrameCache()->addSpriteFramesWithFile("Sprites1-ipadhd.plist");
		_batchNodes = CCSpriteBatchNode::create("Sprites1-ipadhd.pvr.ccz");
        
//         CCSpriteFrameCache::sharedSpriteFrameCache()->addSpriteFramesWithFile("Sprites2-ipadhd.plist");
//         CCSpriteBatchNode* _nodes = CCSpriteBatchNode::create("Sprites2-ipadhd.pvr.ccz");
//         
//         for(int i=0;i<_nodes->getChildrenCount();i++)
//         {
//             _batchNodes->addChild((CCSprite*)_nodes->getChildren()->objectAtIndex(i));
//             
//         }
   
//         CCSpriteFrameCache::sharedSpriteFrameCache()->addSpriteFramesWithFile("Sprites3-ipadhd.plist");
//         _nodes = CCSpriteBatchNode::create("Sprites3-ipadhd.pvr.ccz");
//         for(int i=0;i<_nodes->getChildrenCount();i++)
//         {
//             _batchNodes->addChild((CCSprite*)_nodes->getChildren()->objectAtIndex(i));
//         }
		 //CCFileUtils::sharedFileUtils()->setResourceDirectory(largeResource.directory);
		 //pDirector->setContentScaleFactor(largeResource.size.height/designResolutionSize.height);
//		 		mapname = "background@4.tmx";
	 }
	 // if the frame's height is larger than the height of small resource size, select medium resource.    
	 else if (frameSize.height > smallResource.size.height)    
	 {        
		CCSpriteFrameCache::sharedSpriteFrameCache()->addSpriteFramesWithFile("Sprites1-ipad.plist");
		_batchNodes = CCSpriteBatchNode::create("Sprites1-ipad.pvr.ccz");
		 //CCFileUtils::sharedFileUtils()->setResourceDirectory(mediumResource.directory);        
		 //pDirector->setContentScaleFactor(mediumResource.size.height/designResolutionSize.height);    
//		mapname = "background@2.tmx";
	 }
	 // if the frame's height is smaller than the height of medium resource size, select small resource.    
	 else  if (frameSize.height > tinyResource.size.height)      
	 {
		 CCSpriteFrameCache::sharedSpriteFrameCache()->addSpriteFramesWithFile("Sprites1-hd.plist");
		_batchNodes = CCSpriteBatchNode::create("Sprites1-hd.pvr.ccz");
//		mapname = "background@2.tmx";

	 }
	 else    
	 {
		CCSpriteFrameCache::sharedSpriteFrameCache()->addSpriteFramesWithFile("Sprites1.plist");
		_batchNodes = CCSpriteBatchNode::create("Sprites1.pvr.ccz");
//		 mapname = "background.tmx";

		 //CCFileUtils::sharedFileUtils()->setResourceDirectory(smallResource.directory);        
		 //pDirector->setContentScaleFactor(smallResource.size.height/designResolutionSize.height); 
	 }
    }
     mapname = "background@4.tmx";
	_tileMap = CCTMXTiledMap::create(mapname);
	_tileMap->retain();
	  _background = _tileMap->layerNamed("background");
		_background->retain();
    //this->setBackground(_tileMap->layerNamed("background"));
	this->addChild(_tileMap, -1);

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
    pvp = false;
	bool paiduser= CCUserDefault::sharedUserDefault()->getBoolForKey("PAIDUSER",false);
	PAIDUSER = paiduser;
    float paidrate =  CCUserDefault::sharedUserDefault()->getFloatForKey("PAIDRATE",0.01f);
    PAIDRATE = paidrate;
    if(paiduser)
    {
        
    
        MAX_SELECTED = 8;
	}

    //this->setTilemap( CCTMXTiledMap::create("background.tmx"));

    //int mapWidth =_tileMap->getMapSize().width;
    //int tilew =_tileMap->getTileSize().width;
    //
    //
    ////求出的是整个瓦片地图的高
    ////_tileMap->getMapSize().height瓦片地图纵向有多少个瓦片
    ////_tileMap->getTileSize().height每一个瓦片的高度
    //
    //int mapHeight =_tileMap->getMapSize().height;
    //int tileH = _tileMap->getTileSize().height;
    
    CCTMXObjectGroup *objects = _tileMap->objectGroupNamed("Objects");
    CCAssert(objects != NULL, "Objects' object group not found");
    //CCDictionary *spawnPoint = objects->objectNamed("SpawnPoint");
    //CCAssert(spawnPoint != NULL, "SpawnPoint object not found");
    //int x = spawnPoint->valueForKey("x")->intValue()/CC_CONTENT_SCALE_FACTOR();
    //int y = spawnPoint->valueForKey("y")->intValue()/CC_CONTENT_SCALE_FACTOR();
    //int spawnwidth = spawnPoint->valueForKey("width")->intValue()/CC_CONTENT_SCALE_FACTOR();
    //int spawnheight = spawnPoint->valueForKey("height")->intValue()/CC_CONTENT_SCALE_FACTOR();
    
	CCDictionary *indexPoint = objects->objectNamed(CCString::createWithFormat("%d",g_level)->getCString());
    CCAssert(indexPoint != NULL, "index object not found");
    int x = indexPoint->valueForKey("x")->intValue()/CC_CONTENT_SCALE_FACTOR();
    int y = indexPoint->valueForKey("y")->intValue()/CC_CONTENT_SCALE_FACTOR();
    int width = indexPoint->valueForKey("width")->intValue()/CC_CONTENT_SCALE_FACTOR();
    int height = indexPoint->valueForKey("height")->intValue()/CC_CONTENT_SCALE_FACTOR();
        
	_player=  CCSprite::createWithSpriteFrameName("aircraft.png");
	_player->retain();
    //this->setPlayer();
	//_player->setAnchorPoint(ccp(0,1));
    _player->setPosition(ccp(x+width/2, y+height/2-height));
    this->addChild(_player);
    
    this->setViewpointCenter(_player->getPosition());
        //other UI
//	CCSprite *background =  CCSprite::createWithSpriteFrameName(backgrounds[0]);
//    background->setPosition(ccp(winSize.width/2, winSize.height/2-yOffset/2));
//    this->addChild(background,-1);

	CCSprite* button = CCSprite::createWithSpriteFrameName("button.png");
	//CCLabelBMFont* welcome = CCLabelBMFont::create("Welcome ","Courier.fnt");
 //   welcome->retain();
 //   welcome->setPosition(ccp(MARGIN*2,winSize.height-MARGIN*1.5));
	//this->addChild(welcome);
//	std::string userword = CCUserDefault::sharedUserDefault()->getStringForKey("home1");
//	std::string name= CCUserDefault::sharedUserDefault()->getStringForKey("name",userword.c_str());
//	CCScale9Sprite* sacel9SprY=CCScale9Sprite::createWithSpriteFrameName("button_null.png",CCRectMake(3,3,
//		button->getContentSize().width-6,	button->getContentSize().height-6));
//    CCEditBox* box = CCEditBox::create(CCSizeMake(button->getContentSize().width*1.1,button->getContentSize().height*1.1), sacel9SprY);
//	box->setPosition(ccp(xMARGIN*1.55+button->getContentSize().width/2,winSize.height-yOffset/2*button->getContentSize().height*1.1/winSize.height-yMARGIN*1.4*1.57));
//	std::string store =  CCUserDefault::sharedUserDefault()->getStringForKey("name");
//	if(store!="")
//		box->setText(store.c_str());
//
//	box->setPlaceHolder(userword.c_str());
//	box->setFontColor(ccc3(0, 250, 29));
//	box->setMaxLength(8);
//	box->setFont(fontname,fontSizeBig);
//	//…Ë÷√º¸≈Ã ‰»Îƒ£ Ω
//    box->setInputMode(kEditBoxInputModeAny);
//    
//    //…Ë÷√º¸≈Ã ‰»Îµƒ◊÷∑˚µƒ ◊–¥¥Û–¥
//    box->setInputFlag(kEditBoxInputFlagInitialCapsWord);
//    
//    //…Ë÷√º¸≈ÃÀıªÿ∞¥≈•Œ™done
//    box->setReturnType(kKeyboardReturnTypeDone);
//	this->addChild(box);
//	box->setDelegate(this); 

	std::string helpword = CCUserDefault::sharedUserDefault()->getStringForKey("home2");
	//CCString* message = CCString::create(text1);

	CCLabelTTF* guide =CCLabelTTF::create(helpword.c_str(), fontname, fontSizeBig, ccp(xMARGIN*16,yMARGIN), kCCTextAlignmentCenter );
	guide->setColor(ccc3(185,220,255));
	guide->setPosition(ccp(winSize.width * 0.5, winSize.height - 0.5*yMARGIN*1.57));
    this->addChild(guide);

  //  int columns = 2;
  //  float spaceBetween = columns +1;
  //  int rows = 5;
  //  int spaceBetweenRows = rows +1;
  //  int spacing = xMARGIN+button->getContentSize().width;
  //  int rowSpacing = yMARGIN*1.57+button->getContentSize().height;
  //  
//    CCPoint point = ccp(0,winSize.height-yMARGIN*4*1.57);
//  //  
//     CCArray* items = CCArray::create();
  //  for(int i=0;i<9;i++)
  //  {
  //      point.x = point.x + spacing;
  //      if(point.x-spacing>= spacing*columns) {
  //          point.x = spacing;
  //          point.y = point.y - rowSpacing;
  //       }
		//CCMenuItemSprite* quirkButton;
		//if(i<_level)
		//	quirkButton = CCMenuItemSprite::create(CCSprite::createWithSpriteFrameName("button.png"),CCSprite::createWithSpriteFrameName("button_sel.png"),this,menu_selector(ArmorHome::levelButtonTapped));
		//else
		//	quirkButton = CCMenuItemSprite::create(CCSprite::createWithSpriteFrameName("button_gray.png"),CCSprite::createWithSpriteFrameName("button_gray.png"),this,NULL);

		//quirkButton->setPosition(point);
  //      //char temp[64];
  //      //sprintf(temp, "Lv %d", i+1);
		//std::string levelword = CCUserDefault::sharedUserDefault()->getStringForKey("home3");
		//levelword+='0'+i+1;
  //      CCSize contentSize =  quirkButton->getContentSize();
  //      
  //      CCLabelBMFont* quirkLabel = CCLabelBMFont::create(levelword.c_str(),fontfile);
		//quirkLabel->setColor(ccc3(185,220,255));
  //      if(i==8)
		//{
		//	std::string endlessword = CCUserDefault::sharedUserDefault()->getStringForKey("home4");
  //          quirkLabel->setString(endlessword.c_str());
		//}
		//quirkLabel->retain();
  //      quirkLabel->setPosition(ccp(contentSize.width * 0.5,contentSize.height * 0.68));
  //      quirkButton->addChild(quirkLabel);
  //      quirkButton->setTag(i+1);
  //      items->addObject(quirkButton);
  //      if(i==8)
  //      {
  //          
  //          quirkButton->setPosition(ccp(point.x+spacing/2,point.y+rowSpacing/2));
  //      }
  //  }

    
	//point.x = point.x + spacing;
	//if(point.x> spacing*columns) {
	//	point.x = spacing;
	//	point.y = point.y - rowSpacing;
 //   }
//	button = CCSprite::createWithSpriteFrameName("shortcut_home.png");
//	point = ccp(winSize.width/2-button->getContentSize().width/2,y-button->getContentSize().height);
//	CCMenuItemSprite* homeButton = CCMenuItemSprite::create(CCSprite::createWithSpriteFrameName("shortcut_home.png"),CCSprite::createWithSpriteFrameName("shortcut_home.png"),this,menu_selector(ArmorHome::homeButtonTapped));
//	homeButton->setPosition(point);
//	items->addObject(homeButton);
//
//	point.x += button->getContentSize().width;
//	CCMenuItemSprite* shopButton = CCMenuItemSprite::create(CCSprite::createWithSpriteFrameName("shortcut_shop.png"),CCSprite::createWithSpriteFrameName("shortcut_shop.png"),this,menu_selector(ArmorHome::shopButtonTapped));
//	shopButton->setPosition(point);
//	items->addObject(shopButton);
//
//	point.x += button->getContentSize().width;
//	CCMenuItemSprite* helpButton = CCMenuItemSprite::create(CCSprite::createWithSpriteFrameName("shortcut_help.png"),CCSprite::createWithSpriteFrameName("shortcut_help.png"),this,menu_selector(ArmorHome::helpButtonTapped));
//	helpButton->setPosition(point);
//	items->addObject(helpButton);
//
//    CCMenu* menu = CCMenu::createWithArray(items);
//    menu->setPosition(ccp(0,0-yMARGIN));
//    this->addChild(menu);
    this->setTouchEnabled(true);
}
void ArmorHome::registerWithTouchDispatcher(void)
{
    CCDirector::sharedDirector()->getTouchDispatcher()->addTargetedDelegate(this,0,true);
}
bool ArmorHome::ccTouchBegan(CCTouch *pTouch, CCEvent *pEvent)
{
    return true;
}
void ArmorHome::setPlayerPosition(CCPoint position)
{
    _player->setPosition(position);
}
void ArmorHome::ccTouchEnded(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent)
{
    //convertToNodeSpace函数就是把OpenGL的坐标转换成CCLayer的坐标。
    CCPoint touchPosition = this->convertTouchToNodeSpace(pTouch);
    //获取任务在CCLayer上的坐标
    CCPoint playerPos = _player->getPosition();
    CCPoint oriPos = _player->getPosition();
  
    //让触摸点的坐标减去人物的坐标，等于人物要移动的方向以及移动一个位置，我们称之为移动坐标点
    CCPoint diff = ccpSub(touchPosition, playerPos);
    
	//CCPoint previous = playerPos;
    //当移动坐标点的x坐标大于y坐标点时，我们只移动x轴，反之则移动y轴
    if (abs(diff.x) > abs(diff.y))
    {
        //当移动坐标点的x大于0时 我们向右移动即让人物的坐标x轴加上一个瓦片地图的宽度。
        if (diff.x > 0)
        {
            //getTileSize().width获取一个瓦片地图的宽度
            playerPos.x += _tileMap->getTileSize().width/CC_CONTENT_SCALE_FACTOR();
			_player->setRotation(0);
        }
        else
        {
            //当移动坐标点的x小于0时 我们向右移动即让人物的坐标x轴减去一个瓦片地图的宽度。
            //getTileSize().width获取一个瓦片地图的宽度
            playerPos.x -= _tileMap->getTileSize().width/CC_CONTENT_SCALE_FACTOR();
			_player->setRotation(180);
        }
    }
    else
    {
        //当移动坐标点的y大于0时 我们向右移动即让人物的坐标y轴加上一个瓦片地图的高度。
        if (diff.y > 0)
        {
            //getTileSize().height获取一个瓦片地图的高度
            playerPos.y += _tileMap->getTileSize().height/CC_CONTENT_SCALE_FACTOR();
			
			_player->setRotation(270);
        }
        else
        {
            //当移动坐标点的y小于0时 我们向右移动即让人物的坐标x轴减去一个瓦片地图的高度。
            //getTileSize().height获取一个瓦片地图的高度
            playerPos.y -= _tileMap->getTileSize().height/CC_CONTENT_SCALE_FACTOR();
			_player->setRotation(90);
        }
		//CCPoint turnAngle = ccpSub(playerPos,previous);
		
    }
	
	
    //求出这个瓦片地图的整体宽度 其中，_tileMap->getTileSize().width得到的是瓦片地图每一个瓦片的宽度，
    //_tileMap->getMapSize().width得到的是瓦片地图横向由多少个瓦片组成
    float mapWidth = _tileMap->getTileSize().width /CC_CONTENT_SCALE_FACTOR()* _tileMap->getMapSize().width;
    
    //求出这个瓦片地图的整体高度 其中，_tileMap->getTileSize().height得到的是瓦片地图每一个瓦片的高度，
    //_tileMap->getMapSize().height得到的是瓦片地图纵向由多少个瓦片组成
    float mapHeight = _tileMap->getMapSize().height * _tileMap->getTileSize().height/CC_CONTENT_SCALE_FACTOR();
    
    //以下这个判断的意思：只有人物的坐标点在瓦片地图中才对人物的坐标点进行重新设置
    //任务的坐标只有在小于瓦片地图的整体宽度和高度以及要大于0点 ，才在地图中
    if (playerPos.x < mapWidth && playerPos.y < mapHeight && playerPos.x >= 0 && playerPos.y >= 0)
    {
        this->setPlayerPosition(playerPos);
    }
    //将人物的坐标传入地图相对移动的方法，以便计算相对移动的方向。
    this->setViewpointCenter(_player->getPosition());
    
    CCTMXObjectGroup *objects = _tileMap->objectGroupNamed("Objects");
    CCAssert(objects != NULL, "Objects' object group not found");
    for(int i=1;i<29;i++)
    {
        CCDictionary *spawnPoint = objects->objectNamed(CCString::createWithFormat("%d",i)->getCString());
        CCAssert(spawnPoint != NULL, "index object not found");
        int x = spawnPoint->valueForKey("x")->intValue()/CC_CONTENT_SCALE_FACTOR();
        int y = spawnPoint->valueForKey("y")->intValue()/CC_CONTENT_SCALE_FACTOR();
        int width = spawnPoint->valueForKey("width")->intValue()/CC_CONTENT_SCALE_FACTOR();
        int height = spawnPoint->valueForKey("height")->intValue()/CC_CONTENT_SCALE_FACTOR();
        
        if(_player->boundingBox().intersectsRect(CCRectMake(x, y, width, height)))
        {
            g_level = i;
            
            switch (i) {
                case 1:
                {
                    if(KTPlayC::isEnabled()){
                        KTPlayC::show();
                        _player->setPosition(oriPos);
                    }
                }
                    break;
                case 2:
                {
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
                    CCDirector::sharedDirector()->replaceScene(UserPay::scene());
#endif
                    break;
                }
                case 3:
                {
                    CCDirector::sharedDirector()->replaceScene(HelpLayer::scene());
                    break;
                }
                case 4:
                {
                    pvp=true;
                    //g_level = 8;
                    CCDirector::sharedDirector()->replaceScene(Splash::scene(g_level));
                    break;
                }
                default:
                    CCDirector::sharedDirector()->replaceScene(Splash::scene(g_level));
                    break;
            }
            
        }
    }
}

void ArmorHome::addPlayers()
{
    CCSize winSize = CCDirector::sharedDirector()->getWinSize();
	_entityManager =new EntityManager();
	_entityFactory = new EntityFactory(_entityManager,_batchNodes);
	//CCDictElement* object = NULL;
	//CCDICT_FOREACH(_particleNodes,object)
	//{
	//	_entityFactory->AddBatchNode((CCParticleBatchNode*)object->getObject(),object->getStrKey());
	//}
	
    
	_healthSystem =new HealthSystem(_entityManager,_entityFactory);
	_moveSystem =new MoveSystem(_entityManager,_entityFactory);
	_playerSystem = new PlayerSystem(_entityManager,_entityFactory);
	_meleeSystem = new MeleeSystem(_entityManager,_entityFactory);
	_gunSystem = new GunSystem(_entityManager,_entityFactory);
	_aiSystem = new AISystem(_entityManager,_entityFactory);
    
    
}

void ArmorHome::levelButtonTapped(CCObject* obj){
#if SOUND
    CocosDenshion::SimpleAudioEngine::sharedEngine()->playEffect("menu_select.wav");
#endif
    CCMenuItemSprite* quirkButton = (CCMenuItemSprite* )obj;
    g_level = quirkButton->getTag();
       if(g_level==9)
    {
        if(KTPlayC::isEnabled()){
            KTPlayC::show();
        }
    }else
    {
        CCDirector::sharedDirector()->replaceScene(Splash::scene(g_level));
    }
}
void  ArmorHome::homeButtonTapped(CCObject* obj)
{
	CCDirector::sharedDirector()->replaceScene(ArmorHome::scene());
}
void  ArmorHome::helpButtonTapped(CCObject* obj) 
{
	CCDirector::sharedDirector()->replaceScene(HelpLayer::scene());
}

void ArmorHome::shopButtonTapped(CCObject* obj) 
{
	#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
	CCDirector::sharedDirector()->replaceScene(UserPay::scene());
#endif
}
//    ø™ ºΩ¯»Î±‡º≠
  void ArmorHome:: editBoxEditingDidBegin(cocos2d::extension::CCEditBox*editBox)
{

}
//Ω· ¯±‡º≠
  void ArmorHome:: editBoxEditingDidEnd(cocos2d::extension::CCEditBox* editBox)
{
	std::string* name = new std::string(editBox->getText());
	std::string store =  CCUserDefault::sharedUserDefault()->getStringForKey("name");
	if(store!=*name)
	{
		CCUserDefault::sharedUserDefault()->setStringForKey("name",*name);
		CCUserDefault::sharedUserDefault()->setIntegerForKey("level",1);
		CCDirector::sharedDirector()->replaceScene(ArmorHome::scene());
	}
}
//±‡º≠øÚŒƒ±æ∏ƒ±‰
void ArmorHome:: editBoxTextChanged(cocos2d::extension::CCEditBox* editBox, const std::string& text)
{
    
}
//µ±¥•∑¢return∫Ûµƒªÿµ˜∫Ø ˝
void ArmorHome:: editBoxReturn(cocos2d::extension::CCEditBox* editBox)
{

}
void ArmorHome::setViewpointCenter(CCPoint position)
{
    
    // 求出屏幕的范围包括宽和高
    CCSize winSize = CCDirector::sharedDirector()->getWinSize();
    //显示屏幕中心点的坐标大于屏幕宽和高的一半
    int x = MAX(position.x, winSize.width / 2);
    int y = MAX(position.y, winSize.height / 2);
    
    //求出的是整个瓦片地图的宽
    //_tileMap->getMapSize().width瓦片地图横向有多少个瓦片
    //_tileMap->getTileSize().width每一个瓦片的宽度
    int mapWidth =_tileMap->getMapSize().width *_tileMap->getTileSize().width;
    
    
    //求出的是整个瓦片地图的高
    //_tileMap->getMapSize().height瓦片地图纵向有多少个瓦片
    //_tileMap->getTileSize().height每一个瓦片的高度
    
    int mapHeight =_tileMap->getMapSize().height *_tileMap->getTileSize().height;
    
    x = MIN(x, mapWidth- winSize.width / 2);
    y = MIN(y, mapHeight - winSize.height / 2);
    
    //目标点
    CCPoint actualPoint = ccp(x, y);
    
    //屏幕的中心点
    CCPoint viewCenterPoint = ccp(winSize.width / 2,winSize.height / 2);
    //计算出重置显示屏幕的中心点
    //ccpSub 返回的是viewCenterPoint.x - actualPoint.x和viewCenterPoint.y - actualPoint.y
    CCPoint viewPoint = ccpSub(viewCenterPoint, actualPoint);
    //重置显示屏幕的中心点
    this->setPosition(viewPoint);
    
}