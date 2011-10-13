//
//  SettingsViewController.m
//  TechTacToe-ah
//
//  Created by andreas on 28/09/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"

@implementation SettingsViewController

@synthesize boardLimitCell;
@synthesize boardLimitSwitch;
@synthesize boardWidthCell;
@synthesize boardWidthTextField;
@synthesize boardHeightCell;
@synthesize boardHeightTextField;
@synthesize minimumForLineCell;
@synthesize limitTurnsCell;
@synthesize limitTurnsSwitch;
@synthesize minimumForLineTextField;
@synthesize numberOfTurnsCell;
@synthesize numberOfTurnsTextField;
@synthesize scoreModeCell;
@synthesize scoreModeSwitch;
@synthesize additionalRedTurnCell;
@synthesize additionalRedTurnSwitch;
@synthesize reuseLineCell;
@synthesize reuseLineSwitch;
@synthesize tapGestureRecognizer;
@synthesize mvc;

#pragma mark - Initializer and memory management

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [minimumForLineCell release];
    [numberOfTurnsCell release];
    [scoreModeCell release];
    [additionalRedTurnCell release];
    [reuseLineCell release];
    [minimumForLineTextField release];
    [scoreModeSwitch release];
    [additionalRedTurnSwitch release];
    [reuseLineSwitch release];
    [numberOfTurnsTextField release];
    [boardWidthCell release];
    [boardHeightCell release];
    [boardWidthTextField release];
    [boardHeightTextField release];
    [limitTurnsCell release];
    [limitTurnsSwitch release];
    [boardLimitCell release];
    [boardLimitSwitch release];
    [tapGestureRecognizer release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    // set the title and back button of the nav bar
    self.navigationItem.title = NSLocalizedString(@"SETTINGS_VIEW_TITLE", @"Customize Game");
    UIBarButtonItem *tempButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"BACK_BUTTON", @"Back") style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = tempButton;
    [tempButton release];
    
    // add a button to start the game to the nav bar
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"SETTINGS_VIEW_PLAY_BUTTON", @"Play") style:UIBarButtonItemStyleDone target:self action:@selector(startGame)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    [anotherButton release];
    
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // set up the cells
    self.limitTurnsCell.textLabel.text = NSLocalizedString(@"SETTINGS_VIEW_CELL_TURN_LIMIT", @"Turn Limit");
    self.limitTurnsCell.accessoryView = self.limitTurnsSwitch;
    self.numberOfTurnsCell.textLabel.text = NSLocalizedString(@"SETTINGS_VIEW_CELL_NUMBER_OF_TURNS", @"Number of Turns");
    self.numberOfTurnsCell.accessoryView = self.numberOfTurnsTextField;
    self.boardLimitCell.textLabel.text = NSLocalizedString(@"SETTINGS_VIEW_CELL_LIMIT_BOARD_SIZE", @"Limit Board Size");
    self.boardLimitCell.accessoryView = self.boardLimitSwitch;
    self.boardWidthCell.textLabel.text = NSLocalizedString(@"SETTINGS_VIEW_CELL_BOARD_WIDTH", @"Board Width");
    self.boardWidthCell.accessoryView = self.boardWidthTextField;
    self.boardHeightCell.textLabel.text = NSLocalizedString(@"SETTINGS_VIEW_CELL_BOARD_HEIGHT", @"Board Height");
    self.boardHeightCell.accessoryView = self.boardHeightTextField;
    self.minimumForLineCell.textLabel.text = NSLocalizedString(@"SETTINGS_VIEW_CELL_MINIMUM_LINE_SIZE", @"Minimum Line Size");
    self.minimumForLineCell.accessoryView = self.minimumForLineTextField;
    self.scoreModeCell.textLabel.text = NSLocalizedString(@"SETTINGS_VIEW_CELL_SCORE_MODE", @"Score Mode");
    self.scoreModeCell.accessoryView = self.scoreModeSwitch;
    self.additionalRedTurnCell.textLabel.text = NSLocalizedString(@"SETTINGS_VIEW_CELL_ADDITIONAL_RED_TURN", @"Additional Red Turn");
    self.additionalRedTurnCell.accessoryView = self.additionalRedTurnSwitch;
    self.reuseLineCell.textLabel.text = NSLocalizedString(@"SETTINGS_VIEW_CELL_REUSE_LINES", @"Reuse Lines");
    self.reuseLineCell.accessoryView = self.reuseLineSwitch;
    
    //add a tap gesture recognizer so we can dismiss the keyboard on a background tap
    UITapGestureRecognizer *temp = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAllKeyboards)];
    self.tapGestureRecognizer = temp;
    [temp release];
    self.tapGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
}

