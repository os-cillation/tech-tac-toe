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
#import "AppDelegate.h"

@interface NewGameViewController : UIViewController <UIAlertViewDelegate>

@property (nonatomic, retain) AppDelegate *appDelegate;

@property (nonatomic, retain) IBOutlet UILabel *label1;
@property (nonatomic, retain) IBOutlet UILabel *label2;
@property (nonatomic, retain) IBOutlet UILabel *label3;
@property (nonatomic, retain) IBOutlet UILabel *label4;

@property (nonatomic, retain) IBOutlet UIButton *button1;
@property (nonatomic, retain) IBOutlet UIButton *button2;
@property (nonatomic, retain) IBOutlet UIButton *button3;
@property (nonatomic, retain) IBOutlet UIButton *button4;

@property (nonatomic, retain) UIAlertView *activeGameAlert21;
@property (nonatomic, retain) UIAlertView *activeGameAlert22;
@property (nonatomic, retain) UIAlertView *activeGameAlert23;

-(IBAction)techTacToe:(id)sender;
-(IBAction)ticTacToe:(id)sender;
-(IBAction)gomoku:(id)sender;
-(IBAction)customGame:(id)sender;

-(void)updateInterface:(UIInterfaceOrientation)toInterfaceOrientation;

@end 
