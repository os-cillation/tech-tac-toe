//
//  AppDelegate.m
//  TechTacToe-ah
//
//  Created by andreas on 9/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

//TODO clean Localized Strings
//TODO clean unneeded files

#import "AppDelegate.h"
#import "BluetoothDataHandler.h"
#import "Game.h"

@implementation AppDelegate

@synthesize mainWindow = _mainWindow;
@synthesize btdh=_btdh;
@synthesize currentGame=_currentGame;
@synthesize tabBarController = _tabBarController;
@synthesize isAIActivated = _isAIActivated;
@synthesize isAIRedPlayer = _isAIRedPlayer;
@synthesize strengthOfAI = _strengthOfAI;
@synthesize turnLimit = _turnLimit;
@synthesize turnLimitNumber = _turnLimitNumber;
@synthesize boardSizeLimit = _boardSizeLimit;
@synthesize boardSizeWidth = _boardSizeWidth;
@synthesize boardSizeHeight = _boardSizeHeight;
@synthesize minimumLineSize = _minimumLineSize;
@synthesize scoreMode = _scoreMode;
@synthesize additionalRedTurn = _additionalRedTurn;
@synthesize reuseLines = _reuseLines;
@synthesize localPlayerColorBlue = _localPlayerColorBlue;
@synthesize menuReqType = _menuReqType;
@synthesize needsAck = _needsAck;
@synthesize noActiveGameViewController = _noActiveGameViewController;
@synthesize tab0NavigationController=_tab0NavigationController;
@synthesize tab1NavigationController=_tab1NavigationController;
@synthesize tab2NavigationController=_tab2NavigationController;
@synthesize tab3NavigationController=_tab3NavigationController;
@synthesize tab4ViewController=_tab4ViewController;

#pragma mark

- (void)dealloc
{
    [_mainWindow release];
    [_tabBarController release];
    [_btdh release];
    [_currentGame release];
    [_noActiveGameViewController release];
    [_tab0NavigationController release];
    [_tab1NavigationController release];
    [_tab2NavigationController release];
    [_tab3NavigationController release];
    [_tab4ViewController release];
    [super dealloc];
}

#pragma mark - Application delegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.tabBarController.delegate = self;
    [self.mainWindow addSubview:self.tabBarController.view];
    [self.mainWindow makeKeyAndVisible];
    self.tabBarController.selectedIndex = 1;
    self.tab0NavigationController = [self.tabBarController.viewControllers objectAtIndex:0];
    self.tab1NavigationController = [self.tabBarController.viewControllers objectAtIndex:1];
    self.tab2NavigationController = [self.tabBarController.viewControllers objectAtIndex:2];
    self.tab3NavigationController = [self.tabBarController.viewControllers objectAtIndex:3];
    self.tab4ViewController = [self.tabBarController.viewControllers objectAtIndex:4];
    
    self.noActiveGameViewController = [self.tab0NavigationController.viewControllers objectAtIndex:0];
    
    self.tab0NavigationController.tabBarItem.title = NSLocalizedString(@"ACTIVE_GAME_TAB_TITLE", "Active Game");
    self.tab1NavigationController.tabBarItem.title = NSLocalizedString(@"NEW_GAME_TAB_TITLE", "New Game");
    self.tab2NavigationController.tabBarItem.title = NSLocalizedString(@"LOAD_TAB_TITLE", "Load");
    self.tab3NavigationController.tabBarItem.title = NSLocalizedString(@"SETTINGS_TAB_TITLE", "Settings");
    self.tab4ViewController.tabBarItem.title = NSLocalizedString(@"INFO_TAB_TITLE", "Info");
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"ImagePaths" ofType:@"plist"];
    NSDictionary *plist = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    [self.tab0NavigationController.tabBarItem setImage: [UIImage imageNamed:[plist objectForKey:@"tab0icon"]]];
    [self.tab1NavigationController.tabBarItem setImage: [UIImage imageNamed:[plist objectForKey:@"tab1icon"]]];
    [self.tab2NavigationController.tabBarItem setImage: [UIImage imageNamed:[plist objectForKey:@"tab2icon"]]];
    [self.tab3NavigationController.tabBarItem setImage: [UIImage imageNamed:[plist objectForKey:@"tab3icon"]]];
    [self.tab4ViewController.tabBarItem setImage: [UIImage imageNamed:[plist objectForKey:@"tab4icon"]]];
    
    [self.tabBarController reloadInputViews];
    [plist release];
    self.menuReqType = -1;
    self.needsAck = YES;
    
    //init AI variables
    self.strengthOfAI = 2;
    self.isAIRedPlayer = YES;
    self.isAIActivated = YES;
    
    //init Custom Game variables
    self.turnLimit = YES;
    self.turnLimitNumber = 100;
    self.boardSizeLimit = YES;
    self.boardSizeWidth = 11;
    self.boardSizeHeight = 11;
    self.minimumLineSize = 4;
    self.scoreMode = NO;
    self.additionalRedTurn = YES;
    self.reuseLines = NO;
    self.localPlayerColorBlue = YES;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    
    // if our application had an open Bluetooth connection, close it before termination
    if (self.btdh.currentSession) {
        [self.btdh doDisconnect];
    }
    //End Image Context from last active game
    UIGraphicsEndImageContext();
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if (self.tabBarController.selectedIndex == 0)
    {
        [self.tab0NavigationController popToRootViewControllerAnimated:NO];
    }
    else if (self.tabBarController.selectedIndex == 2)
    {
        [self.tab2NavigationController popToRootViewControllerAnimated:NO];
    }
    else if (self.tabBarController.selectedIndex == 1)
    {
        [self.tab1NavigationController popToRootViewControllerAnimated:NO];
    }
    else if (self.tabBarController.selectedIndex == 3)
    {
        [self.tab3NavigationController popToRootViewControllerAnimated:NO];
    }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if (self.btdh.currentSession && !self.btdh.localUserActAsServer && (viewController == self.tab1NavigationController || viewController == self.tab2NavigationController))
    {
        return NO;
    }
    return YES;
}

- (void)startGame
{
    self.tabBarController.selectedIndex = 0;
    NSArray *resetNavCon = [[NSArray alloc] init];
    self.tab0NavigationController.viewControllers = resetNavCon;
    UIGraphicsEndImageContext();
    [self.tab0NavigationController pushViewController:self.currentGame.gameViewController animated:YES];
    [resetNavCon release];
}

- (void)endGame
{
    NSArray *resetNavCon = [[NSArray alloc] initWithObjects:self.noActiveGameViewController, nil];
    self.tab0NavigationController.viewControllers = resetNavCon;
    [resetNavCon release];
    self.currentGame = Nil;
}
@end
