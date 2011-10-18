//
//  GameData.m
//  TechTacToe-ah
//
//  Created by andreas on 9/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameData.h"

@implementation GameData

@synthesize fields=_fields;
@synthesize bluePlayerTurn=_bluePlayerTurn;
@synthesize gameOver=_gameOver;
@synthesize blueDidLeadOnPreviousTurn=_blueDidLeadOnPreviousTurn;
@synthesize blueResigned=_blueResigned;
@synthesize redResigned=_redResigned;
@synthesize localPlayerBlue=_localPlayerBlue;
@synthesize positionOfLastMarkedFieldX=_positionOfLastMarkedFieldX;
@synthesize positionOfLastMarkedFieldY=_positionOfLastMarkedFieldY;
@synthesize selection=_selection;
@synthesize mode=_mode;
@synthesize numberOfTurn=_numberOfTurn;
@synthesize redPoints=_redPoints;
@synthesize bluePoints=_bluePoints;
@synthesize redPointsLastTurn=_redPointsLastTurn;
@synthesize bluePointsLastTurn=_bluePointsLastTurn;
@synthesize rules=_rules;
@synthesize boardWidth=_boardWidth;
@synthesize boardHeight=_boardHeight;
@synthesize hitBoardLimit=_hitBoardLimit;

#pragma mark - Initializer and memory management

