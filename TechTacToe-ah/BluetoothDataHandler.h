//
//  BluetoothDataHandler.h
//  TechTacToe-ah
//
//  Created by andreas on 14/10/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GKSession.h>
#import <GameKit/GKPeerPickerController.h>

@class MainViewController;

// message types
typedef enum {
    MESSAGE_COINTOSS,
    MESSAGE_REVOKE_CONTROL,
    MESSAGE_GAME_DATA,
    MESSAGE_COMMIT
} messageTypes;

@interface BluetoothDataHandler : NSObject <GKSessionDelegate>
{
    GKSession *currentSession; // will be nil in hotseat mode or is a valid bluetooth seesion
    BOOL localUserActAsServer; // if NO and a session exists, the remote device will start/load a game and will be blue unless specified otherwise
    int cointossResult; // the cointoss determined by arc4random() % 1000 call
}

@property (nonatomic, retain) GKSession *currentSession;
@property (nonatomic, assign) MainViewController *mvc;
@property (nonatomic, getter = doesLocalUserActAsServer) BOOL localUserActAsServer;
@property (nonatomic) int cointossResult;

// will be sent as first message when establishing a session - the winner will be able to start or load a game which both devices will be playing
-(void) doCointoss;

// can be either directly called by a UI element or indirectly by losing a cointoss and gives control of starting/loading bluetooth enabled games to the other device
-(void) doRevokeControl;

// will send everything the other device needs to recreate a copy of the current game - right now, it should never be bigger than at about 70KB even on very large loaded games, but if it ever grows in size we might need to send 2 messages (max limit for message is 86K)
-(void) transmitCurrentGameData;

@end
