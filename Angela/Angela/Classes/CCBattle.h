#pragma once
#include "cocos2d.h"

#include "SimpleAudioEngine.h"
#include "GameObject.h"

#include "RenderComponent.h"
#include "HealthComponent.h"
#include "GunComponent.h"
#include "MonsterComponent.h"

#include "Constant.h"
#include "AIState.h"
#include "Player.h"
#include "EntityFactory.h"
#include "EntityManager.h"

#include "HealthSystem.h"
#include "MoveSystem.h"
#include "PlayerSystem.h"
#include "MeleeSystem.h"
#include "GunSystem.h"
#include "AISystem.h"
#include "ItemSystem.h"
#include "CommunicateSystem.h"

#include "CCLayerParent.h"
#include "CCControlPotentiometer.h"
#include "MatchmakingProtocol.h"

NS_CC_BEGIN
USING_NS_CC_EXT;

class Player;
class CCBattle: public CCLayer,public MatchmakingClientProtocol, public MatchmakingServerProtocol
{
public:

    CCSpriteBatchNode *_batchNodes;
	CCDictionary *_particleNodes;
	
	CCLabelBMFont *_stateLabel;
	CCLabelBMFont *_coin1Label;
	CCLabelBMFont *_coin2Label;
	CCLabelBMFont *_people1Label;
	CCLabelBMFont *_people2Label;
	CCMenuItemSprite* quirkButton;
	CCMenuItemSprite* zapButton;
	CCMenuItemSprite* munchButton;
	CCMenuItemSprite* dragonButton;
	CCMenuItemSprite* phoenixButton;
	CCMenuItemSprite* pauseButton;

	CCControlPotentiometer* potentio;


	CCMenu* menu ;
	bool _gameOver;
	bool _cooldown;
    bool _startGame;
    int lastHPTime;
    
 	Entity* _humanPlayer;
    Entity* _aiPlayer;
	EntityFactory * _entityFactory;
	EntityManager* _entityManager;
	
	HealthSystem* _healthSystem;
 	MoveSystem* _moveSystem;
    PlayerSystem* _playerSystem;	 
	MeleeSystem* _meleeSystem;
    GunSystem* _gunSystem;
	AISystem* _aiSystem;
	ItemSystem* _itemSystem;
	CommunicateSystem* _communicateSystem;
     MatchmakingServer* matchmakingServer;
     MatchmakingClient* matchmakingClient;
	CCBattle();

	static CCScene* scene();
	bool init();
	CREATE_FUNC(CCBattle);

	void basicSetup();
	void addPlayers();
    void removeButtons();
	CCMenuItemSprite * getSpriteButton(int tag,int price,const char* frameName,SEL_MenuHandler selector);
	void quirkButtonTapped(CCObject* obj) ;
	void pauseButtonTapped(CCObject* obj) ;
	void update(float delta);

 	void restartTapped(CCObject* obj);
	void showRestartMenu(bool won);
	void draw();

	void release();
    void spawnMonsterForEntity(MonsterType monsterType,Entity *entity);

	void registerWithTouchDispatcher();
    
    void notice(const char* notice,CCPoint position);
	inline void clean(CCNode* node){
		node->removeFromParentAndCleanup(true);
	}
	bool ccTouchBegan(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent);
    void ccTouchEnded(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent);
	void shopButtonTapped(CCObject* obj) ;
	void homeButtonTapped(CCObject* obj) ;
	void helpButtonTapped(CCObject* obj) ;
 	
    void serverButtonTapped(CCObject* obj) ;
    void clientButtonTapped(CCObject* obj) ;
    void connectButtonTapped(CCObject* obj)  ;
    
    void serverBecameAvailable(MatchmakingClient* client, NSString* peerID);
    void serverBecameUnavailable(MatchmakingClient* client, NSString* peerID);
    void didDisconnectFromServer(MatchmakingClient* client, NSString* peerID);
    void clientNoNetwork(MatchmakingClient* client);
    
    void clientDidConnect(MatchmakingServer* server, NSString* peerID);
    void clientDidDisconnect(MatchmakingServer* server, NSString* peerID);
    void sessionDidEnd(MatchmakingServer* server);
    void serverNoNetwork(MatchmakingServer* server);
    
	void clientReceiveData(NSData* data, NSString* peerID);
	void serverReceiveData(NSData* data, NSString* peerID);

    void beServer();
	void queryServers();
    void beClient();
    void joinServer(const char* peerID);
    void endSession();
    void disconnectFromServer();
    void sendPacket(int role, PacketType type, const char* message);

};

NS_CC_END

