//
//  BluetoothDataHandler.m
//  TechTacToe-ah
//
//  Created by andreas on 14/10/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BluetoothDataHandler.h"
#import "MainViewController.h"
#import "AppDelegate.h"

@implementation BluetoothDataHandler

@synthesize currentSession=_currentSession;
@synthesize appDelegate=_appDelegate;
@synthesize localUserActAsServer=_localUserActAsServer;
@synthesize cointossResult=_cointossResult;
@synthesize mvc=_mvc;

@synthesize currentSessionBool;

#pragma mark - Initializer and memory management

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        
        // we might change it when we connect
        self.localUserActAsServer = YES;
        
        // roll once for cointoss now
        int coinValue = arc4random() % 1000;
        self.cointossResult = coinValue;
        
        // tell the application delegate about this object
        self.appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
        self.appDelegate.btdh = self;
    }
    
    return self;
}

- (void)dealloc
{
    // if a session was active, disconnect and clean-up before deallocating
    if (self.currentSession)
        [self doDisconnect];
    
    [_currentSession release];
    [_appDelegate release];
    [_mvc release];
    [super dealloc];
}

#pragma mark - Session delegate

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state {
    switch (state)
    {
        case GKPeerStateConnected:
            //NSLog(@"connected");
            if (self.appDelegate.bluetoothIndicator) {
                self.appDelegate.bluetoothIndicator.hidden = NO;
            }
            // do first (and hopefully only) cointoss
            [self doCointoss];
            break;
            
        case GKPeerStateDisconnected:
            // since we only ever have one peer connected, thrash the session if he leaves
            if (self.currentSession) {
                [self doDisconnect];
                // display alert telling about the session ending
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"BLUETOOTH_ALERT_PEER_DISCONNECTED_TITLE", @"Bluetooth Session Ended") message:NSLocalizedString(@"BLUETOOTH_ALERT_PEER_DISCONNECTED_MESSAGE", @"The Bluetooth session has been terminated because the other device has disconnected.") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
            //NSLog(@"disconnected");    
            break;
            
        default:
            break;
    }
}

#pragma mark - Manual or triggered disconnection

- (void)doDisconnect
{
    if (self.currentSession) {
        // first, disconnect and close the session
        [self.currentSession disconnectFromAllPeers];
        self.currentSession.available = NO;
        [self.currentSession setDataReceiveHandler:nil withContext:NULL];
        self.currentSession.delegate = nil;
        self.currentSession = nil;
    }
    // update the main menu to reflect new status
    [self.mvc.tableView reloadData];
    self.appDelegate.bluetoothIndicator.hidden = YES;
    
    // then, if we had a running game open, set it to hotseat mode again by reactivating controls and updating labels
    // also, dismiss any open dialogues (alert views) regarding going back to menu or waiting for the other device and stop the activity indicator
    if (self.appDelegate.currentGame) {
        [self.appDelegate.currentGame.gameViewController.backToMenuGameOver dismissWithClickedButtonIndex:-1 animated:YES];
        [self.appDelegate.currentGame.gameViewController.backToMenuWaitView dismissWithClickedButtonIndex:-1 animated:YES];
        [self.appDelegate.currentGame.gameViewController.backToMenuReqView dismissWithClickedButtonIndex:-1 animated:YES];
        [self.appDelegate.currentGame.gameViewController.backToMenuAckView dismissWithClickedButtonIndex:-1 animated:YES];
        [self.appDelegate.currentGame.gameViewController.activityIndicator stopAnimating];
        
        if (!self.appDelegate.currentGame.gameData.isGameOver) {
            [self.appDelegate.currentGame.gameViewController.tapGestureRecognizer setEnabled:YES];
            [self.appDelegate.currentGame.gameViewController.navigationItem.rightBarButtonItem setEnabled:YES];
            [self.appDelegate.currentGame.gameViewController.navigationItem.leftBarButtonItem setEnabled:YES];
            [self.appDelegate.currentGame.gameViewController updateLabels];
        }
    }
}

#pragma mark - Receiving and handling data

- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context
{
    // decode message type
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    int type = [unarchiver decodeIntForKey:@"messageType"];
    
    if (type == MESSAGE_COINTOSS) {
        // handle cointoss
        int otherDeviceCoinValue = [unarchiver decodeIntForKey:@"coinValue"];
        
        // if the other device has a higher number, give it control, if the number is the same, however unlikely, roll again
        if (otherDeviceCoinValue > self.cointossResult) {
            [self doRevokeControl];
            
            // on a lost cointoss, we should inform the user that he does not have control (but not on intentional revoking, so do it here)
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"BLUETOOTH_ALERT_COINTOSS_LOST_TITLE", @"Cointoss Lost") message:NSLocalizedString(@"BLUETOOTH_ALERT_COINTOSS_LOST_MESSAGE", @"The virtual cointoss determined that the other device will decide on the game to be played.") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
            
        } else if (otherDeviceCoinValue == self.cointossResult) {
            [self doCointoss];
        }
    } else if (type == MESSAGE_REVOKE_CONTROL) {
        // handle revoking control of main menu
        self.localUserActAsServer = YES;
        [self.mvc.tableView reloadData];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"BLUETOOTH_ALERT_ASSUMED_CONTROL_TITLE", @"Assumed Game Control") message:NSLocalizedString(@"BLUETOOTH_ALERT_ASSUMED_CONTROL_MESSAGE", @"The other device has relinquished control.") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    } else if (type == MESSAGE_GAME_DATA) {
        // handle receiving the game data
        GameData *receivedGameData = [unarchiver decodeObjectForKey:@"game data"];
        //switch players for local device
        receivedGameData.localPlayerBlue = !receivedGameData.localPlayerBlue;
        
        // build game object from the data received
        Game *aGame = [Game new];
        aGame.gameData = receivedGameData;
        
        // give the main view controller ownership, clean up and display - take care of displaying unlimited boards the same way as the one on remote device
        self.appDelegate.currentGame = aGame;
        if (aGame.gameData.boardWidth == 0) {
            GameViewController *tempGameViewController = [[GameViewController alloc] initWithSize:CGSizeMake(FIELDSIZE * 7, FIELDSIZE * 7) gameData:aGame.gameData];
            self.appDelegate.currentGame.gameViewController = tempGameViewController;
            [tempGameViewController release];
        } else {
            GameViewController *tempGameViewController = [[GameViewController alloc] initWithSize:CGSizeMake(MAX(FIELDSIZE * (self.appDelegate.currentGame.gameData.boardWidth + 2), FIELDSIZE * 9), MAX(FIELDSIZE * (self.appDelegate.currentGame.gameData.boardHeight + 2), FIELDSIZE * 9)) gameData:self.appDelegate.currentGame.gameData];
            self.appDelegate.currentGame.gameViewController = tempGameViewController;
            [tempGameViewController release];
        }
        
        
        self.appDelegate.currentGame.gameViewController.btDataHandler = self;
        
        // we need to manually deactivate controls on the first turn for the player if it is not his turn
        if (self.appDelegate.currentGame.gameData.isLocalPlayerBlue != self.appDelegate.currentGame.gameData.isBluePlayerTurn) {
            [self.appDelegate.currentGame.gameViewController.tapGestureRecognizer setEnabled:NO];
            [self.appDelegate.currentGame.gameViewController.navigationItem.rightBarButtonItem setEnabled:NO];
            [self.appDelegate.currentGame.gameViewController.navigationItem.leftBarButtonItem setEnabled:NO];
        }
        
        [aGame release];
        
        //[self.mvc.navigationController pushViewController:self.appDelegate.currentGame.gameViewController animated:YES];
        [self.appDelegate startGame];
        

    } else if (type == MESSAGE_COMMIT) {
        // handle committing a turn
        // recreate the valid point where the field was committed and tell the game where it is
        int validFieldLocationX = [unarchiver decodeIntForKey:@"commit at x"];
        int validFieldLocationY = [unarchiver decodeIntForKey:@"commit at y"];
        self.appDelegate.currentGame.gameData.positionOfLastMarkedFieldX = validFieldLocationX;
        self.appDelegate.currentGame.gameData.positionOfLastMarkedFieldY = validFieldLocationY;
        self.appDelegate.currentGame.gameData.selection = YES;
        
        // change the status of the field in question to 'marked', so commit will accept it as valid
        NSString* key = [NSString stringWithFormat:@"%i, %i", validFieldLocationX, validFieldLocationY];
        Field *newField;
        if (self.appDelegate.currentGame.gameData.isBluePlayerTurn) {
           newField = [[Field alloc]initWithStatus:BLUE_MARKED atPositionX:validFieldLocationX atPositionY:validFieldLocationY]; 
        } else {
            newField = [[Field alloc]initWithStatus:RED_MARKED atPositionX:validFieldLocationX atPositionY:validFieldLocationY];
        }
        [self.appDelegate.currentGame.gameData.fields setObject:newField forKey:key];
        [newField release];
        
        // do the commit
        [self.appDelegate.currentGame.gameViewController commitTurn];
        
        // re-activate the controls since it's the local device's turn now if it's not already game over
        if (!self.appDelegate.currentGame.gameData.isGameOver) {
            [self.appDelegate.currentGame.gameViewController.tapGestureRecognizer setEnabled:YES];
            [self.appDelegate.currentGame.gameViewController.navigationItem.rightBarButtonItem setEnabled:YES];
            [self.appDelegate.currentGame.gameViewController.navigationItem.leftBarButtonItem setEnabled:YES];
        }
        
    } else if (type == MESSAGE_RESIGN) {
        // handle resign of the other player
        [self.appDelegate.currentGame.gameData resignGame];
        [self.appDelegate.currentGame.gameViewController cleanUpAfterGameOver];
    
    } else if (type == MESSAGE_MENU_REQ) { 
        // menu-related message handling: req and ack
        // show the confirmation alert view to the other player - in case of both players sending requests at the same time, dismiss both of the waiting dialogues (not pretty, but it should work - might be a future thing to improve), also dismiss the back to menu request and back to menu on game over view
        [self.appDelegate.currentGame.gameViewController.backToMenuGameOver dismissWithClickedButtonIndex:-1 animated:YES];
        [self.appDelegate.currentGame.gameViewController.backToMenuWaitView dismissWithClickedButtonIndex:-1 animated:YES];
        [self.appDelegate.currentGame.gameViewController.backToMenuReqView dismissWithClickedButtonIndex:-1 animated:YES];
        [self.appDelegate.currentGame.gameViewController.backToMenuAckView show];
    
    } else if (type == MESSAGE_MENU_ACK) {
        // dismiss the waiting dialogue / back to menu on game over view, stop the indicator and go to menu
        [self.appDelegate.currentGame.gameViewController.backToMenuGameOver dismissWithClickedButtonIndex:-1 animated:YES];
        [self.appDelegate.currentGame.gameViewController.backToMenuWaitView dismissWithClickedButtonIndex:-1 animated:YES];
        [self.appDelegate.currentGame.gameViewController.activityIndicator stopAnimating];
        [self.appDelegate.currentGame.gameViewController.navigationController popToRootViewControllerAnimated:YES];
    }
    // clean up
    [unarchiver finishDecoding];
    [unarchiver release];
}