- (void)viewDidUnload
{
    [self setMinimumForLineCell:nil];
    [self setNumberOfTurnsCell:nil];
    [self setScoreModeCell:nil];
    [self setAdditionalRedTurnCell:nil];
    [self setReuseLineCell:nil];
    [self setMinimumForLineTextField:nil];
    [self setScoreModeSwitch:nil];
    [self setAdditionalRedTurnSwitch:nil];
    [self setReuseLineSwitch:nil];
    [self setNumberOfTurnsTextField:nil];
    [self setBoardWidthCell:nil];
    [self setBoardHeightCell:nil];
    [self setBoardWidthTextField:nil];
    [self setBoardHeightTextField:nil];
    [self setLimitTurnsCell:nil];
    [self setLimitTurnsSwitch:nil];
    [self setBoardLimitCell:nil];
    [self setBoardLimitSwitch:nil];
    [self setTapGestureRecognizer:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.tintColor = nil; 
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 3;
            break;
        case 2:
            return 1;
            break;
        case 3:
            return 1;
            break;
        case 4:
            return 1;
            break;
        case 5:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"Cell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
//    }
//    
//    // Configure the cell...
//    
//    return cell;
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0)
                return self.limitTurnsCell;
            else
                return self.numberOfTurnsCell;
            break;
        case 1:
            if (indexPath.row == 0)
                return self.boardLimitCell;
            if (indexPath.row == 1)
                return self.boardWidthCell;
            else
                return self.boardHeightCell;
            break;
        case 2:
            return self.minimumForLineCell;
            break;
        case 3:
            return self.scoreModeCell;
            break;
        case 4:
            return self.additionalRedTurnCell;
            break;
        case 5:
            return self.reuseLineCell;
            break;
        default:
            return 0;
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return NSLocalizedString(@"SETTINGS_VIEW_HEADER_BOARD_OPTIONS", @"Board Options");
            break;
        case 1:
            return @"";
            break;
        case 2:
            return @"";
            break;
        case 3:
            return NSLocalizedString(@"SETTINGS_VIEW_HEADER_GAME_MODE_OPTIONS", @"Game Mode Options");
            break;
        case 4:
            return @"";
            break;
        case 5:
            return @"";
            break;
        default:
            return @"";
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return [NSString stringWithFormat:NSLocalizedString(@"SETTINGS_VIEW_FOOTER_TURN_OPTIONS", @"Sets the number of turns. Cannot be higher than the total board size. If no turn limit is set but the board has a limit, the maximum number of turns will be used. On unlimited boards, the highest valid value is %i. Also, if no turn limit and no board limit is set, game will not be in score mode."), MAX_FIELDS];
            break;
        case 1:
            return [NSString stringWithFormat:NSLocalizedString(@"SETTINGS_VIEW_FOOTER_BOARD_OPTIONS", @"Determines the size of the board. Values cannot be lower than the minimum line size or higher than 25. On games with deactivated size limit, the blue player will already have set and players cannot set more than two fields away from any previously set field. Also, if the total number of possible fields reaches or exceeds %i, the board will be limited during the game."), MAX_FIELDS];
            break;
        case 2:
            return NSLocalizedString(@"SETTINGS_VIEW_FOOTER_MINIMUM_LINE_SIZE", @"The minimum number of fields in a row for a line. Lines with more than this value will score for additional points. Values range from three to six.");
            break;
        case 3:
            return NSLocalizedString(@"SETTINGS_VIEW_FOOTER_SCORE_MODE", @"If enabled, the game will always end after a set number of turns with the player with a higher score winning.");
            break;
        case 4:
            return NSLocalizedString(@"SETTINGS_VIEW_FOOTER_ADDITIONAL_RED_TURN", @"Allow the second (red) player a chance to counter a line with an additional turn on non-score mode games.");
            break;
        case 5:
            return NSLocalizedString(@"SETTINGS_VIEW_FOOTER_REUSE_LINES", @"Either allow lines to be crossed (but not extended) by any new line or effectively remove fields of a line from the game.");
            break;
        default:
            return @"";
            break;
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

#pragma mark Table view delegate

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
    
    /* code deactivated: nice idea, but won't cooperate with the tap gesture recognizer which dismisses the keyboard again - will be kept for reference if another approach is desired */
//    // activate the keyboard of the cell selected
//    if (indexPath.section == 0 && indexPath.row == 1) {
//        [self.numberOfTurnsTextField becomeFirstResponder];
//    } else if (indexPath.section == 1) {
//        if (indexPath.row == 1) {
//            [self.boardWidthTextField becomeFirstResponder];
//        } else if (indexPath.row == 2) {
//            [self.boardHeightTextField becomeFirstResponder];
//        }
//    } else if (indexPath.section == 2) {
//        [self.minimumForLineTextField becomeFirstResponder];
//    }
}

