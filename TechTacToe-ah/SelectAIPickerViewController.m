//
//  SelectAIPickerViewController.m
//  TechTacToe
//
//  Created by Christian Zöller on 25.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SelectAIPickerViewController.h"
#import "MainViewController.h"

@interface SelectAIPickerViewController ()

@end

@implementation SelectAIPickerViewController

@synthesize mvc;
@synthesize pickerID;
@synthesize pickerName;
@synthesize picker;
@synthesize selectedValue;
@synthesize dataArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    // set the title and back button of the nav bar
    self.navigationItem.title = NSLocalizedString(@"SELECT_AI_SETTINGS", "Settings");
    UIBarButtonItem *tempButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"BACK_BUTTON", @"Back") style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = tempButton;
    [tempButton release];
    
    // init empty dataSource
    NSMutableArray *array = [[NSMutableArray alloc] init];
    self.dataArray = array;
    [array release];
    
    self.picker.delegate = self;
    self.picker.dataSource = self;
    
    if (pickerID)
    {
        //color
        self.pickerName.text = NSLocalizedString(@"AI_PICKER_COLOR", "COLOR");
        [self.dataArray addObject:NSLocalizedString(@"AICOLOR_BLUE", "blue")];
        [self.dataArray addObject:NSLocalizedString(@"AICOLOR_RED", "red")];
        
        if (self.mvc.isAIRedPlayer)
        {
            [self.picker selectRow:1 inComponent:0 animated:NO];
        }
        else
        {
            [self.picker selectRow:0 inComponent:0 animated:NO];
        }
    }
    else
    {
        //strength
        self.pickerName.text = NSLocalizedString(@"AI_PICKER_STRENGTH", "Srength");
       /* for (int i = 1; i < 4; i++) {
            [self.dataArray addObject:[NSString stringWithFormat:@"%i",i]];
        }
        [self.picker selectRow:self.mvc.strengthOfAI-1 inComponent:0 animated:NO];*/
        [self.dataArray addObject:NSLocalizedString(@"AISTRENGTH_1", "weak")];
        [self.dataArray addObject:NSLocalizedString(@"AISTRENGTH_2", "normal")];
        [self.dataArray addObject:NSLocalizedString(@"AISTRENGTH_3", "strong")];
        if (self.mvc.strengthOfAI == 1)
        {
            [self.picker selectRow:0 inComponent:0 animated:NO];
        }
        else if (self.mvc.strengthOfAI == 2)
        {
            [self.picker selectRow:1 inComponent:0 animated:NO];
        }
        else
        {
            [self.picker selectRow:2 inComponent:0 animated:NO];
        }
    }
    //[self.picker selectRow:0 inComponent:0 animated:NO];

    // set up the background view
    NSString *path = [[NSBundle mainBundle]pathForResource:@"ImagePaths" ofType:@"plist"];
    NSDictionary *plist = [[NSDictionary alloc] initWithContentsOfFile:path];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[plist objectForKey:@"main view background"]]];
    [plist release];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedValue = [self.dataArray objectAtIndex:row];
    
    if (pickerID)
    {
        //color
        //set values from picker to mvc
        if ([self.selectedValue isEqualToString:NSLocalizedString(@"AICOLOR_RED", "red")])
        {
            self.mvc.isAIRedPlayer = YES;
        }
        else
        {
            self.mvc.isAIRedPlayer = NO;
        }
    }
    else
    {
        //strength
        //self.mvc.strengthOfAI = self.selectedValue.intValue;
        if ([self.selectedValue isEqualToString:NSLocalizedString(@"AISTRENGTH_1", "weak")])
        {
            self.mvc.strengthOfAI = 1;
        }
        else if ([self.selectedValue isEqualToString:NSLocalizedString(@"AISTRENGTH_2", "normal")])
        {
            self.mvc.strengthOfAI = 2;
        }
        else
        {
            self.mvc.strengthOfAI = 3;
        }
    }
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
    NSString *result = [self.dataArray objectAtIndex:row];
    return result;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) dealloc
{
    [picker release];
    [pickerName release];
    [dataArray release];
    [selectedValue release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
