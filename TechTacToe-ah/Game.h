//
//  Game.h
//  TechTacToe-ah
//
//  Created by andreas on 9/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameViewController.h" //this includes GameAI

@class MainViewController;

@interface Game : NSObject {
    GameViewController *gameViewController;
    GameData *gameData;
}

// will initialize a new game if passed nil as filename, else tries to load a saved game - will pass information about game mode and rules to the gameData object - use this instead of standard init
-(Game*)initInMode:(int)mode withBoardSize:(CGSize)sizeOrNil:(MainViewController *)mvc;

@property (nonatomic, retain) GameViewController *gameViewController;
@property (nonatomic, retain) GameData *gameData;

@end
