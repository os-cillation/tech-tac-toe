//
//  LoadViewController.m
//  TechTacToe-ah
//
//  Created by andreas on 07/10/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoadViewController.h"

@implementation LoadViewController

@synthesize path=_path;
@synthesize files=_files;
@synthesize appDelegate=_appDelegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [_path release];
    [_files release];
    [_appDelegate release];
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
    // get path to documents directory
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDirectory, YES) objectAtIndex:0];
    self.path = docPath;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // set up the background view
    NSString *resourcePath = [[NSBundle mainBundle]pathForResource:@"ImagePaths" ofType:@"plist"];
    NSDictionary *plist = [[NSDictionary alloc] initWithContentsOfFile:resourcePath];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[plist objectForKey:@"main view background"]]];
    [plist release];
        
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{   
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // set nav bar content
    self.navigationController.navigationBar.tintColor = [UIColor grayColor];
    
    if (self.appDelegate.isAIActivated)
    {
        self.navigationItem.title = NSLocalizedString(@"LOAD_VIEW_TITLE_SP", "Savegames for Singleplayer");
    }
    else
    {
        self.navigationItem.title = NSLocalizedString(@"LOAD_VIEW_TITLE_MP", "Savegames for Multiplayer");
    }
    
    /*
    UIBarButtonItem *tempButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"BACK_BUTTON", @"Back") style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = tempButton;
    [tempButton release];
     */
    
    //Disable Editing if active
    //[self.tableView setEditing:NO];
    self.editing = NO;
    
    //self.navigationItem.title = NSLocalizedString(@"LOAD_VIEW_TITLE", @"Load Game");
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // get contents of documents directory
    //self.files = [NSMutableArray arrayWithArray:[[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.path error:NULL]];
    
    NSMutableArray *allFiles = [NSMutableArray arrayWithArray:[[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.path error:NULL]];
    NSMutableArray *filesToKeep = [[NSMutableArray alloc] init ];
    
    for (NSString *tempSaveName in allFiles)
    {
        if([tempSaveName hasPrefix:@"SP"])
        {
            if (self.appDelegate.isAIActivated)
            {
                //NSString *saveName = [tempSaveName substringFromIndex:2];
                [filesToKeep addObject:tempSaveName];
            }
        }
        else
        {
            if (!self.appDelegate.isAIActivated)
            {
                [filesToKeep addObject:tempSaveName];
            }
        }
    }
    self.files = filesToKeep;
    [filesToKeep release];
    
    [self.tableView reloadData];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationItem.title = NSLocalizedString(@"LOAD_VIEW_TITLE", @"Load Game");
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSInteger result = self.files.count;
    if (self.appDelegate.currentGame)
    {
        result++;
    }
    return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
     // Configure the cell...
    NSString *filename;
    if (self.appDelegate.currentGame)
    {
        if (indexPath.row == 0)
        {
            filename = NSLocalizedString(@"SAVE_ACTIVE_GAME_CELL", @"Save");
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
        else
        {
            filename = [self.files objectAtIndex:indexPath.row - 1];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    else
    {
        filename = [self.files objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if([filename hasPrefix:@"SP"])
    {
        filename = [filename substringFromIndex:2];
    }
    cell.textLabel.text = filename;
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && self.appDelegate.currentGame)
    {
        return UITableViewCellEditingStyleInsert;
    }
    
    return UITableViewCellEditingStyleDelete;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // we need to get the filename before removing it from the data source
        NSString *filename;// = [[NSString alloc] init];
        if (self.appDelegate.currentGame)
        {
            filename = [[self.files objectAtIndex:indexPath.row - 1 ] copy];
            [self.files removeObjectAtIndex:indexPath.row - 1];
        }
        else
        {
            filename = [[self.files objectAtIndex:indexPath.row] copy];
            [self.files removeObjectAtIndex:indexPath.row];
            
        }
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        // also delete file, display alert if for any reason there is an error
        if (![[NSFileManager defaultManager] removeItemAtPath:[self.path stringByAppendingPathComponent:filename] error:NULL])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"LOAD_VIEW_ALERT_DELETE_GAME_UNSUCCESSFUL_TITLE", @"Error") message:NSLocalizedString(@"LOAD_VIEW_ALERT_DELETE_GAME_UNSUCCESSFUL_MESSAGE", @"Could not delete the file.") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
        [filename release];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        NSString *filename = [NSDateFormatter localizedStringFromDate:[NSDate date] dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterShortStyle];
        
        if (self.appDelegate.currentGame.gameData.gameAI)
        {
            filename = [NSString stringWithFormat:@"%@%@",@"SP",filename];
        }
        
        if (self.appDelegate.currentGame.gameData.hasSelection)
        {
            self.appDelegate.currentGame.gameData.selection = NO;
            [self.appDelegate.currentGame.gameData changeDataAtPoint:CGPointMake(self.appDelegate.currentGame.gameData.positionOfLastMarkedFieldX, self.appDelegate.currentGame.gameData.positionOfLastMarkedFieldY)  withStatus:FREE_FIELD];
            NSMutableArray *needsDrawing = [NSMutableArray arrayWithCapacity:1];
            Field *drawMe = [[Field alloc] initWithStatus:FREE_FIELD atPositionX:self.appDelegate.currentGame.gameData.positionOfLastMarkedFieldX atPositionY:self.appDelegate.currentGame.gameData.positionOfLastMarkedFieldY];
            [needsDrawing addObject:drawMe];
            [drawMe release];
            // draw the field we deselected
            [self.appDelegate.currentGame.gameViewController changeGameFields:needsDrawing orDrawAll:NO orSetMarkForLastTurn:NO];
        }
        self.appDelegate.currentGame.gameData.positionOfLastMarkedFieldX = self.appDelegate.currentGame.gameViewController.positionToMark.x;
        self.appDelegate.currentGame.gameData.positionOfLastMarkedFieldY = self.appDelegate.currentGame.gameViewController.positionToMark.y;
        if ([self.appDelegate.currentGame.gameData saveGameToFile:filename])
        {
            //success
            //update TableView only if file was not overwritten
            if (![self.files containsObject:filename])
            {
                [self.files addObject:filename];
                [self.tableView reloadData];
            }
        }
    }   
}

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
    // create and navigate to detail view
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *filename = @"";
    if (self.appDelegate.currentGame)
    {
        if (indexPath.row > 0)
        {
            filename = [self.files objectAtIndex:indexPath.row - 1];
        }
    }
    else
    {
        filename = [self.files objectAtIndex:indexPath.row];
    }
    if (self.appDelegate.currentGame && indexPath.row == 0)
    {
    }
    else
    {
        LoadDetailViewController *detailViewController = [[LoadDetailViewController alloc] initWithGameDataFromFile:filename];
        [self.navigationController pushViewController:detailViewController animated:YES];
        [detailViewController release];
    }

}

@end
