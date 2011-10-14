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

@interface BluetoothDataHandler : NSObject <GKSessionDelegate>
{
    GKSession *currentSession; // will be nil in hotseat mode or is a valid bluetooth seesion
    BOOL localUserBlue; // if NO and a session exists, the remote device will start/load a game and will be blue
}

@property (nonatomic, retain) GKSession *currentSession;
@property (nonatomic, assign) MainViewController *mvc;
@property (nonatomic, getter = isLocalUserBlue) BOOL localUserBlue;

@end
