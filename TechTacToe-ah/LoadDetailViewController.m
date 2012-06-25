//
//  LoadDetailViewController.m
//  TechTacToe-ah
//
//  Created by andreas on 07/10/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoadDetailViewController.h"

@implementation LoadDetailViewController

@synthesize gameInformation=_gameInformation;
@synthesize gameName=_gameName;
@synthesize appDelegate=_appDelegate;

@synthesize activeGameAlert41=_activeGameAlert41;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (LoadDetailViewController*) initWithGameDataFromFile:(NSString *)filename
{
    self = [super init];
    [self initWithNibName:@"LoadDetailViewController" bundle:nil];
    
    // load game data
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDirectory, YES) objectAtIndex:0];
    NSData *codedData = [[NSData alloc] initWithContentsOfFile:[docPath stringByAppendingPathComponent:filename]];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:codedData];
    
    GameData *localData = [[unarchiver decodeObjectForKey:@"game data"] retain];
    [unarchiver finishDecoding];
    
    self.gameInformation = localData;
    
    if([filename hasPrefix:@"SP"])
    {
        self.gameName = [filename substringFromIndex:2];
    }
    else
    {
        self.gameName = filename;
    }
    
    // set board width and height
    [self.gameInformation updateBoardSize];
    
    [unarchiver release];
    [codedData release];    
    [localData release];
    
    return self;
}

- (void)dealloc
{
    [_gameName release];
    [_gameInformation release];
    [_appDelegate release];
    [_activeGameAlert41 release];
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
    // nav bar setup
    // load button
    UIBarButtonItem *tempButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"LOAD_DETAIL_VIEW_LOAD_BUTTON", @"Load")  style:UIBarButtonItemStyleDone target:self action:@selector(loadGame)];
    self.navigationItem.rightBarButtonItem = tempButton;
    [tempButton release];
    // title
    self.navigationItem.title = NSLocalizedString(@"LOAD_DETAIL_VIEW_TITLE", @"Game Details") ;
    
    [super viewDidLoad];

    // set up the background view
    NSString *path = [[NSBundle mainBundle]pathForResource:@"ImagePaths" ofType:@"plist"];
    NSDictionary *plist = [[NSDictionary alloc] initWithContentsOfFile:path];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[plist objectForKey:@"main view background"]]];
    [plist release];
    
    UIAlertView *alert41 = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"NEW_GAME_ALERT_ACTIVE_GAME_TITLE", @"Active Game Found") message:NSLocalizedString(@"NEW_GAME_ALERT_ACTIVE_GAME_MESSAGE", @"There is already an active game running. Abort active game and start a new game?") delegate:self cancelButtonTitle:NSLocalizedString(@"CANCEL", @"Cancel") otherButtonTitles:NSLocalizedString(@"OK", @"OK"),nil];
    alert41.tag = 41;
    self.activeGameAlert41 = alert41;
    [alert41 release];
    
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
    self.navigationController.navigationBar.tintColor = [UIColor grayColor];
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
    return YES;
    // Return YES for supported orientations
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            // turns: current turn, maximum turns
            return 2;
            break;
        case 1:
            // board: current width, height and if the board is extendable or not
            return 3;
            break;
        case 2:
            // game: minimum fields for line, score mode, additional turn, reuse lines
            return 4;
            break;
        case 3:
            // player color - of interest if the game should be continued over Bluetooth
            return 1;
        case 4:
            // points: blue points, red points
            return 2;
            break;
        default:
            return 0;
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        // only one header: the filename
        NSString *savegame = NSLocalizedString(@"LOAD_DETAIL_VIEW_HEADER_SAVEGAME", @"Savegame: ");
        return [savegame stringByAppendingString:self.gameName];
    }
    return @"";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section == 3) {
        return NSLocalizedString(@"LOAD_DETAIL_VIEW_FOOTER_PLAYER_COLOR", @"In a Bluetooth game, the local player will have this color.");
    }
    return  @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // no cell is ever selectable
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    // we need this for some display information
    BOOL boardAtLimit = self.gameInformation.boardWidth * self.gameInformation.boardHeight >= MAX_FIELDS;
    
    // Configure the cell...
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    // current turn
                    cell.textLabel.text = NSLocalizedString(@"LOAD_DETAIL_VIEW_CELL_CURRENT_TURN", @"Current Turn");
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%i",self.gameInformation.numberOfTurn];
                    break;
                case 1:
                    // maximum number of turns
                    cell.textLabel.text = NSLocalizedString(@"LOAD_DETAIL_VIEW_CELL_MAXIMUM_NUMBER_OF_TURNS", @"Maximum Number of Turns");
                    if (self.gameInformation.rules.maxNumberOfTurns) {
                        cell.detailTextLabel.text = [NSString stringWithFormat:@"%i",self.gameInformation.rules.maxNumberOfTurns];
                    }
                    else {
                        if (boardAtLimit)
                            cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", (self.gameInformation.boardWidth - 2) * (self.gameInformation.boardHeight - 2)];
                        else
                            cell.detailTextLabel.text = NSLocalizedString(@"LIMIT_NONE", @"none");
                    }
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    // board width - display in gray text if it is extendable
                    cell.textLabel.text = NSLocalizedString(@"LOAD_DETAIL_VIEW_CELL_BOARD_WIDTH", @"Board Width");
                    if (self.gameInformation.rules.isExtendableBoard && !self.gameInformation.didHitBoardLimit) 
                        cell.textLabel.enabled = NO;
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%i",self.gameInformation.boardWidth];
                    break;
                case 1:
                    // board height
                    cell.textLabel.text = NSLocalizedString(@"LOAD_DETAIL_VIEW_CELL_BOARD_HEIGHT", @"Board Height");
                    if (self.gameInformation.rules.isExtendableBoard && !self.gameInformation.didHitBoardLimit)
                        cell.textLabel.enabled = NO;
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%i",self.gameInformation.boardHeight];
                    break;
                case 2:
                    // extendable board or not
                    cell.textLabel.text = NSLocalizedString(@"LOAD_DETAIL_VIEW_CELL_EXTENDABLE_BOARD", @"Board Extendable");
                    // ask if it is extendable
                    if (self.gameInformation.rules.isExtendableBoard && !self.gameInformation.didHitBoardLimit) {
                        cell.detailTextLabel.text = NSLocalizedString(@"ENABLED_CONCISE", @"enabled");
                    } else {
                        cell.detailTextLabel.text = NSLocalizedString(@"DISABLED_CONCISE", @"disabled");
                    }
                    break;
                default:
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                    // minimum fields for line
                    cell.textLabel.text = NSLocalizedString(@"LOAD_DETAIL_VIEW_CELL_MINIMUM_LINE_SIZE", @"Minimum Line Size");
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%i",self.gameInformation.rules.minFieldsForLine];
                    break;
                case 1:
                    // score mode
                    cell.textLabel.text = NSLocalizedString(@"LOAD_DETAIL_VIEW_CELL_SCORE_MODE", @"Score Mode");
                    if (self.gameInformation.rules.inScoreMode)
                        cell.detailTextLabel.text = NSLocalizedString(@"ENABLED", @"enabled");
                    else
                        cell.detailTextLabel.text = NSLocalizedString(@"DISABLED", @"disabled");
                    break;
                case 2:
                    // additional turn
                    cell.textLabel.text = NSLocalizedString(@"LOAD_DETAIL_VIEW_CELL_ADDITIONAL_RED_TURN", @"Additional Red Turn");
                    if (self.gameInformation.rules.doesAllowAdditionalRedTurn)
                        cell.detailTextLabel.text = NSLocalizedString(@"ENABLED", @"enabled");
                    else
                        cell.detailTextLabel.text = NSLocalizedString(@"DISABLED", @"disabled");
                    break;
                case 3:
                    // reuse lines
                    cell.textLabel.text = NSLocalizedString(@"LOAD_DETAIL_VIEW_CELL_REUSE_LINES", @"Reuse Lines");
                    if (self.gameInformation.rules.doesAllowReuseOfLines)
                        cell.detailTextLabel.text = NSLocalizedString(@"ENABLED", @"enabled");
                    else
                        cell.detailTextLabel.text = NSLocalizedString(@"DISABLED", @"disabled");
                    break;
                default:
                    break;
            }
            break;
        case 3:
            // local player information
            cell.textLabel.text = NSLocalizedString(@"LOAD_DETAIL_VIEW_CELL_PLAYER_COLOR", @"Player color");
            if (self.gameInformation.isLocalPlayerBlue)
                cell.detailTextLabel.text = NSLocalizedString(@"BLUE", @"blue");
            else
                cell.detailTextLabel.text = NSLocalizedString(@"RED", @"red");
            break;
        case 4:
            switch (indexPath.row) {
                case 0:
                    // blue points
                    cell.textLabel.text = NSLocalizedString(@"LOAD_DETAIL_VIEW_CELL_BLUE_PLAYER_SCORE", @"Blue Player Score");
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%i",self.gameInformation.bluePoints];
                    break;
                case 1:
                    // red points
                    cell.textLabel.text = NSLocalizedString(@"LOAD_DETAIL_VIEW_CELL_RED_PLAYER_SCORE", @"Red Player Score");
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%i",self.gameInformation.redPoints];
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    return cell;
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
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 41)
    {
        if (buttonIndex != [alertView cancelButtonIndex])
        {
            self.appDelegate.currentGame = Nil;
            [self loadGame];
        }
    }
}

