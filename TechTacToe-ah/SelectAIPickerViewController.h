//
//  SelectAIPickerViewController.h
//  TechTacToe
//
//  Created by Christian Zöller on 25.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MainViewController;

@interface SelectAIPickerViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, retain) IBOutlet UILabel *pickerName;
@property (nonatomic, retain) IBOutlet UIPickerView *picker;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, assign) MainViewController *mvc;
@property (nonatomic) bool pickerID;
@property (nonatomic, retain) NSString *selectedValue;

@end