-(GameData*)initEmptyInMode:(int)gameMode withBoardSize:(CGSize)sizeOrNil
{
    self = [super init];
    
    _mode = gameMode;
    _boardWidth = (int)sizeOrNil.width;
    _boardHeight = (int)sizeOrNil.height;
    
    // might be changed in bluetooth games, but for now set it to YES
    self.localPlayerBlue = YES;
    
    // new game: no points yet, nothing selected
    self.redPoints = 0;
    self.bluePoints = 0;
    self.redPointsLastTurn = 0;
    self.bluePointsLastTurn = 0;
    self.selection = NO;
    self.positionOfLastMarkedFieldX = -1;
    self.positionOfLastMarkedFieldY = -1;
    self.gameOver = NO;
    self.blueDidLeadOnPreviousTurn = NO;
    self.blueResigned = NO;
    self.redResigned = NO;
    self.hitBoardLimit = NO;
    
    // divide initializer for modes
    if (self.mode == TICTACTOE) {
        // on a new classic game no turn was made
        self.numberOfTurn = 1;
        
        // only ever need 25 fields of which 9 are free fields
        self.fields = [NSMutableDictionary dictionaryWithCapacity:25];
        
        // set up the complete board
        for (int i = 2; i <= 6; i++) {
            for (int j = 2; j <= 6; j++) {
                if (i == 2 || i == 6 || j == 2 || j == 6) {
                    // make a border of unavailable fields to limit board
                    Field *fieldToAdd = [[Field alloc] initWithStatus:UNAVAILABLE_FIELD atPositionX:i atPositionY:j];
                    NSString *key = [NSString stringWithFormat:@"%i, %i", i, j];
                    [self.fields setObject:fieldToAdd forKey:key];
                    // will be retained by the dictionary, should be save to release
                    [fieldToAdd release];
                } else {
                    Field *fieldToAdd = [[Field alloc] initWithStatus:FREE_FIELD atPositionX:i atPositionY:j];
                    NSString *key = [NSString stringWithFormat:@"%i, %i", i, j];
                    [self.fields setObject:fieldToAdd forKey:key];
                    // will be retained by the dictionary, should be save to release
                    [fieldToAdd release];
                }
            }
        }
        // blue has the first turn
        self.bluePlayerTurn = YES;
    } else if (self.mode == GOMOKU) {
        // on a new gomoku game no turn was made
        self.numberOfTurn = 1;
        
        // only ever need 441 fields of which 361 are free fields
        self.fields = [NSMutableDictionary dictionaryWithCapacity:441];
        
        // set up the complete board
        for (int i = 0; i <= 20; i++) {
            for (int j = 0; j <= 20; j++) {
                if (i == 0 || i == 20 || j == 0 || j == 20) {
                    // make a border of unavailable fields to limit board
                    Field *fieldToAdd = [[Field alloc] initWithStatus:UNAVAILABLE_FIELD atPositionX:i atPositionY:j];
                    NSString *key = [NSString stringWithFormat:@"%i, %i", i, j];
                    [self.fields setObject:fieldToAdd forKey:key];
                    // will be retained by the dictionary, should be save to release
                    [fieldToAdd release];
                } else {
                    // the reminder of the fields are available
                    Field *fieldToAdd = [[Field alloc] initWithStatus:FREE_FIELD atPositionX:i atPositionY:j];
                    NSString *key = [NSString stringWithFormat:@"%i, %i", i, j];
                    [self.fields setObject:fieldToAdd forKey:key];
                    // will be retained by the dictionary, should be save to release
                    [fieldToAdd release];
                }
            }
        }
        // blue has the first turn
        self.bluePlayerTurn = YES;
    } else {
        // have to check for width == 0 here since the game data will be created before extendable board is set in rules
        if (self.boardWidth == 0) {
            // on a new non-classic game without set board size, regardless of rules one turn was made (blue in the middle)
            self.numberOfTurn = 2;
            
            // start with capacity for a few fields
            self.fields = [NSMutableDictionary dictionaryWithCapacity:121];
            
            // old behaviour
//            // set up the initial board
//            for (int i = 2; i <= 8; i++) {
//                for (int j = 2; j <= 8; j++) {
//                    // declare it now, alloc and init it depending on position (if-else block will make sure that it will not be nil)
//                    Field *fieldToAdd;
//                    // everything 2 fields around the center is good to click
//                    if ((i >= 3 && i <= 7) && (j >= 3 && j <= 7)) {
//                        fieldToAdd = [[Field alloc] initWithStatus:FREE_FIELD atPositionX:i atPositionY:j];
//                    }
//                    else {
//                        // for everything further away than 2 fields, make it unavailable (= not clickable)
//                        fieldToAdd = [[Field alloc] initWithStatus:UNAVAILABLE_FIELD atPositionX:i atPositionY:j];
//                    }
//                    NSString *key = [NSString stringWithFormat:@"%i, %i", i, j];
//                    [self.fields setObject:fieldToAdd forKey:key];
//                    // will be retained by the dictionary, should be save to release
//                    [fieldToAdd release];
//                }
//            }
//            // make the middle a blue field
//            NSString *key = [NSString stringWithFormat:@"%i, %i", 5, 5];
            
            for (int i = 1; i <= 5; i++) {
                for (int j = 1; j <= 5; j++) {
                    // declare it now, alloc and init it depending on position (if-else block will make sure that it will not be nil)
                    Field *fieldToAdd;
                    fieldToAdd = [[Field alloc] initWithStatus:FREE_FIELD atPositionX:i atPositionY:j];
                    NSString *key = [NSString stringWithFormat:@"%i, %i", i, j];
                    [self.fields setObject:fieldToAdd forKey:key];
                    // will be retained by the dictionary, should be save to release
                    [fieldToAdd release];
                }
            }
            // make the middle a blue field            
            NSString *key = [NSString stringWithFormat:@"%i, %i", 3, 3];
            Field *middle = [self.fields objectForKey:key];
            middle.status = BLUE_FIELD;
            [self.fields setObject:middle forKey:key];
            
            // red has the first turn - blue already set in the middle
            self.bluePlayerTurn = NO; 
        }
        else {
            // we have a new custom game with a set board size (cannot be smaller than 3x3 and no dimension can be smaller than the minimum number of fields for a line)
            // blue begins
            self.numberOfTurn = 1;
            
            // start with full capacity
            self.fields = [NSMutableDictionary dictionaryWithCapacity:(self.boardWidth + 2) * (self.boardHeight + 2)];
            
            // if we have less than 9 fields in any dimension (that means less than 7 usable fields since we also draw a border) try to center the board on a 9x9 matrix, because we have a minimum drawing size of 9 fields in the controller - on even numbers smaller than 9 (7) there will be a black border: this is not a bug. however, if we want to get rid of that we need to rethink how boards are drawn
            int initialI = MAX(0, (7 - self.boardWidth + 1) / 2);
            int conditionI = MAX(0, (7 - self.boardWidth + 1) / 2) + self.boardWidth + 1;
            
            int initialJ = MAX(0, (7 - self.boardHeight + 1) / 2);
            int conditionJ = MAX(0, (7 - self.boardHeight + 1) / 2) + self.boardHeight + 1;
            
            // set up the complete board
            for (int i = initialI; i <= conditionI; i++) {
                for (int j = initialJ; j <= conditionJ; j++) {
                    if (i == initialI || i == conditionI || j == initialJ || j == conditionJ) {
                        // make a border of unavailable fields to limit board
                        Field *fieldToAdd = [[Field alloc] initWithStatus:UNAVAILABLE_FIELD atPositionX:i atPositionY:j];
                        NSString *key = [NSString stringWithFormat:@"%i, %i", i, j];
                        [self.fields setObject:fieldToAdd forKey:key];
                        // will be retained by the dictionary, should be save to release
                        [fieldToAdd release];
                    } else {
                        // the reminder of the fields are available
                        Field *fieldToAdd = [[Field alloc] initWithStatus:FREE_FIELD atPositionX:i atPositionY:j];
                        NSString *key = [NSString stringWithFormat:@"%i, %i", i, j];
                        [self.fields setObject:fieldToAdd forKey:key];
                        // will be retained by the dictionary, should be save to release
                        [fieldToAdd release];
                    }
                }
            }
            // red has the first turn
            self.bluePlayerTurn = YES;
        }
    }
    return self;
}

