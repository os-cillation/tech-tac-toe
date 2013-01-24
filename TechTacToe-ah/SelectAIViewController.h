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
