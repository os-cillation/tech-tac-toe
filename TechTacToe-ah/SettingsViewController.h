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

#import <UIKit/UIKit.h>
#import "Game.h"

@interface SettingsViewController : UITableViewController {
    
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
@property (nonatomic, retain) IBOutlet UITextField *playerColorTextField;

@property (nonatomic, retain) AppDelegate *appDelegate;

@property (nonatomic, retain) UIAlertView *activeGameAlert31;

// Interface Builder actions will handle activating/deactivating controls depending on current setting

- (IBAction)boardLimitChanged:(id)sender;
- (IBAction)limitTurnsChanged:(id)sender;
- (IBAction)scoreModeChanged:(id)sender;

-(void) startGame; // collects information about switches and text field values and creates rules/new game - also, will push a new game view controller unto the navigation stack

@end
