//
//  NewGameViewController.h
//  TechTacToe
//
//  Created by Christian Zöller on 11.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

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
