#include "CCBattle.h"
//#include "Scenes.h"
#include "GameOverScene.h"
#include "ArmorHomeScene.h"

USING_NS_CC;
USING_NS_CC_EXT;
CCBattle::CCBattle()
{
	
}

CCScene* CCBattle::scene()
{
    // 'scene' is an autorelease object
    CCScene *scene = CCScene::create();
    
    // 'layer' is an autorelease object
    CCBattle *layer = CCBattle::create();

    // add layer as a child to scene
    scene->addChild(layer);

    // return the scene
    return scene;
}

// on "init" you need to initialize your instance
bool CCBattle::init()
{
    //////////////////////////////
    // 1. super init first
    if ( !CCLayer::init() )
    {
	    return false;
    }
 	basicSetup();
	//addPlayers();

    return true;
}


void CCBattle::basicSetup()
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
            
//            CCSpriteFrameCache::sharedSpriteFrameCache()->addSpriteFramesWithFile("Sprites3-ipadhd.plist");
//            _nodes = CCSpriteBatchNode::create("Sprites3-ipadhd.pvr.ccz");
//            for(int i=0;i<_nodes->getChildrenCount();i++)
//            {
//                _batchNodes->addChild((CCSprite*)_nodes->getChildren()->objectAtIndex(i));
//            }
        }
        // if the frame's height is larger than the height of small resource size, select medium resource.
        else if (frameSize.height > smallResource.size.height)
        {
            CCSpriteFrameCache::sharedSpriteFrameCache()->addSpriteFramesWithFile("Sprites1-ipad.plist");
            _batchNodes = CCSpriteBatchNode::create("Sprites1-ipad.pvr.ccz");
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
        }
    }
	this->addChild(_batchNodes);
	
	for(int i=0;i<EFFECT_NUM;i++)
	{
		effects[i].particle = CCParticleBatchNode::create(effects[i].pngname );
		effects[i].particle->retain();
		this->addChild(effects[i].particle);
	}
#if SOUND
   // Sounds
    CocosDenshion::SimpleAudioEngine::sharedEngine()->playBackgroundMusic("Electric Romeo.mp3");
    CocosDenshion::SimpleAudioEngine::sharedEngine()->preloadEffect("LASER.WAV");
    CocosDenshion::SimpleAudioEngine::sharedEngine()->preloadEffect("beam_laser.wav");
    CocosDenshion::SimpleAudioEngine::sharedEngine()->preloadEffect("ioncannon.wav");
    CocosDenshion::SimpleAudioEngine::sharedEngine()->preloadEffect("player_laserhit.wav");
    CocosDenshion::SimpleAudioEngine::sharedEngine()->preloadEffect("Metal1.wav");
    CocosDenshion::SimpleAudioEngine::sharedEngine()->preloadEffect("Metal2.wav");
    CocosDenshion::SimpleAudioEngine::sharedEngine()->preloadEffect("Metal3.wav");
    
    CocosDenshion::SimpleAudioEngine::sharedEngine()->preloadEffect("bigHit.wav");
    CocosDenshion::SimpleAudioEngine::sharedEngine()->preloadEffect("boom.wav");
    CocosDenshion::SimpleAudioEngine::sharedEngine()->preloadEffect("pew.wav");
    CocosDenshion::SimpleAudioEngine::sharedEngine()->preloadEffect("pew2.wav");
    CocosDenshion::SimpleAudioEngine::sharedEngine()->preloadEffect("smallHit.wav");
    CocosDenshion::SimpleAudioEngine::sharedEngine()->preloadEffect("attack.wav");
    CocosDenshion::SimpleAudioEngine::sharedEngine()->preloadEffect("defend.wav");
    CocosDenshion::SimpleAudioEngine::sharedEngine()->preloadEffect("spawn.wav");
