//
//  LoadDetailViewController.h
//  TechTacToe-ah
//
//  Created by andreas on 07/10/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

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
