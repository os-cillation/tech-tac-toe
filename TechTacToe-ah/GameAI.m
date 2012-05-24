//
//  GameAI.m
//  TechTacToe
//
//  Created by Christian Zöller on 18.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameAI.h"
#import "GameData.h"

@implementation GameAI

@synthesize gameData;
@synthesize isRedPlayer;
@synthesize isActivated;
@synthesize lastAIPosition;
@synthesize strength;

-(CGPoint)callAI:(CGPoint *)playerPosition
{
    CGPoint newPosition;
       
    if (playerPosition == nil)
    {
        if (self.gameData.rules.isExtendableBoard)
        {
            //AI has first commit if red
            if (self.isRedPlayer && !self.gameData.isBluePlayerTurn)
            {
                //determine middle point
                if(self.gameData.boardHeight<7 || self.gameData.boardWidth < 7)
                {
                    newPosition = CGPointMake(4.0, 4.0);
                }
                else
                {
                    newPosition = CGPointMake(self.gameData.boardWidth/2+1, self.gameData.boardHeight/2+1);
                }
                newPosition.y = newPosition.y - 1;
                [self.gameData changeDataAtPoint:newPosition withStatus:RED_MARKED];
                self.lastAIPosition = newPosition;
            }
        }
        else
        {
            //AI has first commit if blue
            if (!self.isRedPlayer && self.gameData.isBluePlayerTurn)
            {
                //determine middle point
                if(self.gameData.boardHeight<7 || self.gameData.boardWidth < 7)
                {
                    newPosition = CGPointMake(4.0, 4.0);
                }
                else
                {
                    newPosition = CGPointMake(self.gameData.boardWidth/2+1, self.gameData.boardHeight/2+1);
                }
                [self.gameData changeDataAtPoint:newPosition withStatus:BLUE_MARKED];
                self.lastAIPosition = newPosition;
            }
        }
    }
    else
    {
        //AI was called after player turn
        if(self.isRedPlayer && !self.gameData.isBluePlayerTurn)
        {
            newPosition = [self searchPosition:playerPosition];
            [self.gameData changeDataAtPoint:newPosition withStatus:RED_MARKED];
        }
        else if(!self.isRedPlayer && self.gameData.isBluePlayerTurn)
        {
            newPosition = [self searchPosition:playerPosition];
            [self.gameData changeDataAtPoint:newPosition withStatus:BLUE_MARKED];
        }
    }
    
    return newPosition;
}

-(CGPoint)searchPosition:(CGPoint *)playerPosition
{
    CGPoint computerPosition = CGPointMake((int)playerPosition->x+1, (int)playerPosition->y);
    CGPoint oldPosition = CGPointMake(self.lastAIPosition.x, self.lastAIPosition.y);
    [self updatePrioritiesAroundPosition:&oldPosition];
    [self updatePrioritiesAroundPosition:playerPosition];
    
    //get array with highest priorities
    int highestPriority = 0;
    NSMutableArray *candidates = [[NSMutableArray alloc]init];
    NSArray *allFields = self.gameData.fields.allValues;
    for (Field *currentField in allFields)
    {
        if (!(currentField.priority < highestPriority))
        {
            if (currentField.priority > highestPriority)
            {
                NSMutableArray *fieldsToKeep = [[NSMutableArray alloc]init];
                highestPriority = currentField.priority;
                for (Field *tempField in candidates)
                {
                    if (tempField.priority >= highestPriority)
                    {
                        [fieldsToKeep addObject:tempField];
                    }
                }
                [candidates removeAllObjects];
                for (Field *tempField in fieldsToKeep)
                {
                    [candidates addObject:tempField];
                }
                [fieldsToKeep release];
            }
            [candidates addObject:currentField];
        }
    }
    
     //debugging purposes
    bool debug = NO;
    if (debug)
    {
        for (Field *tempField in candidates)
        {
            NSLog(@"%i, %i, %i",tempField.positionX,tempField.positionY, tempField.priority);
        }
        NSLog(@"----------"); 
    }
    //choose one of the fields
    if (candidates.count > 0 && highestPriority > 0)
    {
        int resultIndex = arc4random() % candidates.count;
        Field *resultField = (Field *)[candidates objectAtIndex:resultIndex];    
        computerPosition = CGPointMake(resultField.positionX, resultField.positionY);
        if (debug)
        {
            NSLog(@"%i, %i, %i",resultField.positionX,resultField.positionY, resultField.priority);
            NSLog(@"++++++++++");
        }
    }
    else
    {
        //no field was selectable
        [self.gameData resignGame];
    }
    [candidates removeAllObjects];
    [candidates release];

    self.lastAIPosition = computerPosition;
    return computerPosition;
}

