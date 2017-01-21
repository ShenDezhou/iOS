
#import <GameKit/GameKit.h>
#import "Packet.h"
typedef enum {
	ClientStateIdle,
	ClientStateSearchingForServers,
	ClientStateConnecting,
	ClientStateConnected,
}
ClientState;

class MatchmakingClientProtocol;
@interface MatchmakingClient : NSObject <GKSessionDelegate> {
	ClientState _clientState;
    MatchmakingClientProtocol* _delegate;
}

@property (nonatomic, retain) NSMutableArray* availableServers;
@property (nonatomic, retain) GKSession* session;
@property (nonatomic, retain) NSString* serverPeerID;

- (void)setDelegate:(MatchmakingClientProtocol*)delegate;
- (void)startSearchingForServersWithSessionID:(NSString*)sessionID displayName:(NSString*)displayName;
- (void)searchAvailServers;
- (NSString*)peerIDForAvailableServerAtIndex:(NSUInteger)index;
- (NSString*)displayNameForPeerID:(NSString*)peerID;
- (void)connectToServerWithPeerID:(NSString*)peerID;
- (void)disconnectFromServer;
- (NSInteger)getAvailServersIndex:(NSString*) peerID;

@end