#pragma mark - Utility

-(void) dismissAllKeyboards
{
    // on a tap anywhere except the navbar and another textfield, this will be called
    [self.boardHeightTextField resignFirstResponder];
    [self.boardWidthTextField resignFirstResponder];
    [self.numberOfTurnsTextField resignFirstResponder];
    [self.minimumForLineTextField resignFirstResponder];
}

#pragma mark - Text field delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField 
{
    // enable navigation items again
    [self.navigationItem setHidesBackButton:NO animated:YES];
    self.navigationItem.rightBarButtonItem.enabled = YES; 
    
    // also reactivate all switches that should be reactivated
    self.limitTurnsSwitch.enabled = YES;
    self.boardLimitSwitch.enabled = YES;
    if (self.limitTurnsSwitch.isOn || self.boardLimitSwitch.isOn)
        self.scoreModeSwitch.enabled = YES;
    if (!self.scoreModeSwitch.isOn)
        self.additionalRedTurnSwitch.enabled = YES;
    self.reuseLineSwitch.enabled = YES;
}

#pragma mark - Interface Builder actions

- (IBAction)keyboardAppeared:(id)sender {
    // deactivate navigation controls if any keyboard is open
    [self.navigationItem setHidesBackButton:YES animated:YES];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    // also deactivate all switches
    self.limitTurnsSwitch.enabled = NO;
    self.boardLimitSwitch.enabled = NO;
    self.scoreModeSwitch.enabled = NO;
    self.additionalRedTurnSwitch.enabled = NO;
    self.reuseLineSwitch.enabled = NO;
}