#endif
	//other UI
    int index = (int)(CCRANDOM_0_1()*2)+1;
    CCSprite *background = CCSprite::createWithSpriteFrameName(backgrounds[index]);
    background->setPosition(ccp(winSize.width/2, winSize.height/2-yOffset/2));
    this->addChild(background,-1);

	for(int i = BUILDING_NUM;i<SPRITE_NUM+BUILDING_NUM;i++)
	{
		
		decks[i].button =  getSpriteButton(i,decks[i].price,decks[i].atlas[0],menu_selector(CCBattle::quirkButtonTapped));
		decks[i].potentio = CCControlPotentiometer::create("potentio.png","potentio_sel.png","potentio_center.png");
		decks[i].potentio->setValue(0.1f);
		decks[i].potentio->retain();
		decks[i].potentio->setPosition(ccp(decks[i].button->getContentSize().width-xMARGIN*0.5,decks[i].button->getContentSize().height/2));
	}
    std::string stateWord =CCUserDefault::sharedUserDefault()->getStringForKey("Idle");
    _stateLabel = CCLabelBMFont::create(stateWord.c_str(),fontfile);
    _stateLabel->setPosition ( ccp(winSize.width/2, yMARGIN * 4));
    this->addChild(_stateLabel);
	std::string help = CCUserDefault::sharedUserDefault()->getStringForKey("bt3");
	CCLabelTTF* guide = CCLabelTTF::create(help.c_str(), fontname, fontSizeBig, ccp(winSize.width * 0.5,2*yMARGIN), kCCTextAlignmentLeft );
	guide->setPosition(ccp(winSize.width * 0.5+xMARGIN, winSize.height - 2*yMARGIN));
    guide->setColor(ccc3(232,186,140));
	this->addChild(guide);

	menu =  CCMenu::create();
	menu->setPosition(ccp(0, 0));
	CCSprite* spawn = CCSprite::createWithSpriteFrameName("spawn.png");
	int deckCount = 0;
	for(int i = BUILDING_NUM;i<SPRITE_NUM+BUILDING_NUM;i++)
	{	
		if(decks[i].selection)
		{
			deckCount++;
			decks[i].button->setPosition(spawn->getContentSize().width*(deckCount-0.5)+xMARGIN*0.05*deckCount,spawn->getContentSize().height/2);
			menu->addChild(decks[i].button);
			decks[i].potentio->setValue(0.1f);
			decks[i].potentio->setVisible(false);
			decks[i].button->addChild(decks[i].potentio);
		}
	}
	pauseButton =  CCMenuItemSprite::create(CCSprite::createWithSpriteFrameName("pause.png"),CCSprite::createWithSpriteFrameName("pause.png"),this,menu_selector(CCBattle::pauseButtonTapped));
	pauseButton->setPosition(ccp(winSize.width -xMARGIN, winSize.height - 2*yMARGIN));
	menu->addChild(pauseButton);
	this->addChild(menu);


    CCSprite* coin1 = CCSprite::createWithSpriteFrameName("coin.png");
	CCSize contentSize =  decks[1].button->getContentSize();
 
    contentSize = coin1->getContentSize();
    coin1->setPosition(ccp(xMARGIN*1.5 + contentSize.width/2, winSize.height - yMARGIN*1.1 - contentSize.height/2));
    this->addChild(coin1);
    
    CCSprite* coin2 = CCSprite::createWithSpriteFrameName("coin.png");
    coin2->setPosition(ccp(winSize.width - xMARGIN*1.5 - contentSize.width/2, winSize.height - yMARGIN*1.1 - contentSize.height/2));
    this->addChild(coin2);
    
	//std::string str2 = "ÌìÊ¹ÐÇÇò";    
	//GBKToUTF8(str2);  
	//CCLabelBMFont *_helpLabel=CCLabelBMFont::create(str2.c_str(),"font/chn.fnt");  
	//_helpLabel->setPosition(ccp(winSize.width/2,winSize.height/2));
 //   this->addChild(_helpLabel);

    _coin1Label = CCLabelBMFont::create("10","Courier.fnt",winSize.width * 0.25,kCCTextAlignmentLeft);
    _coin1Label->setPosition(ccp(coin1->getPosition().x + contentSize.width/2 + xMARGIN + _coin1Label->getContentSize().width/2, winSize.height - yMARGIN*1.5));
    this->addChild(_coin1Label);
    
    _coin2Label = CCLabelBMFont::create("10","Courier.fnt",winSize.width * 0.25,kCCTextAlignmentRight);;
    _coin2Label->setPosition ( ccp(coin2->getPosition().x -  contentSize.width/2 - xMARGIN - _coin1Label->getContentSize().width/2, winSize.height - yMARGIN*1.5));
    this->addChild(_coin2Label);

    CCSprite* people1 = CCSprite::createWithSpriteFrameName("people.png");

    contentSize = people1->getContentSize();
    people1->setPosition(ccp(xMARGIN*1.5 + contentSize.width/2, winSize.height - yMARGIN*2.2 - contentSize.height/2));
    this->addChild(people1);
    
    CCSprite* people2 = CCSprite::createWithSpriteFrameName("people.png");
    people2->setPosition(ccp(winSize.width - xMARGIN*1.5 - contentSize.width/2, winSize.height - yMARGIN*2.2 - contentSize.height/2));;
    this->addChild(people2);
        
    _people1Label = CCLabelBMFont::create("0","Courier_green.fnt",winSize.width * 0.25,kCCTextAlignmentLeft);
    _people1Label->setPosition(ccp(people1->getPosition().x + contentSize.width/2 + xMARGIN + _people1Label->getContentSize().width/2, winSize.height - yMARGIN*2 - contentSize.height/2));
    this->addChild(_people1Label);
    
    _people2Label = CCLabelBMFont::create("0","Courier_green.fnt",winSize.width * 0.25,kCCTextAlignmentRight);;
    _people2Label->setPosition ( ccp(people2->getPosition().x -  contentSize.width/2 - xMARGIN - _people1Label->getContentSize().width/2, winSize.height - yMARGIN*2 - contentSize.height/2));
    this->addChild(_people2Label);
  
	CCSprite* battle_deck = CCSprite::createWithSpriteFrameName("battle_deck.png");
    battle_deck->setPosition(ccp(winSize.width/2,battle_deck->getContentSize().height/2));
	battle_deck->setZOrder(1);
    this->addChild(battle_deck);


    this->setTouchEnabled(true);
    this->scheduleUpdate();
	_gameOver=false;
	
	for(int i = BUILDING_NUM;i<BUILDING_NUM+SPRITE_NUM;i++)
	{
		values[0][i] = 0;
		values[1][i] = 0;
	}
    
    _startGame = false;
    CCMenuItemSprite* serverButton;
    serverButton = CCMenuItemSprite::create(CCSprite::createWithSpriteFrameName("button.png"),CCSprite::createWithSpriteFrameName("button_sel.png"),this,menu_selector(CCBattle::serverButtonTapped));
    serverButton->setPosition(ccp(winSize.width/2-2*xMARGIN,winSize.height/2));
