//
//  MainViewController.h
//  TechTacToe-ah
//
//  Created by andreas on 29/09/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"
#import "BluetoothDataHandler.h"

@interface MainViewController : UITableViewController <UINavigationBarDelegate, GKPeerPickerControllerDelegate>
{
    Game *currentGame; // the game that will be started either from self, the settings view or from the load detail view
    BluetoothDataHandler *dataHandler; // handles data transfer from one device to another
}

@property (nonatomic, retain) Game *currentGame;
@property (nonatomic, retain) BluetoothDataHandler *dataHandler;

@end