- (IBAction)numberOfTurnsEditEnd:(id)sender {
    // check for non-zero value, display alert if the value is invalid

    int value = self.numberOfTurnsTextField.text.intValue;
    int numberOfFields = self.boardHeightTextField.text.intValue * self.boardWidthTextField.text.intValue;
    if (value) {
        // good value
        self.numberOfTurnsTextField.text = [NSString stringWithFormat:@"%i", value];
    } else if (!self.limitTurnsSwitch.isOn) {
        // might be bad value before dismissing numpad - correct it. since the turn limit is deactivated prior to dismissing keyboard, don't bother notifying the user (because the itention to deactivate turn limit is clear)
        if (self.boardLimitSwitch)
            self.numberOfTurnsTextField.text = [NSString stringWithFormat:@"%i", numberOfFields];
        else
            self.numberOfTurnsTextField.text = @"100";
    } else {
        // zero value - set default either to maximum on a limited board or 100 (which is bound to change in the future)
        if (self.boardLimitSwitch) {
            NSString *lnotee = NSLocalizedString(@"SETTINGS_VIEW_ALERT_NUMBER_OF_TURNS_EDIT_END_BOARD_LIMITED", @"Please enter a valid value.\nIf a turn limit is not desired, switch it off instead. Defaulting to current maximum (%i).");
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"SETTINGS_VIEW_ALERT_TITLE_INVALID_VALUE", @"Invalid Value") message:[NSString stringWithFormat:lnotee,numberOfFields] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];       
            self.numberOfTurnsTextField.text = [NSString stringWithFormat:@"%i", numberOfFields];
        } else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"SETTINGS_VIEW_ALERT_TITLE_INVALID_VALUE", @"Invalid Value") message:NSLocalizedString(@"SETTINGS_VIEW_ALERT_NUMBER_OF_TURNS_EDIT_END_BOARD_UNLIMITED", @"Please enter a valid value.\nIf a turn limit is not desired, switch it off instead. Defaulting to 100 turns.") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
            self.numberOfTurnsTextField.text = @"100";  
        }
    }
}

- (IBAction)numberOfTurnsEditChanged:(id)sender {
    // also check for correct input here: catch numbers too high before they are set
    int numberOfFields = self.boardHeightTextField.text.intValue * self.boardWidthTextField.text.intValue;
    // only alert if value too high (to avoid displaying alerts if the user deletes the current value (check for too low/no value in ...EditEnd)
    if (self.numberOfTurnsTextField.text.intValue > numberOfFields && self.boardLimitSwitch.isOn) {
        NSString *lnotec = NSLocalizedString(@"SETTINGS_VIEW_ALERT_NUMBER_OF_TURNS_EDIT_CHANGED_BOARD_LIMITED", @"The value is too high. Make sure it does not exceed the current number of fields, which is %i.");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"SETTINGS_VIEW_ALERT_TITLE_VALUE_TOO_HIGH", @"Value Too High") message:[NSString stringWithFormat:lnotec,numberOfFields] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        self.numberOfTurnsTextField.text = [NSString stringWithFormat:@"%i", numberOfFields];
    } else if (self.numberOfTurnsTextField.text.intValue > MAX_FIELDS && !self.boardLimitSwitch.isOn) {
        // alert if the value exceeds MAX_FIELDS on a no-limit board
        NSString *lnotec = NSLocalizedString(@"SETTINGS_VIEW_ALERT_NUMBER_OF_TURNS_EDIT_CHANGED_BOARD_UNLIMITED", @"The value is too high. Make sure it does not exceed %i.");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"SETTINGS_VIEW_ALERT_TITLE_VALUE_TOO_HIGH", @"Value Too High") message:[NSString stringWithFormat:lnotec,MAX_FIELDS] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        self.numberOfTurnsTextField.text = [NSString stringWithFormat:@"%i", MAX_FIELDS];
    }
}