//    CCSize contentSize =  serverButton->getContentSize();
    //CCLabelBMFont* quirkLabel = CCLabelBMFont::create("Server",fontfile);
    std::string hostgame =CCUserDefault::sharedUserDefault()->getStringForKey("bt1");

    CCLabelTTF* quirkLabel = CCLabelTTF::create(hostgame.c_str(),fontname, fontSizeBig,ccp(xMARGIN*4,yMARGIN*1.5), kCCTextAlignmentLeft );
    quirkLabel->setColor(ccc3(185,220,255));
    quirkLabel->setPosition(ccp(contentSize.width * 0.5+xMARGIN*3,contentSize.height * 0.4));
    quirkLabel->setTag(1000);
    serverButton->addChild(quirkLabel);
    serverButton->setTag(100);
    menu->addChild(serverButton);
    
    CCMenuItemSprite* clientButton;
    clientButton = CCMenuItemSprite::create(CCSprite::createWithSpriteFrameName("button.png"),CCSprite::createWithSpriteFrameName("button_sel.png"),this,menu_selector(CCBattle::clientButtonTapped));
    clientButton->setPosition(ccp(winSize.width/2+2*xMARGIN,winSize.height/2));
    //CCLabelBMFont* clientLabel = CCLabelBMFont::create("Available",fontfile);
    std::string joingame =CCUserDefault::sharedUserDefault()->getStringForKey("bt2");
    
    CCLabelTTF* clientLabel = CCLabelTTF::create(joingame.c_str(),fontname, fontSizeBig,ccp(xMARGIN*4,yMARGIN*1.5), kCCTextAlignmentLeft );
    clientLabel->setTag(2000);
    clientLabel->setColor(ccc3(185,220,255));
    clientLabel->setPosition(ccp(contentSize.width * 0.5+xMARGIN*3,contentSize.height * 0.4));
    clientButton->addChild(clientLabel);
    clientButton->setTag(200);
     menu->addChild(clientButton);
}
void  CCBattle::serverButtonTapped(CCObject* obj)
{
    
	CCMenuItemSprite* item = (CCMenuItemSprite*)obj;
    const char* txt = ((CCLabelTTF* )item->getChildByTag(1000))->getString();
        std::string hostgame =CCUserDefault::sharedUserDefault()->getStringForKey("bt1");
    if(strncmp(txt,hostgame.c_str(),strlen(hostgame.c_str()))==0)
    {
        beServer();
        std::string disconnect =CCUserDefault::sharedUserDefault()->getStringForKey("bt4");
        

        ((CCLabelTTF* )item->getChildByTag(1000))->setString(disconnect.c_str());
    }else
    {
        ((CCLabelTTF* )item->getChildByTag(1000))->setString(hostgame.c_str());
        endSession();
    }
}
void  CCBattle::clientButtonTapped(CCObject* obj)
{
	CCMenuItemSprite* item = (CCMenuItemSprite*)obj;
    const char* txt = ((CCLabelTTF* )item->getChildByTag(2000))->getString();
    std::string joingame =CCUserDefault::sharedUserDefault()->getStringForKey("bt2");
    
    if(strncmp(txt,joingame.c_str(),strlen(joingame.c_str()))==0)
    {
        beClient();
        std::string disconnect =CCUserDefault::sharedUserDefault()->getStringForKey("bt4");

        ((CCLabelTTF* )item->getChildByTag(2000))->setString(disconnect.c_str());
        
    }else
    {
        ((CCLabelTTF* )item->getChildByTag(2000))->setString(joingame.c_str());
        disconnectFromServer();
    }
    
}
void CCBattle::connectButtonTapped(CCObject* obj)
{
    CCMenuItemSprite* item = (CCMenuItemSprite*)obj;
    int tag = ((CCMenuItemSprite* )item)->getTag();
    
    const char* txt = ((CCLabelTTF* )item->getChildByTag(3000))->getString();
    std::string disconnect =CCUserDefault::sharedUserDefault()->getStringForKey("bt4");
    
    if(strncmp(txt,disconnect.c_str(),strlen(disconnect.c_str()))!=0)
    {
        joinServer([[NSString stringWithFormat:@"%d",tag] UTF8String]);
        ((CCLabelTTF* )item->getChildByTag(3000))->setString(disconnect.c_str());
        role =2;

        addPlayers();
        removeButtons();
    }else
    {
        ((CCLabelTTF* )item->getChildByTag(3000))->setString(
                                                                [[matchmakingClient displayNameForPeerID:[NSString stringWithFormat:@"%d",tag]] UTF8String]
                                                                );
        [matchmakingClient disconnectFromServer];
        
    }
    
    
}
void CCBattle::removeButtons()
{
    menu->removeChildByTag(100);
    menu->removeChildByTag(200);
    for(int i=0;i<[matchmakingClient.availableServers count];i++)
        menu->removeChildByTag([[matchmakingClient peerIDForAvailableServerAtIndex:i] intValue]);
    
    
}


void CCBattle::beServer() {
	CCLOG("CCBattle::beServer");
	if (matchmakingServer == NULL) {
		matchmakingServer = [[MatchmakingServer alloc] init];
        [matchmakingServer setDelegate:this];
		[matchmakingServer startAcceptingConnectionsForSessionID:[NSString stringWithFormat:@"%s", "JSBBLUETOOTH"]
                                                     displayName:@""];
	}else
    {
        matchmakingServer=NULL;
        matchmakingServer = [[MatchmakingServer alloc] init];
        [matchmakingServer setDelegate:this];
		[matchmakingServer startAcceptingConnectionsForSessionID:[NSString stringWithFormat:@"%s", "JSBBLUETOOTH"]
                                                     displayName:@""];
   
    }
}

