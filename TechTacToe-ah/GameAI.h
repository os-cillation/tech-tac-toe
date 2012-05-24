//
//  GameAI.h
//  TechTacToe
//
//  Created by Christian Zöller on 18.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "GameData.h"
#import "Field.h"
@class GameData;

@interface GameAI : NSObject <NSCoding>
{
    
}


@property (nonatomic) BOOL isRedPlayer;
@property (nonatomic) BOOL isActivated;
@property (nonatomic) CGPoint lastAIPosition;
@property (nonatomic) int strength;
@property (nonatomic, retain) GameData *gameData;

// call AI to make the next turn - if player position is nil AI does the first turn
-(CGPoint) callAI:(CGPoint *)playerPosition;

-(CGPoint) searchPosition:(CGPoint *)playerPosition;

-(GameAI *) init;

-(void)dealloc;

-(void)updatePrioritiesAroundPosition:(CGPoint *)position;

-(void)updatePrioritiesForArray:(NSMutableArray *)array;

-(int)analyzeField:(Field *)field;

-(int)analyzeFieldsInDirection:(Field *)startField:(int)xModifier:(int)yModifier;

-(void)createArray:(NSMutableArray *)resultArray:(int)xModifier:(int)yModifier:(CGPoint *)playerPosition;

-(bool)checkForLine:(Field *)currentField:(bool)colorIsRed:(int)xModifier:(int)yModifier;

-(int)calculatePriority:(int)ownFieldsLeft:(int)opponentFieldsLeft:(int)freeFieldsLeft:(int)rowOfOwnFields:(int)rowOfOpponentFields:(int)rowOfFreeFields:(bool)freeAfterLeft:(bool)freeAfterRight;

@end