- (IBAction)minimumForLineEditEnd:(id)sender {
    // check for valid value, display alert if the value is invalid (less than 3)
    
    int value = self.minimumForLineTextField.text.intValue;
    if (value >= 3) {
        // good value
        self.minimumForLineTextField.text = [NSString stringWithFormat:@"%i", value];
        // auto-adjust board size and turn limit if necessary, display a alert with changes
        int oldWidth = self.boardWidthTextField.text.intValue;
        int oldHeight = self.boardHeightTextField.text.intValue;
        NSString *widthChange = @"";
        NSString *heightChange = @"";
        BOOL somethingChanged = NO;
        if (oldWidth < value) {
            // no need to explain anything on an unlimited board
            self.boardWidthTextField.text = [NSString stringWithFormat:@"%i",value];
            if (self.boardLimitSwitch.isOn) {
                somethingChanged = YES;
                NSString *lwc = NSLocalizedString(@"SETTINGS_VIEW_ALERT_MINIMUM_FOR_LINE_EDIT_END_BOARD_WIDTH_CHANGE", @"Changed board width from %i to %i.\n");
                widthChange = [NSString stringWithFormat:lwc,oldWidth,value];
            }
        }
        if (oldHeight < value) {
            self.boardHeightTextField.text = [NSString stringWithFormat:@"%i",value];
            if (self.boardLimitSwitch.isOn) {
                somethingChanged = YES;
                NSString *lhc = NSLocalizedString(@"SETTINGS_VIEW_ALERT_MINIMUM_FOR_LINE_EDIT_END_BOARD_HEIGHT_CHANGE", @"Changed board height from %i to %i.\n");
                heightChange = [NSString stringWithFormat:lhc,oldHeight,value];
            }
        }
        if (somethingChanged) {
            // display alert
            NSString *lmfleeaa = NSLocalizedString(@"SETTINGS_VIEW_ALERT_MINIMUM_FOR_LINE_EDIT_END_AUTO-ADJUSTMENT", @"Setting the minimum line size to %i triggered the following adjustments:\n\n%@%@");
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"SETTINGS_VIEW_ALERT_TITLE_AUTO-ADJUSTMENT", @"Auto-adjustment") message:[NSString stringWithFormat:lmfleeaa,value,widthChange,heightChange] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    } else {
        // too small value - feedback for user
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"SETTINGS_VIEW_ALERT_TITLE_INVALID_VALUE", @"Invalid Value") message:NSLocalizedString(@"SETTINGS_VIEW_ALERT_MINIMUM_FOR_LINE_EDIT_END_INVALID_VALUE", @"Please enter a value between three and six.\nDefaulting to minimum (three).") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release]; 
        
        self.minimumForLineTextField.text = @"3";
    }
}

- (IBAction)minimumForLineEditChanged:(id)sender {
    // also check for correct input here - values bigger than 6 will be capped to 6
    
    int value = self.minimumForLineTextField.text.intValue;
    if (value > 6) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"SETTINGS_VIEW_ALERT_TITLE_VALUE_TOO_HIGH", @"Value Too High") message:NSLocalizedString(@"SETTINGS_VIEW_ALERT_MINIMUM_FOR_LINE_EDIT_CHANGED", @"Please enter a value between three and six.\nDefaulting to maximum (six).\nAuto-adjusting board size if necessary.") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release]; 
        
        self.minimumForLineTextField.text = @"6";
        
        //auto-adjusting board dimensions and turn limit if necessary
        if (self.boardWidthTextField.text.intValue < 6)
            self.boardWidthTextField.text = @"6";
        if (self.boardHeightTextField.text.intValue < 6) 
            self.boardHeightTextField.text = @"6";
        if (self.numberOfTurnsTextField.text.intValue > 36 && self.limitTurnsSwitch.isOn) {
            self.numberOfTurnsTextField.text = @"36";
        }
    }
}