void CCBattle::beClient() {
	CCLOG("CCBattle::beClient");
    if (matchmakingClient == NULL) {
		matchmakingClient = [[MatchmakingClient alloc] init];
        [matchmakingClient setDelegate:this];
		[matchmakingClient startSearchingForServersWithSessionID:[NSString stringWithFormat:@"%s", "JSBBLUETOOTH"]
                                                     displayName:@""];
        [matchmakingClient searchAvailServers];
	}else
    {
        matchmakingClient=NULL;
        matchmakingClient = [[MatchmakingClient alloc] init];
        
        [matchmakingClient setDelegate:this];
		[matchmakingClient startSearchingForServersWithSessionID:[NSString stringWithFormat:@"%s", "JSBBLUETOOTH"]
                                                     displayName:@""];
        [matchmakingClient searchAvailServers];

    }
}

void CCBattle::queryServers() {
    CCLOG("CCBattle::queryServers");
    if (matchmakingClient != NULL) {
        [matchmakingClient searchAvailServers];
	}
}
void CCBattle::joinServer(const char* peerID) {
	CCLOG("CCBattle::joinServer: %s", peerID);
    if (matchmakingClient) {
		[matchmakingClient connectToServerWithPeerID:[NSString stringWithFormat:@"%s", peerID]];
	}
}

void CCBattle::endSession() {
    CCLOG("CCBattle::endSession");
    if (matchmakingServer) {
        [matchmakingServer endSession];
    }
}

void CCBattle::disconnectFromServer() {
    CCLOG("CCBattle::disconnectFromServer");
    if (matchmakingClient) {
        [matchmakingClient disconnectFromServer];
    }
}

void CCBattle::sendPacket(int role, PacketType type, const char* message) {
	CCLOG("CCBattle::sendPacket");
    CCLOG("role: %d -- type: %d -- message: %s", role, type, message);
	Packet *packet = [Packet packetWithType:type message:[NSString stringWithFormat:@"%s", message]];
	NSData *data = [packet data];
	NSError *error;
	if (role == 1) {
        if(![matchmakingServer.session  sendData:data toPeers:matchmakingServer.connectedClients withDataMode:GKSendDataUnreliable error:&error]){
//		if (![matchmakingServer.session sendDataToAllPeers:data withDataMode:GKSendDataUnreliable error:&error]) {
			NSLog(@"Error sending data to clients: %@", [error localizedDescription]);
		}
	}
	else {
        NSArray* arr = [NSArray arrayWithObject:matchmakingClient.serverPeerID ] ;
        if(![matchmakingClient.session sendData:data toPeers:arr withDataMode:GKSendDataUnreliable error:&error]){
//		if (![matchmakingClient.session sendDataToAllPeers:data withDataMode:GKSendDataUnreliable error:&error]) {
			NSLog(@"Error sending data to clients: %@", [error localizedDescription]);
		}
	}
}

CCMenuItemSprite* CCBattle::getSpriteButton(int tag,int price,const char* frameName,SEL_MenuHandler selector)
{	
 	CCSize winSize = CCDirector::sharedDirector()->getWinSize();

    CCMenuItemSprite *quirkButton =  CCMenuItemSprite::create(CCSprite::createWithSpriteFrameName("spawn.png"),CCSprite::createWithSpriteFrameName("spawn_sel.png"),this,selector);
    CCSize contentSize =  quirkButton->getContentSize();
	//quirkButton->setPosition (ccp(contentSize.width* tag, contentSize.height/2));
	quirkButton->setTag(tag);
    CCSprite* quirk = CCSprite::createWithSpriteFrameName(frameName);
	quirk->setPosition(ccp(quirk->getContentSize().width/2, contentSize.height-quirk->getContentSize().height/2));
    quirkButton->addChild(quirk);
    char temp[64];
    sprintf(temp, "%d", price);

    //CCLabel* quirkLabel = CCLabelBMFont::create(temp,"Courier_green.fnt");
	CCLabelTTF* quirkLabel = CCLabelTTF::create(temp, "Helvetica-Bold", fontSizeBig, ccp(xMARGIN,yMARGIN), kCCTextAlignmentCenter );
	quirkLabel->setColor(ccc3(255,255,255));
    quirkLabel->setPosition(ccp(quirk->getContentSize().width/2, yMARGIN*0.4));
    quirkButton->addChild(quirkLabel);
	quirkButton->setZOrder(3);
	return quirkButton;
}
void CCBattle::addPlayers()
{
    CCSize winSize = CCDirector::sharedDirector()->getWinSize();
	_entityManager =new EntityManager();
	_entityFactory = new EntityFactory(_entityManager,_batchNodes);
	

	_healthSystem =new HealthSystem(_entityManager,_entityFactory);
	_moveSystem =new MoveSystem(_entityManager,_entityFactory);
	_playerSystem = new PlayerSystem(_entityManager,_entityFactory);
	_meleeSystem = new MeleeSystem(_entityManager,_entityFactory);
	_gunSystem = new GunSystem(_entityManager,_entityFactory);
	//_aiSystem = new AISystem(_entityManager,_entityFactory);
	_itemSystem = new ItemSystem(_entityManager,_entityFactory);
	_communicateSystem = new CommunicateSystem(_entityManager,_entityFactory);
	
    _aiPlayer = _entityFactory->createAIPlayer();
	_aiPlayer->retain();
    
    
    RenderComponent* aiRender =  _aiPlayer->render();
	if (aiRender) {
        aiRender->node->setPosition ( ccp(winSize.width - aiRender->node->getContentSize().width/2-xMARGIN, winSize.height/2));
        aiRender->node->setZOrder(-1);
	}
	
     _humanPlayer = _entityFactory->createHumanPlayer();
	_humanPlayer->retain();
    
    RenderComponent* humanRender =_humanPlayer->render();
    if (humanRender) {
        humanRender->node->setPosition ( ccp(humanRender->node->getContentSize().width/2+xMARGIN, winSize.height/2));
        humanRender->node->setZOrder(-1);
    }  
	
    _startGame = true;
    
   
}
void CCBattle::spawnMonsterForEntity(MonsterType monsterType,Entity *entity)
{
    
	
    PlayerComponent* humanPlayer = _humanPlayer->player();
	if(!_playerSystem->handleEconomic(humanPlayer,&decks[(int)monsterType])) return;
#if SOUND
    CocosDenshion::SimpleAudioEngine::sharedEngine()->playEffect("spawn.wav");
#endif
	TeamComponent* team = entity->team();
	values[team->team-1][(int)monsterType] += decks[(int)monsterType].price;
    
    Entity* monster = this->_entityFactory->createMonsterWithTeam(monsterType,1);
    RenderComponent* render = monster->render();
    if (render) {
        CCSize winSize = CCDirector::sharedDirector()->getWinSize();
        float randomOffset = CCRANDOM_X_Y(-winSize.height * 0.25, winSize.height * 0.25);
        render->node->setPosition ( ccp(winSize.width * 0.25, winSize.height * 0.5 + randomOffset));
    }
	char cmd[] = {(char)0x71,(char)0x01,(char)monsterType};
	//_aiPlayer->communicate()->sendData->addObject(CCString::create(cmd));
	sendPacket(role,PacketTypeMessage, cmd);

}


