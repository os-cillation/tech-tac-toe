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
    MINIMUM_LINE_SIZE
} pickerID;

@interface SettingsPickerViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
    UILabel *pickerName;
    UIPickerView *picker;
    int pickerID;
    NSMutableArray *dataArray;
    SettingsViewController *svc;
    NSNumber *selectedValue;
}

@property (nonatomic, retain) IBOutlet UILabel *pickerName;
@property (nonatomic, retain) IBOutlet UIPickerView *picker;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, assign) SettingsViewController *svc;
@property (nonatomic) int pickerID;
@property (nonatomic, retain) NSNumber *selectedValue;

- (SettingsPickerViewController*) initWithPickerID:(int)pickerIdentity fromSettingsView:(SettingsViewController*)settings;

@end
