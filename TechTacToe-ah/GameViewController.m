//
//  GameViewController.m
//  TechTacToe-ah
//
//  Created by andreas on 9/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameViewController.h"
#import "BluetoothDataHandler.h"

@implementation GameViewController

@synthesize gameScrollView=_gameScrollView;
@synthesize containerView=_containerView;
@synthesize displayedGameFields=_displayedGameFields;
@synthesize redField=_redField;
@synthesize blueField=_blueField;
@synthesize emptyField=_emptyField;
@synthesize unavailableField=_unavailableField;
@synthesize redFieldMarked=_redFieldMarked;
@synthesize blueFieldMarked=_blueFieldMarked;
@synthesize redFieldLine=_redFieldLine;
@synthesize blueFieldLine=_blueFieldLine;
@synthesize lastDrawn=_lastDrawn;
@synthesize gameData=_gameData;
@synthesize currentSize=_currentSize;
@synthesize rulesButton=_rulesButton;
@synthesize tapGestureRecognizer=_tapGestureRecognizer;
@synthesize turnInfo=_turnInfo;
@synthesize gameInfo=_gameInfo;
@synthesize btDataHandler=_btDataHandler;
@synthesize backToMenuGameOver=_backToMenuGameOver;
@synthesize backToMenuReqView=_backToMenuReqView;
@synthesize backToMenuWaitView=_backToMenuWaitView;
@synthesize backToMenuAckView=_backToMenuAckView;
@synthesize activityIndicator=_activityIndicator;

#pragma mark - Initializer and memory management

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(GameViewController*)initWithSize:(CGSize)size gameData:(GameData *)data
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // getting the plist containing the paths to the image files
        NSString *path = [[NSBundle mainBundle]pathForResource:@"ImagePaths" ofType:@"plist"];
        NSDictionary *plist = [[NSDictionary alloc] initWithContentsOfFile:path];
        
        // loading all the images into UIImage ivars so we have them ready for drawing
        NSString *emptyFieldPath = [plist objectForKey:@"free field"];
        self.emptyField = [UIImage imageNamed:emptyFieldPath];
        
        NSString *unavailableFieldPath = [plist objectForKey:@"unavailable field"];
        self.unavailableField = [UIImage imageNamed:unavailableFieldPath];
        
        NSString *redFieldPath = [plist objectForKey:@"red field"];
        self.redField = [UIImage imageNamed:redFieldPath];
        
        NSString *blueFieldMarkedPath = [plist objectForKey:@"blue marked field"];
        self.blueFieldMarked = [UIImage imageNamed:blueFieldMarkedPath];
        
        NSString *redFieldMarkedPath = [plist objectForKey:@"red marked field"];
        self.redFieldMarked = [UIImage imageNamed:redFieldMarkedPath];
        
        NSString *blueFieldPath = [plist objectForKey:@"blue field"];
        self.blueField = [UIImage imageNamed:blueFieldPath];
        
        NSString *redFieldLinePath = [plist objectForKey:@"red line field"];
        self.redFieldLine = [UIImage imageNamed:redFieldLinePath];
        
        NSString *blueFieldLinePath = [plist objectForKey:@"blue line field"];
        self.blueFieldLine = [UIImage imageNamed:blueFieldLinePath];
        
        // cleanup plist
        [plist release];
        
        // data was loaded/created in Game, assign it here (no retaining)
        self.gameData = data;
        
        self.currentSize = size;
    }
    return self;
}

