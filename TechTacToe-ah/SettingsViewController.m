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

// TODO (low priority): remove the rest of the old approach with textfields: replace textfields and cells with Value1 style cells, rewrite the whole class to use cell identifiers instead of a .xib file, removing memory overhead and speeding up the settings menu a bit

#import "SettingsViewController.h"
#import "SettingsPickerViewController.h"
#import "BluetoothDataHandler.h"

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
@synthesize playerSelectionCell;
@synthesize playerColorTextField;
@synthesize appDelegate;
@synthesize activeGameAlert31;

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
    [playerSelectionCell release];
    [playerSelectionSwitch release];
    [appDelegate release];
    [activeGameAlert31 release];
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
    self.appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
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
    self.playerSelectionCell.textLabel.text = NSLocalizedString(@"SETTINGS_VIEW_CELL_PLAYER_COLOR", @"Local Player is Blue");
    self.playerSelectionCell.accessoryView = self.playerColorTextField;
    
    // code disabled so we can choose the local player even on a hotseat game, because if you can save it and load it as a Bluetooth game later, you should be able to choose player colors
//    // disable the Bluetooth options if we don't have a Bluetooth game
//    if (!self.mvc.dataHandler.currentSession) {
//        self.playerSelectionCell.textLabel.enabled = NO;
//        self.playerSelectionSwitch.enabled = NO;
//    }
    
    // set up the background view
    NSString *path = [[NSBundle mainBundle]pathForResource:@"ImagePaths" ofType:@"plist"];
    NSDictionary *plist = [[NSDictionary alloc] initWithContentsOfFile:path];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[plist objectForKey:@"main view background"]]];
    [plist release];
    
    UIAlertView *alert31 = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"NEW_GAME_ALERT_ACTIVE_GAME_TITLE", @"Active Game Found") message:NSLocalizedString(@"NEW_GAME_ALERT_ACTIVE_GAME_MESSAGE", @"There is already an active game running. Abort active game and start a new game?") delegate:self cancelButtonTitle:NSLocalizedString(@"CANCEL", @"Cancel") otherButtonTitles:NSLocalizedString(@"OK", @"OK"),nil];
    alert31.tag = 31;
    self.activeGameAlert31 = alert31;
    [alert31 release];
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
    [self setPlayerSelectionCell:nil];
    [self setPlayerColorTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.tintColor = [UIColor grayColor];
    
    //Load values and set Interface according to them
    self.limitTurnsSwitch.on = self.appDelegate.turnLimit;
    self.numberOfTurnsTextField.text = [NSString stringWithFormat:@"%i", self.appDelegate.turnLimitNumber];
    self.boardLimitSwitch.on = self.appDelegate.boardSizeLimit;
    self.boardWidthTextField.text = [NSString stringWithFormat:@"%i", self.appDelegate.boardSizeWidth];
    self.boardHeightTextField.text = [NSString stringWithFormat:@"%i", self.appDelegate.boardSizeHeight];
    self.minimumForLineTextField.text = [NSString stringWithFormat:@"%i", self.appDelegate.minimumLineSize];
    self.scoreModeSwitch.on = self.appDelegate.scoreMode;
    self.additionalRedTurnSwitch.on = self.appDelegate.additionalRedTurn;
    self.reuseLineSwitch.on = self.appDelegate.reuseLines;
    if (self.appDelegate.localPlayerColorBlue)
    {
        self.playerColorTextField.textColor = [UIColor blueColor];
        self.playerColorTextField.text = NSLocalizedString(@"AICOLOR_BLUE","blue");
    }
    else
    {
        self.playerColorTextField.textColor = [UIColor redColor];
        self.playerColorTextField.text = NSLocalizedString(@"AICOLOR_RED","red");
    }
    // check for invalid settings combinations we might have got from the picker view and correct them
    // minimum line size might change the board size:
    int value = self.minimumForLineTextField.text.intValue;
    int oldWidth = self.boardWidthTextField.text.intValue;
    int oldHeight = self.boardHeightTextField.text.intValue;
    if (oldWidth < value) {
        self.boardWidthTextField.text = [NSString stringWithFormat:@"%i",value];
    }
    if (oldHeight < value) {
        self.boardHeightTextField.text = [NSString stringWithFormat:@"%i",value];
    }
    // (maybe already changed) board size might change the turn limit:
    if (self.numberOfTurnsTextField.text.intValue > self.boardHeightTextField.text.intValue * self.boardWidthTextField.text.intValue && self.boardLimitSwitch.isOn) {
        self.numberOfTurnsTextField.text = [NSString stringWithFormat:@"%i", self.boardHeightTextField.text.intValue * self.boardWidthTextField.text.intValue];
    }
    
    [super viewWillAppear:animated];
    
    [self performSelector:@selector(boardLimitChanged:)];
    [self performSelector:@selector(limitTurnsChanged:)];
    [self performSelector:@selector(scoreModeChanged:)];
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
    self.appDelegate.turnLimit = self.limitTurnsSwitch.on;
    self.appDelegate.turnLimitNumber = self.numberOfTurnsTextField.text.intValue;
    self.appDelegate.boardSizeLimit = self.boardLimitSwitch.on;
    self.appDelegate.boardSizeWidth = self.boardWidthTextField.text.intValue;
    self.appDelegate.boardSizeHeight = self.boardHeightTextField.text.intValue;
    self.appDelegate.minimumLineSize = self.minimumForLineTextField.text.intValue;
    self.appDelegate.scoreMode = self.scoreModeSwitch.on;
    self.appDelegate.additionalRedTurn = self.additionalRedTurnSwitch.on;
    self.appDelegate.reuseLines = self.reuseLineSwitch.on;
    if ([self.playerColorTextField.text isEqualToString:NSLocalizedString(@"AICOLOR_BLUE", "blue")])
    {
        self.appDelegate.localPlayerColorBlue = YES;
    }
    else
    {
        self.appDelegate.localPlayerColorBlue = NO;
    }
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
    // Return YES for supported orientations
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 7;
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
        case 6:
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
        case 6:
            return self.playerSelectionCell;
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
        case 6:
            return NSLocalizedString(@"SETTINGS_VIEW_HEADER_BLUETOOTH_GAME_OPTIONS", @"Bluetooth Game Options");
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
        case 6:
            return NSLocalizedString(@"SETTINGS_VIEW_FOOTER_PLAYER_SELECTION", @"On a Bluetooth game, set if the player on this device will be the blue player or the red player. Also, if a game was started locally, saved and loaded as a Bluetooth game later, the player on this device will be this color.");
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
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // create and display a picker depending on cell clicked
    SettingsPickerViewController *pickerView;
    if (indexPath.section == 0 && indexPath.row == 1 && self.limitTurnsSwitch.isOn) {
        pickerView = [[SettingsPickerViewController alloc] initWithPickerID:NUMBER_OF_TURNS];
        [self.navigationController pushViewController:pickerView animated:YES];
        [pickerView release];
    } else if (indexPath.section == 1 && self.boardLimitSwitch.isOn) {
        if (indexPath.row == 1) {
            pickerView = [[SettingsPickerViewController alloc] initWithPickerID:BOARD_WIDTH];
            [self.navigationController pushViewController:pickerView animated:YES];
            [pickerView release];
        } else if (indexPath.row == 2) {
            pickerView = [[SettingsPickerViewController alloc] initWithPickerID:BOARD_HEIGHT];
            [self.navigationController pushViewController:pickerView animated:YES];
            [pickerView release];
        }
    } else if (indexPath.section == 2) {
        pickerView = [[SettingsPickerViewController alloc] initWithPickerID:MINIMUM_LINE_SIZE];
        [self.navigationController pushViewController:pickerView animated:YES];
        [pickerView release];
    }
    else if (indexPath.section == 6)
    {
        pickerView = [[SettingsPickerViewController alloc] initWithPickerID:PLAYER_COLOR];
        [self.navigationController pushViewController:pickerView animated:YES];
        [pickerView release];
    }
}

