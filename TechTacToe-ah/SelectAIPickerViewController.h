//
//  SelectAIPickerViewController.h
//  TechTacToe
//
//  Created by Christian Zöller on 25.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SelectAIViewController;

@interface SelectAIPickerViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, retain) IBOutlet UILabel *pickerName;
@property (nonatomic, retain) IBOutlet UIPickerView *picker;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, assign) SelectAIViewController *svc;
@property (nonatomic) int pickerID;
@property (nonatomic, retain) NSString *selectedValue;

@end

/***Picker ID
*
*0 - AIColor
*1 - AIStrength
*
*/