void CCBattle::quirkButtonTapped(CCObject* obj) {
    if(!_startGame)return;
   //CCLog("Quirk button tapped!");
	 CCMenuItemSprite * item = ( CCMenuItemSprite * )obj;
	 
 	int index = item->getTag();
	//CCLog("%d button tapped!",index);
    if(!decks[index].cooldown) return;
//   PlayerComponent* humanPlayer = _humanPlayer->player();
//	if(!_playerSystem->handleEconomic(humanPlayer,&decks[index])) return;

   if(decks[index].cooldown)
   {
	   decks[index].cooldown = false;
	   decks[index].potentio->setValue(0.1f);
	   decks[index].potentio->setVisible(true);
   }

    this->spawnMonsterForEntity(MonsterType(index),_humanPlayer);
	
 
}


void CCBattle::restartTapped(CCObject* obj){
    
    // Reload the current scene
    CCScene *scene = GameOverLayer::scene();
    CCDirector::sharedDirector()->replaceScene(CCTransitionZoomFlipX::create(0.5,scene));
    
}
void CCBattle::pauseButtonTapped(CCObject* obj){
    
    // Reload the current scene
    CCScene *scene = ArmorHome::scene();
    CCDirector::sharedDirector()->replaceScene(CCTransitionZoomFlipX::create(0.5,scene));
    
}

void CCBattle::showRestartMenu(bool won) {
     if (_gameOver) return;
    _gameOver = true;
	endSession();
    disconnectFromServer();
    CCScene *scene = GameOverLayer::scene();
    CCDirector::sharedDirector()->replaceScene(CCTransitionZoomFlipX::create(0.5,scene));

}


void CCBattle::update(float delta){
    if(!_startGame) return;
    _healthSystem->update(delta);
	_moveSystem->update(delta);
	_playerSystem->update(delta);
	_meleeSystem->update(delta);
	_gunSystem->update(delta);
	//_aiSystem->update(delta);
	_itemSystem->update(delta);
	_communicateSystem->update(delta);
	
	for(int i=0;i<EFFECT_NUM;i++)
	{
		if(effects[i].particle->getChildrenCount()>10)
			effects[i].particle->removeAllChildren();

	}
    // Check for game over
    HealthComponent* humanHealth = _humanPlayer->health();
    if (humanHealth) {
        if(((int)humanHealth->curHP)>>4 <0x7F && lastHPTime > 2)
        {
            lastHPTime=0;
            char hp =(char) ((int)humanHealth->curHP)>>4;
        char cmd[] = {(char)0x74,(char)0x02,hp};
        //_aiPlayer->communicate()->sendData->addObject(CCString::create(cmd));
        sendPacket(role,PacketTypeMessage, cmd);
        }
        lastHPTime+=delta;
        
        if (humanHealth->curHP <= 0) {
            gameresult = false;
            this->showRestartMenu(false);
        }
    }    
    HealthComponent* aiHealth = _aiPlayer->health();
    if (aiHealth) {
        if (aiHealth->curHP <= 0) {
//            char cmd[] = {(char)0x74,(char)0x02,(char)0x01};
//            //_aiPlayer->communicate()->sendData->addObject(CCString::create(cmd));
//            sendPacket(role,PacketTypeMessage, cmd);

            gameresult = true;
		this->showRestartMenu(true);
        }
    }
	//check network connection
	/*if(_socket->disconnected())
	{
		this->showRestartMenu(humanHealth->curHP >aiHealth->curHP );
	}*/
    
    // Display coins
    PlayerComponent* humanPlayer = _humanPlayer->player();
    if (humanPlayer) {
        _coin1Label->setString(CCString::createWithFormat("%d", humanPlayer->coins)->getCString());
		switch(humanPlayer->overload){
		case Effecient:
			_people1Label->setFntFile("Courier_green.fnt");break;
		case Warning:
			_people1Label->setFntFile("Courier_yellow.fnt");break;
		case Overload:
			_people1Label->setFntFile("Courier_red.fnt");break;
		}
		_people1Label->setString(CCString::createWithFormat("%d", humanPlayer->people)->getCString());
    }
    PlayerComponent* aiPlayer = _aiPlayer->player();
    if (aiPlayer) {
        _coin2Label->setString(CCString::createWithFormat("%d", aiPlayer->coins)->getCString());
		switch(aiPlayer->overload){
		case Effecient:
			_people2Label->setFntFile("Courier_green.fnt");break;
		case Warning:
			_people2Label->setFntFile("Courier_yellow.fnt");break;
		case Overload:
			_people2Label->setFntFile("Courier_red.fnt");break;
		}
		_people2Label->setString(CCString::createWithFormat("%d", aiPlayer->people)->getCString());

    }


    // Display AI state
//    AIComponent* aiComp = _aiPlayer->ai();
//    if (aiComp) {
//        _stateLabel->setString(CCUserDefault::sharedUserDefault()->getStringForKey(aiComp->state->name()->getCString()).c_str());
//    }

	for(int i = BUILDING_NUM;i<SPRITE_NUM+BUILDING_NUM;i++)
	{	
		if(decks[i].selection && !decks[i].cooldown)
		{
			if(decks[i].potentio->getValue()==1.0)
			{
				decks[i].cooldown = true;
				decks[i].potentio->setVisible(false);
			}else
			{
				float value =decks[i].potentio->getValue()+delta /decks[i].buildtime ;
				decks[i].potentio->setValue(value);
				
			}
		}
	}

}
void CCBattle::notice(const char* notice,CCPoint position)
{
    CCLabelTTF* hitLabel =CCLabelTTF::create(notice, fontname, fontSizeBig, ccp(xMARGIN*16,yMARGIN), kCCTextAlignmentCenter );
    hitLabel->setColor(ccc3(255,255,0));
    hitLabel->setPosition(position);
    this->_entityFactory->_batchNode->getParent()->addChild(hitLabel);
    
    CCScaleTo* scaleFrom = CCScaleTo::create(0.1f,1.5f);
    CCDelayTime* delay = CCDelayTime::create(0.1f);
    CCScaleTo* scaleTo = CCScaleTo::create(0.1f,1.0f);
    CCFiniteTimeAction* actionMoveDone = CCCallFuncN::create(this,callfuncN_selector(CCLayerParent::clean));
    
    CCSequence* sequence = CCSequence::create(scaleFrom,delay,scaleTo,delay,actionMoveDone,NULL);
    
    hitLabel->runAction(sequence);

    
}
void CCBattle::draw(){
    if(!_startGame)return;
    _healthSystem->draw();
}
void CCBattle::registerWithTouchDispatcher()
{
	CCDirector::sharedDirector()->getTouchDispatcher()->addTargetedDelegate(this,0,true);
}