#pragma mark - Interface Builder actions

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
        
        // set cells' selection style to blue
        [self.boardWidthCell setSelectionStyle:UITableViewCellSelectionStyleBlue];
        [self.boardHeightCell setSelectionStyle:UITableViewCellSelectionStyleBlue];
        
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
        
        // set cells' selection style to none
        [self.boardWidthCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self.boardHeightCell setSelectionStyle:UITableViewCellSelectionStyleNone];
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
        
        // enable blue cell selection style
        [self.numberOfTurnsCell setSelectionStyle:UITableViewCellSelectionStyleBlue];
        
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
        
        // also deactivate blue cell selection
        [self.numberOfTurnsCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 31)
    {
        if (buttonIndex != [alertView cancelButtonIndex])
        {
            self.appDelegate.currentGame = Nil;
            [self startGame];
        }
    }
}

#pragma mark - Start game

- (void) startGame {
    
    if (self.appDelegate.currentGame && !self.appDelegate.currentGame.gameData.gameOver)
    {
        if (self.appDelegate.btdh.currentSession && self.appDelegate.needsAck)
        {
            [self.appDelegate.currentGame.gameViewController.backToMenuReqView show];
            self.appDelegate.menuReqType = 3;
            return;
        }
        else
        {
            [self.activeGameAlert31 show];
            return;
        }
    }
    // create rules, start a new game and tell the navigation controller to display it
    
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
    Rules *customRules = [[Rules alloc] initWithMinFieldsForLine:self.minimumForLineTextField.text.intValue numberOfTurns:turns extendableBoard:extendable scoreMode:self.scoreModeSwitch.isOn additionalRedTurn:self.additionalRedTurnSwitch.isOn reuseOfLines:self.reuseLineSwitch.isOn];
    Game *newGame = [[Game alloc]initInMode:CUSTOM_GAME withBoardSize:boardSize];
    newGame.gameData.rules = customRules;
//    newGame.gameData.localPlayerBlue = self.playerSelectionSwitch.isOn;
    if ([self.playerColorTextField.text isEqualToString:NSLocalizedString(@"AICOLOR_BLUE", "blue")])
    {
        newGame.gameData.localPlayerBlue = YES;
    }
    else
    {
        newGame.gameData.localPlayerBlue = NO;
    }
    self.appDelegate.currentGame = newGame;
    [customRules release];
    [newGame release];
    
    // on a Bluetooth game, send game data to the opponent and set the data handler for the game view controller
    if (self.appDelegate.btdh.currentSession) {
        [self.appDelegate.btdh transmitCurrentGameData];
        self.appDelegate.currentGame.gameViewController.btDataHandler = self.appDelegate.btdh;
    }
    self.appDelegate.needsAck = YES;
    //[self.navigationController pushViewController:self.appDelegate.currentGame.gameViewController animated:YES];
    [self.appDelegate startGame];
}

@end