-(void)updatePrioritiesAroundPosition:(CGPoint *)position
{
    NSMutableArray *positionArray = [[NSMutableArray alloc]init];
       
    //left to right
    [self createArray:positionArray:1:0:position];
    [self updatePrioritiesForArray:positionArray];
    //upleft to downright
    [self createArray:positionArray:1:1:position];
    [self updatePrioritiesForArray:positionArray];
    //up to down
    [self createArray:positionArray:0:1:position];
    [self updatePrioritiesForArray:positionArray];
    //upright to downleft
    [self createArray:positionArray:-1:1:position];
    [self updatePrioritiesForArray:positionArray];

    [positionArray release];
}

-(void)updatePrioritiesForArray:(NSMutableArray *)array
{
    for (Field *tempField in array)
    {
        if (tempField.status == 1)
        {
            tempField.priority = [self analyzeField:tempField];
        }
        else
        {
            tempField.priority = -1;
        }
        NSString *key = [NSString stringWithFormat:@"%i, %i", tempField.positionX, tempField.positionY];
        [self.gameData.fields setObject:tempField forKey:key];
    }
}

-(void)createArray:(NSMutableArray *)resultArray:(int)xModifier:(int)yModifier:(CGPoint *)position
{
    NSMutableArray *partA = [[NSMutableArray alloc]init];
    NSMutableArray *partB = [[NSMutableArray alloc]init];
    
    Field *searchedField;
    
    for (int w = 0; w <= gameData.rules.minFieldsForLine;w++)
    {
        NSString *key = [NSString stringWithFormat:@"%i, %i", (int)position->x-(w * xModifier), (int)position->y-(w * yModifier)];
        searchedField = [self.gameData.fields objectForKey:key];
        if(searchedField)
        {
            [partA insertObject:searchedField atIndex:0];
        }
    }
    for (int w = 1; w <= gameData.rules.minFieldsForLine;w++)
    {
        NSString *key = [NSString stringWithFormat:@"%i, %i", (int)position->x+(w * xModifier), (int)position->y+(w * yModifier)];
        searchedField = [self.gameData.fields objectForKey:key];
        if(searchedField)
        {
            [partB addObject:searchedField];
        }
    }
    //combine those created 2 array into 1 array for a direction
    
    [resultArray removeAllObjects];
    
    for (int i = 0; i < partA.count; i++)
    {
        [resultArray addObject:[partA objectAtIndex:i]];
    }
    for (int i = 0; i < partB.count; i++)
    {
        [resultArray addObject:[partB objectAtIndex:i]];
    }
    
    [partA removeAllObjects];
    [partB removeAllObjects];
    
    [partA release];
    [partB release];
}

-(void)dealloc
{
    //[self.gameData release];
    [super dealloc];
}

-(GameAI *)init
{
    return [super init];
}