- (IBAction)boardLimitChanged:(id)sender {
    // disables the text field for both board size text fields or re-enables them
    if (self.boardLimitSwitch.isOn) {
        self.boardWidthCell.textLabel.enabled = YES;
        self.boardWidthTextField.enabled = YES;
        self.boardWidthTextField.textColor = [UIColor blueColor];
        
        self.boardHeightCell.textLabel.enabled = YES;
        self.boardHeightTextField.enabled = YES;
        self.boardHeightTextField.textColor = [UIColor blueColor];
        
        // re-enable option for score mode
        self.scoreModeCell.textLabel.enabled = YES;
        self.scoreModeSwitch.enabled = YES;
        [self performSelector:@selector(scoreModeChanged:)];
        
        // if we had a big turn limit, set it to maximum possible
        int maxTurns = self.boardWidthTextField.text.intValue * self.boardHeightTextField.text.intValue;
        if (self.numberOfTurnsTextField.text.intValue > maxTurns) {
            self.numberOfTurnsTextField.text = [NSString stringWithFormat:@"%i",maxTurns];
            // only notify if a turn limit is desired (but change anyway)
            if (self.limitTurnsSwitch.isOn) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SETTINGS_VIEW_ALERT_TITLE_AUTO-ADJUSTMENT", @"Auto-adjustment") message:[NSString stringWithFormat:NSLocalizedString(@"SETTINGS_VIEW_ALERT_BOARD_LIMIT_SWITCHED_ON", @"Automatically set the number of turns to current maximum (%i)."), maxTurns] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
        }
    } else {
        self.boardWidthCell.textLabel.enabled = NO;
        self.boardWidthTextField.enabled = NO;
        self.boardWidthTextField.textColor = [UIColor grayColor];
        
        self.boardHeightCell.textLabel.enabled = NO;
        self.boardHeightTextField.enabled = NO;
        self.boardHeightTextField.textColor = [UIColor grayColor];
        
        // if limit turns is also off, deactivate score mode
        if (!self.limitTurnsSwitch.isOn) {
            self.scoreModeSwitch.on = NO;
            self.scoreModeSwitch.enabled= NO;
            self.scoreModeCell.textLabel.enabled = NO;
            [self performSelector:@selector(scoreModeChanged:)];
        }
    }
}

- (IBAction)boardWidthEditEnd:(id)sender {
    // check for valid value, display alert if the value is invalid
    
    int value = self.boardWidthTextField.text.intValue;
    int minimum = self.minimumForLineTextField.text.intValue;
    BOOL alreadyNotifed = NO;
    if (value >= minimum) {
        // good value
        self.boardWidthTextField.text = [NSString stringWithFormat:@"%i", value];
    } else if (!self.boardLimitSwitch.isOn) {
        // might be bad value before dismissing numpad - correct it. since the board limit is deactivated prior to dismissing (if the user dismisses numpad by switching off board limit), don't bother notifying the user because the intention to deactivate board limit is clear and the values do not matter as much
        self.boardWidthTextField.text = [NSString stringWithFormat:@"%i", minimum];
    } else {
        // invalid value - feedback for user
        NSString *lbweeiv = NSLocalizedString(@"SETTINGS_VIEW_ALERT_BOARD_WIDTH_EDIT_END_INVALID_VALUE", @"Please enter a value equal or greater than the minimum line size.\nIf you do not want the board to be of set size, switch the limiter off instead. Defaulting to current minimum (%i).\nAuto-adjusting turn limit if necessary.");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"SETTINGS_VIEW_ALERT_TITLE_INVALID_VALUE", @"Invalid Value") message:[NSString stringWithFormat:lbweeiv,minimum] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        //set this, so we don't show the other alert as well
        alreadyNotifed = YES;
        
        self.boardWidthTextField.text = [NSString stringWithFormat:@"%i", minimum];
    }
    //auto-adjusting turn limit if necessary, display notification if no alert was shown before
    if (self.numberOfTurnsTextField.text.intValue > self.boardWidthTextField.text.intValue * self.boardHeightTextField.text.intValue && self.boardLimitSwitch.isOn) {
        self.numberOfTurnsTextField.text = [NSString stringWithFormat:@"%i", self.boardWidthTextField.text.intValue * self.boardHeightTextField.text.intValue];
        if (!alreadyNotifed && self.limitTurnsSwitch.isOn) {
            NSString *lbweeaa = NSLocalizedString(@"SETTINGS_VIEW_ALERT_BOARD_WIDTH_EDIT_END_AUTO-ADJUSTMENT", @"Changing the board width has made it necessary to adjust the number of turns to the new maximum value of %i.");
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"SETTINGS_VIEW_ALERT_TITLE_AUTO-ADJUSTMENT", @"Auto-adjustment") message:[NSString stringWithFormat:lbweeaa,self.numberOfTurnsTextField.text.intValue] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }
}

