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

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@class SettingsViewController;

typedef enum {
    NUMBER_OF_TURNS,
    BOARD_WIDTH,
    BOARD_HEIGHT,
    MINIMUM_LINE_SIZE,
    PLAYER_COLOR
} pickerID;

@interface SettingsPickerViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
    UIPickerView *picker; // the main object of this view
    int pickerID; // can be a value declared in the enum and identifies the cell of the settings view this picker corresponds to
    NSMutableArray *dataArray; // contains all valid numbers of our current picker
    NSNumber *selectedValue; // the currently selected value of the picker
}

@property (nonatomic, retain) IBOutlet UIPickerView *picker;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic) int pickerID;
@property (nonatomic, retain) NSString *selectedValue;
@property (nonatomic, retain) AppDelegate *appDelegate;

// custom init method
- (SettingsPickerViewController*) initWithPickerID:(int)pickerIdentity;

@end