-(int)analyzeField:(Field *)field
{
    int result = 1;
    
    int left2Right = [self analyzeFieldsInDirection:field :1 :0];
    int upLeft2DownRight = [self analyzeFieldsInDirection:field :1 :1];
    int up2Down = [self analyzeFieldsInDirection:field :0 :1];
    int upRight2DownLeft = [self analyzeFieldsInDirection:field :-1 :1];
    
    //combine priorities
    
    if (self.strength > 2)
    {
        //add priorities
        if (left2Right == 501 || upLeft2DownRight == 501 || up2Down == 501 || upRight2DownLeft == 501)
        {
            return 9001;
        }
        if (left2Right == 500 || upLeft2DownRight == 500 || up2Down == 500 || upRight2DownLeft == 500)
        {
            return 9000;
        }
        if (left2Right > 300 || upLeft2DownRight > 300 || up2Down > 300 || upRight2DownLeft > 300)
        {
            bool ownScore = NO;
            int pointsToAdd = 0;
            if (left2Right > 300)
            {
                if (left2Right % 2 == 1)
                {
                    left2Right = left2Right - 301;
                    ownScore = YES;
                }
                else
                {
                    left2Right = left2Right - 300;
                }
                pointsToAdd = left2Right / 2;
            }
            if (upLeft2DownRight > 300)
            {
                if (upLeft2DownRight % 2 == 1)
                {
                    upLeft2DownRight = upLeft2DownRight - 301;
                    ownScore = YES;
                }
                else
                {
                    upLeft2DownRight = upLeft2DownRight - 300;
                }
                pointsToAdd += upLeft2DownRight / 2;
            }
            if (up2Down > 300)
            {
                if (up2Down % 2 == 1)
                {
                    up2Down = up2Down - 301;
                    ownScore = YES;
                }
                else
                {
                    up2Down = up2Down - 300;
                }
                pointsToAdd += up2Down / 2;
            }
            if (upRight2DownLeft > 300)
            {
                if (upRight2DownLeft % 2 == 1)
                {
                    upRight2DownLeft = upRight2DownLeft - 301;
                    ownScore = YES;
                }
                else
                {
                    upRight2DownLeft = upRight2DownLeft - 300;
                }
                pointsToAdd += upRight2DownLeft / 2;
            }
            if (ownScore)
            {
                pointsToAdd++;
            }
            return 1000 + pointsToAdd;
        }
        if (left2Right > 99 || upLeft2DownRight > 99 || up2Down > 99 || upRight2DownLeft > 99)
        {
            int result = 500;
            if (left2Right > 99)
            {
                result = result + left2Right;
            }
            if (upLeft2DownRight > 99)
            {
                result = result + upLeft2DownRight;
            }
            if (up2Down > 99)
            {
                result = result + up2Down;
            }
            if (upRight2DownLeft > 99)
            {
                result = result + upRight2DownLeft;
            }
            return result;
        }
        if (left2Right > 10 || upLeft2DownRight > 10 || up2Down > 10 || upRight2DownLeft > 10)
        {
            bool ownCheck = NO;
            int pointsToAdd = 0;
            if (left2Right > 10)
            {
                if (left2Right % 2 == 1)
                {
                    left2Right = left2Right - 11;
                    ownCheck = YES;
                }
                else
                {
                    left2Right = left2Right - 10;
                }
                pointsToAdd = left2Right / 2;
            }
            if (upLeft2DownRight > 10)
            {
                if (upLeft2DownRight % 2 == 1)
                {
                    upLeft2DownRight = upLeft2DownRight - 11;
                    ownCheck = YES;
                }
                else
                {
                    upLeft2DownRight = upLeft2DownRight - 10;
                }
                pointsToAdd += upLeft2DownRight / 2;
            }
            if (up2Down > 10)
            {
                if (up2Down % 2 == 1)
                {
                    up2Down = up2Down - 11;
                    ownCheck = YES;
                }
                else
                {
                    up2Down = up2Down - 10;
                }
                pointsToAdd += up2Down / 2;
            }
            if (upRight2DownLeft > 10)
            {
                if (upRight2DownLeft % 2 == 1)
                {
                    upRight2DownLeft = upRight2DownLeft - 11;
                    ownCheck = YES;
                }
                else
                {
                    upRight2DownLeft = upRight2DownLeft - 10;
                }
                pointsToAdd += upRight2DownLeft / 2;
            }
            if (ownCheck)
            {
                pointsToAdd++;
            }
            return 10 + pointsToAdd;
        }
        return left2Right + upLeft2DownRight + up2Down + upRight2DownLeft;
    }
    else
    {
        //get Max
        if (upLeft2DownRight > left2Right)
        {
            result = upLeft2DownRight;
        }
        else
        {
            result = left2Right;
        }
        if (up2Down > result)
        {
            result = up2Down;
        }
        if (upRight2DownLeft > result)
        {
            result = upRight2DownLeft;
        }
        if (self.strength < 2)
        {
            //weak AI
            if (result > 300)
            {
                result = 5;
            }
            else if (result > 10)
            {
                result = 3;
            }
        }
        return result;
    }
}    

