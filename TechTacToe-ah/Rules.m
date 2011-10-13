//
//  Rules.m
//  TechTacToe-ah
//
//  Created by andreas on 9/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Rules.h"

@implementation Rules

@synthesize minFieldsForLine=_minFieldsForLine;
@synthesize maxNumberOfTurns=_maxNumberOfTurns;
@synthesize extendableBoard=_extendableBoard;
@synthesize survivalMode=_survivalMode;
@synthesize allowAdditionalRedTurn=_allowAdditionalRedTurn;
@synthesize allowReuseOfLines=_allowReuseOfLines;

#pragma mark - Initializer and memory management

-(Rules*)initWithMinFieldsForLine:(int)minFields numberOfTurns:(int)numberOrNil extendableBoard:(BOOL)extendable survivalMode:(BOOL)survival additionalRedTurn:(BOOL)additionalTurn reuseOfLines:(BOOL)reuse
{
    self = [super init];
    _minFieldsForLine = minFields;
    _maxNumberOfTurns = numberOrNil;
    _extendableBoard = extendable;
    _survivalMode = survival;
    _allowAdditionalRedTurn = additionalTurn;
    _allowReuseOfLines = reuse;
    return self;
}

- (void)dealloc
{
    // currently, nothing is retained, so nothing needs to be released
    
    [super dealloc];   
}

#pragma mark - NSCoding protocol

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    _minFieldsForLine = [aDecoder decodeIntForKey:@"minimum fields for a line"];
    _maxNumberOfTurns = [aDecoder decodeIntForKey:@"maximum number of turns"];
    _extendableBoard = [aDecoder decodeBoolForKey:@"extendable board"];
    _survivalMode = [aDecoder decodeBoolForKey:@"survival mode"];
    _allowAdditionalRedTurn = [aDecoder decodeBoolForKey:@"allow additional red turn"];
    _allowReuseOfLines = [aDecoder decodeBoolForKey:@"allow reuse of lines"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:_minFieldsForLine forKey:@"minimum fields for a line"];
    [aCoder encodeInt:_maxNumberOfTurns forKey:@"maximum number of turns"];
    [aCoder encodeBool:_extendableBoard forKey:@"extendable board"];
    [aCoder encodeBool:_survivalMode forKey:@"survival mode"];
    [aCoder encodeBool:_allowAdditionalRedTurn forKey:@"allow additional red turn"];
    [aCoder encodeBool:_allowReuseOfLines forKey:@"allow reuse of lines"];
}

@end
