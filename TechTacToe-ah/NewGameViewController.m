//
//  NewGameViewController.m
//  TechTacToe
//
//  Created by Christian Zöller on 11.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewGameViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Game.h"
#import "BluetoothDataHandler.h"
#import "SettingsViewController.h"

@interface NewGameViewController ()

@end

@implementation NewGameViewController

@synthesize appDelegate = _appDelegate;
@synthesize label1 = _label1;
@synthesize label2 = _label2;
@synthesize label3 = _label3;
@synthesize label4 = _label4;
@synthesize button1 = _button1;
@synthesize button2 = _button2;
@synthesize button3 = _button3;
@synthesize button4 = _button4;
@synthesize activeGameAlert21 = _activeGameAlert21;
@synthesize activeGameAlert22 = _activeGameAlert22;
@synthesize activeGameAlert23 = _activeGameAlert23;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [_appDelegate release];
    [_activeGameAlert21 release];
    [_activeGameAlert22 release];
    [_activeGameAlert23 release];
    [_button1 release];
    [_button2 release];
    [_button3 release];
    [_button4 release];
    [_label1 release];
    [_label2 release];
    [_label3 release];
    [_label4 release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.tintColor = [UIColor grayColor];
    //self.title = NSLocalizedString(@"NEW_GAME_TITLE", "New Game");
    self.navigationItem.title = NSLocalizedString(@"NEW_GAME_TITLE", "New Game");
    self.appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    UIBarButtonItem *tempButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"BACK_BUTTON", @"Back") style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = tempButton;
    [tempButton release];
    NSString *path = [[NSBundle mainBundle]pathForResource:@"ImagePaths" ofType:@"plist"];
    NSDictionary *plist = [[NSDictionary alloc] initWithContentsOfFile:path];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[plist objectForKey:@"main view background"]]];
    //set button corners to make the corners rounded
    self.button1.layer.cornerRadius = 10;
    self.button1.clipsToBounds = YES;
    self.button2.layer.cornerRadius = 10;
    self.button2.clipsToBounds = YES;
    self.button3.layer.cornerRadius = 10;
    self.button3.clipsToBounds = YES;
    self.button4.layer.cornerRadius = 10;
    self.button4.clipsToBounds = YES;
    
    [self.button1 setImage:[UIImage imageNamed:[plist objectForKey:@"TechTacToeButton"]] forState:UIControlStateNormal];
    [self.button2 setImage:[UIImage imageNamed:[plist objectForKey:@"TicTacToeButton"]] forState:UIControlStateNormal];
    [self.button3 setImage:[UIImage imageNamed:[plist objectForKey:@"GomokuButton"]] forState:UIControlStateNormal];
    [self.button4 setBackgroundImage:[UIImage imageNamed:[plist objectForKey:@"CustomButtonBack"]] forState:UIControlStateNormal];
    self.button4.imageEdgeInsets = UIEdgeInsetsMake(25, 25, 0, 0);
    [self.button4 setImage:[UIImage imageNamed:[plist objectForKey:@"CustomButtonFront"]] forState:UIControlStateNormal];
    
    [plist release];
    self.label1.text = NSLocalizedString(@"NEW_GAME_TECHTACTOE", "TechTacToe");
    self.label2.text = NSLocalizedString(@"NEW_GAME_TICTACTOE", "TicTacToe");
    self.label3.text = NSLocalizedString(@"NEW_GAME_GOMOKU", "Gomoku");
    self.label4.text = NSLocalizedString(@"NEW_GAME_CUSTOMIZED_GAME", "Customized Game");
    
    UIAlertView *alert21 = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"NEW_GAME_ALERT_ACTIVE_GAME_TITLE", @"Active Game Found") message:NSLocalizedString(@"NEW_GAME_ALERT_ACTIVE_GAME_MESSAGE", @"There is already an active game running. Abort active game and start a new game?") delegate:self cancelButtonTitle:NSLocalizedString(@"CANCEL", @"Cancel") otherButtonTitles:NSLocalizedString(@"OK", @"OK"),nil];
    UIAlertView *alert22 = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"NEW_GAME_ALERT_ACTIVE_GAME_TITLE", @"Active Game Found") message:NSLocalizedString(@"NEW_GAME_ALERT_ACTIVE_GAME_MESSAGE", @"There is already an active game running. Abort active game and start a new game?") delegate:self cancelButtonTitle:NSLocalizedString(@"CANCEL", @"Cancel") otherButtonTitles:NSLocalizedString(@"OK", @"OK"),nil];
    UIAlertView *alert23 = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"NEW_GAME_ALERT_ACTIVE_GAME_TITLE", @"Active Game Found") message:NSLocalizedString(@"NEW_GAME_ALERT_ACTIVE_GAME_MESSAGE", @"There is already an active game running. Abort active game and start a new game?") delegate:self cancelButtonTitle:NSLocalizedString(@"CANCEL", @"Cancel") otherButtonTitles:NSLocalizedString(@"OK", @"OK"),nil];
    alert21.tag = 21;
    alert22.tag = 22;
    alert23.tag = 23;
    self.activeGameAlert21 = alert21;
    self.activeGameAlert22 = alert22;
    self.activeGameAlert23 = alert23;
    [alert21 release];
    [alert22 release];
    [alert23 release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 21)
    {
        if (buttonIndex != [alertView cancelButtonIndex])
        {
            self.appDelegate.currentGame = Nil;
            [self techTacToe:Nil];
        }
    }
    else if (alertView.tag == 22)
    {
        if (buttonIndex != [alertView cancelButtonIndex])
        {
            self.appDelegate.currentGame = Nil;
            [self ticTacToe:Nil];
        }
    }
    else if (alertView.tag == 23)
    {
        if (buttonIndex != [alertView cancelButtonIndex])
        {
            self.appDelegate.currentGame = Nil;
            [self gomoku:Nil];
        }
    }
}

