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

#import "SettingsPickerViewController.h"
#import "SettingsViewController.h"

@implementation SettingsPickerViewController
@synthesize picker;
@synthesize dataArray=_dataArray;
@synthesize pickerID=_pickerID;
@synthesize selectedValue=_selectedValue;
@synthesize appDelegate = _appDelegate;

#pragma mark - Initializer and memory management

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (SettingsPickerViewController *)initWithPickerID:(int)pickerIdentity
{
    self = [super initWithNibName:@"SettingsPickerViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.pickerID = pickerIdentity;
        self.appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    }
    return self;
}

- (void)dealloc {
    [picker release];
    [_dataArray release];
    [_selectedValue release];
    [_appDelegate release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Picker view data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dataArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //NSNumber *number = [self.dataArray objectAtIndex:row];
    //return number.description;
    return [self.dataArray objectAtIndex:row];
}

#pragma mark Picker view delegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    self.selectedValue = [self.dataArray objectAtIndex:row];
        
    switch (self.pickerID) {
        case NUMBER_OF_TURNS:
            self.appDelegate.turnLimitNumber = self.selectedValue.intValue;
            break;
        case BOARD_WIDTH:
            self.appDelegate.boardSizeWidth = self.selectedValue.intValue;
            break;
        case BOARD_HEIGHT:
            self.appDelegate.boardSizeHeight = self.selectedValue.intValue;
            break;
        case MINIMUM_LINE_SIZE:
            self.appDelegate.minimumLineSize = self.selectedValue.intValue;
            break;
        case PLAYER_COLOR:
            if ([self.selectedValue isEqualToString:NSLocalizedString(@"AICOLOR_BLUE", "blue")])
            {
                self.appDelegate.localPlayerColorBlue = YES;
            }
            else
            {                
                self.appDelegate.localPlayerColorBlue = NO;
            }
            break;
        default:
            break;
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    // set the title and back button of the nav bar
    //self.navigationItem.title = NSLocalizedString(@"SETTINGS_VIEW_TITLE", @"Customize Game");
    UIBarButtonItem *tempButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"BACK_BUTTON", @"Back") style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = tempButton;
    [tempButton release];
    
    // init empty dataSource
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:25];
    self.dataArray = array;
    [array release];
    
    self.picker.delegate = self;
    self.picker.dataSource = self;
    
    // set up our picker
    switch (self.pickerID) {
        case NUMBER_OF_TURNS:
            // number of turns picker
            self.navigationItem.title = NSLocalizedString(@"SETTINGS_VIEW_CELL_NUMBER_OF_TURNS", @"Number of Turns");
            
            // fill our picker's data source
            if (self.appDelegate.boardSizeLimit) {
                for (int i = 1; i <= self.appDelegate.boardSizeHeight * self.appDelegate.boardSizeWidth; i++) {
                    //[self.dataArray addObject:[NSNumber numberWithInt:i]];
                    [self.dataArray addObject:[NSString stringWithFormat:@"%i",i]];
                }
            } else {
                for (int i = 1; i <= 625; i++) {
                    //[self.dataArray addObject:[NSNumber numberWithInt:i]];
                    [self.dataArray addObject:[NSString stringWithFormat:@"%i",i]];
                }
            }
            [self.picker selectRow:self.appDelegate.turnLimitNumber - 1 inComponent:0 animated:NO];
            break;
        case BOARD_WIDTH:
            self.navigationItem.title = NSLocalizedString(@"SETTINGS_VIEW_CELL_BOARD_WIDTH", @"Board Width");
            for (int i = self.appDelegate.minimumLineSize; i <= 25 ; i++) {
                //[self.dataArray addObject:[NSNumber numberWithInt:i]];
                [self.dataArray addObject:[NSString stringWithFormat:@"%i",i]];
            }
            [self.picker selectRow:self.appDelegate.boardSizeWidth - self.appDelegate.minimumLineSize inComponent:0 animated:NO];
            break;
        case BOARD_HEIGHT:
            self.navigationItem.title = NSLocalizedString(@"SETTINGS_VIEW_CELL_BOARD_HEIGHT", @"Board Height");
            for (int i = self.appDelegate.minimumLineSize; i <= 25 ; i++) {
                //[self.dataArray addObject:[NSNumber numberWithInt:i]];
                [self.dataArray addObject:[NSString stringWithFormat:@"%i",i]];
            }
            [self.picker selectRow:self.appDelegate.boardSizeHeight - self.appDelegate.minimumLineSize inComponent:0 animated:NO];
            break;
        case MINIMUM_LINE_SIZE:
            self.navigationItem.title = NSLocalizedString(@"SETTINGS_VIEW_CELL_MINIMUM_LINE_SIZE", @"Minimum Line Size");
            for (int i = 3; i <= 6; i++) {
                //[self.dataArray addObject:[NSNumber numberWithInt:i]];
                [self.dataArray addObject:[NSString stringWithFormat:@"%i",i]];
            }
            [self.picker selectRow:self.appDelegate.minimumLineSize - 3 inComponent:0 animated:NO];
            break;
        case PLAYER_COLOR:
            self.navigationItem.title = NSLocalizedString(@"SETTINGS_VIEW_CELL_PLAYER_COLOR", "Player Color");
            [self.dataArray addObject:NSLocalizedString(@"AICOLOR_BLUE", "blue")];
            [self.dataArray addObject:NSLocalizedString(@"AICOLOR_RED", "red")];
            
            if (self.appDelegate.localPlayerColorBlue)
            {
                [self.picker selectRow:0 inComponent:0 animated:NO];
            }
            else
            {
                [self.picker selectRow:1 inComponent:0 animated:NO];
            }
            break;
        default:
            break;
    }
    
    // set up the background view
    NSString *path = [[NSBundle mainBundle]pathForResource:@"ImagePaths" ofType:@"plist"];
    NSDictionary *plist = [[NSDictionary alloc] initWithContentsOfFile:path];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[plist objectForKey:@"main view background"]]];
    [plist release];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setPicker:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.tintColor = [UIColor grayColor]; 
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
    // Return YES for supported orientations
}

@end
