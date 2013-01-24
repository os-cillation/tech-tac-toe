/*-
 * Copyright 2012 os-cillation GmbH
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

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
