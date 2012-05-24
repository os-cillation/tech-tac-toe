//
//  Field.h
//  TechTacToe-ah
//
//  Created by andreas on 9/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// field status
typedef enum {
    UNAVAILABLE_FIELD,
    FREE_FIELD,
    RED_FIELD,
    RED_MARKED,
    RED_LINE,
    BLUE_FIELD,
    BLUE_MARKED,
    BLUE_LINE
} fieldStatus;

@interface Field : NSObject <NSCoding> {
    int positionX, positionY; // the position of the field on the board
    int status; // the status of the field
}

// initialize a new field with all data (don't use the standard init)
-(Field*)initWithStatus:(int)stat atPositionX:(int)x atPositionY:(int)y;

@property int positionX;
@property int positionY;
@property int status;
//used by AI to determine which field to choose
@property int priority;

@end
