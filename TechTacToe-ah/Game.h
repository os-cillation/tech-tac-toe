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

#import <Foundation/Foundation.h>
#import "GameViewController.h" //this includes GameAI
#import "AppDelegate.h"

@class MainViewController;

@interface Game : NSObject {
    GameViewController *gameViewController;
    GameData *gameData;
}

// will initialize a new game if passed nil as filename, else tries to load a saved game - will pass information about game mode and rules to the gameData object - use this instead of standard init
-(Game*)initInMode:(int)mode withBoardSize:(CGSize)sizeOrNil;

@property (nonatomic, retain) GameViewController *gameViewController;
@property (nonatomic, retain) GameData *gameData;
@property (nonatomic, retain) AppDelegate *appDelegate;

@end