-(void)dealloc
{
    [_fields release];
    [_rules release];
    [super dealloc];
}

#pragma mark - NSCoding protocol

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    _bluePointsLastTurn = 0;
    _redPointsLastTurn = 0;
    
    self.fields = [NSMutableDictionary dictionaryWithDictionary:[aDecoder decodeObjectForKey:@"field data"]];
    _bluePlayerTurn = [aDecoder decodeBoolForKey:@"blue player turn"];
    _gameOver = [aDecoder decodeBoolForKey:@"game over"];
    _blueDidLeadOnPreviousTurn = [aDecoder decodeBoolForKey:@"blue did lead on previous turn"];
    _blueResigned = [aDecoder decodeBoolForKey:@"blue resigned"];
    _redResigned = [aDecoder decodeBoolForKey:@"red resigned"];
    _localPlayerBlue = [aDecoder decodeBoolForKey:@"local player blue"];
    _positionOfLastMarkedFieldX = [aDecoder decodeIntForKey:@"position of last marked field x"];
    _positionOfLastMarkedFieldY = [aDecoder decodeIntForKey:@"position of last marked field y"];
    _selection = [aDecoder decodeBoolForKey:@"selection"];
    _mode = [aDecoder decodeIntForKey:@"game mode"];
    _numberOfTurn = [aDecoder decodeIntForKey:@"turn number"];
    _redPoints = [aDecoder decodeIntForKey:@"red player score"];
    _bluePoints = [aDecoder decodeIntForKey:@"blue player score"];
    _boardWidth = [aDecoder decodeIntForKey:@"board width"];
    _boardHeight = [aDecoder decodeIntForKey:@"board height"];
    _hitBoardLimit = [aDecoder decodeBoolForKey:@"hit board limit"];
    self.rules = [aDecoder decodeObjectForKey:@"rules"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_fields forKey:@"field data"];
    [aCoder encodeBool:_bluePlayerTurn forKey:@"blue player turn"];
    [aCoder encodeBool:_gameOver forKey:@"game over"];
    [aCoder encodeBool:_blueDidLeadOnPreviousTurn forKey:@"blue did lead on previous turn"];
    [aCoder encodeBool:_blueResigned forKey:@"blue resigned"];
    [aCoder encodeBool:_redResigned forKey:@"red resigned"];
    [aCoder encodeBool:_localPlayerBlue forKey:@"local player blue"];
    [aCoder encodeInt:_positionOfLastMarkedFieldX forKey:@"position of last marked field x"];
    [aCoder encodeInt:_positionOfLastMarkedFieldY forKey:@"position of last marked field y"];
    [aCoder encodeBool:_selection forKey:@"selection"];
    [aCoder encodeInt:_mode forKey:@"game mode"];
    [aCoder encodeInt:_numberOfTurn forKey:@"turn number"];
    [aCoder encodeInt:_redPoints forKey:@"red player score"];
    [aCoder encodeInt:_bluePoints forKey:@"blue player score"];
    [aCoder encodeInt:_boardWidth forKey:@"board width"];
    [aCoder encodeInt:_boardHeight forKey:@"board height"];
    [aCoder encodeBool:_hitBoardLimit forKey:@"hit board limit"];
    [aCoder encodeObject:_rules forKey:@"rules"];

}

