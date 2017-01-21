#ifndef __SERVERSCENE_H__
#define __SERVERSCENE_H__
#include "cocos2d.h"

#include "Packet.h"
#include "MatchmakingClient.h"
#include "MatchmakingServer.h"
#include "MatchmakingProtocol.h"

NS_CC_BEGIN
class ServerScene : public CCLayer,public MatchmakingClientProtocol, public MatchmakingServerProtocol
{
public:
    CCSpriteBatchNode *_batchNodes;

    CCMenu* menu;
    CCPoint basePoint;
    int serverNum;
    // there's no 'id' in cpp, so we recommend returning the class instance pointer
	static CCScene* scene();

    // Here's a difference. Method 'init' in cocos2d-x returns bool, instead of returning 'id' in cocos2d-iphone    
    virtual bool init();
	//static GameOverLayer* create(bool won,int _level);
	void registerWithTouchDispatcher();
	bool ccTouchBegan(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent);
	//bool initWithWon(bool won,int _level);
    void basicSetup();

	CREATE_FUNC(ServerScene);

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
	
	
	void beServer();
	void queryServers();
    void beClient();
    void joinServer(const char* peerID);
    void endSession();
    void disconnectFromServer();
    void sendPacket(int role, PacketType type, const char* message);
	void clientReceiveData(NSData* data, NSString* peerID);
	void serverReceiveData(NSData* data, NSString* peerID);

};
static MatchmakingServer* matchmakingServer;
static MatchmakingClient* matchmakingClient;

NS_CC_END

#endif