bool CCBattle::ccTouchBegan(CCTouch *pTouch, CCEvent *pEvent)
{
    CCPoint touchPoint = this->convertTouchToNodeSpace(pTouch);
    //CCLog("Touch at: %f,%f",touchPoint.x,touchPoint.y);
    //bool target = true;

	
	

	return true;
}

void CCBattle::ccTouchEnded(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent)
{
    if(!_startGame) return;
	CCPoint touchPoint = this->convertTouchToNodeSpace(pTouch);
	CCArray* items = _entityManager->getAllEntitiesPosessingComponentOfClass("ItemComponent");
	for(UINT i=0;i<items->count();i++){ 
		Entity* entity =(Entity* ) items->objectAtIndex(i);
		RenderComponent* render = entity->render();
		ItemComponent* item = (ItemComponent*) entity->item();
		if (render->node->boundingBox().containsPoint(touchPoint)) {
			//_aiPlayer->communicate()->sendData->addObject(CCString::create(cmd));

			switch(item->itemType){
				case ItemTypeGold:
                {
					_humanPlayer->player()->coins += item->Gold;
                    std::string stateWord =CCUserDefault::sharedUserDefault()->getStringForKey("Gold");
                    char result[40];
                    sprintf(result,"%d%s",item->Gold,stateWord.c_str());
                    CCLabelTTF* guide =CCLabelTTF::create(result, fontname, fontSizeBig, ccp(xMARGIN*16,yMARGIN), kCCTextAlignmentCenter );
                    guide->setColor(ccc3(255,255,0));
                    guide->setPosition(render->node->getPosition());
                    this->_entityFactory->_batchNode->getParent()->addChild(guide);
                    
                    CCScaleTo* scaleFrom = CCScaleTo::create(0.1f,1.5f);
                    CCDelayTime* delay = CCDelayTime::create(0.1f);
                    CCScaleTo* scaleTo = CCScaleTo::create(0.1f,1.0f);
                    CCFiniteTimeAction* actionMoveDone = CCCallFuncN::create(this,callfuncN_selector(CCBattle::clean));
                    
                    CCSequence* sequence = CCSequence::create(scaleFrom,delay,scaleTo,delay,actionMoveDone,NULL);
                    guide->runAction(sequence);
                    render->node->removeFromParentAndCleanup(true);
					_entityManager->removeEntity(entity);
					return;
                }
                case ItemTypeAttackPoint:
                case ItemTypeMaxHitPoint:
                case ItemTypeFireSpeed:
                case ItemTypeMoveSpeed:
                {
                    char cmd[] = {(char)0x72,(char)0x01,(char)item->itemType};
                    sendPacket(role,PacketTypeMessage, cmd);
                    break;   
                }
                default:
                {
                    std::string stateWord =CCUserDefault::sharedUserDefault()->getStringForKey("Empty");
                    CCLabelTTF* guide =CCLabelTTF::create(stateWord.c_str(), fontname, fontSizeBig, ccp(xMARGIN*16,yMARGIN), kCCTextAlignmentCenter );
                    guide->setColor(ccc3(255,255,0));
                    guide->setPosition(render->node->getPosition());
                    this->_entityFactory->_batchNode->getParent()->addChild(guide);
                    
                    CCScaleTo* scaleFrom = CCScaleTo::create(0.1f,1.5f);
                    CCDelayTime* delay = CCDelayTime::create(0.1f);
                    CCScaleTo* scaleTo = CCScaleTo::create(0.1f,1.0f);
                    CCFiniteTimeAction* actionMoveDone = CCCallFuncN::create(this,callfuncN_selector(CCBattle::clean));
                    
                    CCSequence* sequence = CCSequence::create(scaleFrom,delay,scaleTo,delay,actionMoveDone,NULL);
                    
                    guide->runAction(sequence);
                    render->node->removeFromParentAndCleanup(true);
					_entityManager->removeEntity(entity);
					return;
                }
			}
			CCArray* monsters = _humanPlayer->getAllEntitiesOnTeam(_humanPlayer->team()->team,"MonsterComponent");
			for(UINT i=0;i<monsters->count();i++){ 
				Entity* monsterEntity =(Entity* ) monsters->objectAtIndex(i);
				CCLog("Entity %d enhanced by item",monsterEntity->_eid);
				MonsterComponent* monster = (MonsterComponent*) monsterEntity->monster();
                RenderComponent *render = (RenderComponent*) monsterEntity->render();
                HealthComponent *health = (HealthComponent*) monsterEntity->health();
				monster->monster->_deck = monster->monster->_storedDeck;
				switch(item->itemType){
				case ItemTypeAttackPoint:
                    {
                        std::string stateWord =CCUserDefault::sharedUserDefault()->getStringForKey("AT1");

                        notice(stateWord.c_str(),render->node->getPosition());
                    
					monster->monster->deck->fight.Damage += item->AttackPoint;break;
                        
                    }
				case ItemTypeMaxHitPoint:
                    {
                        std::string stateWord =CCUserDefault::sharedUserDefault()->getStringForKey("HP1");
                        
                        notice(stateWord.c_str(),render->node->getPosition());
    
                    health->curHP += item->MaxHitPoint;
                    if(health->curHP>health->maxHP)
                        health->curHP = health->maxHP;
					break;
                    }
				case ItemTypeFireSpeed:
                    {
                        std::string stateWord =CCUserDefault::sharedUserDefault()->getStringForKey("VF1");
                        
                        notice(stateWord.c_str(),render->node->getPosition());
                        
                            monster->monster->deck->fight.FireRate -= item->FireSpeed;break;
                    }
				case ItemTypeMoveSpeed:
					{
                        std::string stateWord =CCUserDefault::sharedUserDefault()->getStringForKey("VM1");
                        
                        notice(stateWord.c_str(),render->node->getPosition());
                        
                        monster->monster->deck->fight.maxVelocity += item->MoveSpeed;break;
                    }
                                }
				item->isConsumed = true;
				item->createTime = GetTickCount();
			}
			render->node->removeFromParentAndCleanup(true);
			if(item->itemType==ItemTypeMaxHitPoint)
				_entityManager->removeEntity(entity);
			return;
		}

	}
    
	CCArray* movers = _humanPlayer->getAllEntitiesOnTeam(_humanPlayer->team()->team,"SelectionComponent");
	for(UINT i=0;i<movers->count();i++){ 
		Entity* entity =(Entity* ) movers->objectAtIndex(i);
		SelectionComponent* select = entity->select();
		 RenderComponent* render = entity->render();
		if(select->selected)
		{
			MoveComponent* move = entity->move();
			RenderComponent* render = entity->render();
			move->moveTarget = touchPoint;
			GunComponent* gun = entity->gun();
			if (gun) {
				CCPoint vector = ccpNormalize(ccpSub(render->node->getPosition(), touchPoint));
				move->moveTarget = ccpAdd(touchPoint, ccpMult(vector, gun->deck->fight.Range / 2));
			}
			//CCLog("Destination %d %f,%f",entity->_eid,touchPoint.x,touchPoint.y);
			
			
		}
	}
		 movers = _humanPlayer->getAllEntitiesOnTeam(_humanPlayer->team()->team,"MoveComponent");
    //for (Entity * mover in movers) {   
    for(UINT i=0;i<movers->count();i++){ 
		Entity* mover =(Entity* ) movers->objectAtIndex(i);
        RenderComponent* render = mover->render();
		if (render->node->boundingBox().containsPoint(touchPoint)) {
			CCLog("entity %d selected",mover->_eid);
			SelectionComponent* select = mover->select();
			select->selected = !select->selected ;
			if(select->selected)
			{
				MoveComponent* move = mover->move();
				MonsterComponent* monster = mover->monster();
				//move->moveTarget = render->node->getPosition();
				move->maxVelocity= move->maxVelocity*2;
				move->velocity = ccpMult(ccp(1,0),move->maxVelocity);
				CCSprite* ring = CCSprite::createWithSpriteFrameName("selection.png");
				ring->setPosition(ccp(render->node->getContentSize().width/2,render->node->getContentSize().height/2));
				render->node->addChild(ring,1,60);
			}
			else
				render->node->removeChildByTag(60,true);
			//return true;
		}

    }
	// switch attack status
    RenderComponent* render = _humanPlayer->render();
    PlayerComponent* player = _humanPlayer->player();
    if (render && player) {
        if (render->node->boundingBox().containsPoint(touchPoint)) {
			char cmd[] ={(char)0x73,(char)0x01,player->attacking ?(char)1:(char)2};
		//_aiPlayer->communicate()->sendData->addObject(CCString::create(cmd));
        sendPacket(role,PacketTypeMessage, cmd);
		player->attacking = !player->attacking;
        }
    }
}

