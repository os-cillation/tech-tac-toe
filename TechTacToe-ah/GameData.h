//
//  GameData.h
//  TechTacToe-ah
//
//  Created by andreas on 9/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Field.h"
#import "Rules.h"

// game modes
typedef enum {
    DEFAULT_GAME,
    CUSTOM_GAME,
    TICTACTOE,
    GOMOKU
} gameModes;

// change this to allow for bigger (extendable) boards - right now, it deactivates further expansion after board reaches or exceeds 25x25 fields
#define MAX_FIELDS 625

@interface GameData : NSObject <NSCoding>
{
    NSMutableDictionary *fields; // contains all field objects
    int positionOfLastMarkedFieldX, positionOfLastMarkedFieldY; // the position of the current or last selected field
    BOOL selection, bluePlayerTurn, gameOver, blueDidLeadOnPreviousTurn, blueResigned, redResigned, localPlayerBlue; // is something selected? is it the blue player's turn? will the game end this turn? did blue score last turn (used for survival mode games with additional turn)? has anyone resigned the game? on a Bluetooth game, is the local device the blue player? (on non-Bluetooth games always YES, but won't matter)
    int mode, numberOfTurn, bluePoints, redPoints, redPointsLastTurn, bluePointsLastTurn; // statistics of the game - will be used to display labels and trigger game over
    Rules *rules; // the rules of the current game
    int boardWidth, boardHeight; // if not (0,0) then board will be limited
    BOOL hitBoardLimit; // will be NO unless we have unlimited boards and they grew too big - will be set by gameViewController
}

@property (nonatomic, retain) NSMutableDictionary *fields;
@property (nonatomic) int positionOfLastMarkedFieldX, positionOfLastMarkedFieldY;
@property (nonatomic, getter = hasSelection) BOOL selection;
@property (nonatomic, readonly) int mode;
@property (nonatomic, getter = isBluePlayerTurn) BOOL bluePlayerTurn;
@property (nonatomic, getter = isGameOver) BOOL gameOver;
@property (nonatomic) BOOL blueDidLeadOnPreviousTurn;
@property (nonatomic, getter = hasBlueResigned) BOOL blueResigned;
@property (nonatomic, getter = hasRedResigned) BOOL redResigned;
@property (nonatomic, getter = isLocalPlayerBlue) BOOL localPlayerBlue;
@property (nonatomic) int numberOfTurn, bluePoints, redPoints, redPointsLastTurn, bluePointsLastTurn;
@property (nonatomic, retain) Rules *rules;
@property (nonatomic) int boardWidth, boardHeight;
@property (nonatomic, getter = didHitBoardLimit) BOOL hitBoardLimit;

// creates a new set of fields for a new game
-(GameData*)initEmptyInMode:(int)gameMode withBoardSize:(CGSize)sizeOrNil;

// will change status of one existing field in the dictionary
-(void)changeDataAtPoint:(CGPoint)point withStatus:(int)stat;

// checks if a field at the given point needs new empty fields in around it and creates them. returns an array with the changed fields (for drawing)
-(NSMutableArray*)createMoreEmptyFieldsAroundPoint:(CGPoint)point;

// moves the entire fields dictionary by a specified number of fields in both directions - will be called if the view needs to expand along a negative axis to prevent positions becoming sub-zero
-(void)moveGameFieldsByHorizontal:(int)fieldsX byVertical:(int)fieldsY;

// will be called by gameViewController when an extendable board hits the size limit: sets maximum number of turns if needed, calls moveGameFields and puts UNAVAILABLE_FIELD entries in the dictionary at the border
-(void)createBorderTiles;

// will be called prior to loading games with extendable boards and sets board width and height to current (maximum) values
-(void)updateBoardSize;

// will make use of current set of rules and checks if someone scores, switches the active player and returns an array with the changed fields (for drawing)
-(NSMutableArray*)consultRulesForFieldAtPoint:(CGPoint)point;

// will be called by the in-game menu if a player wants to resign the game
-(void)resignGame;

// will save the current game data to a file. if no filename is specified, it uses "autosave"
-(BOOL) saveGameToFile:(NSString*)filenameOrNil;

@end
