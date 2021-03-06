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

#import "SelectAIPickerViewController.h"
#import "AppDelegate.h"

@interface SelectAIPickerViewController ()

@end

@implementation SelectAIPickerViewController

@synthesize pickerID;
@synthesize picker;
@synthesize selectedValue;
@synthesize dataArray;
@synthesize appDelegate;

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
    self.appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    // set the title and back button of the nav bar
    //self.navigationItem.title = NSLocalizedString(@"SELECT_AI_SETTINGS", "Settings");
    UIBarButtonItem *tempButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"BACK_BUTTON", @"Back") style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = tempButton;
    [tempButton release];
    
    // init empty dataSource
    NSMutableArray *array = [[NSMutableArray alloc] init];
    self.dataArray = array;
    [array release];
    
    self.picker.delegate = self;
    self.picker.dataSource = self;
    
    if (pickerID == 0)
    {
        //color
        self.navigationItem.title = NSLocalizedString(@"AI_PICKER_COLOR", "COLOR");
        [self.dataArray addObject:NSLocalizedString(@"AICOLOR_BLUE", "blue")];
        [self.dataArray addObject:NSLocalizedString(@"AICOLOR_RED", "red")];
        
        if (self.appDelegate.isAIRedPlayer)
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
        self.navigationItem.title = NSLocalizedString(@"AI_PICKER_STRENGTH", "Srength");
       /* for (int i = 1; i < 4; i++) {
            [self.dataArray addObject:[NSString stringWithFormat:@"%i",i]];
        }
        [self.picker selectRow:self.svc.strengthOfAI-1 inComponent:0 animated:NO];*/
        [self.dataArray addObject:NSLocalizedString(@"AISTRENGTH_1", "weak")];
        [self.dataArray addObject:NSLocalizedString(@"AISTRENGTH_2", "normal")];
        [self.dataArray addObject:NSLocalizedString(@"AISTRENGTH_3", "strong")];
        if (self.appDelegate.strengthOfAI == 1)
        {
            [self.picker selectRow:0 inComponent:0 animated:NO];
        }
        else if (self.appDelegate.strengthOfAI == 2)
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
    
    if (pickerID == 0)
    {
        //color
        //set values from picker to mvc
        if ([self.selectedValue isEqualToString:NSLocalizedString(@"AICOLOR_RED", "red")])
        {
            self.appDelegate.isAIRedPlayer = YES;
        }
        else
        {
            self.appDelegate.isAIRedPlayer = NO;
        }
    }
    else
    {
        //strength
        //self.svc.strengthOfAI = self.selectedValue.intValue;
        if ([self.selectedValue isEqualToString:NSLocalizedString(@"AISTRENGTH_1", "weak")])
        {
            self.appDelegate.strengthOfAI = 1;
        }
        else if ([self.selectedValue isEqualToString:NSLocalizedString(@"AISTRENGTH_2", "normal")])
        {
            self.appDelegate.strengthOfAI = 2;
        }
        else
        {
            self.appDelegate.strengthOfAI = 3;
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
    [dataArray release];
    [selectedValue release];
    [appDelegate release];
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
    return YES;
}

@end
