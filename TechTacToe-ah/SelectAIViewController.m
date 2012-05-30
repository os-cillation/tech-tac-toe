//
//  SelectAIViewController.m
//  TechTacToe
//
//  Created by Christian Zöller on 25.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SelectAIViewController.h"
#import "MainViewController.h"
#import "SelectAIPickerViewController.h"

@interface SelectAIViewController ()

@end

@implementation SelectAIViewController

@synthesize mvc;
@synthesize colorCell;
@synthesize colorTextField;
@synthesize enableCell;
@synthesize enableSwitch;
@synthesize strengthCell;
@synthesize strengthTextField;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"ImagePaths" ofType:@"plist"];
    NSDictionary *plist = [[NSDictionary alloc] initWithContentsOfFile:path];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[plist objectForKey:@"main view background"]]];
    [plist release];
    
    self.enableCell.textLabel.text = NSLocalizedString(@"SELECT_AI_ENABLED","Enabled");
    self.enableCell.accessoryView = self.enableSwitch;
    self.colorCell.textLabel.text = NSLocalizedString(@"SELECT_AI_COMPUTER_COLOR","Computer Color");
    self.colorCell.accessoryView = self.colorTextField;
    self.strengthCell.textLabel.text = NSLocalizedString(@"SELECT_AI_COMPUTER_STRENGTH","Computer Strength");
    self.strengthCell.accessoryView = self.strengthTextField;
    
    if (self.mvc.isAIActivated)
    {
        self.enableSwitch.on = YES;
        //enable Options
        
        self.colorCell.userInteractionEnabled = YES;
        self.colorCell.textLabel.enabled = YES;
        self.strengthCell.textLabel.enabled = YES;
        self.strengthCell.userInteractionEnabled = YES;
        
    }
    else
    {
        self.enableSwitch.on = NO;
        //disable Options
        self.colorCell.userInteractionEnabled = NO;
        self.colorCell.textLabel.enabled = NO;
        self.strengthCell.textLabel.enabled = NO;
        self.strengthCell.userInteractionEnabled = NO;

    }

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidAppear:(BOOL)animated
{
    if (self.mvc.isAIRedPlayer)
    {
        self.colorTextField.text = NSLocalizedString(@"AICOLOR_RED", "red");
        self.colorTextField.textColor = [UIColor redColor];
        self.strengthTextField.textColor = [UIColor redColor];
    }
    else
    {
        self.colorTextField.text = NSLocalizedString(@"AICOLOR_BLUE", "blue");
        self.colorTextField.textColor = [UIColor blueColor];
        self.strengthTextField.textColor = [UIColor blueColor];
    }
    if (!self.enableSwitch.isOn)
    {
        self.colorTextField.textColor = [UIColor grayColor];
        self.strengthTextField.textColor = [UIColor grayColor];
    }
    //NSString *strengthOfAI = [NSString stringWithFormat:@"%i",self.mvc.strengthOfAI];
    //self.strengthTextField.text =  strengthOfAI;
    if (self.mvc.strengthOfAI == 1)
    {
        self.strengthTextField.text = NSLocalizedString(@"AISTRENGTH_1", "weak");
    }
    else if (self.mvc.strengthOfAI == 2)
    {
        self.strengthTextField.text = NSLocalizedString(@"AISTRENGTH_2", "normal");
    }
    else
    {
        self.strengthTextField.text = NSLocalizedString(@"AISTRENGTH_3", "strong");
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)dealloc
{
    [strengthTextField release];
    [strengthCell release];
    [colorTextField release];
    [colorCell release];
    [enableSwitch release];
    [enableCell release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    //return 0;
    if (section == 1)
    {
        return 2;
    }
    else
    {
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return NSLocalizedString(@"SELECT_AI_COMPUTER_OPPONENT", "Computer Opponent");
            break;
        default:
            return NSLocalizedString(@"SELECT_AI_OPTIONS", "Options");
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return NSLocalizedString(@"SELECT_AI_AI_FOOTER", "Enables or disables the computer opponent");
            break;
        default:
            return NSLocalizedString(@"SELECT_AI_OPTIONS_FOOTER", "TODO");
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"Cell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    //return cell;
    if (indexPath.section == 0)
    {
        return self.enableCell;
    }
    else
    {
        if (indexPath.row == 0)
        {
            return self.colorCell;
        }
        else
        {
            return self.strengthCell;
        }
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1)
    {
        SelectAIPickerViewController *pickerView = [[SelectAIPickerViewController alloc] initWithNibName:@"SelectAIPickerViewController" bundle:Nil];
        pickerView.mvc = self.mvc;
        if (indexPath.row == 0)
        {
            //color
            pickerView.pickerID = YES;
        }
        else
        {
            //strength
            pickerView.pickerID = NO;

        }
        [self.navigationController pushViewController:pickerView animated:YES];
        [pickerView release];
    }
}

-(void)enableSwitchChanged:(id)sender
{
    if (self.enableSwitch.isOn)
    {
        //set value and enable settings
        self.mvc.isAIActivated = YES;
        
        self.colorCell.userInteractionEnabled = YES;
        self.colorCell.textLabel.enabled = YES;
        self.strengthCell.textLabel.enabled = YES;
        self.strengthCell.userInteractionEnabled = YES;
        
        //self.strengthTextField.textColor = [UIColor blueColor];
        
        if (self.mvc.isAIRedPlayer)
        {
            self.colorTextField.text = NSLocalizedString(@"AICOLOR_RED", "red");
            self.colorTextField.textColor = [UIColor redColor];
            self.strengthTextField.textColor = [UIColor redColor];
        }
        else
        {
            self.colorTextField.text = NSLocalizedString(@"AICOLOR_BLUE", "blue");
            self.colorTextField.textColor = [UIColor blueColor];
            self.strengthTextField.textColor = [UIColor blueColor];
        }
    }
    else
    {
        //set value and disable settings
        self.mvc.isAIActivated = NO;
        
        self.colorCell.userInteractionEnabled = NO;
        self.colorCell.textLabel.enabled = NO;
        self.strengthCell.textLabel.enabled = NO;
        self.strengthCell.userInteractionEnabled = NO;
        
        self.colorTextField.textColor = [UIColor grayColor];
        self.strengthTextField.textColor = [UIColor grayColor];
    }
}

@end