- (void)dealloc 
{    
    [_gameScrollView release];
    [_containerView release];
    [_displayedGameFields release];
    [_redField release];
    [_blueField release];
    [_emptyField release];
    [_unavailableField release];
    [_redFieldMarked release];
    [_blueFieldMarked release];
    [_redFieldLine release];
    [_blueFieldLine release];
    [_lastDrawn release];
    [_rulesButton release];
    [_tapGestureRecognizer release];
    [_turnInfo release];
    [_gameInfo release];
    [_backToMenuGameOver release];
    [_backToMenuReqView release];
    [_backToMenuWaitView release];
    [_backToMenuAckView release];
    [_activityIndicator release];
    
    // release the image context - if we don't do this, a big chunk of memory will leak if we go back to menu and start a new game
    UIGraphicsEndImageContext();
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Scroll view delegate

-(UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.containerView;
}

#pragma mark - Action sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        // resign: display alert view for confirmation, but only if the game is still ongoing and it is your turn on Bluetooth games
        if (!self.gameData.isGameOver && ((self.btDataHandler.currentSession && self.gameData.isLocalPlayerBlue == self.gameData.isBluePlayerTurn) || !self.btDataHandler.currentSession)) {
            // code deactivated: don't ask for confirmation - do it! activate this code for old behaviour
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"GAME_VIEW_ALERT_RESIGN_CONFIRMATION_TITLE", @"Resigning") message:NSLocalizedString(@"GAME_VIEW_ALERT_RESIGN_CONFIRMATION_MESSAGE", @"Really resign the game?") delegate:self cancelButtonTitle:NSLocalizedString(@"NO", @"no") otherButtonTitles:NSLocalizedString(@"YES", @"yes"), nil];
//            alert.tag = 12;
//            [alert show];
//            [alert release];
            
            // deactivate this code for old confirmation dialogue
            // do resign
            
            // first clear any selection, so we don't keep them even when the game is already over - on Bluetooth games, there should be no marked field so skip it automatically
            if (self.gameData.hasSelection) {
                self.gameData.selection = NO;
                [self.gameData changeDataAtPoint:CGPointMake(self.gameData.positionOfLastMarkedFieldX, self.gameData.positionOfLastMarkedFieldY)  withStatus:FREE_FIELD];
                NSMutableArray *needsDrawing = [NSMutableArray arrayWithCapacity:1];
                Field *drawMe = [[Field alloc] initWithStatus:FREE_FIELD atPositionX:self.gameData.positionOfLastMarkedFieldX atPositionY:self.gameData.positionOfLastMarkedFieldY];
                [needsDrawing addObject:drawMe];
                [drawMe release];
                // reset position of our last selection
                self.gameData.positionOfLastMarkedFieldX = -1;
                self.gameData.positionOfLastMarkedFieldY = -1;
                // draw the field we deselected
                [self changeGameFields:needsDrawing orDrawAll:NO];
            }
            // at last, do the resigning and declare game over
            [self.gameData resignGame];
            [self cleanUpAfterGameOver];
            
            // on Bluetooth games, tell the other player you have resigned
            if (self.btDataHandler.currentSession && self.gameData.isBluePlayerTurn == self.gameData.isLocalPlayerBlue) {
                [self.btDataHandler sendResign];
            }
        } else {
            // display an alert view with a message that you cannot resign the game at this moment
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"GAME_VIEW_ALERT_RESIGN_UNAVAILBLE_TITLE", @"Resigning Not Possible") message:NSLocalizedString(@"GAME_VIEW_ALERT_RESIGN_UNAVAILABLE_MESSAGE", @"Resigning the game is only possible if the game is not already over and if it is your turn on a game via Bluetooth.") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }
    if (buttonIndex == 1) {
        // save
        // first clear any selection
        if (self.gameData.hasSelection) {
            self.gameData.selection = NO;
            [self.gameData changeDataAtPoint:CGPointMake(self.gameData.positionOfLastMarkedFieldX, self.gameData.positionOfLastMarkedFieldY)  withStatus:FREE_FIELD];
            NSMutableArray *needsDrawing = [NSMutableArray arrayWithCapacity:1];
            Field *drawMe = [[Field alloc] initWithStatus:FREE_FIELD atPositionX:self.gameData.positionOfLastMarkedFieldX atPositionY:self.gameData.positionOfLastMarkedFieldY];
            [needsDrawing addObject:drawMe];
            [drawMe release];
            // reset position of our last selection
            self.gameData.positionOfLastMarkedFieldX = -1;
            self.gameData.positionOfLastMarkedFieldY = -1;
            // draw the field we deselected
            [self changeGameFields:needsDrawing orDrawAll:NO];
        }
        NSString *filename = [NSDateFormatter localizedStringFromDate:[NSDate date] dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterShortStyle];
        if([self.gameData saveGameToFile:filename]) {
            NSString *message = NSLocalizedString(@"GAME_VIEW_ACTION_SHEET_SAVE_GAME_ALERT_SUCCESSFUL_MESSAGE", @"The game was successfully saved as \"%@\".");
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GAME_VIEW_ACTION_SHEET_SAVE_GAME_ALERT_SUCCESSFUL_TITLE", @"Game Saved") message:[NSString stringWithFormat:message, filename] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        } else {
            // message for unsuccessful save
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GAME_VIEW_ACTION_SHEET_SAVE_GAME_ALERT_UNSUCCESSFUL_TITLE", @"Error") message:NSLocalizedString(@"GAME_VIEW_ACTION_SHEET_SAVE_GAME_ALERT_UNSUCCESSFUL_MESSAGE", @"The game could not be saved.") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }
    if (buttonIndex == 2) {
        // main menu
        // back to menu if we are in hotseat mode - in a Bluetooth game we need to notify the other device and ask for confirmation
        if (!self.btDataHandler.currentSession)
            [self.navigationController popToRootViewControllerAnimated:YES];
        else {
            // ask for confirmation on Bluetooth games, send remote device notification to go back to menu as well or to disconnect and stay - if someone starts a new game while the old one is still running, memory will leak - so do not EVER allow only one peer to go back to menu!
            [self.backToMenuReqView show];
        }
    }
    // buttonIndex == 3 is the cancel button - don't do anything if it's clicked
}

#pragma mark - Alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // which alert view is caller
    // game over alert view
    if (alertView.tag == 11) {
        if (buttonIndex == 0) {
            // cancel
        } else if (buttonIndex == 1) {
            // back to menu if we are in hotseat mode - in a Bluetooth game we need to notify the other device and ask for confirmation
            if (!self.btDataHandler.currentSession)
                [self.navigationController popToRootViewControllerAnimated:YES];
            else {
            // ask for confirmation on Bluetooth games, send remote device notification to go back to menu as well or to disconnect and stay - if someone starts a new game while the old one is still running, memory will leak - so do not EVER allow only one peer to go back to menu!
                [self.backToMenuReqView show];
            }
        }
    } // resign confirmation alert view - currently will not be called as we scrapped the confirmation dialogue
    else if (alertView.tag == 12) {
        if (buttonIndex == 0) {
            // cancel
        } else if (buttonIndex == 1) {
            // do resign
            
            // first clear any selection, so we don't keep them even when the game is already over - on Bluetooth games, there should be no marked field so skip it automatically
            if (self.gameData.hasSelection) {
                self.gameData.selection = NO;
                [self.gameData changeDataAtPoint:CGPointMake(self.gameData.positionOfLastMarkedFieldX, self.gameData.positionOfLastMarkedFieldY)  withStatus:FREE_FIELD];
                NSMutableArray *needsDrawing = [NSMutableArray arrayWithCapacity:1];
                Field *drawMe = [[Field alloc] initWithStatus:FREE_FIELD atPositionX:self.gameData.positionOfLastMarkedFieldX atPositionY:self.gameData.positionOfLastMarkedFieldY];
                [needsDrawing addObject:drawMe];
                [drawMe release];
                // reset position of our last selection
                self.gameData.positionOfLastMarkedFieldX = -1;
                self.gameData.positionOfLastMarkedFieldY = -1;
                // draw the field we deselected
                [self changeGameFields:needsDrawing orDrawAll:NO];
            }
            // at last, do the resigning and declare game over
            [self.gameData resignGame];
            [self cleanUpAfterGameOver];
            
            // on Bluetooth games, tell the other player you have resigned
            if (self.btDataHandler.currentSession && self.gameData.isBluePlayerTurn == self.gameData.isLocalPlayerBlue) {
                [self.btDataHandler sendResign];
            }
        }
    } // back to menu alert view on a running Bluetooth game
    else if (alertView.tag == 13) {
        if (buttonIndex == 0) {
            // cancel
        } else if (buttonIndex == 1) {
            // send a MESSAGE_MENU_REQ to the other device and display another dialogue
            [self.btDataHandler sendBackToMenuRequest];
            // waiting dialogue with the option to disconnect early
            [self.backToMenuWaitView show];
            // start the activity indicator
            [self.activityIndicator startAnimating];
            
        } else if (buttonIndex == 2) {
            // disconnect from the session and go back to menu
            [self.btDataHandler doDisconnect];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } // waiting alert view - will be dismissed by the other device by sending a MESSAGE_MENU_ACK or by clicking the disconnect button
    else if (alertView.tag == 14) {
        if (buttonIndex == 0) {
            // disconnect button - we don't have a cancel button per sé, but this is as close as it can get (stopping the activity indicator will be done in doDisconnect)
            [self.btDataHandler doDisconnect];
            // also, we can go back to the menu now
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } // the alert view requesting an acknowledgement to go back to menu
    else if (alertView.tag == 15) {
        if (buttonIndex == 0) {
            // 'No' means that the session will be ended, so disconnect from this device since we don't agree with the other device
            [self.btDataHandler doDisconnect];
        } else if (buttonIndex == 1) {
            // we agree to go back to menu, tell the other device, go back to menu
            [self.btDataHandler sendBackToMenuAcknowledge];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

#pragma mark - Drawing, selecting and resizing

-(void) changeGameFields:(NSArray *)fieldsOrNil orDrawAll:(BOOL)redrawEverything
{
    // will be called if turn was committed, a tile was selected or deselected or multiple times if the game field needs more empty fields. point has to be a valid entry in gameData (i.e. a point where a field was actually drawn), multiplied by the FIELDSIZE or needs to be at a correct location for new, empty fields to be created
    
    // in case of missing last image (e.g. going back to menu and going back in the same game) we need to redraw all
    if (!self.lastDrawn)
        redrawEverything = YES;
    
    // only begin new context if the last user interaction triggered a resize (old context is ended in the resize method) - also happens if there was no last image
    // if memory footprint will be too big, maybe revert to (much slower) behaviour of creating and ending a context in each drawing cycle: will about halve average footprint (although still causes memory consumption spikes of size of the CGImage used to display)
    if (self.lastDrawn.size.height != self.currentSize.height || self.lastDrawn.size.width != self.currentSize.width) {
        UIGraphicsBeginImageContextWithOptions(self.currentSize, YES, 0);
        // first draw the old image into the new one as a whole, but only if we do not redraw everything
        if (!redrawEverything) {
            [self.lastDrawn drawAtPoint:CGPointMake(0,0)];
        }
    }
    
    // get fields to be drawn differently
    // draw the change
    int positionXForDrawing;
    int positionYForDrawing;
    
    // when we need to redraw everything, overwrite our array with the complete contents of the gameData.fields dictionary
    if (redrawEverything)
        fieldsOrNil = [self.gameData.fields allValues];
    
    for (Field* currentField in fieldsOrNil) {
        positionXForDrawing = currentField.positionX * FIELDSIZE;
        positionYForDrawing = currentField.positionY * FIELDSIZE;
        
        switch (currentField.status) {
            case UNAVAILABLE_FIELD:
                [self.unavailableField drawInRect:CGRectMake(positionXForDrawing, positionYForDrawing, FIELDSIZE, FIELDSIZE)];
                break;
            case FREE_FIELD:
                [self.emptyField drawInRect:CGRectMake(positionXForDrawing, positionYForDrawing, FIELDSIZE, FIELDSIZE)];
                break;
            case RED_FIELD:
                [self.redField drawInRect:CGRectMake(positionXForDrawing, positionYForDrawing, FIELDSIZE, FIELDSIZE)];
                break;
            case RED_MARKED:
                [self.redFieldMarked drawInRect:CGRectMake(positionXForDrawing, positionYForDrawing, FIELDSIZE, FIELDSIZE)];
                break;
            case RED_LINE:
                [self.redFieldLine drawInRect:CGRectMake(positionXForDrawing, positionYForDrawing, FIELDSIZE, FIELDSIZE)];
                break;
            case BLUE_FIELD:
                [self.blueField drawInRect:CGRectMake(positionXForDrawing, positionYForDrawing, FIELDSIZE, FIELDSIZE)]; 
                break;
            case BLUE_MARKED:
                [self.blueFieldMarked drawInRect:CGRectMake(positionXForDrawing, positionYForDrawing, FIELDSIZE, FIELDSIZE)];
                break;
            case BLUE_LINE:
                [self.blueFieldLine drawInRect:CGRectMake(positionXForDrawing, positionYForDrawing, FIELDSIZE, FIELDSIZE)];
                break;
            default:
                break;
        }
    }
    // assign the changed image
    self.lastDrawn = UIGraphicsGetImageFromCurrentImageContext();
    
    // set and display
    //UIGraphicsEndImageContext();
    [self.displayedGameFields setImage:self.lastDrawn];
    
    // size of lastDrawn could have changed - need to adjust UIImageView
    [self.displayedGameFields sizeToFit];
    
    // need to do this only once
    if (!self.displayedGameFields.superview) {
        [self.containerView addSubview:self.displayedGameFields];
    }    
}

-(void)selectFieldByTap:(UITapGestureRecognizer *)tapRecognizer
{
    // get the location of the tap in the playing field
    CGPoint tapLocation = [tapRecognizer locationInView:self.containerView];
    
    // recalculate the location to get the point of origin of the field for the gameData
    tapLocation = CGPointMake((int)tapLocation.x / FIELDSIZE, (int)tapLocation.y / FIELDSIZE);
    
    // we put every field that needs a redraw into this (maximum: 2)
    NSMutableArray *needsDrawing = [NSMutableArray arrayWithCapacity:2];
    
    BOOL sameLocation = (tapLocation.x == self.gameData.positionOfLastMarkedFieldX) && (tapLocation.y == self.gameData.positionOfLastMarkedFieldY);
    
    // first clear an old selection if it exists and we did not tap the same field
    if (self.gameData.hasSelection && !sameLocation) {
        self.gameData.selection = NO;
        [self.gameData changeDataAtPoint:CGPointMake(self.gameData.positionOfLastMarkedFieldX, self.gameData.positionOfLastMarkedFieldY) withStatus:FREE_FIELD];
        // just create a new field with the data here - doesn't matter if it is not from the data since it is identical to it
        Field *drawMe = [[Field alloc] initWithStatus:FREE_FIELD atPositionX:self.gameData.positionOfLastMarkedFieldX atPositionY:self.gameData.positionOfLastMarkedFieldY];
        [needsDrawing addObject:drawMe];
        [drawMe release];
        // reset position of our last selection
        self.gameData.positionOfLastMarkedFieldX = -1;
        self.gameData.positionOfLastMarkedFieldY = -1;
    }
    // get the field for the tap
    NSString *key = [NSString stringWithFormat:@"%i, %i", (int)tapLocation.x, (int)tapLocation.y];
    Field *field = [self.gameData.fields objectForKey:key];
    
    // only do something if the field existed and was empty
    if(field) {
        
        // when we tapped twice at the same field, or the field can't be selected and we didn't have a selection before to clear, draw if we must and don't bother doing anything else here
        BOOL fieldIsFree = field.status == FREE_FIELD;
        
        if ((!self.gameData.hasSelection && !fieldIsFree) || sameLocation) {
            if ([needsDrawing count] > 0) 
                [self changeGameFields:needsDrawing orDrawAll:NO];
            // then again, if we tap twice at the same location and it was a marked field, then commit the turn
            if (sameLocation && (field.status == BLUE_MARKED || field.status == RED_MARKED)) {
                [self commitTurn];
            }
            return;
        }
        
        if (fieldIsFree) {
            // call changeGameFieldAtPoint operation depending on which turn we're in, put field with changed status into array for drawing
            if (self.gameData.isBluePlayerTurn) {
                [self.gameData changeDataAtPoint:tapLocation withStatus:BLUE_MARKED];
                field.status = BLUE_MARKED;
                [needsDrawing addObject:field];
            }
            else {
                [self.gameData changeDataAtPoint:tapLocation withStatus:RED_MARKED];
                field.status = RED_MARKED;
                [needsDrawing addObject:field];
            }
        }
    }
    // give the array with the changes to the drawing routine
    [self changeGameFields:needsDrawing orDrawAll:NO];
}

-(void)resizeBoard
{
    // we need a new drawing context after resizing, so end the current one
    UIGraphicsEndImageContext();
    
    // cannot do correct resizing with zoom, so save the current scale and assign it back later
    CGFloat zoom = self.gameScrollView.zoomScale;
    self.gameScrollView.zoomScale = 1.0f;
    
    // adjust size of the containerView
    [self.containerView setFrame:CGRectMake(0, 0, self.currentSize.width, self.currentSize.height)];
    
    // also adjust the content of the scrollview
    self.gameScrollView.contentSize = CGSizeMake(self.containerView.frame.size.width, self.containerView.frame.size.height);
    
    //and recalculate minimum zoom scale 
    //(deactivated for now, because it can cause memory spikes)
    //self.gameScrollView.minimumZoomScale = self.gameScrollView.frame.size.height / self.containerView.frame.size.height;
    
    // set the old zoom scale back
    self.gameScrollView.zoomScale = zoom;
}

#pragma mark - Button actions

-(void)showRules
{
    // create a view with labels explaining the current rules, display it in the navigation hierarchy
    RulesViewController *rulesViewController = [[RulesViewController alloc] initWithNibName:@"RulesViewController" bundle:nil];
    [self.navigationController pushViewController:rulesViewController animated:YES];
    [rulesViewController displayRules:self.gameData];
    [rulesViewController release];
}

-(void)commitTurn
{
    /* get last selected field, check if valid turn, consult rules for scoring, call cleanUpAfterGameOver on game over, set turn result in data, check if size of the game field will change, add more free fields if needed, change self.currentSize if needed and call appropriate methods to either just draw the change (changeGameFieldAtPoint) or notify the data to check for need of more free fields and draw everything (createGameField)*/
    
    // we can use this to determine if we need to do a complete redraw
    BOOL needsCompleteRedraw = NO;
    
    // if this is not set to yes before the Bluetooth send would be made, nothing will be sent (since nothing changed)
    BOOL validTurn = NO;
    
    // check if there is a valid selection
    if (self.gameData.hasSelection) {
        CGPoint position = CGPointMake(self.gameData.positionOfLastMarkedFieldX, self.gameData.positionOfLastMarkedFieldY);
        
        NSString *key = [NSString stringWithFormat:@"%i, %i", (int)position.x, (int)position.y];
        Field *fieldToCommit = [self.gameData.fields objectForKey:key];
        
        // compare the status of the field with the active player (redundant check for security)        
        // everything that should be executed if a turn is successfully committed should be in here
        if ((fieldToCommit.status == BLUE_MARKED && self.gameData.isBluePlayerTurn) || (fieldToCommit.status == RED_MARKED && !self.gameData.isBluePlayerTurn)) {
            
            // it is a valid turn, so we need to send data on a Bluetooth game
            validTurn = YES;
            
            // set up a container with all changes - we need to use this if we don't do a complete redraw
            NSMutableArray *needsDrawing = [NSMutableArray arrayWithCapacity:35];
            
            // only do this on games with non-limited board sizes - add to the array
            if (self.gameData.rules.isExtendableBoard)
                [needsDrawing addObjectsFromArray:[self.gameData createMoreEmptyFieldsAroundPoint:position]];
            
            // clear selection first (no need to draw since it will be overridden with non-selectable field shortly)
            self.gameData.selection = NO;
            
            // set new field status, switch active player, put into the container for drawing
            if (self.gameData.isBluePlayerTurn) {
                [self.gameData changeDataAtPoint:position withStatus:BLUE_FIELD];
                // just create a new field with the data here - doesn't matter if it is not from the data since it is identical to it
                Field *drawMe = [[Field alloc] initWithStatus:BLUE_FIELD atPositionX:position.x atPositionY:position.y];
                [needsDrawing addObject:drawMe];
                [drawMe release];
            }
            else {
                [self.gameData changeDataAtPoint:position withStatus:RED_FIELD];
                Field *drawMe = [[Field alloc] initWithStatus:RED_FIELD atPositionX:position.x atPositionY:position.y];
                [needsDrawing addObject:drawMe];
                [drawMe release];
            }
            
            // consult the rules (which will add points - if any and switch active player), add every field that needs drawing because it now belongs to a line to our array - will change self.isGameOver to YES on winning conditions
            [needsDrawing addObjectsFromArray:[self.gameData consultRulesForFieldAtPoint:position]];
            
            // we need these to calculate the new offset
            CGPoint offset = self.gameScrollView.contentOffset;
            CGFloat zoom = self.gameScrollView.zoomScale;
            
            // resizing the views and complete re-drawing not if we have a board of set size or if we don't expand it anymore!
            if (self.gameData.rules.isExtendableBoard && !self.gameData.didHitBoardLimit) {
                // for calculations regarding the drawing positions, we need the position we got from the data converted
                CGPoint positionForDrawing = CGPointMake(position.x * FIELDSIZE, position.y * FIELDSIZE);
                
                // check if we need to resize the container and move the offset of the scroller
                // if we are at least one field away from the -upper- or -left- border we need to resize AND move the fields (since we don't want to draw at negative values)
                BOOL needsResizeMoveX = positionForDrawing.x <= 2 * FIELDSIZE;
                BOOL needsResizeMoveY = positionForDrawing.y <= 2 * FIELDSIZE;
                
                // resize and move, calculate new offset of the scroller, so we don't get "thrown around"
                // if we are at the upper border AND the left border, only do this once to save cpu time
                if (needsResizeMoveX && needsResizeMoveY) {
                    self.currentSize = CGSizeMake((self.currentSize.width + (3 * FIELDSIZE) - positionForDrawing.x), (self.currentSize.height + (3 * FIELDSIZE) - positionForDrawing.y));
                    [self.gameData moveGameFieldsByHorizontal:3 - position.x byVertical:3 - position.y];
                    offset.x += zoom * (3 * FIELDSIZE - positionForDrawing.x);
                    offset.y += zoom * (3 * FIELDSIZE - positionForDrawing.y);
                    needsCompleteRedraw = YES;
                }
                else if (needsResizeMoveX) {
                    self.currentSize = CGSizeMake((self.currentSize.width + (3 * FIELDSIZE) - positionForDrawing.x), self.currentSize.height);
                    [self.gameData moveGameFieldsByHorizontal:3 - position.x byVertical:0];
                    offset.x += zoom * (3 * FIELDSIZE - positionForDrawing.x);
                    needsCompleteRedraw = YES;
                } 
                else if (needsResizeMoveY) {
                    self.currentSize = CGSizeMake(self.currentSize.width, (self.currentSize.height + (3 * FIELDSIZE) - positionForDrawing.y));
                    [self.gameData moveGameFieldsByHorizontal:0 byVertical:3 - position.y];
                    offset.y += zoom * (3 * FIELDSIZE - positionForDrawing.y);
                    needsCompleteRedraw = YES;
                }
                // for the -lower- or -right- border we just need to enlarge the display area (coordinates will not change) - since drawing origin is in the upper-left corner, we need to calculate everything with one extra FIELDSIZE
                needsResizeMoveX = positionForDrawing.x >= self.currentSize.width - 3 * FIELDSIZE;
                needsResizeMoveY = positionForDrawing.y >= self.currentSize.height - 3 * FIELDSIZE;
                
                // we just need to resize here
                if (needsResizeMoveX && needsResizeMoveY) {
                    self.currentSize = CGSizeMake(positionForDrawing.x + 4 * FIELDSIZE, positionForDrawing.y + 4 * FIELDSIZE);
                }
                else if (needsResizeMoveX) {
                    self.currentSize = CGSizeMake(positionForDrawing.x + 4 * FIELDSIZE, self.currentSize.height);
                }
                else if (needsResizeMoveY) {
                    self.currentSize = CGSizeMake(self.currentSize.width, positionForDrawing.y + 4 * FIELDSIZE);
                }
                if (needsResizeMoveX || needsResizeMoveY) {
                    // just resize
                    [self resizeBoard];
                    [self.gameScrollView setContentOffset:offset];
                }
            }
            // update the board size once more since it could have changed - and if we hit the MAX_FIELDS threshold, set to draw everything, call the border creation in gameData and set the bool of the data so we do this only once
            [self.gameData updateBoardSize];
            if (self.gameData.boardWidth * self.gameData.boardHeight >= MAX_FIELDS && !self.gameData.didHitBoardLimit && self.gameData.rules.isExtendableBoard) {
                needsCompleteRedraw = YES;
                [self.gameData createBorderTiles];
                self.gameData.hitBoardLimit = YES;
                // display a alert for the user
                NSString *alertMessage = NSLocalizedString(@"GAME_VIEW_ALERT_BOARD_LIMITATION_MESSAGE", @"The board is now limited to the size of %i by %i fields.");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"GAME_VIEW_ALERT_BOARD_LIMITATION_TITLE", @"Notification") message:[NSString stringWithFormat:alertMessage, self.gameData.boardWidth, self.gameData.boardHeight] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
            
            // if we did resizing AND moving draw from scratch by data
            if (needsCompleteRedraw) {
                // resize, draw everything
                [self resizeBoard];
                [self changeGameFields:nil orDrawAll:YES];
                // set the new offset AFTER the resizing and drawing for it to be correct
                [self.gameScrollView setContentOffset:offset];
            } else {
                // just draw the changes
                [self changeGameFields:needsDrawing orDrawAll:NO];
            }
            // on a Bluetooth game, send the other player the turn if it is valid and it was made locally (of course) - but since the game data already changed active turns, check the opposite
            if (self.btDataHandler.currentSession && validTurn && self.gameData.isBluePlayerTurn != self.gameData.isLocalPlayerBlue) {
                [self.btDataHandler sendCommittedTurn];
                
                // deactivate controls (the data handler will re-activate them for us
                [self.tapGestureRecognizer setEnabled:NO];
                [self.navigationItem.rightBarButtonItem setEnabled:NO];
            }
            
            // reset position of last marked field to normally unattainable value to avoid having the wrong field after resizing at the coordinates
            self.gameData.positionOfLastMarkedFieldX = -1; 
            self.gameData.positionOfLastMarkedFieldY = -1;
            
            // check for game over - on game over, call cleanUpAfterGameOver and return and don't bother with updating labels or incrementing turn numbers
            if (self.gameData.isGameOver) {
                [self cleanUpAfterGameOver];
                return;
            }
            
            // let the gameData know a turn has been made
            self.gameData.numberOfTurn ++;
            
            // update the game and turn information
            [self updateLabels];
        }
    }
}

-(void) showMenu {
    // show in-game menu
    // display action sheet with options (save game, save and quit, resign, just quit)
    
    UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"GAME_VIEW_ACTION_SHEET_TITLE", @"Game Menu") delegate:self cancelButtonTitle:NSLocalizedString(@"CANCEL", @"Cancel") destructiveButtonTitle:NSLocalizedString(@"GAME_VIEW_ACTION_SHEET_RESIGN_BUTTON", @"Resign Game") otherButtonTitles:NSLocalizedString(@"GAME_VIEW_ACTION_SHEET_SAVE_BUTTON", @"Save Game"), NSLocalizedString(@"GAME_VIEW_ACTION_SHEET_MAIN_MENU_BUTTON", @"Back to Main Menu"), nil];
    [menu showFromBarButtonItem:self.navigationItem.leftBarButtonItem animated:YES];
    [menu release];
}

#pragma mark - Displaying game information

-(void) updateLabels
{
    // setting turnInfo text depending on information of gameData
    
    BOOL redLeads = self.gameData.bluePoints < self.gameData.redPoints;
    BOOL blueLeads = self.gameData.bluePoints > self.gameData.redPoints;
    
    // turn information for on-going game
    if (!self.gameData.isGameOver) {
        
        // set color depending on whose turn it is
        if (self.gameData.isBluePlayerTurn) {
            [self.turnInfo setTextColor:[UIColor blueColor]];
        }
        else {
            [self.turnInfo setTextColor:[UIColor redColor]];
        }
        
        if (self.btDataHandler.currentSession && (self.gameData.isLocalPlayerBlue != self.gameData.isBluePlayerTurn)) {
            [self.turnInfo setFont:[UIFont boldSystemFontOfSize:13.0f]];
            // display "waiting for other device" message
            [self.turnInfo setText:NSLocalizedString(@"GAME_VIEW_TURN_TEXT_WAITING", @"Waiting for other player")];
            
        } else {
            // it's a valid turn
            [self.turnInfo setFont:[UIFont boldSystemFontOfSize:19.0f]];
            // set text - we don't need to tell the player that classic modes with a limited board and no special turn limit have a natural maximum number of turns, also if we do not set a maximum number, we cannot tell it
            if (self.gameData.mode == TICTACTOE || self.gameData.mode == GOMOKU || self.gameData.rules.maxNumberOfTurns == 0) {
                NSString *tts = NSLocalizedString(@"GAME_VIEW_TURN_TEXT_SHORT", @"Turn %i");
                NSString *turnText = [NSString stringWithFormat:tts, self.gameData.numberOfTurn];
                [self.turnInfo setText:turnText];
            } else {
                NSString *ttn = NSLocalizedString(@"GAME_VIEW_TURN_TEXT_NORMAL", @"Turn %i of %i");
                NSString *turnText = [NSString stringWithFormat:ttn, self.gameData.numberOfTurn,  self.gameData.rules.maxNumberOfTurns];
                [self.turnInfo setText:turnText];
            }
        }
    }else {
        // game over information
        
        // if a game was resigned
        // set color and text, set smaller font size so information will fit in title
        if (self.gameData.hasBlueResigned) {
            [self.turnInfo setFont:[UIFont boldSystemFontOfSize:13.0f]];
            [self.turnInfo setTextColor:[UIColor redColor]];
            NSString *ttbr = NSLocalizedString(@"GAME_VIEW_TURN_TEXT_GAME_OVER_BLUE_RESIGNED", @"Blue resigned on turn %i");
            NSString *turnText = [NSString stringWithFormat:ttbr, self.gameData.numberOfTurn];
            [self.turnInfo setText:turnText];
            
        } else if (self.gameData.hasRedResigned) {
            [self.turnInfo setFont:[UIFont boldSystemFontOfSize:13.0f]];
            [self.turnInfo setTextColor:[UIColor blueColor]];
            NSString *ttrr = NSLocalizedString(@"GAME_VIEW_TURN_TEXT_GAME_OVER_RED_RESIGNED", @"Red resigned on turn %i");
            NSString *turnText = [NSString stringWithFormat:ttrr, self.gameData.numberOfTurn];
            [self.turnInfo setText:turnText];
            
        } else {
            // if game ended normally
            // set color and text, set smaller font size so information will fit in title
            [self.turnInfo setFont:[UIFont boldSystemFontOfSize:16.0f]];
            if (redLeads) {
                [self.turnInfo setTextColor:[UIColor redColor]];
                NSString *ttgorw = NSLocalizedString(@"GAME_VIEW_TURN_TEXT_GAME_OVER_RED_WON", @"Red won on turn %i");
                NSString *turnText = [NSString stringWithFormat:ttgorw, self.gameData.numberOfTurn];
                [self.turnInfo setText:turnText];
            } else if (blueLeads) {
                [self.turnInfo setTextColor:[UIColor blueColor]];
                NSString *ttgobw = NSLocalizedString(@"GAME_VIEW_TURN_TEXT_GAME_OVER_BLUE_WON", @"Blue won on turn %i");
                NSString *turnText = [NSString stringWithFormat:ttgobw, self.gameData.numberOfTurn];
                [self.turnInfo setText:turnText];
            } else {
                // no one has won
                [self.turnInfo setTextColor:[UIColor whiteColor]];
                NSString *ttgod = NSLocalizedString(@"GAME_VIEW_TURN_TEXT_GAME_OVER_DRAW", @"Draw on turn %i");
                NSString *turnText = [NSString stringWithFormat:ttgod, self.gameData.numberOfTurn];
                [self.turnInfo setText:turnText];
            }
        }
    }
    
    // display scores - color the text by leading player
    if (redLeads)
        [self.gameInfo setTextColor:[UIColor colorWithRed:1.0f green:0.333f blue:0.333f alpha:1.0f]];
    else if (blueLeads)
        [self.gameInfo setTextColor:[UIColor colorWithRed:0.333f green:0.333f blue:1.0f alpha:1.0f]];
    else
        // currently draw
        [self.gameInfo setTextColor:[UIColor whiteColor]];
    
    NSString *gt = NSLocalizedString(@"GAME_VIEW_GAME_TEXT", @"Blue Score:   %i            Red Score:   %i");
    NSString *gameText = [NSString stringWithFormat:gt, self.gameData.bluePoints,  self.gameData.redPoints];
    [self.gameInfo setText:gameText];
}

-(void) cleanUpAfterGameOver
{
    // disable all game-changing mechanics, update the labels
    [self.tapGestureRecognizer setEnabled:NO];
    //[self.navigationItem.rightBarButtonItem setHidden:YES];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    [self updateLabels];
    
    // show alert view with the option to go back to main menu directly - this will also show on loading a game which is over. this behaviour is intended.
    [self.backToMenuGameOver show];
}

- (void)layoutElements:(UIInterfaceOrientation)orientation {
    // we reuse this a lot, so declare it now
    CGRect frame;
    
    // if we do our layouting with any zoom scale != 1, we get display problems (too small area on scales > 1, too big area on < 1)
    float zoom = self.gameScrollView.zoomScale;
    self.gameScrollView.zoomScale = 1.0f;
    
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        // frame setups for portrait orientations
        frame = CGRectMake(0, 0, self.currentSize.width, self.currentSize.height);
        self.containerView.frame = frame;
        frame = [[UIScreen mainScreen]applicationFrame];
        self.view.frame = frame;
        frame.size.height -= 70;
        self.gameScrollView.frame = frame;
        self.gameScrollView.contentSize = CGSizeMake(self.containerView.frame.size.width, self.containerView.frame.size.height);
        frame = CGRectMake(5, 400, 300, 50);
        self.gameInfo.frame = frame;
        frame = CGRectMake(284, 401, 44, 44);
        self.rulesButton.frame = frame;
    } else {
        // frame setups for landscape orientations
        frame = CGRectMake(0, 0, self.currentSize.width, self.currentSize.height);
        self.containerView.frame = frame;
        frame = [[UIScreen mainScreen]applicationFrame];
        frame.size = CGSizeMake(frame.size.height, frame.size.width);
        self.view.frame = frame;
        frame.size.height -= 55;
        self.gameScrollView.frame = frame;
        self.gameScrollView.contentSize = CGSizeMake(self.containerView.frame.size.height, self.containerView.frame.size.width);
        frame = CGRectMake(5, 255, 300, 50);
        self.gameInfo.frame = frame;
        frame = CGRectMake(440, 255, 44, 44);
        self.rulesButton.frame = frame;
    }
    // finally, re-apply zoom
    self.gameScrollView.zoomScale = zoom;
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void) loadView
{
    //init UIImageView
    UIImageView *tempDisplayedGameFields = [[UIImageView alloc] init];
    self.displayedGameFields = tempDisplayedGameFields;
    [tempDisplayedGameFields release];
    
    // create container to scroll in
    // has to be size.width + FIELDSIZE and size.height + FIELDSIZE to display lower and right fields because of the way the images are drawn
    UIView *tempContainerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.currentSize.width, self.currentSize.height)];
    self.containerView = tempContainerView;
    [tempContainerView release];
    [self.containerView setBackgroundColor:[UIColor blackColor]];
    
    //get a rectangle that will be the frame with the right size for our main game view - we will reuse "frame" later for buttons and labels
    CGRect frame = [[UIScreen mainScreen]applicationFrame];
    frame.size.height -= 70;
    
    //get board dimensions
    [self.gameData updateBoardSize];
    
    //set up the scroller
    UIScrollView *tempScrollView = [[UIScrollView alloc] initWithFrame:frame];
    self.gameScrollView = tempScrollView;
    [tempScrollView release];
    [self.gameScrollView setBackgroundColor:[UIColor blackColor]];
    self.gameScrollView.bounces = YES;
    self.gameScrollView.bouncesZoom = NO;
    self.gameScrollView.maximumZoomScale = 1.333f;
    //self.gameScrollView.minimumZoomScale = self.gameScrollView.frame.size.height / self.containerView.frame.size.height;
    self.gameScrollView.minimumZoomScale = 0.666f;
    self.gameScrollView.delegate = self;
    // set initial zoom scale to maximum zoom scale on small (i.e. mostly new) extendable boards - in combination with smaller field sizes this will save memory at the cost of image quality
    if (self.gameData.rules.isExtendableBoard && (self.gameData.boardWidth < 9 || self.gameData.boardHeight < 9))
        self.gameScrollView.zoomScale = self.gameScrollView.maximumZoomScale;
    else
        self.gameScrollView.zoomScale = 1.0f;
    // in tictactoe mode, do not zoom (board too small anyway)
    if (self.gameData.mode == TICTACTOE) {
        self.gameScrollView.maximumZoomScale = 1.2f;
        self.gameScrollView.minimumZoomScale = 1.2f;
        self.gameScrollView.zoomScale = 1.2f;
        self.gameScrollView.bouncesZoom = NO;
    }
    
    //set up the game view
    [self changeGameFields:nil orDrawAll:YES];
    
    //create the view and add the scroller as subview
    UIView *tempView = [[UIView alloc]initWithFrame:[[UIScreen mainScreen]applicationFrame]];
    [tempView setBackgroundColor:[UIColor blackColor]];
    self.view = tempView;
    [tempView release];
    [self.view addSubview:self.gameScrollView];
    
    // add a tap recognizer to the contentView, set the delegate and action for this gesture
    UITapGestureRecognizer *tempRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectFieldByTap:)];
    self.tapGestureRecognizer = tempRecognizer;
    [tempRecognizer release];
    self.tapGestureRecognizer.delegate = self;
    [self.containerView addGestureRecognizer:self.tapGestureRecognizer];
    
    //add the game view to the scroller and display the middle of the content
    [self.gameScrollView addSubview:self.containerView];
    self.gameScrollView.contentSize = CGSizeMake(self.containerView.frame.size.width, self.containerView.frame.size.height);
    CGFloat displaceX = self.gameScrollView.frame.size.width / 2;
    CGFloat displaceY = self.gameScrollView.frame.size.height / 2;
    self.gameScrollView.contentOffset = CGPointMake((self.containerView.frame.size.width / 2) - displaceX, (self.containerView.frame.size.height / 2) - displaceY);
    
    //adding the rules button
    frame = CGRectMake(284, 401, 44, 44);
    UIButton *tempButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [tempButton setFrame:frame];
    //[tempButton setTitle:@"Rules" forState:UIControlStateNormal];
    self.rulesButton = tempButton;
    [self.rulesButton addTarget:self action:@selector(showRules) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.rulesButton];
    
    //adding the labels
    // turn information will be displayed in the nav bar as title
    frame = CGRectMake(10, 393, 180, 40);
    UILabel *tempLabel = [[UILabel alloc]initWithFrame:frame];
    self.turnInfo = tempLabel;
    [self.view addSubview:self.turnInfo];
    [tempLabel release];
    [self.turnInfo setBackgroundColor:[UIColor clearColor]];
    [self.turnInfo setShadowColor:[UIColor darkTextColor]];
    [self.turnInfo setFont:[UIFont boldSystemFontOfSize:19.0f]];
    [self.turnInfo setTextAlignment:UITextAlignmentCenter];
    [self.turnInfo setShadowOffset:CGSizeMake(0.0f, -1.0f)];
    
    // game information (i.e. scores) will be displayed on the bottom of the screen
    frame = CGRectMake(5, 400, 300, 50);
    UILabel *tempLabel2 = [[UILabel alloc]initWithFrame:frame];
    self.gameInfo = tempLabel2;
    [self.view addSubview:self.gameInfo];
    [tempLabel2 release];
    [self.gameInfo setBackgroundColor:[UIColor clearColor]];
    [self.gameInfo setTextAlignment:UITextAlignmentLeft];
    [self.gameInfo setTextColor:[UIColor whiteColor]];
    [self.gameInfo setFont:[UIFont boldSystemFontOfSize:16.0f]];
    // shadows disabled right now because on black area, it looks okay the way it already is
    //[self.gameInfo setShadowOffset:CGSizeMake(1, -1)];
    //[self.gameInfo setShadowColor:[UIColor blackColor]];
    
    // set the navbar title with turn information, make it black
    self.navigationItem.titleView = self.turnInfo;
    
    // configure and add the commit button to the navbar
    UIBarButtonItem *commitButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"GAME_VIEW_COMMIT_BUTTON", @"Commit") style:UIBarButtonItemStyleDone target:self action:@selector(commitTurn)];
    self.navigationItem.rightBarButtonItem = commitButton;
    [commitButton release];
    
    //set up a custom back button that will get the user all the way back to the main menu by calling a custom action
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"GAME_VIEW_MENU_BUTTON", @"Menu") style:UIBarButtonItemStyleBordered target:self action:@selector(showMenu)];
    self.navigationItem.leftBarButtonItem = menuButton;
    [menuButton release];
    
    // init and config the alert views we might need on a Bluetooth game
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"GAME_VIEW_ALERT_GAME_OVER_TITLE", @"Game Over") message:NSLocalizedString(@"GAME_VIEW_ALERT_GAME_OVER_MESSAGE", @"The game is over. Back to menu?") delegate:self cancelButtonTitle:NSLocalizedString(@"NO", @"no") otherButtonTitles:NSLocalizedString(@"YES", @"yes"), nil];
    alert.tag = 11;
    self.backToMenuGameOver = alert;
    [alert release];
    
    UIAlertView *alertReq = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GAME_VIEW_ALERT_BACK_TO_MENU_REQUEST_TITLE", @"Back to Menu") message:NSLocalizedString(@"GAME_VIEW_ALERT_BACK_TO_MENU_REQUEST_MESSAGE", @"Going back to menu on a Bluetooth game will require confirmation from the other device.\nSend request to go back to menu or disconnect from the session?") delegate:self cancelButtonTitle:NSLocalizedString(@"CANCEL", @"Cancel") otherButtonTitles:NSLocalizedString(@"SEND", @"Send"),NSLocalizedString(@"DISCONNECT", @"Disconnect"),nil];
    alertReq.tag = 13;
    self.backToMenuReqView = alertReq;
    [alertReq release];
    
    UIAlertView *alertWaitAck = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GAME_VIEW_ALERT_BACK_TO_MENU_WAIT_FOR_ACK_TITLE", @"Waiting for Response") message:NSLocalizedString(@"GAME_VIEW_ALERT_BACK_TO_MENU_WAIT_FOR_ACK_MESSAGE", @"The request to go back to menu has been sent.\nWaiting for the other device to respond...") delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"DISCONNECT", @"Disconnect"),nil];
    alertWaitAck.tag = 14;
    self.backToMenuWaitView = alertWaitAck;
    [alertWaitAck release];
    
    UIAlertView *alertAck = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GAME_VIEW_ALERT_BACK_TO_MENU_ACKNOWLEDGE_TITLE", @"Peer Wants Back to Menu") message:NSLocalizedString(@"GAME_VIEW_ALERT_BACK_TO_MENU_ACKNOWLEDGE_MESSAGE", @"The peer has send a request to go back to menu. Do it?\n(Selecting 'no' will end the session.)") delegate:self cancelButtonTitle:NSLocalizedString(@"NO", @"No") otherButtonTitles:NSLocalizedString(@"YES", @"Yes"),nil];
    alertAck.tag = 15;
    self.backToMenuAckView = alertAck;
    [alertAck release];
    
    // init the activity indicator view and add it to the alert view for waiting
    UIActivityIndicatorView *tempAcInView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    frame = CGRectMake(130, 132, 20, 20);
    tempAcInView.frame = frame;
    self.activityIndicator = tempAcInView;
    [self.backToMenuWaitView addSubview:self.activityIndicator];
    [tempAcInView release];
    
    // we are not able to make a move on: Bluetooth sessions when it is not the local player's turn
    if (self.btDataHandler.currentSession && (self.gameData.isLocalPlayerBlue != self.gameData.isBluePlayerTurn)) {
        [self.tapGestureRecognizer setEnabled:NO];
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
    
    //update the labels with initial data
    [self updateLabels];
    
    // if the view did get unloaded (e.g. by a memory warning) and there was a finished game displayed before, immediately clean up on reloading
    if (self.gameData.isGameOver)
        [self cleanUpAfterGameOver];
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewWillAppear:(BOOL)animated
{
    // layout if orientation changed: always assume portrait after leaving another view
    [self layoutElements:UIInterfaceOrientationPortrait];
    
    // set tint of the navbar to something more fitting
    self.navigationController.navigationBar.tintColor = [UIColor grayColor];
    
    // check if we are able to make a move (especially on bt games) and update labels
    // we are not able to make a move on: game over and Bluetooth sessions when it is not the local player's turn
    if (self.gameData.gameOver || (self.btDataHandler.currentSession && (self.gameData.isLocalPlayerBlue != self.gameData.isBluePlayerTurn))) {
        [self.tapGestureRecognizer setEnabled:NO];
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
    [self updateLabels];
    
    [super viewWillAppear:animated];
}

/*
- (void) viewWillDisappear:(BOOL)animated
{
    
}
*/

- (void) viewDidUnload
{
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.containerView = nil;
    self.gameScrollView = nil;
    self.displayedGameFields = nil;
    self.rulesButton = nil;
    self.tapGestureRecognizer = nil;
    self.turnInfo = nil;
    self.gameInfo = nil;
    self.backToMenuGameOver = nil;
    self.backToMenuReqView = nil;
    self.backToMenuWaitView = nil;
    self.backToMenuAckView = nil;
    self.activityIndicator = nil;
    
    // release the image context
    UIGraphicsEndImageContext();
    
    self.lastDrawn = nil;
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // all orientations supported
    return YES;
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    // hide the bottom text element and the info icon for rules view
    self.gameInfo.hidden = YES;
    self.rulesButton.hidden = YES;
    
    // call layouting code
    [self layoutElements:toInterfaceOrientation];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    // unhide elements we hid before
    self.gameInfo.hidden = NO;
    self.rulesButton.hidden = NO;
}

@end
