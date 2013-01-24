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

@interface LoadDetailViewController : UITableViewController {
    NSString *gameName; // the filename - displayed in table view
    GameData *gameInformation; // game data of a saved game - will be used to display details of the game prior to loading it
}

@property (nonatomic, retain) NSString *gameName;
@property (nonatomic, retain) GameData *gameInformation;
@property (nonatomic, retain) AppDelegate *appDelegate;

@property (nonatomic, retain) UIAlertView *activeGameAlert41;

// custom initializer - will load from nib and create and retain a game data object
- (LoadDetailViewController*) initWithGameDataFromFile:(NSString*)filename;

// bound to a bar button to load the game displayed in the table view
- (void) loadGame;

@end
