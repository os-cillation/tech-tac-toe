//
//  Game.m
//  TechTacToe-ah
//
//  Created by andreas on 9/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Game.h"

@implementation Game

@synthesize gameViewController=_gameViewController;
@synthesize gameData=_gameData;
@synthesize appDelegate=_appDelegate;

#pragma mark - Initializer and memory management

-(Game*)initInMode:(int)mode withBoardSize:(CGSize)sizeOrNil
{
    self = [super init];
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (!self.gameData) {
        GameData *localGameData = [[GameData alloc]initEmptyInMode:mode withBoardSize:sizeOrNil];
        self.gameData = localGameData;
        [localGameData release];
    }
    Rules *rules;
    
    //init AI
    if(self.appDelegate.isAIActivated)
    {
        GameAI *tempGameAI = [[GameAI alloc] init];
        tempGameAI.isRedPlayer = self.appDelegate.isAIRedPlayer;
        tempGameAI.isActivated = YES;
        tempGameAI.gameData = self.gameData;
        tempGameAI.strength = self.appDelegate.strengthOfAI;
        self.gameData.gameAI = tempGameAI;
        [tempGameAI release];
    }
    else
    {
        self.gameData.gameAI = Nil;
    }
    
    if (mode == TICTACTOE) {
        // init new classic game
        
        // Tic Tac Toe mode always has the same rules: a maximum of 9 turns, 3 fields for a line and no additional turn for the red player
        rules = [[Rules alloc] initWithMinFieldsForLine:3 numberOfTurns:9 extendableBoard:NO scoreMode:NO additionalRedTurn:NO reuseOfLines:NO];
        
        // set the rules for the gameData - since gameData retains them, it should be safe to release here
        self.gameData.rules = rules;
        [rules release];
        
        // init gameViewController with inital values (new game): only 9 fields, but we need enough space to display border tiles and to center the view on the screen since we cannot scroll
        GameViewController *tempGameViewController = [[GameViewController alloc] initWithSize:CGSizeMake(FIELDSIZE * 9, FIELDSIZE * 9) gameData:self.gameData];
        self.gameViewController = tempGameViewController;
        [tempGameViewController release];
    }
    else if (mode == GOMOKU) {
        // init new gomoku game
        
        // gomoku mode always has the same rules: a maximum of 361 turns, 5 fields for a line and no additional turn for the red player
        rules = [[Rules alloc] initWithMinFieldsForLine:5 numberOfTurns:361 extendableBoard:NO scoreMode:NO additionalRedTurn:NO reuseOfLines:NO];
        
        // set the rules for the gameData - since gameData retains them, it should be safe to release here
        self.gameData.rules = rules;
        [rules release];
        
        // init gameViewController with inital values (new gomoku game): only 19x19 fields, but we need enough space to display the border tiles
        GameViewController *tempGameViewController = [[GameViewController alloc] initWithSize:CGSizeMake(FIELDSIZE * 21, FIELDSIZE * 21) gameData:self.gameData];
        self.gameViewController = tempGameViewController;
        [tempGameViewController release];
    }
    else {
        // set standard values if we have no special rules
        rules = [[Rules alloc] initWithMinFieldsForLine:4 numberOfTurns:0 extendableBoard:YES scoreMode:NO additionalRedTurn:YES reuseOfLines:NO];
        
        // set the rules for the gameData - since gameData retains them, it should be safe to release here
        self.gameData.rules = rules;
        [rules release];
        
        // rules might not yet have been assigned, so test for width == 0 instead of self.rules.isExtendableBoard here
        if (self.gameData.boardWidth == 0) {
            // init gameViewController with inital values (new game, no set board size - start with view size for initial board)
            GameViewController *tempGameViewController = [[GameViewController alloc] initWithSize:CGSizeMake(FIELDSIZE * 7, FIELDSIZE * 7) gameData:self.gameData];
            self.gameViewController = tempGameViewController;
            [tempGameViewController release];
        } else {
            // init gameViewController with a size what contains the whole board at once - display needs to be at least 9x9 fields in size
            GameViewController *tempGameViewController = [[GameViewController alloc] initWithSize:CGSizeMake(MAX(FIELDSIZE * (sizeOrNil.width + 2), FIELDSIZE * 9), MAX(FIELDSIZE * (sizeOrNil.height + 2), FIELDSIZE * 9)) gameData:self.gameData];
            self.gameViewController = tempGameViewController;
            [tempGameViewController release];
        }
    }
    return self;
}

-(void)dealloc{
    [_gameViewController release];
    [_gameData release];
    [_appDelegate release];
    [super dealloc];
}

@end
