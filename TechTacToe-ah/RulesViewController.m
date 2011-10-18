//
//  RulesViewController.m
//  TechTacToe-ah
//
//  Created by andreas on 04/10/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RulesViewController.h"

@implementation RulesViewController
@synthesize numericValuesLabel;
@synthesize extraSettingsLabel;

#pragma mark - Initializer and memory management

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [numericValuesLabel release];
    [extraSettingsLabel release];
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
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = NSLocalizedString(@"RULES_VIEW_TITLE", @"Rules");
    
    // "a bit of a hack" to force portrait orientation: present and directly dismiss a blank view controller modally
    UIViewController *viewController = [UIViewController new];
    [self presentModalViewController:viewController animated:NO];
    [self dismissModalViewControllerAnimated:NO];
    [viewController release];
}

- (void)viewDidUnload
{
    [self setNumericValuesLabel:nil];
    [self setExtraSettingsLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.tintColor = nil; 
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Creating label information

- (void) displayRules:(GameData *)gameData
{
    NSString *turnsDescription, *sizeDescription, *minimumForLineDescription, *scoreModeDescription;
    NSString *additionalTurnDescription = @"";
    NSString *reuseLinesDescription = @"";
    // describe the size of the board and if it is limited
    if (!gameData.rules.isExtendableBoard || gameData.didHitBoardLimit) {
        NSString *lsd = NSLocalizedString(@"RULES_VIEW_LIMITED_BOARD", @"-  The board is %i by %i fields in size.\n");
        sizeDescription = [NSString stringWithFormat:lsd ,gameData.boardWidth, gameData.boardHeight];
    } else {
        NSString *usd = NSLocalizedString(@"RULES_VIEW_UNLIMITED_BOARD", @"-  The board has no set size and will be enlarged on demand. It is currently %i by %i fields in size.\n");
            sizeDescription = [NSString stringWithFormat:usd ,gameData.boardWidth, gameData.boardHeight];
    }
    
    // set number of turns string depending on score mode or not, turn limit or none
    if (gameData.rules.maxNumberOfTurns != 0) {
        NSString *ltd = NSLocalizedString(@"RULES_VIEW_LIMITED_TURNS", @"-  After %i turns, if no one has won, the game will end in a draw.");
        turnsDescription = [NSString stringWithFormat:ltd, gameData.rules.maxNumberOfTurns];
    } else {
        // if we know the hardware limit, tell the user - for now act as if no limit
        turnsDescription = NSLocalizedString(@"RULES_VIEW_UNLIMITED_TURNS", @"-  There is currently no turn limit. If the board cannot grow anymore, a turn limit will be set.");
    }
    
    // minimum line size - if the first one to score wins, save the explanation about additional points
    if (gameData.rules.inScoreMode || gameData.rules.doesAllowAdditionalRedTurn) {
        NSString *lmfld = NSLocalizedString(@"RULES_VIEW_MINIMUM_LINE_SIZE", @"-  A line has to be at least %i fields long to be counted. Longer lines will score for one or more additional points.\n");
        minimumForLineDescription = [NSString stringWithFormat:lmfld,gameData.rules.minFieldsForLine];
    } else {
        NSString *lfmld = NSLocalizedString(@"RULES_VIEW_MINIMUM_LINE_SIZE_CONCISE", @"-  A line has to be at least %i fields long to be counted.\n");
        minimumForLineDescription = [NSString stringWithFormat:lfmld,gameData.rules.minFieldsForLine];
    }
    //combine into label
    self.numericValuesLabel.text = [NSString stringWithFormat:@"%@\n%@\n%@", sizeDescription, minimumForLineDescription, turnsDescription];
    
    // score mode or not, additional turn or not
    if (gameData.rules.inScoreMode) {
        scoreModeDescription = NSLocalizedString(@"RULES_VIEW_SCORE_MODE_ENABLED", @"-  The game will end after the set number of turns and the winner will be determined by score only.\n");
    } else {
        scoreModeDescription = NSLocalizedString(@"RULES_VIEW_SCORE_MODE_DISABLED", @"-  The first player to get a line of at least minimum size will be declared the winner.\n");
    } 
    if (gameData.rules.doesAllowAdditionalRedTurn) {
        additionalTurnDescription = NSLocalizedString(@"RULES_VIEW_ADDITIONAL_TURN", @"-  The red player has one extra turn to counter a blue line with one of his own. However, if the red player has a higher score than the blue player at any time, he will win.\n");
    }
    
    // reuse of lines or not (do not display if first to score wins anyway)
    if (gameData.rules.inScoreMode || gameData.rules.doesAllowAdditionalRedTurn) {
        if (gameData.rules.doesAllowReuseOfLines) {
            reuseLinesDescription = NSLocalizedString(@"RULES_VIEW_REUSE_LINES_ENABLED", @"-  Fields of a line may be crossed (but not extended) by fields in any direction and do count towards a new line.");
        } else {
            reuseLinesDescription = NSLocalizedString(@"RULES_VIEW_REUSE_LINES_DISABLED", @"-  Fields belonging to a line cannot be used again. They are effectively out of the game.");
        }
    }
    
    // combine into the second label
    self.extraSettingsLabel.text = [NSString stringWithFormat:@"%@\n%@\n%@", scoreModeDescription,additionalTurnDescription,reuseLinesDescription];
}

@end
