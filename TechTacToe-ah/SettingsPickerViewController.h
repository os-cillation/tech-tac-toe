//
//  SettingsPickerViewController.h
//  TechTacToe-ah
//
//  Created by andreas on 21/10/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SettingsViewController;

typedef enum {
    NUMBER_OF_TURNS,
    BOARD_WIDTH,
    BOARD_HEIGHT,
    MINIMUM_LINE_SIZE,
    PLAYER_COLOR
} pickerID;

@interface SettingsPickerViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
    UILabel *pickerName; // displays the selected cell name of the settings view (uses same localization string as cell)
    UIPickerView *picker; // the main object of this view
    int pickerID; // can be a value declared in the enum and identifies the cell of the settings view this picker corresponds to
    NSMutableArray *dataArray; // contains all valid numbers of our current picker
    SettingsViewController *svc; // the reference to the settings view - we change the value the picker represents with this
    NSNumber *selectedValue; // the currently selected value of the picker
}

@property (nonatomic, retain) IBOutlet UILabel *pickerName;
@property (nonatomic, retain) IBOutlet UIPickerView *picker;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, assign) SettingsViewController *svc;
@property (nonatomic) int pickerID;
@property (nonatomic, retain) NSString *selectedValue;

// custom init method
- (SettingsPickerViewController*) initWithPickerID:(int)pickerIdentity fromSettingsView:(SettingsViewController*)settings;

@end
