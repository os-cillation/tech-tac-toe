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
@synthesize dataHandler=_dataHandler;
@synthesize bluetoothIndicator=_bluetoothIndicator;

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
    [_dataHandler release];
    [_bluetoothIndicator release];
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
    
    // get image for bluetooth button (freeware, commercial use allowed)
    NSString *path = [[NSBundle mainBundle]pathForResource:@"ImagePaths" ofType:@"plist"];
    NSDictionary *plist = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    UIImageView *bluetoothImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[plist objectForKey:@"bluetooth icon"]]];
    self.bluetoothIndicator = bluetoothImageView;
    self.bluetoothIndicator.frame = CGRectMake(0, 0, 32, 32);
    [bluetoothImageView release];
    
    UIBarButtonItem *btIcon = [[UIBarButtonItem alloc] initWithCustomView:bluetoothImageView];
    self.navigationItem.leftBarButtonItem = btIcon;
    
    [btIcon release];
    [plist release];
    
    // make a data handler if none exists
    if (!self.dataHandler) {
        BluetoothDataHandler *btdh = [BluetoothDataHandler new];
        self.dataHandler = btdh;
        self.dataHandler.mvc = self;
        [btdh release];
    }
    
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
    self.bluetoothIndicator = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    // reset nav bar color
    self.navigationController.navigationBar.tintColor = nil;
    
    // hide or show bluetooth icon
    if (self.dataHandler.currentSession) {
        self.bluetoothIndicator.hidden = NO;
    } else
        self.bluetoothIndicator.hidden = YES;
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    // disables the contiune cell if no running game is present or we have a bluetooth game or enables it otherwise
    if (self.currentGame && !self.dataHandler.currentSession) {
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
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    
    // section 0: 4
    // section 1: 2
    // section 2: 2
    // section 3: 1
    if (section == 3) {
        return 1;
    } else if (section == 1 || section == 2) {
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
    
    static NSString *DetailCellIdentifier = @"DetailCell";
    
    UITableViewCell *detailCell = [tableView dequeueReusableCellWithIdentifier:DetailCellIdentifier];
    if (detailCell == nil) {
        detailCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:DetailCellIdentifier] autorelease];
    }
    
    // Configure the cell...
    cell.textLabel.enabled = YES;
    [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    detailCell.textLabel.enabled = YES;
    [detailCell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    // new default game cell
                    cell.textLabel.text = NSLocalizedString(@"MAIN_VIEW_CELL_DEFAULT_SETTINGS", @"Default Settings");
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    // if a session exists and we are not server, disable every cell except to disconnect
                    if (self.dataHandler.currentSession && !self.dataHandler.doesLocalUserActAsServer) {
                        cell.textLabel.enabled = NO;
                        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    } 
                    break;
                case 1:
                    // new tictactoe game cell
                    cell.textLabel.text = NSLocalizedString(@"MAIN_VIEW_CELL_TICTACTOE", @"TicTacToe");
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    if (self.dataHandler.currentSession && !self.dataHandler.doesLocalUserActAsServer) {
                        cell.textLabel.enabled = NO;
                        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    }
                    break;
                case 2:
                    // new gomoku game cell
                    cell.textLabel.text = NSLocalizedString(@"MAIN_VIEW_CELL_GOMOKU", @"Gomoku");
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    if (self.dataHandler.currentSession && !self.dataHandler.doesLocalUserActAsServer) {
                        cell.textLabel.enabled = NO;
                        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    }
                    break;
                case 3:
                    // new custom game cell
                    cell.textLabel.text = NSLocalizedString(@"MAIN_VIEW_CELL_CUSTOMIZED_GAME", @"Customized Game");
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    if (self.dataHandler.currentSession && !self.dataHandler.doesLocalUserActAsServer) {
                        cell.textLabel.enabled = NO;
                        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    }
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
                    // don't ever continue on bluetooth games - save and load instead
                    if (self.dataHandler.currentSession || !self.currentGame) {
                        cell.textLabel.enabled = NO;
                        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    }
                    break;
                case 1:
                    // load game cell
                    cell.textLabel.text = NSLocalizedString(@"MAIN_VIEW_CELL_LOAD", @"Load Game");
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    if (self.dataHandler.currentSession && !self.dataHandler.doesLocalUserActAsServer) {
                        cell.textLabel.enabled = NO;
                        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    }
                    break;
                default:
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                    // connect/disconnect to/from bluetooth
                    if (!self.dataHandler.currentSession) {
                        cell.textLabel.text = NSLocalizedString(@"MAIN_VIEW_CELL_CONNECT", @"Connect Via Bluetooth");
                    } else {
                        cell.textLabel.text = NSLocalizedString(@"MAIN_VIEW_CELL_DISCONNECT", @"Disconnect");
                    }
                    break;
                case 1:
                    // revoke control and give it to the other device
                    // special cell - only one, so configure AND return it here
                    detailCell.textLabel.text = NSLocalizedString(@"MAIN_VIEW_CELL_REVOKE_CONTROL", @"Pass Game Control To:");
                    detailCell.detailTextLabel.text = @" ";
                    if (self.dataHandler.currentSession) {
                        NSString *peerID = [[self.dataHandler.currentSession peersWithConnectionState:GKPeerStateConnected] objectAtIndex:0];
                        NSString *peerName = [self.dataHandler.currentSession displayNameForPeer:peerID];
                        detailCell.detailTextLabel.text = peerName;
                    }
                    if (!self.dataHandler.currentSession || !self.dataHandler.doesLocalUserActAsServer) {
                        detailCell.textLabel.enabled = NO;
                        [detailCell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    }
                    return detailCell;
                    break;
                default:
                    break;
            }
            break;
        case 3:
            // about screen cell
            cell.textLabel.text = NSLocalizedString(@"MAIN_VIEW_CELL_ABOUT", @"About");
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if (self.dataHandler.currentSession && !self.dataHandler.doesLocalUserActAsServer) {
                cell.textLabel.enabled = NO;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
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
            return @"Bluetooth";
            break;
        case 3:
            return @" ";
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
            // if a session exists and we are not server, disable every cell except to disconnect
            if (self.dataHandler.currentSession && !self.dataHandler.doesLocalUserActAsServer) {
                return;
            }
            Game *newGame = [[Game alloc]initInMode:DEFAULT_GAME withBoardSize:CGSizeMake(0, 0)];
            self.currentGame = newGame;
            [newGame release];
            
            // set the data handler regardless of bluetooth status (will check for session in-game)
            self.currentGame.gameViewController.btDataHandler = self.dataHandler;
            
            // on a bluetooth game, send game data to the opponent
            if (self.dataHandler.currentSession) {
                [self.dataHandler transmitCurrentGameData];
            }
            [self.navigationController pushViewController:self.currentGame.gameViewController animated:YES];
        } else if (indexPath.row == 1) {
             // new tictactoe game cell
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            // if a session exists and we are not server, disable every cell except to disconnect
            if (self.dataHandler.currentSession && !self.dataHandler.doesLocalUserActAsServer) {
                return;
            }
            Game *newGame = [[Game alloc]initInMode:TICTACTOE withBoardSize:CGSizeMake(3, 3)];
            self.currentGame = newGame;
            [newGame release];
            
            // set the data handler regardless of bluetooth status (will check for session in-game)
            self.currentGame.gameViewController.btDataHandler = self.dataHandler;
            
            // on a bluetooth game, send game data to the opponent
            if (self.dataHandler.currentSession) {
                [self.dataHandler transmitCurrentGameData];
            }
            [self.navigationController pushViewController:self.currentGame.gameViewController animated:YES];  
        } else if (indexPath.row == 2) {
            // new gomoku game cell
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            // if a session exists and we are not server, disable every cell except to disconnect
            if (self.dataHandler.currentSession && !self.dataHandler.doesLocalUserActAsServer) {
                return;
            }
            Game *newGame = [[Game alloc]initInMode:GOMOKU withBoardSize:CGSizeMake(19, 19)];
            self.currentGame = newGame;
            [newGame release];
            
            // set the data handler regardless of bluetooth status (will check for session in-game)
            self.currentGame.gameViewController.btDataHandler = self.dataHandler;
            
            // on a bluetooth game, send game data to the opponent
            if (self.dataHandler.currentSession) {
                [self.dataHandler transmitCurrentGameData];
            }
            [self.navigationController pushViewController:self.currentGame.gameViewController animated:YES];
        } else if (indexPath.row == 3) {
            // new custom game cell
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            // if a session exists and we are not server, disable every cell except to disconnect
            if (self.dataHandler.currentSession && !self.dataHandler.doesLocalUserActAsServer) {
                return;
            }
            SettingsViewController *settings = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
             settings.mvc = self;
            [self.navigationController pushViewController:settings animated:YES];
            [settings release];
        }    
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            // continue running game
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            // never continue on a bluetooth game
            if (self.dataHandler.currentSession) {
                return;
            }
            if (self.currentGame) {
                [self.navigationController pushViewController:self.currentGame.gameViewController animated:YES];
            }
        } else if (indexPath.row == 1) {
            // load game from file
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            // if a session exists and we are not server, disable every cell except to disconnect
            if (self.dataHandler.currentSession && !self.dataHandler.doesLocalUserActAsServer) {
                return;
            }
            LoadViewController *loadView = [[LoadViewController alloc] initWithNibName:@"LoadViewController" bundle:nil];
            loadView.mvc = self;
            [self.navigationController pushViewController:loadView animated:YES];
            [loadView release];
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            // find and establish connection to other device or disconnect
            if (!self.dataHandler.currentSession) {
                // find/connect
                GKPeerPickerController *picker = [[GKPeerPickerController alloc] init];
                picker.delegate = self;
                picker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
                [picker show];
            } else {
                // disconnect
                [self.dataHandler doDisconnect];
                self.bluetoothIndicator.hidden = YES;
                [self.tableView reloadData]; 
            }
        } else if (indexPath.row == 1) {
            // revoke control if you have it
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            // if a session exists and we are not server, disable every cell except to disconnect
            if (self.dataHandler.currentSession && !self.dataHandler.doesLocalUserActAsServer) {
                return;
            }
            [self.dataHandler doRevokeControl];
            // reloading data is done in doRevokeControl, so don't need to do it here
            // [self.tableView reloadData];
        }
    } else if (indexPath.section == 3) {
        // about screen with information about the app
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        // if a session exists and we are not server, disable every cell except to disconnect
        if (self.dataHandler.currentSession && !self.dataHandler.doesLocalUserActAsServer) {
            return;
        }
        AboutViewController *aboutView = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
        [self.navigationController pushViewController:aboutView animated:YES];
        [aboutView release];
    }
}

#pragma mark - Peer picker delegate

- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *) session
{
    self.dataHandler.currentSession = session;
    self.dataHandler.currentSession.delegate = self.dataHandler;
    [self.dataHandler.currentSession setDataReceiveHandler:self.dataHandler withContext:nil];
 
    // refresh table view
    [self.tableView reloadData];  
    
    picker.delegate = nil;
    [picker dismiss];
    [picker autorelease];
}

- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker
{
    picker.delegate = nil;
    [picker autorelease];
}

@end