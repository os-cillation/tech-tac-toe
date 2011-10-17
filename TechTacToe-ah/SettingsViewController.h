//
//  SettingsViewController.h
//  TechTacToe-ah
//
//  Created by andreas on 28/09/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"
#import "MainViewController.h"

@interface SettingsViewController : UITableViewController <UITextFieldDelegate, UIGestureRecognizerDelegate> {
    
    // Interface Builder outlets
    UITableViewCell *minimumForLineCell;
    UITableViewCell *limitTurnsCell;
    UISwitch *limitTurnsSwitch;
    UITextField *minimumForLineTextField;
    UITableViewCell *numberOfTurnsCell;
    UITextField *numberOfTurnsTextField;
    UITableViewCell *scoreModeCell;
    UISwitch *scoreModeSwitch;
    UITableViewCell *additionalRedTurnCell;
    UISwitch *additionalRedTurnSwitch;
    UITableViewCell *reuseLineCell;
    UISwitch *reuseLineSwitch;
    UITableViewCell *playerSelectionCell;
    UISwitch *playerSelectionSwitch;
    UITableViewCell *boardWidthCell;
    UITextField *boardWidthTextField;
    UITableViewCell *boardHeightCell;
    UITextField *boardHeightTextField;
    UITableViewCell *boardLimitCell;
    UISwitch *boardLimitSwitch;
    
    UITapGestureRecognizer *tapGestureRecognizer; // this gesture recognizer will be used to dismiss keyboards on background tap
}

@property (nonatomic, retain) IBOutlet UITableViewCell *boardLimitCell;
@property (nonatomic, retain) IBOutlet UISwitch *boardLimitSwitch;
@property (nonatomic, retain) IBOutlet UITableViewCell *boardWidthCell;
@property (nonatomic, retain) IBOutlet UITextField *boardWidthTextField;
@property (nonatomic, retain) IBOutlet UITableViewCell *boardHeightCell;
@property (nonatomic, retain) IBOutlet UITextField *boardHeightTextField;
@property (nonatomic, retain) IBOutlet UITableViewCell *minimumForLineCell;
@property (nonatomic, retain) IBOutlet UITextField *minimumForLineTextField;
@property (nonatomic, retain) IBOutlet UITableViewCell *limitTurnsCell;
@property (nonatomic, retain) IBOutlet UISwitch *limitTurnsSwitch;
@property (nonatomic, retain) IBOutlet UITableViewCell *numberOfTurnsCell;
@property (nonatomic, retain) IBOutlet UITextField *numberOfTurnsTextField;
@property (nonatomic, retain) IBOutlet UITableViewCell *scoreModeCell;
@property (nonatomic, retain) IBOutlet UISwitch *scoreModeSwitch;
@property (nonatomic, retain) IBOutlet UITableViewCell *additionalRedTurnCell;
@property (nonatomic, retain) IBOutlet UISwitch *additionalRedTurnSwitch;
@property (nonatomic, retain) IBOutlet UITableViewCell *reuseLineCell;
@property (nonatomic, retain) IBOutlet UISwitch *reuseLineSwitch;
@property (nonatomic, retain) IBOutlet UITableViewCell *playerSelectionCell;
@property (nonatomic, retain) IBOutlet UISwitch *playerSelectionSwitch;

@property (nonatomic, retain) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, assign) MainViewController *mvc;

-(void) dismissAllKeyboards; // will be called by the tap gesture recognizer to dismiss the keyboard if we tap anywhere except a text field

- (IBAction)keyboardAppeared:(id)sender; // shared action called by any textfield on keyboard appearence - will disable navigation items to avoid starting a game or going back to main menu and getting an alert of the settings menu for invalid values or auto-adjusting

// Interface Builder actions will handle correct values in text fields and activating/deactivating controls depending on current setting
- (IBAction)numberOfTurnsEditEnd:(id)sender;
- (IBAction)numberOfTurnsEditChanged:(id)sender;
- (IBAction)minimumForLineEditEnd:(id)sender;
- (IBAction)minimumForLineEditChanged:(id)sender;
- (IBAction)boardLimitChanged:(id)sender;
- (IBAction)boardWidthEditEnd:(id)sender;
- (IBAction)boardWidthEditChanged:(id)sender;
- (IBAction)boardHeightEditEnd:(id)sender;
- (IBAction)boardHeightEditChanged:(id)sender;
- (IBAction)limitTurnsChanged:(id)sender;
- (IBAction)scoreModeChanged:(id)sender;

-(void) startGame; // collects information about switches and text field values and creates rules/new game - also, will push a new game view controller unto the navigation stack

@end
