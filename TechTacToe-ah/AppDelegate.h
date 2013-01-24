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

@property (nonatomic, retain) NSDictionary *plist;

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

@property (nonatomic) BOOL needsAck;
//used by AlertViews to know which type of game player tried to start
@property (nonatomic) int menuReqType;
/*  0 - TechTacToe
    1 - TicTacToe
    2 - Gomoku
    3 - Custom Game
    4 - Load Game
 */

@property (nonatomic, retain) UIViewController *noActiveGameViewController;

@property (nonatomic, retain) UINavigationController *tab0NavigationController;
@property (nonatomic, retain) UINavigationController *tab1NavigationController;
@property (nonatomic, retain) UINavigationController *tab2NavigationController;
@property (nonatomic, retain) UINavigationController *tab3NavigationController;
@property (nonatomic, retain) UIViewController *tab4ViewController;

@end
