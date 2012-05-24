//
//  Field.m
//  TechTacToe-ah
//
//  Created by andreas on 9/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Field.h"

@implementation Field

@synthesize positionX, positionY, status, priority;

#pragma mark - Initializer and memory management

-(Field*)initWithStatus:(int)stat atPositionX:(int)x atPositionY:(int)y {
    self = [super init];
    positionX = x;
    positionY = y;
    status = stat;
    //priority should be 0 unless changed by AI
    priority = 0;
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
    
    positionX = [aDecoder decodeIntForKey:@"position X"];
    positionY = [aDecoder decodeIntForKey:@"position Y"];
    status = [aDecoder decodeIntForKey:@"status"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:positionX forKey:@"position X"];
    [aCoder encodeInt:positionY forKey:@"position Y"];
    [aCoder encodeInt:status forKey:@"status"];
}

@end