#pragma mark - Editing data

-(void)changeDataAtPoint:(CGPoint)point withStatus :(int)stat
{
    // don't do anything on game over anymore
    if (self.isGameOver)
        return;
    
    NSString* key = [NSString stringWithFormat:@"%i, %i", (int)point.x, (int)point.y];
    Field* searchedField = [self.fields objectForKey:key];
    // if entry wasn't in the dictionary, create it (but with the current version, this should not happen)
    if (!searchedField) {
        searchedField = [[Field alloc] initWithStatus:stat atPositionX:(int)point.x atPositionY:(int)point.y];
        [self.fields setObject:searchedField forKey:key];
        [searchedField release];
    } else {
        // if entry already existed, just change status and replace
        searchedField.status = stat;
        [self.fields setObject:searchedField forKey:key];
    }
    // if we did a field selection, save the position of it for later use and set a flag
    if (stat == RED_MARKED || stat == BLUE_MARKED) {
        self.positionOfLastMarkedFieldX = point.x;
        self.positionOfLastMarkedFieldY = point.y;
        self.selection = YES;
    }
}

-(NSMutableArray*)createMoreEmptyFieldsAroundPoint:(CGPoint)point
{
    // we put every field we need to redraw in this - at maximum, we need 31 entries
    NSMutableArray *needDrawing = [NSMutableArray arrayWithCapacity:31];
    
    // don't do anything on game over anymore
    if (self.isGameOver)
        return needDrawing;
    
    int x = (int) point.x;
    int y = (int) point.y;
    
    // old behaviour
//    // for all fields 3 or less fields away from point in any direction
//    for (int i = x - 3; i <= x + 3 ; i++) {
//        for (int j = y - 3; j <= y + 3; j++) {
//            // find entry, if possible
//            NSString* key = [NSString stringWithFormat:@"%i, %i", i, j];
//            Field* searchedField = [self.fields objectForKey:key];
//            // check for previously non-active fields 2 fields away from point and add new free field if or unavailable field it did not exist
//            if ((!searchedField || searchedField.status == UNAVAILABLE_FIELD) && ((i >= x - 2 && i <= x + 2) && (j >= y - 2 && j <= y + 2))) {
//                // since it is possible for a field to not exist, create it in all cases to be on the safe side
//                Field *newField = [[Field alloc]initWithStatus:FREE_FIELD atPositionX:i atPositionY:j];
//                [self.fields setObject:newField forKey:key];
//                // put it into the array for drawing
//                [needDrawing addObject:newField];
//                [newField release];
//            } else if (!searchedField) {
//                Field *newField = [[Field alloc]initWithStatus:UNAVAILABLE_FIELD atPositionX:i atPositionY:j];
//                [self.fields setObject:newField forKey:key];
//                // put it into the array for drawing
//                [needDrawing addObject:newField];
//                [newField release];
//            }
//        }
//    }
    
    // for all fields two or less positions away from the point provided
    for (int i = x - 2; i <= x + 2 ; i++) {
        for (int j = y - 2; j <= y + 2; j++) {
            // check for and add new free field if it did not exist
            NSString* key = [NSString stringWithFormat:@"%i, %i", i, j];
            Field* searchedField = [self.fields objectForKey:key];
            if (!searchedField) {
            Field *newField = [[Field alloc]initWithStatus:FREE_FIELD atPositionX:i atPositionY:j];
            [self.fields setObject:newField forKey:key];
            // put it into the array for drawing
            [needDrawing addObject:newField];
            [newField release];
            }
        }
    }    return needDrawing;
}