void CCBattle::release()
{
	CCLayer::release();
	_humanPlayer->release();
	_aiPlayer->release();
    delete _itemSystem;
    
	delete _entityManager;
	delete _entityFactory; 

	delete _healthSystem; 
	delete _moveSystem; 
	delete _playerSystem; 
	delete _meleeSystem;  
	delete _gunSystem; 
	for(int i=0;i<EFFECT_NUM;i++)
	{
		this->removeChild(effects[i].particle);
	}
}
void  CCBattle::homeButtonTapped(CCObject* obj) 
{
	CCDirector::sharedDirector()->replaceScene(ArmorHome::scene());
}
void  CCBattle::helpButtonTapped(CCObject* obj) 
{
	CCDirector::sharedDirector()->replaceScene(HelpLayer::scene());
}

void CCBattle::shopButtonTapped(CCObject* obj) 
{
	//CCDirector::sharedDirector()->replaceScene(UserPay::scene());
}

/*
 client server delegate
 */
void CCBattle::clientReceiveData(NSData* data, NSString *peerID) {
	CCLOG("CCBattle::clientReceiveData");
	Packet *packet = [Packet packetWithData:data];
	if (packet == nil) {
		return;
	}
    CommunicateComponent* com = _aiPlayer->communicate();
    if(com)
    com->recvData->addObject(CCString::create([packet.packetMessage cStringUsingEncoding:NSASCIIStringEncoding]));
    
    
    //    tirggerFuncWithString("clientReceiveData", packet.packetMessage);
}

