//
//  MainViewController.m
//  TechTacToe-ah
//
//  Created by andreas on 29/09/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "SettingsViewController.h"
#import "AboutViewController.h"
#import "LoadViewController.h"

@implementation MainViewController

@synthesize currentGame=_currentGame;

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
    [_currentGame release];
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
    // set the title of the navbar and the title of the back button
    self.navigationItem.title = NSLocalizedString(@"MAIN_VIEW_TITLE", @"TechTacToe - Main Menu");
    UIBarButtonItem *tempButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"BACK_BUTTON", @"Back") style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = tempButton;
    [tempButton release];
    
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
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
    // disables the contiune cell if no running game is present or enables it if there is
    if (self.currentGame) {
        [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]].textLabel.enabled = YES;
        [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]] setSelectionStyle:UITableViewCellSelectionStyleBlue];
    } else {
        [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]].textLabel.enabled = NO;
        [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]] setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    if (section == 2) {
        return 1;
    } else if (section == 1) {
        return 2;
    } else {
        return 4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    // new default game cell
                    cell.textLabel.text = NSLocalizedString(@"MAIN_VIEW_CELL_DEFAULT_SETTINGS", @"Default Settings");
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                case 1:
                    // new tictactoe game cell
                    cell.textLabel.text = NSLocalizedString(@"MAIN_VIEW_CELL_TICTACTOE", @"TicTacToe");
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                case 2:
                    // new gomoku game cell
                    cell.textLabel.text = NSLocalizedString(@"MAIN_VIEW_CELL_GOMOKU", @"Gomoku");
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                case 3:
                    // new custom game cell
                    cell.textLabel.text = NSLocalizedString(@"MAIN_VIEW_CELL_CUSTOMIZED_GAME", @"Customized Game");
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    // continue cell
                    cell.textLabel.text = NSLocalizedString(@"MAIN_VIEW_CELL_CONTINUE", @"Continue");
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                case 1:
                    // load game cell
                    cell.textLabel.text = NSLocalizedString(@"MAIN_VIEW_CELL_LOAD", @"Load Game");
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                default:
                    break;
            }
            break;
        case 2:
            // about screen cell
            cell.textLabel.text = NSLocalizedString(@"MAIN_VIEW_CELL_ABOUT", @"About");
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        default:
            break;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return NSLocalizedString(@"MAIN_VIEW_HEADER_START_NEW_GAME", @"New Game");
            break;
        case 1:
            return NSLocalizedString(@"MAIN_VIEW_HEADER_ONGOING_GAMES", @"Ongoing Games");
            break;
        case 2:
            return @" ";
            break;
        default:
            break;
    }
    return @"";
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
    
    // navigate to game (skip over the settings screen), load/continue, settings or about screen
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            // new default game cell
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            Game *newGame = [[Game alloc]initInMode:DEFAULT_GAME withBoardSize:CGSizeMake(0, 0) withCustomRules:nil];
            self.currentGame = newGame;
            [newGame release];
            [self.navigationController pushViewController:self.currentGame.gameViewController animated:YES];
        } else if (indexPath.row == 1) {
             // new tictactoe game cell
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            Game *newGame = [[Game alloc]initInMode:TICTACTOE withBoardSize:CGSizeMake(3, 3) withCustomRules:nil];
            self.currentGame = newGame;
            [newGame release];
            [self.navigationController pushViewController:self.currentGame.gameViewController animated:YES];  
        } else if (indexPath.row == 2) {
            // new gomoku game cell
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            Game *newGame = [[Game alloc]initInMode:GOMOKU withBoardSize:CGSizeMake(19, 19) withCustomRules:nil];
            self.currentGame = newGame;
            [newGame release];
            [self.navigationController pushViewController:self.currentGame.gameViewController animated:YES];
        } else if (indexPath.row == 3) {
            // new custom game cell
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            SettingsViewController *settings = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
            [self.navigationController pushViewController:settings animated:YES];
            settings.mvc = self;
            [settings release];
        }    
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            // continue running game
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            if (self.currentGame) {
                [self.navigationController pushViewController:self.currentGame.gameViewController animated:YES];
            }
        } else if (indexPath.row == 1) {
            // load game from file
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            LoadViewController *loadView = [[LoadViewController alloc] initWithNibName:@"LoadViewController" bundle:nil];
            [self.navigationController pushViewController:loadView animated:YES];
            loadView.mvc = self;
            [loadView release];
        }
    } else if (indexPath.section == 2) {
        // TODO: fill about view with content
        // about screen with information about the app
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        AboutViewController *aboutView = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
        [self.navigationController pushViewController:aboutView animated:YES];
        [aboutView release];
    }
}

@end
