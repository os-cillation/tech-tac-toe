//
//  Field.h
//  TechTacToe-ah
//
//  Created by andreas on 9/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// field status
#define UNAVAILABLE_FIELD 0
#define FREE_FIELD 1
#define RED_FIELD 2
#define RED_MARKED 3
#define RED_LINE 4
#define BLUE_FIELD 5
#define BLUE_MARKED 6
#define BLUE_LINE 7

@interface Field : NSObject <NSCoding> {
    int positionX, positionY; // the position of the field on the board
    int status; // the status of the field
}

// initialize a new field with all data (don't use the standard init)
-(Field*)initWithStatus:(int)stat atPositionX:(int)x atPositionY:(int)y;

@property int positionX;
@property int positionY;
@property int status;

@end
