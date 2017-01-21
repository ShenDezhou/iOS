#include "ServerScene.h"
#include "Constant.h"
#include "Scenes.h"

USING_NS_CC;

//const char* atlas_sel[] = {"quirk_sel.png","zap_sel.png","munch_sel.png","dragon_sel.png","phoenix_sel.png"};
// there's no 'id' in cpp, so we recommend returning the class instance pointer
CCScene* ServerScene::scene()
{
	CCScene *scene = CCScene::create();

	ServerScene *splash = ServerScene::create();

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
bool ServerScene::init()
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


void ServerScene::basicSetup()
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
            
            CCSpriteFrameCache::sharedSpriteFrameCache()->addSpriteFramesWithFile("Sprites2-ipadhd.plist");
            CCSpriteBatchNode* _nodes = CCSpriteBatchNode::create("Sprites2-ipadhd.pvr.ccz");
            
            for(int i=0;i<_nodes->getChildrenCount();i++)
            {
                _batchNodes->addChild((CCSprite*)_nodes->getChildren()->objectAtIndex(i));
                
            }
            
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
    
    
//		std::string helpword = CCUserDefault::sharedUserDefault()->getStringForKey("help1");
//
//	
//
//	CCLabelTTF* tutlabel = CCLabelTTF::create(helpword.c_str(),fontname, fontSizeSmall,ccpSub( board->getContentSize(),ccp(10,10)), kCCTextAlignmentLeft );
//	tutlabel->setPosition(ccpSub(point,ccp(0,yMARGIN)));
//	tutlabel->setColor(ccc3(0,0,0x99));
//	this->addChild(tutlabel,3);
    //
    CCMenuItemSprite* quirkButton;
    quirkButton = CCMenuItemSprite::create(CCSprite::createWithSpriteFrameName("button.png"),CCSprite::createWithSpriteFrameName("button_sel.png"),this,menu_selector(ServerScene::serverButtonTapped));
      int columns = 2;
      float spaceBetween = columns +1;
      int rows = 5;
      int spaceBetweenRows = rows +1;
      int spacing = xMARGIN+quirkButton->getContentSize().width;
      int rowSpacing = yMARGIN*1.57+quirkButton->getContentSize().height;
    
    CCArray* items = CCArray::create();
    
    point = ccp(0,winSize.height-yMARGIN*4*1.57);
    basePoint = ccp(spacing*1.5,winSize.height-yMARGIN*4*1.57);
    point.x = point.x + spacing;
    if(point.x-spacing>= spacing*columns) {
        point.x = spacing;
        point.y = point.y - rowSpacing;
    }
//    CCMenuItemSprite* quirkButton;
//    quirkButton = CCMenuItemSprite::create(CCSprite::createWithSpriteFrameName("button.png"),CCSprite::createWithSpriteFrameName("button_sel.png"),this,menu_selector(ServerScene::serverButtonTapped));
    quirkButton->setPosition(point);
    CCSize contentSize =  quirkButton->getContentSize();
    CCLabelBMFont* quirkLabel = CCLabelBMFont::create("Server",fontfile);
    quirkLabel->setColor(ccc3(185,220,255));
    quirkLabel->setPosition(ccp(contentSize.width * 0.5,contentSize.height * 0.68));
    quirkLabel->setTag(1000);
    quirkButton->addChild(quirkLabel);
    items->addObject(quirkButton);

    
          point.x = point.x + spacing;
          if(point.x-spacing>= spacing*columns) {
              point.x = spacing;
              point.y = point.y - rowSpacing;
          }
    
    CCMenuItemSprite* clientButton;
    clientButton = CCMenuItemSprite::create(CCSprite::createWithSpriteFrameName("button.png"),CCSprite::createWithSpriteFrameName("button_sel.png"),this,menu_selector(ServerScene::clientButtonTapped));
    clientButton->setPosition(point);
    CCLabelBMFont* clientLabel = CCLabelBMFont::create("Available",fontfile);
        clientLabel->setTag(2000);
    clientLabel->setColor(ccc3(185,220,255));
    clientLabel->setPosition(ccp(contentSize.width * 0.5,contentSize.height * 0.68));
    clientButton->addChild(clientLabel);
    items->addObject(clientButton);
    
 
	CCSprite* button = CCSprite::createWithSpriteFrameName("shortcut_home.png");
	point = ccp(winSize.width-button->getContentSize().width/2,winSize.height/2-button->getContentSize().height);
	CCMenuItemSprite* homeButton = CCMenuItemSprite::create(CCSprite::createWithSpriteFrameName("shortcut_home.png"),CCSprite::createWithSpriteFrameName("shortcut_home.png"),this,menu_selector(ServerScene::homeButtonTapped));
	homeButton->setPosition(point);
	items->addObject(homeButton);

	point.y += button->getContentSize().height;
	CCMenuItemSprite* shopButton = CCMenuItemSprite::create(CCSprite::createWithSpriteFrameName("shortcut_shop.png"),CCSprite::createWithSpriteFrameName("shortcut_shop.png"),this,menu_selector(ServerScene::shopButtonTapped));
	shopButton->setPosition(point);
	items->addObject(shopButton);

	point.y += button->getContentSize().height;
	CCMenuItemSprite* helpButton = CCMenuItemSprite::create(CCSprite::createWithSpriteFrameName("shortcut_help.png"),CCSprite::createWithSpriteFrameName("shortcut_help.png"),this,menu_selector(ServerScene::helpButtonTapped));
	helpButton->setPosition(point);
	items->addObject(helpButton);


    menu = CCMenu::createWithArray(items);
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
void  ServerScene::serverButtonTapped(CCObject* obj)
{
    
	CCMenuItemSprite* item = (CCMenuItemSprite*)obj;
    const char* txt = ((CCLabelBMFont* )item->getChildByTag(1000))->getString();
    if(strncmp(txt,"Server",6)==0)
    {
        beServer();
        
        ((CCLabelBMFont* )item->getChildByTag(1000))->setString("Close!");
    }else
    {
        ((CCLabelBMFont* )item->getChildByTag(1000))->setString("Server");
        endSession();
    }
}
void  ServerScene::clientButtonTapped(CCObject* obj)
{
	beClient();
    CCMenuItemSprite* item = (CCMenuItemSprite*)obj;
    const char* txt = ((CCLabelBMFont* )item->getChildByTag(2000))->getString();
    if(strncmp(txt,"Close!",6)!=0)
    {
        beClient();
        
        ((CCLabelBMFont* )item->getChildByTag(2000))->setString("Close!");

    }else
    {
        ((CCLabelBMFont* )item->getChildByTag(2000))->setString("Available");
        disconnectFromServer();
    }
        
}
void ServerScene::connectButtonTapped(CCObject* obj)
{
    CCMenuItemSprite* item = (CCMenuItemSprite*)obj;
    int tag = ((CCMenuItemSprite* )item)->getTag();
    
    const char* txt = ((CCLabelBMFont* )item->getChildByTag(1000))->getString();
    if(strncmp(txt,"Connected",8)!=0)
    {
        joinServer([[NSString stringWithFormat:@"%d",tag] UTF8String]);
        ((CCLabelBMFont* )item->getChildByTag(1000))->setString("Connected");
        role =2;
        //[matchmakingClient sendPacket:PacketTypeMessage withMessage:@"hi"];
//        CCDirector::sharedDirector()->replaceScene(CCBattle::scene());
            sendPacket(2,PacketTypeMessage,"ABC");

    }else
    {
         ((CCLabelBMFont* )item->getChildByTag(1000))->setString(
        [[matchmakingClient displayNameForPeerID:[NSString stringWithFormat:@"%d",tag]] UTF8String]
        );
        [matchmakingClient disconnectFromServer];

    }
    
        
}

void  ServerScene::homeButtonTapped(CCObject* obj) 
{
	CCDirector::sharedDirector()->replaceScene(ArmorHome::scene());
}
void  ServerScene::helpButtonTapped(CCObject* obj) 
{
	CCDirector::sharedDirector()->replaceScene(ServerScene::scene());
}

void ServerScene::shopButtonTapped(CCObject* obj) 
{
	#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
	CCDirector::sharedDirector()->replaceScene(UserPay::scene());
#endif
}

void ServerScene::registerWithTouchDispatcher()
{
	CCDirector::sharedDirector()->getTouchDispatcher()->addTargetedDelegate(this,0,true);
}

bool ServerScene::ccTouchBegan(CCTouch *pTouch, CCEvent *pEvent)
{
	return true;
}


void ServerScene::beServer() {
	CCLOG("ServerScene::beServer");
	if (matchmakingServer == NULL) {
		matchmakingServer = [[MatchmakingServer alloc] init];
        [matchmakingServer setDelegate:this];
		[matchmakingServer startAcceptingConnectionsForSessionID:[NSString stringWithFormat:@"%s", "JSBBLUETOOTH"]
                                                     displayName:@""];
	}

}

void ServerScene::beClient() {
	CCLOG("ServerScene::beClient");
    if (matchmakingClient == NULL) {
		matchmakingClient = [[MatchmakingClient alloc] init];
        [matchmakingClient setDelegate:this];
		[matchmakingClient startSearchingForServersWithSessionID:[NSString stringWithFormat:@"%s", "JSBBLUETOOTH"]
                                                     displayName:@""];
        [matchmakingClient searchAvailServers];
	}
}

void ServerScene::queryServers() {
    CCLOG("ServerScene::queryServers");
    if (matchmakingClient != NULL) {
        [matchmakingClient searchAvailServers];
	}
}
void ServerScene::joinServer(const char* peerID) {
	CCLOG("ServerScene::joinServer: %s", peerID);
    if (matchmakingClient) {
		[matchmakingClient connectToServerWithPeerID:[NSString stringWithFormat:@"%s", peerID]];
	}
}

void ServerScene::endSession() {
    CCLOG("ServerScene::endSession");
    if (matchmakingServer) {
        [matchmakingServer endSession];
    }
}

void ServerScene::disconnectFromServer() {
    CCLOG("ServerScene::disconnectFromServer");
    if (matchmakingClient) {
        [matchmakingClient disconnectFromServer];
    }
}

void ServerScene::sendPacket(int role, PacketType type, const char* message) {
	CCLOG("ServerScene::sendPacket");
    CCLOG("role: %d -- type: %d -- message: %s", role, type, message);
	Packet *packet = [Packet packetWithType:type message:[NSString stringWithFormat:@"%s", message]];
	NSData *data = [packet data];
	NSError *error;
	if (role == 0) {
		if (![matchmakingServer.session sendDataToAllPeers:data withDataMode:GKSendDataReliable error:&error]) {
			NSLog(@"Error sending data to clients: ");
		}
	}
	else {
		if (![matchmakingClient.session sendDataToAllPeers:data withDataMode:GKSendDataReliable error:&error]) {
			NSLog(@"Error sending data to clients: ");
		}
	}
}

/*
 client server delegate
 */
void ServerScene::clientReceiveData(NSData* data, NSString *peerID) {
	CCLOG("ServerScene::clientReceiveData");
	Packet *packet = [Packet packetWithData:data];
	if (packet == nil) {
		return;
	}
    CCLog("%s",[packet.packetMessage UTF8String]);
//    CCArray* entities = _entityManager->getAllEntitiesPosessingComponentOfClass("CommunicateComponent");
//    if (entities->count() == 0) return;
//    
//    
//    Entity* entity = (Entity* )entities->objectAtIndex(0);
//    entity->retain();
//    TeamComponent* team = entity->team();
//    CommunicateComponent* com = entity->communicate();
//    com->recvData->addObject(CCString::create([packet.packetMessage cStringUsingEncoding:NSNEXTSTEPStringEncoding]));

    
//    tirggerFuncWithString("clientReceiveData", packet.packetMessage);
}

void ServerScene::serverReceiveData(NSData* data, NSString *peerID) {
	CCLOG("ServerScene::serverReceiveData");
	Packet *packet = [Packet packetWithData:data];
	if (packet == nil) {
		return;
	}
 
    CCLog("%s",[packet.packetMessage UTF8String]);
//    CCArray* entities = _entityManager->getAllEntitiesPosessingComponentOfClass("CommunicateComponent");
//    if (entities->count() == 0) return;
//    
//    
//    Entity* entity = (Entity* )entities->objectAtIndex(0);
//    entity->retain();
//    TeamComponent* team = entity->team();
//    CommunicateComponent* com = entity->communicate();
//    com->recvData->addObject(CCString::create([packet.packetMessage cStringUsingEncoding:NSNEXTSTEPStringEncoding]));
    

//    tirggerFuncWithString("serverReceiveData", packet.packetMessage);
}

void ServerScene::serverBecameAvailable(MatchmakingClient* client, NSString* peerID) {
    CCLOG("ServerScene::serverBecameAvailable");
//    tirggerFuncWithString("serverBecameAvailable", peerID);
    //CCMessageBox([peerID UTF8String], "ServerAvailble");
    CCMenuItemSprite* quirkButton;
    quirkButton = CCMenuItemSprite::create(CCSprite::createWithSpriteFrameName("button.png"),CCSprite::createWithSpriteFrameName("button_sel.png"),this,menu_selector(ServerScene::connectButtonTapped));
    CCPoint point = basePoint;
    point.y = point.y- ([client getAvailServersIndex:peerID ] +1)* CCSprite::createWithSpriteFrameName("button.png")->getContentSize().height * 1.1;
    quirkButton->setPosition(point);
    CCSize contentSize =  quirkButton->getContentSize();
    CCLabelBMFont* quirkLabel = CCLabelBMFont::create([[client displayNameForPeerID:peerID] UTF8String],fontfile);
    quirkLabel->setColor(ccc3(185,220,255));
    quirkLabel->setPosition(ccp(contentSize.width * 0.5,contentSize.height * 0.68));
    quirkLabel->setTag(1000);
    quirkButton->addChild(quirkLabel);
    quirkButton->setTag([peerID intValue]);
    menu->addChild(quirkButton);
    
}
void ServerScene::serverBecameUnavailable(MatchmakingClient* client, NSString* peerID) {
    CCLOG("ServerScene::serverBecameUnavailable");
    menu->removeChildByTag([peerID intValue]);
    for(int i=0;i< [client.availableServers count];i++)
        if(client.availableServers[i]==peerID)
        {
            CCPoint point = basePoint;
            point.y = point.y- (i+1) * CCSprite::createWithSpriteFrameName("button.png")->getContentSize().height * 1.1;
            menu->getChildByTag([peerID intValue])->setPosition(point);
        }
//	tirggerFuncWithString("serverBecameUnavailable", peerID);
}
void ServerScene::didDisconnectFromServer(MatchmakingClient* client, NSString* peerID) {
    CCLOG("ServerScene::didDisconnectFromServer");
//	tirggerFuncWithString("didDisconnectFromServer", peerID);
    //matchmakingClient = NULL;
}
void ServerScene::clientNoNetwork(MatchmakingClient* client) {
    CCLOG("ServerScene::clientNoNetwork");
//	tirggerFunc("clientNoNetwork");
}

void ServerScene::clientDidConnect(MatchmakingServer* server, NSString* peerID) {
    CCLOG("ServerScene::clientDidConnect");
//    tirggerFuncWithString("clientDidConnect", peerID);
    
    
    //CCDirector::sharedDirector()->replaceScene(CCBattle::scene());

    role =1;
    sendPacket(1,PacketTypeMessage,"ABC");
}
void ServerScene::clientDidDisconnect(MatchmakingServer* server, NSString* peerID) {
    CCLOG("ServerScene::clientDidDisconnect");
//	tirggerFuncWithString("clientDidDisconnect", peerID);
}
void ServerScene::sessionDidEnd(MatchmakingServer* server) {
    CCLOG("ServerScene::sessionDidEnd");
//	tirggerFuncWithString("sessionDidEnd", "");
//    matchmakingServer = NULL;
}
void ServerScene::serverNoNetwork(MatchmakingServer* server) {
    CCLOG("ServerScene::serverNoNetwork");
//	tirggerFunc("serverNoNetwork");
}



