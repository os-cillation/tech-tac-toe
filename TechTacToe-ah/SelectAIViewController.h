//
//  SelectAIViewController.h
//  TechTacToe
//
//  Created by Christian Zöller on 25.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GKSession.h>
#import <GameKit/GKPeerPickerController.h>
#import "AppDelegate.h"

@interface SelectAIViewController : UITableViewController <UIAlertViewDelegate, GKPeerPickerControllerDelegate>

@property (nonatomic, retain) IBOutlet UITableViewCell *modeSelectCell;
@property (nonatomic, retain) IBOutlet UISegmentedControl *modeSelectControl;
@property (nonatomic, retain) IBOutlet UITableViewCell *colorCell;
@property (nonatomic, retain) IBOutlet UITextField *colorTextField;
@property (nonatomic, retain) IBOutlet UITableViewCell *strengthCell;
@property (nonatomic, retain) IBOutlet UITextField *strengthTextField;

@property (nonatomic, retain) IBOutlet UITableViewCell *connectCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *passControllCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *disconnectCell;

@property (nonatomic, retain) AppDelegate *appDelegate;
@property (nonatomic) BOOL isAIActivated;
@property (nonatomic) BOOL isAIRedPlayer;
@property (nonatomic) int strengthOfAI;

@property (nonatomic, retain) UIAlertView *btAlert51;
@property (nonatomic, retain) UIAlertView *btAlert52;

- (IBAction)modeSelectChanged:(id)sender;

@end