void CCBattle::serverReceiveData(NSData* data, NSString *peerID) {
	CCLOG("CCBattle::serverReceiveData");
	Packet *packet = [Packet packetWithData:data];
	if (packet == nil) {
		return;
	}
    CommunicateComponent* com = _aiPlayer->communicate();
    if(com)
    com->recvData->addObject(CCString::create([packet.packetMessage cStringUsingEncoding:NSASCIIStringEncoding]));
    
    //    tirggerFuncWithString("serverReceiveData", packet.packetMessage);
}

void CCBattle::serverBecameAvailable(MatchmakingClient* client, NSString* peerID) {
    CCLOG("CCBattle::serverBecameAvailable");
    //    tirggerFuncWithString("serverBecameAvailable", peerID);
    CCSize winSize = CCDirector::sharedDirector()->getWinSize();
    CCMenuItemSprite* quirkButton;
    quirkButton = CCMenuItemSprite::create(CCSprite::createWithSpriteFrameName("button.png"),CCSprite::createWithSpriteFrameName("button_sel.png"),this,menu_selector(CCBattle::connectButtonTapped));
    CCPoint point = ccp(winSize.width/2,winSize.height/2);
    point.y = point.y- ([client getAvailServersIndex:peerID ] +1)* CCSprite::createWithSpriteFrameName("button.png")->getContentSize().height * 1.1;
    quirkButton->setPosition(point);
    CCSize contentSize =  quirkButton->getContentSize();
    //CCLabelBMFont* quirkLabel = CCLabelBMFont::create([[client displayNameForPeerID:peerID] UTF8String],fontfile);
    CCLabelTTF* quirkLabel = CCLabelTTF::create([[client displayNameForPeerID:peerID] UTF8String],fontname, fontSizeBig, ccp(xMARGIN*4,yMARGIN*1.5), kCCTextAlignmentCenter );

    quirkLabel->setColor(ccc3(185,220,255));
    quirkLabel->setPosition(ccp(contentSize.width * 0.5,contentSize.height * 0.68));
    quirkLabel->setTag(3000);
    quirkButton->addChild(quirkLabel);
    quirkButton->setTag([peerID intValue]);
    menu->addChild(quirkButton);
    
}
void CCBattle::serverBecameUnavailable(MatchmakingClient* client, NSString* peerID) {
    CCLOG("CCBattle::serverBecameUnavailable");
    //	tirggerFuncWithString("serverBecameUnavailable", peerID);
}
void CCBattle::didDisconnectFromServer(MatchmakingClient* client, NSString* peerID) {
    CCLOG("CCBattle::didDisconnectFromServer");
    //	tirggerFuncWithString("didDisconnectFromServer", peerID);
    //matchmakingClient = NULL;
}
void CCBattle::clientNoNetwork(MatchmakingClient* client) {
    CCLOG("CCBattle::clientNoNetwork");
    //	tirggerFunc("clientNoNetwork");
}

void CCBattle::clientDidConnect(MatchmakingServer* server, NSString* peerID) {
    CCLOG("CCBattle::clientDidConnect");
    //    tirggerFuncWithString("clientDidConnect", peerID);
    addPlayers();
    removeButtons();
    role=1;
}
void CCBattle::clientDidDisconnect(MatchmakingServer* server, NSString* peerID) {
    CCLOG("CCBattle::clientDidDisconnect");
    if(_humanPlayer)
    {
        HealthComponent* health = _humanPlayer->health();
        if(health)
            showRestartMenu(health->curHP>_aiPlayer->health()->curHP);
    }
    //	tirggerFuncWithString("clientDidDisconnect", peerID);
}
void CCBattle::sessionDidEnd(MatchmakingServer* server) {
    CCLOG("CCBattle::sessionDidEnd");
    if(_humanPlayer)
    {
    HealthComponent* health = _humanPlayer->health();
    if(health)
        showRestartMenu(health->curHP>_aiPlayer->health()->curHP);
    }

    //	tirggerFuncWithString("sessionDidEnd", "");
    //    matchmakingServer = NULL;
}
void CCBattle::serverNoNetwork(MatchmakingServer* server) {
    CCLOG("CCBattle::serverNoNetwork");
    if(_humanPlayer)
    {
        HealthComponent* health = _humanPlayer->health();
    if(health)
        showRestartMenu(health->curHP>_aiPlayer->health()->curHP);
    }
    //	tirggerFunc("serverNoNetwork");
}