#pragma mark - Sending data

- (void) mySendDataToPeers:(NSData *) data
{
    if (self.currentSession) {
        [self.currentSession sendDataToAllPeers:data withDataMode:GKSendDataReliable error:nil];    
    }
}

- (void)doCointoss
{
    // cointoss
    int coinValue = arc4random() % 1000;
    self.cointossResult = coinValue;
    
    // create data packet and send
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	
    [archiver encodeInt:MESSAGE_COINTOSS forKey:@"messageType"];
    [archiver encodeInt:self.cointossResult forKey:@"coinValue"];
    
    [archiver finishEncoding];
    
    [self mySendDataToPeers:data];
    
    [archiver release];
    [data release];
}

- (void)doRevokeControl
{
    // first, let the local device know it has no server rights
    self.localUserActAsServer = NO;
    [self.mvc.tableView reloadData];
    
    // then let the other device know we rescinded control of the menu (or lost the cointoss)
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	
    [archiver encodeInt:MESSAGE_REVOKE_CONTROL forKey:@"messageType"];

    [archiver finishEncoding];
    
    [self mySendDataToPeers:data];
    
    [archiver release];
    [data release];
}

- (void)transmitCurrentGameData
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	
    // prepare object for transmission
    [archiver encodeInt:MESSAGE_GAME_DATA forKey:@"messageType"];
    [archiver encodeObject:self.appDelegate.currentGame.gameData forKey:@"game data"];
    [archiver finishEncoding];
    
    [self mySendDataToPeers:data];
    
    [archiver release];
    [data release];
}

- (void)sendCommittedTurn
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	
    // prepare object for transmission
    [archiver encodeInt:MESSAGE_COMMIT forKey:@"messageType"];
    [archiver encodeInt:self.appDelegate.currentGame.gameData.positionOfLastMarkedFieldX forKey:@"commit at x"];
    [archiver encodeInt:self.appDelegate.currentGame.gameData.positionOfLastMarkedFieldY forKey:@"commit at y"];
    [archiver finishEncoding];
    
    [self mySendDataToPeers:data];
    
    [archiver release];
    [data release];
}

- (void)sendResign
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	
    // prepare object for transmission
    [archiver encodeInt:MESSAGE_RESIGN forKey:@"messageType"];
    [archiver finishEncoding];
    
    [self mySendDataToPeers:data];
    
    [archiver release];
    [data release];
}

- (void)sendBackToMenuRequest
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	
    // prepare object for transmission
    [archiver encodeInt:MESSAGE_MENU_REQ forKey:@"messageType"];
    [archiver finishEncoding];
    
    [self mySendDataToPeers:data];
    
    [archiver release];
    [data release];
}

- (void)sendBackToMenuAcknowledge
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	
    // prepare object for transmission
    [archiver encodeInt:MESSAGE_MENU_ACK forKey:@"messageType"];
    [archiver finishEncoding];
    
    [self mySendDataToPeers:data];
    
    [archiver release];
    [data release];
}

@end
