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
    priority = [aDecoder decodeIntForKey:@"priority"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:positionX forKey:@"position X"];
    [aCoder encodeInt:positionY forKey:@"position Y"];
    [aCoder encodeInt:status forKey:@"status"];
    [aCoder encodeInt:priority forKey:@"priority"];
}

@end