-(int)analyzeFieldsInDirection:(Field *)startField :(int)xModifier :(int)yModifier
{
    int result = 1;
    
    int rowOfOwnFields = 0;
    int rowOfOpponentFields = 0;
    int rowOfFreeFields = 1;
    
    bool freeAfterLeft = NO;
    
    //field status
    //UNAVAILABLE_FIELD,
    //FREE_FIELD,
    //RED_FIELD,
    //RED_MARKED,
    //RED_LINE,
    //BLUE_FIELD,
    //BLUE_MARKED,
    //BLUE_LINE
    
    //first go to left
    int i = 0;
    //Field *currentField = [[Field alloc] init ];
    Field *currentField;
    int lastStatus = 1;
    
    NSString *key = [NSString stringWithFormat:@"%i, %i", startField.positionX, startField.positionY];
    currentField = (Field *)[self.gameData.fields objectForKey:key];
    
    //currentField.positionX = startField.positionX;
    //currentField.positionY = startField.positionY;
    //currentField.status = startField.status;
    
    while (i < self.gameData.rules.minFieldsForLine)
    {
        i++;
        //update current field
        //currentField = [self getNextField:currentField :-(i * xModifier) :-(i * yModifier)];
        
        NSString *key = [NSString stringWithFormat:@"%i, %i", currentField.positionX-xModifier, currentField.positionY-yModifier];
        currentField = (Field *)[self.gameData.fields objectForKey:key];
        
        //check current fields status
        if (currentField.status == 1)
        {
            //free field
            if (lastStatus == 1)
            {
                //free fields before hitting something else
                rowOfFreeFields++;
            }
            else
            {
                //free field after something else
                
                //continue with going to right
                freeAfterLeft = YES;
                break;
            }
            lastStatus = currentField.status;
        }
        else if (currentField.status == 2 || (currentField.status == 4 && [self checkForLine:currentField :YES :-xModifier :-yModifier]))
        {
            //red field
            if (lastStatus == 2 || lastStatus == 1 || lastStatus == 4)
            {
                //row of red fields
                if (self.isRedPlayer)
                {
                    rowOfOwnFields++;
                }
                else
                {
                    rowOfOpponentFields++;
                }
            }
            else
            {
                break;
            }
            lastStatus = currentField.status;
        }
        else if (currentField.status == 5 || (currentField.status == 7 && [self checkForLine:currentField :NO :-xModifier :-yModifier]))
        {
            //blue field
            if (lastStatus == 5 || lastStatus == 1 || lastStatus == 7)
            {
                //row of blue fields
                if (self.isRedPlayer)
                {
                    rowOfOpponentFields++;
                }
                else
                {
                    rowOfOwnFields++;
                }
            }
            else
            {
                break;
            }
            lastStatus = currentField.status;
        }
        else
        {
            //border
            break;
        }
    }
    i = 0;
    lastStatus = 1;
    
    currentField = (Field *)[self.gameData.fields objectForKey:key];
    
    int ownFieldsLeft = rowOfOwnFields;
    int opponentFieldsLeft = rowOfOpponentFields;
    int freeFieldsLeft = rowOfFreeFields;
    
    rowOfOwnFields = 0;
    rowOfOpponentFields = 0;
    rowOfFreeFields = 1;
    
    bool freeAfterRight = NO;
    
    //second to right
    while (i < self.gameData.rules.minFieldsForLine)
    {
        i++;
        //update current field
        //currentField = [self getNextField:currentField :(i * xModifier) :(i * yModifier)];
        
        NSString *key = [NSString stringWithFormat:@"%i, %i", currentField.positionX+xModifier, currentField.positionY+yModifier];
        currentField = (Field *)[self.gameData.fields objectForKey:key];
        
        //check current fields status
        if (currentField.status == 1)
        {
            //free field
            if (lastStatus == 1)
            {
                //free fields before hitting something else
                rowOfFreeFields++;
            }
            else
            {
                freeAfterRight = YES;
                //calculate priority
                break;
            }
            lastStatus = currentField.status;
        }
        else if (currentField.status == 2 || (currentField.status == 4 && [self checkForLine:currentField :YES :-xModifier :-yModifier]))
        {
            //red field
            if (lastStatus == 2 || lastStatus == 1 || lastStatus == 4)
            {
                //row of red fields
                if (self.isRedPlayer)
                {
                    rowOfOwnFields++;
                }
                else
                {
                    rowOfOpponentFields++;
                }
            }
            else
            {
                //calculate priority
                break;
            }
            lastStatus = currentField.status;
        }
        else if (currentField.status == 5 || (currentField.status == 7 && [self checkForLine:currentField :NO :-xModifier :-yModifier]))
        {
            //blue field
            if (lastStatus == 5 || lastStatus == 1 || lastStatus == 7)
            {
                //row of blue fields
                if (self.isRedPlayer)
                {
                    rowOfOpponentFields++;
                }
                else
                {
                    rowOfOwnFields++;
                }
            }
            else
            {
                //calculate priority
                break;
            }
            lastStatus = currentField.status;
        }
        else
        {
            //border
            //calculate priority
            break;
        }
    }
    //[currentField release];
    result = [self calculatePriority:ownFieldsLeft :opponentFieldsLeft :freeFieldsLeft :rowOfOwnFields :rowOfOpponentFields :rowOfFreeFields :freeAfterLeft :freeAfterRight];
    
    return result;
}