- (void)loadGame
{
    if (self.appDelegate.currentGame && !self.appDelegate.currentGame.gameData.gameOver)
    {
        if (self.appDelegate.btdh.currentSession && self.appDelegate.needsAck)
        {
            [self.appDelegate.currentGame.gameViewController.backToMenuReqView show];
            self.appDelegate.menuReqType = 4;
            return;
        }
        else
        {
            [self.activeGameAlert41 show];
            return;
        }
    }
    // if the main view controller did not have a game before (e.g. on loading a game directly after the app starts) create one with standard init
    if (!self.appDelegate.currentGame) {
        Game *loadedGame = [Game new];
        self.appDelegate.currentGame = loadedGame;
        [loadedGame release];
    }
    // assign the game data we loaded in initWithGameDataFromFile (mvc will take ownership), create a controller, assign it as well and display
    self.appDelegate.currentGame.gameData = self.gameInformation;
    GameViewController *tempGameViewController = [[GameViewController alloc] initWithSize:CGSizeMake(MAX(FIELDSIZE * (self.appDelegate.currentGame.gameData.boardWidth + 2), FIELDSIZE * 9), MAX(FIELDSIZE * (self.appDelegate.currentGame.gameData.boardHeight + 2), FIELDSIZE * 9)) gameData:self.appDelegate.currentGame.gameData];
    self.appDelegate.currentGame.gameViewController = tempGameViewController;
    
    // on a Bluetooth game, send game data to the opponent and set the data handler for the game view controller
    if (self.appDelegate.btdh.currentSession) {
        [self.appDelegate.btdh transmitCurrentGameData];
        self.appDelegate.currentGame.gameViewController.btDataHandler = self.appDelegate.btdh;
    }
    
    //[self.navigationController pushViewController:self.appDelegate.currentGame.gameViewController animated:YES];
    [tempGameViewController release];
    self.appDelegate.needsAck = YES;
    [self.appDelegate startGame];
}

@end