- (IBAction)boardWidthEditChanged:(id)sender {
    // also check for correct input here - catch & handle values that are too high
    int value = self.boardWidthTextField.text.intValue;
    // only alert if value too high (to avoid displaying alerts if the user deletes the current value (check for too low/no value in ...EditEnd)
    if (value > 25) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"SETTINGS_VIEW_ALERT_TITLE_VALUE_TOO_HIGH", @"Value Too High") message:NSLocalizedString(@"SETTINGS_VIEW_ALERT_BOARD_WIDTH_EDIT_CHANGED", @"The value is too high. Make sure it does not exceed the maximum, which is 25.") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        self.boardWidthTextField.text = @"25";
    }
}

- (IBAction)boardHeightEditEnd:(id)sender {
    // check for non-zero value, display alert if the value is invalid
    
    int value = self.boardHeightTextField.text.intValue;
    int minimum = self.minimumForLineTextField.text.intValue;
    BOOL alreadyNotifed = NO;
    if (value >= minimum) {
        // good value
        self.boardHeightTextField.text = [NSString stringWithFormat:@"%i", value];
        
    } else if (!self.boardLimitSwitch.isOn) {
        self.boardHeightTextField.text = [NSString stringWithFormat:@"%i", minimum];
    } else {
        // invalid value - feedback for user
        NSString *lbheeiv = NSLocalizedString(@"SETTINGS_VIEW_ALERT_BOARD_WIDTH_EDIT_END_INVALID_VALUE", @"Please enter a value equal or greater than the minimum line size.\nIf you do not want the board to be of set size, switch the limiter off instead. Defaulting to current minimum (%i).\nAuto-adjusting turn limit if necessary.");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"SETTINGS_VIEW_ALERT_TITLE_INVALID_VALUE", @"Invalid Value") message:[NSString stringWithFormat:lbheeiv,minimum] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        //set this, so we don't show the other alert as well
        alreadyNotifed = YES;
        
        self.boardHeightTextField.text = [NSString stringWithFormat:@"%i", minimum];
    }
    //auto-adjusting turn limit if necessary, display notification if no alert was shown before
    if (self.numberOfTurnsTextField.text.intValue > self.boardHeightTextField.text.intValue * self.boardWidthTextField.text.intValue && self.boardLimitSwitch.isOn) {
        self.numberOfTurnsTextField.text = [NSString stringWithFormat:@"%i", self.boardHeightTextField.text.intValue * self.boardWidthTextField.text.intValue];
        if (!alreadyNotifed && self.limitTurnsSwitch.isOn && self.boardLimitSwitch.isOn) {
            NSString *lbheeaa = NSLocalizedString(@"SETTINGS_VIEW_ALERT_BOARD_WIDTH_EDIT_END_AUTO-ADJUSTMENT", @"Changing the board width has made it necessary to adjust the number of turns to the new maximum value of %i.");
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"SETTINGS_VIEW_ALERT_TITLE_AUTO-ADJUSTMENT", @"Auto-adjustment") message:[NSString stringWithFormat:lbheeaa,self.numberOfTurnsTextField.text.intValue] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }
}

- (IBAction)boardHeightEditChanged:(id)sender {
    // also check for correct input here - catch & handle values that are too high
    int value = self.boardHeightTextField.text.intValue;
    if (value > 25) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"SETTINGS_VIEW_ALERT_TITLE_VALUE_TOO_HIGH", @"Value Too High") message:NSLocalizedString(@"SETTINGS_VIEW_ALERT_BOARD_HEIGHT_EDIT_CHANGED", @"The value is too high. Make sure it does not exceed the maximum, which is 25.") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        self.boardHeightTextField.text = @"25";
    }
}

