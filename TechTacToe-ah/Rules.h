//
//  Rules.h
//  TechTacToe-ah
//
//  Created by andreas on 9/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Rules : NSObject <NSCoding>
{
    int minFieldsForLine; // lines below this value do not count
    int maxNumberOfTurns; // if 0, play until one player scored (without the other countering)
    BOOL extendableBoard; // if YES, we play on a board with no initially set size
    BOOL scoreMode; // if NO, play until one player scored without countering, if YES, game ends after the maximum number of turns
    BOOL allowAdditionalRedTurn; // if YES, does allow the red player to counter, use NO for classic behaviour
    BOOL allowReuseOfLines; // if YES, fields of a line can be crossed (but not extended) to help getting a new line faster, if NO, fields of a line will be considered removed (default is YES)
}

@property (nonatomic, readonly) int minFieldsForLine;
@property (nonatomic) int maxNumberOfTurns; // needs to be writable for late board limiting
@property (nonatomic, readonly, getter = isExtendableBoard) BOOL extendableBoard;
@property (nonatomic, readonly, getter = inScoreMode) BOOL scoreMode;
@property (nonatomic, readonly, getter = doesAllowAdditionalRedTurn) BOOL allowAdditionalRedTurn;
@property (nonatomic, readonly, getter = doesAllowReuseOfLines) BOOL allowReuseOfLines;

// initializer to get a new rules object with complete data - use this and do not use standard init
-(Rules*)initWithMinFieldsForLine:(int)minFields numberOfTurns:(int)numberOrNil extendableBoard:(BOOL)extendable scoreMode:(BOOL)score additionalRedTurn:(BOOL)additionalTurn reuseOfLines:(BOOL)reuse;

@end
