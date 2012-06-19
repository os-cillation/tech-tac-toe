//
//  SettingsPickerViewController.m
//  TechTacToe-ah
//
//  Created by andreas on 21/10/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsPickerViewController.h"
#import "SettingsViewController.h"

@implementation SettingsPickerViewController
@synthesize pickerName;
@synthesize picker;
@synthesize dataArray=_dataArray;
@synthesize svc=_svc;
@synthesize pickerID=_pickerID;
@synthesize selectedValue=_selectedValue;

#pragma mark - Initializer and memory management

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (SettingsPickerViewController *)initWithPickerID:(int)pickerIdentity fromSettingsView:(SettingsViewController*)settings
{
    self = [super initWithNibName:@"SettingsPickerViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.svc = settings;
        self.pickerID = pickerIdentity;
    }
    return self;
}

- (void)dealloc {
    [pickerName release];
    [picker release];
    [_dataArray release];
    [_selectedValue release];
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
            //self.svc.numberOfTurnsTextField.text = self.selectedValue.description;
            self.svc.numberOfTurnsTextField.text = self.selectedValue;
            break;
        case BOARD_WIDTH:
            self.svc.boardWidthTextField.text = self.selectedValue;
            break;
        case BOARD_HEIGHT:
            self.svc.boardHeightTextField.text = self.selectedValue;
            break;
        case MINIMUM_LINE_SIZE:
            self.svc.minimumForLineTextField.text = self.selectedValue;
            break;
        case PLAYER_COLOR:
            if ([self.selectedValue isEqualToString:NSLocalizedString(@"AICOLOR_BLUE", "blue")])
            {
                self.svc.playerColorTextField.text = NSLocalizedString(@"AICOLOR_BLUE", "blue");
                self.svc.playerColorTextField.textColor = [UIColor blueColor];
            }
            else
            {
                self.svc.playerColorTextField.text = NSLocalizedString(@"AICOLOR_RED", "red");
                self.svc.playerColorTextField.textColor = [UIColor redColor];
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
    self.navigationItem.title = NSLocalizedString(@"SETTINGS_VIEW_TITLE", @"Customize Game");
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
            self.pickerName.text = NSLocalizedString(@"SETTINGS_VIEW_CELL_NUMBER_OF_TURNS", @"Number of Turns");
            // fill our picker's data source
            if (self.svc.boardLimitSwitch.isOn) {
                for (int i = 1; i <= self.svc.boardHeightTextField.text.intValue * self.svc.boardWidthTextField.text.intValue; i++) {
                    //[self.dataArray addObject:[NSNumber numberWithInt:i]];
                    [self.dataArray addObject:[NSString stringWithFormat:@"%i",i]];
                }
            } else {
                for (int i = 1; i <= 625; i++) {
                    //[self.dataArray addObject:[NSNumber numberWithInt:i]];
                    [self.dataArray addObject:[NSString stringWithFormat:@"%i",i]];
                }
            }
            [self.picker selectRow:self.svc.numberOfTurnsTextField.text.intValue - 1 inComponent:0 animated:NO];
            break;
        case BOARD_WIDTH:
            self.pickerName.text = NSLocalizedString(@"SETTINGS_VIEW_CELL_BOARD_WIDTH", @"Board Width");
            for (int i = self.svc.minimumForLineTextField.text.intValue; i <= 25 ; i++) {
                //[self.dataArray addObject:[NSNumber numberWithInt:i]];
                [self.dataArray addObject:[NSString stringWithFormat:@"%i",i]];
            }
            [self.picker selectRow:self.svc.boardWidthTextField.text.intValue - self.svc.minimumForLineTextField.text.intValue inComponent:0 animated:NO];
            break;
        case BOARD_HEIGHT:
            self.pickerName.text = NSLocalizedString(@"SETTINGS_VIEW_CELL_BOARD_HEIGHT", @"Board Height");
            for (int i = self.svc.minimumForLineTextField.text.intValue; i <= 25 ; i++) {
                //[self.dataArray addObject:[NSNumber numberWithInt:i]];
                [self.dataArray addObject:[NSString stringWithFormat:@"%i",i]];
            }
            [self.picker selectRow:self.svc.boardHeightTextField.text.intValue - self.svc.minimumForLineTextField.text.intValue inComponent:0 animated:NO];
            break;
        case MINIMUM_LINE_SIZE:
            self.pickerName.text = NSLocalizedString(@"SETTINGS_VIEW_CELL_MINIMUM_LINE_SIZE", @"Minimum Line Size");
            for (int i = 3; i <= 6; i++) {
                //[self.dataArray addObject:[NSNumber numberWithInt:i]];
                [self.dataArray addObject:[NSString stringWithFormat:@"%i",i]];
            }
            [self.picker selectRow:self.svc.minimumForLineTextField.text.intValue - 3 inComponent:0 animated:NO];
            break;
        case PLAYER_COLOR:
            self.pickerName.text = NSLocalizedString(@"SETTINGS_VIEW_CELL_PLAYER_COLOR", "Player Color");
            [self.dataArray addObject:NSLocalizedString(@"AICOLOR_BLUE", "blue")];
            [self.dataArray addObject:NSLocalizedString(@"AICOLOR_RED", "red")];
            
            if ([self.svc.playerColorTextField.text isEqualToString:NSLocalizedString(@"AICOLOR_BLUE", "blue")])
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
    [self setPickerName:nil];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