-(void)moveGameFieldsByHorizontal:(int)fieldsX byVertical:(int)fieldsY
{
    // don't do anything on game over anymore
    if (self.isGameOver)
        return;
    
    // create a new dictionary to put the changed values in
    NSMutableDictionary *newValues = [[NSMutableDictionary alloc] initWithCapacity:self.fields.count];
    // put the changed entries into the new dictionary
    NSArray *oldValues = [self.fields allValues];
    for (Field *currentValue in oldValues) {
        currentValue.positionX += fieldsX;
        currentValue.positionY += fieldsY;
        NSString* key = [NSString stringWithFormat:@"%i, %i", currentValue.positionX, currentValue.positionY];
        [newValues setObject:currentValue forKey:key];
    }
    self.fields = newValues;
    [newValues release];
}

-(void) createBorderTiles
{
    // overwrite unlimited turns if needed
    if (self.rules.maxNumberOfTurns == 0)
        self.rules.maxNumberOfTurns = self.boardWidth * self.boardHeight;
    
    for (int i = 0; i <= self.boardWidth + 1; i++) {
        for (int j = 0; j <= self.boardHeight + 1; j++) {
            if (i == 0 || j == 0 || i == self.boardWidth + 1 || j == self.boardHeight + 1) {
                NSString* key = [NSString stringWithFormat:@"%i, %i", i, j];
                Field *newField = [[Field alloc]initWithStatus:UNAVAILABLE_FIELD atPositionX:i atPositionY:j];
                [self.fields setObject:newField forKey:key];
                [newField release];
            }
        }
    }
}

#pragma mark Evaluating data

- (void)updateBoardSize
{
    // only update board size on a extendible board that is still small enough
    if (self.rules.isExtendableBoard && !self.didHitBoardLimit) {
        NSArray *toCheck = [self.fields allValues];
        for (Field *currentValue in toCheck) {
            if (currentValue.positionX > self.boardWidth) {
                self.boardWidth = currentValue.positionX;
            }
            if (currentValue.positionY > self.boardHeight) {
                self.boardHeight = currentValue.positionY;
            }
        }
    }
}

