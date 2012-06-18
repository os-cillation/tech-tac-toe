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
#import "AppDelegate.h"

@interface MainViewController : UITableViewController <UINavigationBarDelegate, GKPeerPickerControllerDelegate>
{
    //UIImageView *bluetoothIndicator; // an icon showing if Bluetooth is activated, hidden if not
}


@property (nonatomic, retain) AppDelegate *appDelegate;

@end