- (IBAction)techTacToe:(id)sender
{
    if (self.appDelegate.currentGame && !self.appDelegate.currentGame.gameData.gameOver)
    {
        [self.activeGameAlert21 show];
        return;
    }
    Game *newGame = [[Game alloc]initInMode:DEFAULT_GAME withBoardSize:CGSizeMake(0, 0)];
    self.appDelegate.currentGame = newGame;
    [newGame release];
    // set the data handler regardless of Bluetooth status (will check for session in-game)
    self.appDelegate.currentGame.gameViewController.btDataHandler = self.appDelegate.btdh;
    // on a Bluetooth game, send game data to the opponent
    if (self.appDelegate.btdh.currentSession) {
        [self.appDelegate.btdh transmitCurrentGameData];
    }
    [self.appDelegate startGame];
}

-(IBAction)ticTacToe:(id)sender
{
    if (self.appDelegate.currentGame && !self.appDelegate.currentGame.gameData.gameOver)
    {
        [self.activeGameAlert22 show];
        return;
    }
    Game *newGame = [[Game alloc]initInMode:TICTACTOE withBoardSize:CGSizeMake(3, 3)];
    self.appDelegate.currentGame = newGame;
    [newGame release];
    self.appDelegate.currentGame.gameViewController.btDataHandler = self.appDelegate.btdh;
    if (self.appDelegate.btdh.currentSession) {
        [self.appDelegate.btdh transmitCurrentGameData];
    }
    [self.appDelegate startGame];
}

-(IBAction)gomoku:(id)sender
{
    if (self.appDelegate.currentGame && !self.appDelegate.currentGame.gameData.gameOver)
    {
        [self.activeGameAlert23 show];
        return;
    }
    Game *newGame = [[Game alloc]initInMode:GOMOKU withBoardSize:CGSizeMake(19, 19)];
    self.appDelegate.currentGame = newGame;
    [newGame release];
    self.appDelegate.currentGame.gameViewController.btDataHandler = self.appDelegate.btdh;
    if (self.appDelegate.btdh.currentSession) {
        [self.appDelegate.btdh transmitCurrentGameData];
    }
    [self.appDelegate startGame];
}

-(IBAction)customGame:(id)sender
{
    SettingsViewController *settings = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    [self.navigationController pushViewController:settings animated:YES];
    [settings release];
}
@end