-(NSMutableArray *)consultRulesForFieldAtPoint:(CGPoint)point
{
    // result-array: in most cases, count for array won't be more than the minimum
    NSMutableArray *resultsOrEmpty = [NSMutableArray arrayWithCapacity:self.rules.minFieldsForLine];
    
    // don't do anything on game over anymore
    if (self.isGameOver)
        return resultsOrEmpty;
    
    int px = (int) point.x;
    int py = (int) point.y;
    
    // if someone scored, we need to increase score by this amount
    int pointsToAdd = 0;
    
    // init vars for testing: we already have a find (the field we have set prior to calling this)
    int i = 1;
    int finds = 1;
    int potentialFinds = 0;
    NSMutableArray *fieldsToChangeIfNewLine = [NSMutableArray arrayWithCapacity:self.rules.minFieldsForLine];
    
    // multiple loops: check in all directions for potential lines
    // need 4 directions and their opposite to completely check all fields for a new line
    NSString *key;
    for (int direction = 0; direction <=3; direction++) {
        // loop will exit when we cannot find another field we might use for a line
        while (YES) {
            switch (direction) {
                case 0:
                    key = [NSString stringWithFormat:@"%i, %i", px + i, py];
                    break;
                case 1:
                    key = [NSString stringWithFormat:@"%i, %i", px, py + i];
                    break;
                case 2:
                    key = [NSString stringWithFormat:@"%i, %i", px - i, py - i];
                    break;
                case 3:
                    key = [NSString stringWithFormat:@"%i, %i", px + i, py - i];
                default:
                    break;
            }
            Field* searchedField = [self.fields objectForKey:key];
            // if we reached the end of the fields break the loop
            if (!searchedField)
                break;
            if (self.isBluePlayerTurn) {
                if (searchedField.status == BLUE_FIELD) {
                    // we found a field we can use for making a line
                    finds++;
                    // if we already have fields as potential finds: mark them as actual finds, since we can use them now and reset the counter for potential finds
                    finds += potentialFinds;
                    potentialFinds = 0;
                    // we might need to change and redraw this field if we actually make a line, so save it
                    [fieldsToChangeIfNewLine addObject:searchedField];
                    // if we found enough to make a line: break the loop (still need to test the other direction for the possibility of a bigger line)
                    if (finds >= self.rules.minFieldsForLine)
                        break;
                } else if (searchedField.status == BLUE_LINE && self.rules.doesAllowReuseOfLines) {
                    // won't reach this code unless we allow to reuse fields already belonging to a line (that is not in the same orientation of our new potential line, of course)
                    
                    // if we reach the minimum number of fields for a line with potentials, we found an existing line, so we can't use them and have to stop testing.
                    potentialFinds++;
                    if (potentialFinds >= self.rules.minFieldsForLine)
                        break;
                } else {
                    // this field is neither a find nor a potential find and would break our line, so stop testing any more - but all fields still marked as potential are now actual finds, since if they were part of a line in the same orientation, code that fired earlier would already have taken care of that
                    finds += potentialFinds;
                    break;
                }
            } else {
                // same for red player turn
                if (searchedField.status == RED_FIELD) {
                    finds++;
                    finds += potentialFinds;
                    potentialFinds = 0;
                    [fieldsToChangeIfNewLine addObject:searchedField];
                    if (finds >= self.rules.minFieldsForLine) {
                        break;
                    }
                } else if (searchedField.status == RED_LINE && self.rules.doesAllowReuseOfLines) {
                    potentialFinds++;
                    if (potentialFinds >= self.rules.minFieldsForLine)
                        break;
                } else {
                    finds += potentialFinds;
                    break;
                }
            }
            // we need to continue testing: next field
            i++;
        }
        // reset counter and potential finds between direction change
        i = 1;
        potentialFinds = 0;
        
        // checking the opposite direction in the same orientation
        while (YES) {
            switch (direction) {
                case 0:
                    key = [NSString stringWithFormat:@"%i, %i", px - i, py];
                    break;
                case 1:
                    key = [NSString stringWithFormat:@"%i, %i", px, py - i];
                    break;
                case 2:
                    key = [NSString stringWithFormat:@"%i, %i", px + i, py + i];
                    break;
                case 3:
                    key = [NSString stringWithFormat:@"%i, %i", px - i, py + i];
                default:
                    break;
            }
            Field* searchedField = [self.fields objectForKey:key];
            if (!searchedField)
                break;
            if (self.isBluePlayerTurn) {
                if (searchedField.status == BLUE_FIELD) {
                    finds++;
                    finds += potentialFinds;
                    potentialFinds = 0;
                    [fieldsToChangeIfNewLine addObject:searchedField];
                    // don't break the loop if we reached the minimum number for a line like we did in the opposite direction so we can do bigger lines
                } else if (searchedField.status == BLUE_LINE && self.rules.doesAllowReuseOfLines) {
                    potentialFinds++;
                    if (potentialFinds >= self.rules.minFieldsForLine)
                        break;
                } else {
                    finds += potentialFinds;
                    break;
                }
            } else {
                if (searchedField.status == RED_FIELD) {
                    finds++;
                    finds += potentialFinds;
                    potentialFinds = 0;
                    [fieldsToChangeIfNewLine addObject:searchedField];
                } else if (searchedField.status == RED_LINE && self.rules.doesAllowReuseOfLines) {
                    potentialFinds++;
                    if (potentialFinds >= self.rules.minFieldsForLine)
                        break;
                } else {
                    finds += potentialFinds;
                    break;
                }
            }
            i++;
        }
        
        // add points, if any: 1 for a normal line, 2 for a bigger one, 3 for a huge one and so on... and put our fields that do not already belong to a line to the result array for drawing/changing
        if (finds >= self.rules.minFieldsForLine) {
            pointsToAdd += finds - (self.rules.minFieldsForLine - 1);
            [resultsOrEmpty addObjectsFromArray:fieldsToChangeIfNewLine];
        }
        // reset vars
        i = 1;
        finds = 1;
        potentialFinds = 0;
        [fieldsToChangeIfNewLine removeAllObjects];
    }
    
    // change the status of the fields now belonging to a line
    for (Field* fieldToChange in resultsOrEmpty) {
        if (self.isBluePlayerTurn)
            [self changeDataAtPoint:CGPointMake(fieldToChange.positionX, fieldToChange.positionY) withStatus:BLUE_LINE];
        else
            [self changeDataAtPoint:CGPointMake(fieldToChange.positionX, fieldToChange.positionY) withStatus:RED_LINE];
    }
    
    // add the score (if any) to the player, switch turns
    if (self.isBluePlayerTurn) {
        // if we had ANY new lines (i.e. one or more points), we also need to set the field we are testing for to a new status and eventually draw it
        if (pointsToAdd > 0 ) {
            [self changeDataAtPoint:point withStatus:BLUE_LINE];
            // just create a new field with the data here - doesn't matter if it is not from the data since it is identical to it
            Field *drawMe = [[Field alloc] initWithStatus:BLUE_LINE atPositionX:px atPositionY:py];
            [resultsOrEmpty addObject:drawMe];
            [drawMe release];
        }
        self.bluePoints += pointsToAdd;
        self.bluePlayerTurn = NO;
    } else {
        if (pointsToAdd > 0 ) {
            [self changeDataAtPoint:point withStatus:RED_LINE];
            // just create a new field with the data here - doesn't matter if it is not from the data since it is identical to it
            Field *drawMe = [[Field alloc] initWithStatus:RED_LINE atPositionX:px atPositionY:py];
            [resultsOrEmpty addObject:drawMe];
            [drawMe release];
        }
        self.redPoints += pointsToAdd;
        self.bluePlayerTurn = YES;
    }
    
    // trigger game over if conditions are met:
    // in survival mode: blue scored last turn and red did not score (enough) to counter, red did score and it was no counter, blue did score and rules.doesAllowAdditionalRedTurn is NO, # of maximum turns is met and no one has won
    // in classic mode: see survival mode w/o additional red turn and a maximum of 9 turns
    // in non-survival mode: # of maximum turns is met - determine winner by points
    
    BOOL redLeads = self.redPoints > self.bluePoints;
    BOOL blueLeads = self.bluePoints > self.redPoints;
    // only check if not zero so it works when game was loaded from archive
    if (self.bluePointsLastTurn)
        self.blueDidLeadOnPreviousTurn = self.bluePointsLastTurn > self.redPointsLastTurn;
    BOOL lastTurn = self.numberOfTurn == self.rules.maxNumberOfTurns;
    
    if (!self.rules.inScoreMode) {
        if ((redLeads && !self.blueDidLeadOnPreviousTurn) || (blueLeads && (!self.rules.doesAllowAdditionalRedTurn || self.blueDidLeadOnPreviousTurn)) || lastTurn)
            self.gameOver = YES;
    } else if (lastTurn)
        self.gameOver = YES;
    
    // set last turn's points as this turn' points
    self.redPointsLastTurn = self.redPoints;
    self.bluePointsLastTurn = self.bluePoints;
    
    // return the fields belonging to a line for the drawing code
    return resultsOrEmpty;
}

- (void) resignGame
{
    // don't resign if game already over
    if (self.isGameOver)
        return;
    
    // depending on active player, resign and set game over
    if (self.isBluePlayerTurn) {
        self.blueResigned = YES;
    } else {
        self.redResigned = YES;
    }
    self.gameOver = YES;
}

#pragma mark - Saving data

- (BOOL) saveGameToFile:(NSString *)filenameOrNil
{
    // archiving data, assigning filename if none provided, getting save path (the apps document folder) and writing to file
    // returns NO on unsuccessful writing attempt
    BOOL success = NO;
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	
    // prepare object for saving
    [archiver encodeObject:self forKey:@"game data"];
    [archiver finishEncoding];
    
    // build save path
    if (!filenameOrNil) {
        filenameOrNil = @"autosave";
    }
    NSString *savePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDirectory, YES) objectAtIndex:0] stringByAppendingPathComponent:filenameOrNil];
    
    // write and set bool
    success = [data writeToFile:savePath atomically:YES];
    
    // clean up
    [archiver release];
    [data release];
    
    return success;
}

@end