- (IBAction)limitTurnsChanged:(id)sender {
    // disables the text field for number of turns if off. re-enables them if on.
    if (self.limitTurnsSwitch.isOn) {
        self.numberOfTurnsCell.textLabel.enabled = YES;
        self.numberOfTurnsTextField.enabled = YES;
        self.numberOfTurnsTextField.textColor = [UIColor blueColor];
        
        // re-enable option for score mode
        self.scoreModeCell.textLabel.enabled = YES;
        self.scoreModeSwitch.enabled = YES;
        [self performSelector:@selector(scoreModeChanged:)];
        
        // if number of turns was zero or higher than maximum, set it to / cap it at maximum
        int numberOfTurns = self.numberOfTurnsTextField.text.intValue;
        int maximum = self.boardWidthTextField.text.intValue * self.boardHeightTextField.text.intValue;
        if (!numberOfTurns || (numberOfTurns > maximum && self.boardLimitSwitch.isOn)) {
            self.numberOfTurnsTextField.text = [NSString stringWithFormat:@"%i",maximum];
        } else if (!numberOfTurns && !self.boardLimitSwitch.isOn) {
            // if number of turns was zero but the board is unlimited, we need to set a valid value
            // temporary fix: if we know the hardware maximum number of fields (bottlenecked by available memory), set it to that value
            self.numberOfTurnsTextField.text = @"100";
        }
    } else {
        self.numberOfTurnsCell.textLabel.enabled = NO;
        self.numberOfTurnsTextField.enabled = NO;
        self.numberOfTurnsTextField.textColor = [UIColor grayColor];
        
        // if limit board size is also off, deactivate score mode
        if (!self.boardLimitSwitch.isOn) {
            self.scoreModeSwitch.on = NO;
            self.scoreModeSwitch.enabled= NO;
            self.scoreModeCell.textLabel.enabled = NO;
            [self performSelector:@selector(scoreModeChanged:)];
        }
    }
}

- (IBAction)scoreModeChanged:(id)sender {
    // sets availability of additional turns option depending on status
    if (self.scoreModeSwitch.isOn) {
        // deactivate additional turn if we play for points
        self.additionalRedTurnCell.textLabel.enabled = NO;
        self.additionalRedTurnSwitch.on = NO;
        self.additionalRedTurnSwitch.enabled = NO;
    } else {
        // otherwise, (re-)enable it
        self.additionalRedTurnCell.textLabel.enabled = YES;
        self.additionalRedTurnSwitch.enabled = YES;       
    }
}

#pragma mark - Start game

- (void) startGame {
    // create rules, start a new game and tell the navigation controller to display it
    
    // dismiss the numpads first
    [self dismissAllKeyboards];
    
    // if no turn limit, override value in the text field with maximum - if also no board limit, set turn limit to zero
    int turns = self.numberOfTurnsTextField.text.intValue;
    if (!self.limitTurnsSwitch.isOn)
        if (!self.boardLimitSwitch.isOn)
        turns = 0;
    else
        turns = self.boardWidthTextField.text.intValue * self.boardHeightTextField.text.intValue;
    
    // if no board size, set bool to yes, size to zero
    BOOL extendable = NO;
    CGSize boardSize = CGSizeMake(self.boardWidthTextField.text.intValue, self.boardHeightTextField.text.intValue);
    if (!self.boardLimitSwitch.isOn) {
        extendable = YES;
        boardSize = CGSizeZero;
    }
    // create the rules, the game, retain it by setter and display new game
    // TODO (low priority) adjust the rest of the code to use "scoreMode" instead of "survivalMode" for continuity
    Rules *customRules = [[Rules alloc] initWithMinFieldsForLine:self.minimumForLineTextField.text.intValue numberOfTurns:turns extendableBoard:extendable survivalMode:!self.scoreModeSwitch.isOn additionalRedTurn:self.additionalRedTurnSwitch.isOn reuseOfLines:self.reuseLineSwitch.isOn];
    Game *newGame = [[Game alloc]initInMode:CUSTOM_GAME withBoardSize:boardSize];
    newGame.gameData.rules = customRules;
    self.mvc.currentGame = newGame;
    [customRules release];
    [newGame release];
    
    [self.navigationController pushViewController:self.mvc.currentGame.gameViewController animated:YES];
}

@end