-(int)calculatePriority:(int)ownFieldsLeft :(int)opponentFieldsLeft :(int)freeFieldsLeft :(int)rowOfOwnFields :(int)rowOfOpponentFields :(int)rowOfFreeFields :(bool)freeAfterLeft :(bool)freeAfterRight
{
    //NSLog(@"%i, %i, %i, %i, | %i, %i, %i, %i",ownFieldsLeft,opponentFieldsLeft,freeFieldsLeft,freeAfterLeft,rowOfOwnFields,rowOfOpponentFields,rowOfFreeFields,freeAfterRight);
    int freeFieldsInMiddle = freeFieldsLeft + rowOfFreeFields -1; //start field is counted twice    
    int numberOfOwnFields = ownFieldsLeft + rowOfOwnFields;
    int numberOfOpponentFields = opponentFieldsLeft + rowOfOpponentFields;

    if (freeFieldsInMiddle == 1)
    {
        //start field between set fields
        if (ownFieldsLeft > 0 && rowOfOwnFields > 0)
        {
            //own fields on both sides
            if ((self.gameData.rules.minFieldsForLine - numberOfOwnFields) == 1)
            {
                //AI could score here
                if (self.gameData.rules.inScoreMode)
                {
                    int possiblePoints = numberOfOwnFields - self.gameData.rules.minFieldsForLine +1;
                    return 301 + (2 * possiblePoints);
                }
                else
                {
                    return 501;
                }
            }
            else if ((self.gameData.rules.minFieldsForLine - numberOfOwnFields) == 2)
            {
                if (freeAfterLeft || freeAfterRight)
                {
                    //enough room
                    return 101;
                }
                else
                {
                    //not enough room here
                    return 1;
                }
            }
            else if (freeAfterLeft && freeAfterRight)
            {
                return 11 + (2 * numberOfOwnFields);
            }
            else
            {
                //AI not interested
                return 1;
            }
        }
        else if (opponentFieldsLeft > 0 && rowOfOpponentFields > 0)
        {
            //opponent fields on both sides
            if ((self.gameData.rules.minFieldsForLine - numberOfOpponentFields) == 1)
            {
                //Player could score here
                if (self.gameData.rules.inScoreMode)
                {
                    int possiblePoints = numberOfOpponentFields - self.gameData.rules.minFieldsForLine +1;
                    return 300 + (2 * possiblePoints);
                }
                else
                {
                    return 500;
                }
            }
            else if ((self.gameData.rules.minFieldsForLine - numberOfOpponentFields) == 2)
            {
                if (freeAfterLeft || freeAfterRight)
                {
                    //enough room
                    return 100;
                }
                else
                {
                    //not enough room here
                    return 1;
                }
            }
            else if (freeAfterLeft && freeAfterRight)
            {
                return 10 + (2 * numberOfOpponentFields);
            }
            else
            {
                //AI not interested
                return 1;
            }
        }
        else
        {
            //mixed fields
            //multiple cases possible here
            int result = 1;
            bool ownCheck = NO;
            bool opponentCheck = NO;
            if (self.gameData.rules.minFieldsForLine - numberOfOwnFields == 1)
            {
                //AI could score here
                ownCheck = YES;
                if (self.gameData.rules.inScoreMode)
                {
                    int possiblePoints = numberOfOwnFields - self.gameData.rules.minFieldsForLine +1;
                    result = 301 + (2 * possiblePoints);
                }
                else
                {
                    return 501;
                }
            }
            if (self.gameData.rules.minFieldsForLine - numberOfOpponentFields == 1)
            {
                //Player could score here
                opponentCheck = YES;
                if (ownCheck)
                {
                    //AI could also get points here
                    int possiblePoints = numberOfOpponentFields + numberOfOwnFields - 2 * (self.gameData.rules.minFieldsForLine +1);
                    result = 301 + (2 * possiblePoints);
                }
                else
                {
                    if (self.gameData.rules.inScoreMode)
                    {
                        int possiblePoints = numberOfOwnFields - self.gameData.rules.minFieldsForLine +1;
                        result = 300 + (2 * possiblePoints);
                    }
                    else
                    {
                        return 500;
                    }
                }
            }
            if (!ownCheck && ( (self.gameData.rules.minFieldsForLine - ownFieldsLeft == 2 && freeAfterLeft) || (self.gameData.rules.minFieldsForLine - rowOfOwnFields == 2 && freeAfterRight)))
            {
                //AI could score here in 2 turns
                if (opponentCheck)
                {
                    //player could score points here - so result is already high
                    result++;
                }
                else
                {
                    result = 101;
                }
            }
            if (!opponentCheck && ((self.gameData.rules.minFieldsForLine - opponentFieldsLeft == 2 && freeAfterLeft) || (self.gameData.rules.minFieldsForLine - rowOfOpponentFields == 2 && freeAfterRight)))
            {
                //Player could score here in 2 turns
                if (ownCheck)
                {
                    //AI could score here, so result is already high
                    result++;
                }
                else
                {
                    result = 100;
                }
            }
            return result;
            
        }
    }
    else if (freeFieldsInMiddle == 2)
    {
        if (ownFieldsLeft > 0 && rowOfOwnFields > 0)
        {
            if (self.gameData.rules.minFieldsForLine - numberOfOwnFields > 2)
            {
                if (freeAfterLeft || freeAfterRight)
                {
                    //enough room to form a line
                    //expand line
                    return 11 + (2 * numberOfOwnFields);
                }
                else
                {
                    return 1;
                }
            }
            else
            {
                //AI could score in 2 turns
                return 101;
            }
        }
        else if (opponentFieldsLeft > 0 && rowOfOpponentFields > 0)
        {
            if (self.gameData.rules.minFieldsForLine - numberOfOpponentFields > 2)
            {
                if (freeAfterLeft || freeAfterRight)
                {
                    //enough room to form a line
                    //block expansion of line
                    return 10 + (2 * numberOfOpponentFields);
                }
                else
                {
                    return 1;
                }
            }
            else
            {
                //player could score in 2 turns
                return 100;
            }
        }
        else
        {
            //mixed
            if (freeFieldsLeft > 1)
            {
                //check on the right
                if (self.gameData.rules.minFieldsForLine - rowOfOwnFields == 1)
                {
                    if (self.gameData.rules.inScoreMode)
                    {
                        int possiblePoints = rowOfOwnFields - self.gameData.rules.minFieldsForLine +1;
                        return 301 + (2 * possiblePoints);
                    }
                    else
                    {
                        return 501;
                    }
                }
                else if (self.gameData.rules.minFieldsForLine - rowOfOwnFields == 2 && freeAfterRight)
                {
                    return 101;
                }
                else if (self.gameData.rules.minFieldsForLine - rowOfOpponentFields == 1)
                {
                    if (self.gameData.rules.inScoreMode)
                    {
                        int possiblePoints = rowOfOpponentFields - self.gameData.rules.minFieldsForLine +1;
                        return 300 + (2 * possiblePoints);
                    }
                    else
                    {
                        return 500;
                    }
                }
                else if (self.gameData.rules.minFieldsForLine - rowOfOpponentFields == 2 && freeAfterRight)
                {
                    return 100;
                }
                else
                {
                    if (rowOfOwnFields > 0)
                    {
                        return 11 + (2 * rowOfOwnFields);
                    }
                    else if (rowOfOpponentFields > 0)
                    {
                        return 10 + (2* rowOfOpponentFields);
                    }
                    else
                    {
                        return 1;
                    }

                }
            }
            else
            {
                //check on the left
                if (self.gameData.rules.minFieldsForLine - ownFieldsLeft == 1)
                {
                    if (self.gameData.rules.inScoreMode)
                    {
                        int possiblePoints = ownFieldsLeft - self.gameData.rules.minFieldsForLine +1;
                        return 301 + (2 * possiblePoints);
                    }
                    else
                    {
                        return 501;
                    }
                }
                else if (self.gameData.rules.minFieldsForLine - ownFieldsLeft == 2 && freeAfterLeft)
                {
                    return 101;
                }
                else if (self.gameData.rules.minFieldsForLine - opponentFieldsLeft == 1)
                {
                    if (self.gameData.rules.inScoreMode)
                    {
                        int possiblePoints = opponentFieldsLeft - self.gameData.rules.minFieldsForLine +1;
                        return 300 + (2 * possiblePoints);
                    }
                    else
                    {
                        return 500;
                    }
                }
                else if (self.gameData.rules.minFieldsForLine - opponentFieldsLeft == 2 && freeAfterLeft)
                {
                    return 100;
                }
                else
                {
                    if (ownFieldsLeft > 0)
                    {
                        return 11 + (2 * ownFieldsLeft);
                    }
                    else if (opponentFieldsLeft > 0)
                    {
                        return 10 + (2 * opponentFieldsLeft);
                    }
                    else
                    {
                        return 1;
                    }
                }
            }
        }
        
    }
    else
    {
        //check if next to something
        if (freeFieldsLeft > 1 && rowOfFreeFields > 1)
        {
            //next to nothing
            //AI might want to expand a line with a hole in it
            //AI Strength 4 only
            if (ownFieldsLeft > 0 && freeFieldsLeft == 2 && self.strength > 3)
            {
                return 11 + (2 * ownFieldsLeft);
            }
            else if (rowOfOwnFields > 0 && rowOfFreeFields == 2 && self.strength > 3)
            {
                return 11 + (2 * rowOfOwnFields);
            }
            else if (freeFieldsInMiddle >= self.gameData.rules.minFieldsForLine)
            {
                //enough room to form a line from scratch
                return 2;
            }
        }
        else if (freeFieldsLeft > 1)
        {
            //check on the right
            if (self.gameData.rules.minFieldsForLine - rowOfOwnFields == 1)
            {
                //AI could score
                if (self.gameData.rules.inScoreMode)
                {
                    int possiblePoints = rowOfOwnFields - self.gameData.rules.minFieldsForLine +1;
                    return 301 + (2 * possiblePoints);
                }
                else
                {
                    return 501;
                }
            }
            else if (self.gameData.rules.minFieldsForLine - rowOfOwnFields == 2 && freeAfterRight)
            {
                //AI could score after 2 turns
                return 101;
            }
            else if (self.gameData.rules.minFieldsForLine - rowOfOpponentFields == 1)
            {
                //player could score
                if (self.gameData.rules.inScoreMode)
                {
                    int possiblePoints = rowOfOpponentFields - self.gameData.rules.minFieldsForLine +1;
                    return 300 + (2 * possiblePoints);
                }
                else
                {
                    return 500;
                }
            }
            else if (self.gameData.rules.minFieldsForLine - rowOfOpponentFields == 2 && freeAfterRight)
            {
                //player could score after 2 turns
                return 100;
            }
            else
            {
                if (rowOfOwnFields > 0)
                {
                    return 11 + (2 * rowOfOwnFields);
                }
                else if (rowOfOpponentFields > 0)
                {
                    return 10 + (2 * rowOfOpponentFields);
                }
                else
                {
                    return 1;
                }
            }
        }
        else
        {
            //check on the left
            if (self.gameData.rules.minFieldsForLine - ownFieldsLeft == 1)
            {
                if (self.gameData.rules.inScoreMode)
                {
                    int possiblePoints = ownFieldsLeft - self.gameData.rules.minFieldsForLine +1;
                    return 301 + (2 * possiblePoints);
                }
                else
                {
                    return 501;
                }
            }
            else if (self.gameData.rules.minFieldsForLine - ownFieldsLeft == 2 && freeAfterLeft)
            {
                return 101;
            }
            else if (self.gameData.rules.minFieldsForLine - opponentFieldsLeft == 1)
            {
                if (self.gameData.rules.inScoreMode)
                {
                    int possiblePoints = opponentFieldsLeft - self.gameData.rules.minFieldsForLine +1;
                    return 300 + (2 * possiblePoints);
                }
                else
                {
                    return 500;
                }
            }
            else if (self.gameData.rules.minFieldsForLine - opponentFieldsLeft == 2 && freeAfterLeft)
            {
                return 100;
            }
            else
            {
                if (ownFieldsLeft > 0)
                {
                    return 11 + (2 * ownFieldsLeft);
                }
                else if (opponentFieldsLeft > 0)
                {
                    return 10 + (2 * opponentFieldsLeft);
                }
                else
                {
                    return 1;
                }
            }
        }
    }
    return 1;
}

