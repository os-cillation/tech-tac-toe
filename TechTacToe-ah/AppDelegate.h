//
//  AppDelegate.h
//  TechTacToe-ah
//
//  Created by andreas on 9/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Game;

@class BluetoothDataHandler;

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate> {
    UIWindow *_mainWindow; // the only window
    BluetoothDataHandler *btdh; // the object managing bluetooth data transfers and disconnects - we need a reference to this, so we can disconnect on application termination
}
-(void) startGame;
-(void) endGame;

@property (nonatomic, retain) IBOutlet UIWindow *mainWindow;
@property (nonatomic, retain) BluetoothDataHandler *btdh;
@property (nonatomic, retain) Game *currentGame;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@property (nonatomic) BOOL isAIActivated;
@property (nonatomic) BOOL isAIRedPlayer;
@property (nonatomic) int strengthOfAI;

@property (nonatomic) BOOL turnLimit;
@property (nonatomic) int turnLimitNumber;
@property (nonatomic) BOOL boardSizeLimit;
@property (nonatomic) int boardSizeWidth;
@property (nonatomic) int boardSizeHeight;
@property (nonatomic) int minimumLineSize;
@property (nonatomic) BOOL scoreMode;
@property (nonatomic) BOOL additionalRedTurn;
@property (nonatomic) BOOL reuseLines;
@property (nonatomic) BOOL localPlayerColorBlue;

@property (nonatomic, retain) UIViewController *noActiveGameViewController;

@property (nonatomic, retain) UINavigationController *tab0NavigationController;
@property (nonatomic, retain) UINavigationController *tab1NavigationController;
@property (nonatomic, retain) UINavigationController *tab2NavigationController;
@property (nonatomic, retain) UINavigationController *tab3NavigationController;
@property (nonatomic, retain) UIViewController *tab4ViewController;

@property (nonatomic, retain) UIImageView *bluetoothIndicator;

@end
