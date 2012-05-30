//
//  SelectAIViewController.h
//  TechTacToe
//
//  Created by Christian Zöller on 25.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MainViewController;

@interface SelectAIViewController : UITableViewController

@property (nonatomic, retain) IBOutlet UITableViewCell *enableCell;
@property (nonatomic, retain) IBOutlet UISwitch *enableSwitch;
@property (nonatomic, retain) IBOutlet UITableViewCell *colorCell;
@property (nonatomic, retain) IBOutlet UITextField *colorTextField;
@property (nonatomic, retain) IBOutlet UITableViewCell *strengthCell;
@property (nonatomic, retain) IBOutlet UITextField *strengthTextField;

@property (nonatomic, assign) MainViewController *mvc;

- (IBAction)enableSwitchChanged:(id)sender;

@end