//returns YES if the line is reusable
-(bool)checkForLine:(Field *)currentField :(bool)colorIsRed:(int)xModifier:(int)yModifier
{
    if (self.gameData.rules.allowReuseOfLines)
    {
        if (colorIsRed && currentField.status == 4)
        {
            
            NSString *key = [NSString stringWithFormat:@"%i, %i", currentField.positionX+xModifier, currentField.positionY+yModifier];
            Field *tempField = (Field *)[self.gameData.fields objectForKey:key];
            
            if (tempField.status == 4)
            {
                //extension of line - treat as border
                return NO;
            }
            else
            {
                return  YES;
            }
        }
        else if (!colorIsRed && currentField.status == 7)
        {
            NSString *key = [NSString stringWithFormat:@"%i, %i", currentField.positionX+xModifier, currentField.positionY+yModifier];
            Field *tempField = (Field *)[self.gameData.fields objectForKey:key];

            if (tempField.status == 7)
            {
                //extension of line - treat as border
                return NO;
            }
            else
            {
                return  YES;
            }
        }
        else
        {
            return NO;
        }
    }
    else
    {
        return NO;
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.strength = [aDecoder decodeIntForKey:@"strength"];
    self.isActivated = [aDecoder decodeBoolForKey:@"isActivated"];
    self.isRedPlayer = [aDecoder decodeBoolForKey:@"isRedPlayer"];
    self.lastAIPosition = [aDecoder decodeCGPointForKey:@"lastAIPosition"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:self.strength forKey:@"strength"];
    [aCoder encodeBool:self.isActivated forKey:@"isActivated"];
    [aCoder encodeCGPoint:self.lastAIPosition forKey:@"lastAIPosition"];
    [aCoder encodeBool:self.isRedPlayer forKey:@"isRedPlayer"];
}
@end
