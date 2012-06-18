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

@synthesize appDelegate=_appDelegate;
@synthesize isAIActivated = _isAIActivated;
@synthesize isAIRedPlayer = _isAIRedPlayer;
@synthesize strengthOfAI = _strengthOfAI;
@synthesize colorCell;
@synthesize colorTextField;
@synthesize strengthCell;
@synthesize strengthTextField;
@synthesize modeSelectCell;
@synthesize modeSelectControl;
@synthesize passControllCell;
@synthesize connectCell;
@synthesize disconnectCell;

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
    self.appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    self.navigationController.navigationBar.tintColor = [UIColor grayColor];
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
    
    self.colorCell.textLabel.text = NSLocalizedString(@"SELECT_AI_COMPUTER_COLOR","Computer Color");
    self.colorCell.accessoryView = self.colorTextField;
    self.strengthCell.textLabel.text = NSLocalizedString(@"SELECT_AI_COMPUTER_STRENGTH","Computer Strength");
    self.strengthCell.accessoryView = self.strengthTextField;
    
    self.modeSelectCell.accessoryView = self.modeSelectControl;
    [self.modeSelectControl setTitle:NSLocalizedString(@"SINGLEPLAYER", "Singleplayer") forSegmentAtIndex:0];
    [self.modeSelectControl setTitle:NSLocalizedString(@"MULTIPLAYER", "Multiplayer") forSegmentAtIndex:1];
    
    self.connectCell.textLabel.text = NSLocalizedString(@"SETTINGS_CELL_CONNECT", "Connect");
    self.disconnectCell.textLabel.text = NSLocalizedString(@"SETTINGS_CELL_DISCONNECT", "Disconnect");
    self.passControllCell.textLabel.text = NSLocalizedString(@"SETTINGS_CELL_REVOKE_CONTROL", "pass Controll");
    
    /*
    if (self.appDelegate.btdh.currentSession) {
        NSString *peerID = [[self.appDelegate.btdh.currentSession peersWithConnectionState:GKPeerStateConnected] objectAtIndex:0];
        NSString *peerName = [self.appDelegate.btdh.currentSession displayNameForPeer:peerID];
        detailCell.detailTextLabel.text = peerName;
    }
     */
    
    //initialize AIvariables
    self.isAIRedPlayer = self.appDelegate.isAIRedPlayer;
    self.isAIActivated = self.appDelegate.isAIActivated;
    self.strengthOfAI = self.appDelegate.strengthOfAI;
    
    if (self.isAIActivated)
    {
        self.modeSelectControl.selectedSegmentIndex = 0;
    }
    else
    {
        self.modeSelectControl.selectedSegmentIndex = 1;
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidAppear:(BOOL)animated
{
    if (self.isAIRedPlayer)
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
    if (self.strengthOfAI == 1)
    {
        self.strengthTextField.text = NSLocalizedString(@"AISTRENGTH_1", "weak");
    }
    else if (self.strengthOfAI == 2)
    {
        self.strengthTextField.text = NSLocalizedString(@"AISTRENGTH_2", "normal");
    }
    else
    {
        self.strengthTextField.text = NSLocalizedString(@"AISTRENGTH_3", "strong");
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    self.appDelegate.isAIActivated = self.isAIActivated;
    self.appDelegate.isAIRedPlayer = self.isAIRedPlayer;
    self.appDelegate.strengthOfAI = self.strengthOfAI;
    
    [super viewDidDisappear:YES];
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
    [_appDelegate release];
    [modeSelectCell release];
    [modeSelectControl release];
    [connectCell release];
    [disconnectCell release];
    [passControllCell release];
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
    if (section == 0)
    {
        return 1;
    }
    else
    {
        if (self.isAIActivated || self.appDelegate.btdh.currentSession)
        {
            return 2;
        }
        else
        {
            return 1;
        }
        
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return NSLocalizedString(@"SELECT_MODE_HEADER", "Game Mode");
            break;
        default:
            if (self.isAIActivated)
            {
                return NSLocalizedString(@"SELECT_AI_OPTIONS", "Options");
            }
            else
            {
                if (self.appDelegate.btdh.currentSession)
                {
                    return NSLocalizedString(@"SETTINGS_MP_HEADER2", "BT Header");
                }
                else
                {
                    return NSLocalizedString(@"SETTINGS_MP_HEADER1", "Hotseat Header");
                }
            }
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return NSLocalizedString(@"SELECT_MODE_FOOTER", "Game Mode description");
            break;
        default:
            if (self.isAIActivated)
            {
                return NSLocalizedString(@"SELECT_AI_OPTIONS_FOOTER", "Description");
            }
            else
            {
                if (self.appDelegate.btdh.currentSession)
                {
                    if (self.appDelegate.btdh.localUserActAsServer)
                    {
                        return NSLocalizedString(@"SETTINGS_MP_FOOTER2a", "BT Footer");
                    }
                    else
                    {
                        return NSLocalizedString(@"SETTINGS_MP_FOOTER2b", "BT Footer");
                    }
                }
                else
                {
                    return NSLocalizedString(@"SETTINGS_MP_FOOTER1", "Hotseat Footer");  
                }
            }
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
        return self.modeSelectCell;
    }
    else
    {
        if (self.isAIActivated)
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
        else
        {
            if (self.appDelegate.btdh.currentSession)
            {
                if (indexPath.row == 0)
                {
                    return self.disconnectCell;
                }
                else
                {
                    return self.passControllCell;
                }
            }
            else
            {
                return self.connectCell;
            }

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
    
    if (indexPath.section == 1 && self.isAIActivated)
    {
        SelectAIPickerViewController *pickerView = [[SelectAIPickerViewController alloc] initWithNibName:@"SelectAIPickerViewController" bundle:Nil];
        pickerView.svc = self;
        if (indexPath.row == 0)
        {
            //color
            pickerView.pickerID = 0;
        }
        else
        {
            //strength
            pickerView.pickerID = 1;

        }
        [self.navigationController pushViewController:pickerView animated:YES];
        [pickerView release];
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            //Connect or disconnect
        }
        else
        {
            //pass game control
        }
    }
}

-(void)modeSelectChanged:(id)sender
{
    if (self.modeSelectControl.selectedSegmentIndex == 1)
    {
        //Multiplayer
        self.isAIActivated = NO;
        [self.tableView reloadData];
    }
    else
    {
        //Singleplayer
        self.isAIActivated = YES;
        [self.tableView reloadData];
    }
}

@end
