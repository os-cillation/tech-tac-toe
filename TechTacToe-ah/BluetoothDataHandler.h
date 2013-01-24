/*-
 * Copyright 2012 os-cillation GmbH
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <Foundation/Foundation.h>
#import <GameKit/GKSession.h>
#import <GameKit/GKPeerPickerController.h>
#import "AppDelegate.h"

@class MainViewController;

// message types
typedef enum {
    MESSAGE_COINTOSS,
    MESSAGE_REVOKE_CONTROL,
    MESSAGE_GAME_DATA,
    MESSAGE_COMMIT,
    MESSAGE_RESIGN,
    MESSAGE_MENU_REQ,
    MESSAGE_MENU_ACK
} messageTypes;

@interface BluetoothDataHandler : NSObject <GKSessionDelegate>
{
    GKSession *currentSession; // will be nil in hotseat mode or is a valid Bluetooth seesion
    BOOL localUserActAsServer; // if NO and a session exists, the remote device will start/load a game and will be blue unless specified otherwise
    int cointossResult; // the cointoss determined by arc4random() % 1000 call
}

@property (nonatomic, retain) GKSession *currentSession;
@property (nonatomic, retain) AppDelegate *appDelegate;
@property (nonatomic, getter = doesLocalUserActAsServer) BOOL localUserActAsServer;
@property (nonatomic) int cointossResult;

// handle disconnecting from and closing a session
-(void) doDisconnect;

// will be sent as first message when establishing a session - the winner will be able to start or load a game which both devices will be playing
-(void) doCointoss;

// can be either directly called by a UI element or indirectly by losing a cointoss and gives control of starting/loading Bluetooth enabled games to the other device
-(void) doRevokeControl;

// will send everything the other device needs to recreate a copy of the current game - right now, it should never be bigger than at about 70KB even on very large loaded games, but if it ever grows in size we might need to send 2 messages (max limit for message is 86K)
-(void) transmitCurrentGameData;

// will send information about the turn the other player has made so it can be recreated on the local device
-(void) sendCommittedTurn;

// send resign notification to the other player, so the game can end early
-(void) sendResign;

// will be sent if a player wants to go back to menu and wants the other to go back as well
-(void) sendBackToMenuRequest;

// is an acknowledgement that the device will return to menu on the previously sent request to do so
-(void) sendBackToMenuAcknowledge;

@end
