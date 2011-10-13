//
//  MainViewController.h
//  TechTacToe-ah
//
//  Created by andreas on 29/09/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GKSession.h>
#import <GameKit/GKPeerPickerController.h>
#import "Game.h"

@interface MainViewController : UITableViewController <UINavigationBarDelegate, GKPeerPickerControllerDelegate, GKSessionDelegate>
{
    Game *currentGame; // the game that will be started either from self, the settings view or from the load detail view
    GKSession *currentSession; // will be nil in hotseat mode or is a valid bluetooth seesion
}

@property (nonatomic, retain) Game *currentGame;
@property (nonatomic, retain) GKSession *currentSession;

@end
