//
//  SettingsPickerViewController.h
//  TechTacToe-ah
//
//  Created by andreas on 21/10/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

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
