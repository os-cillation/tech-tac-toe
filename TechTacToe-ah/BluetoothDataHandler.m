//
//  BluetoothDataHandler.m
//  TechTacToe-ah
//
//  Created by andreas on 14/10/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BluetoothDataHandler.h"
#import "MainViewController.h"

@implementation BluetoothDataHandler

@synthesize currentSession=_currentSession;
@synthesize mvc;
@synthesize localUserActAsServer=_localUserActAsServer;
@synthesize cointossResult=_cointossResult;

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
    }
    
    return self;
}

- (void)dealloc
{
    [_currentSession release];
    [super dealloc];
}

#pragma mark - Session delegate

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state {
    switch (state)
    {
        case GKPeerStateConnected:
            NSLog(@"connected");
            if (self.mvc.bluetoothIndicator) {
                self.mvc.bluetoothIndicator.hidden = NO;
            }
            // do first (and hopefully only) cointoss
            [self doCointoss];
            break;
            
        case GKPeerStateDisconnected:
            // since we only ever have one peer connected, thrash the session if he leaves
            if (self.currentSession) {
                self.currentSession.available = NO;
                [self.currentSession setDataReceiveHandler:nil withContext:NULL];
                self.currentSession.delegate = nil;
                self.currentSession = nil;
                [self.mvc.tableView reloadData];
                self.mvc.bluetoothIndicator.hidden = YES;
                // display alert telling about the session ending
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"BLUETOOTH_ALERT_TITLE_PEER_DISCONNECTED", @"Bluetooth Session Ended") message:NSLocalizedString(@"BLUETOOTH_ALERT_MESSAGE_PEER_DISCONNECTED", @"The bluetooth session has been terminated because the other device has disconnected.") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
                
                // if there was a running game open when the peer disconnected, set everything back to be able to run in hotseat mode
                if (self.mvc.currentGame) {
                    if (!self.mvc.currentGame.gameData.isGameOver) {
                        [self.mvc.currentGame.gameViewController.tapGestureRecognizer setEnabled:YES];
                        [self.mvc.currentGame.gameViewController.navigationItem.rightBarButtonItem setEnabled:YES];
                        [self.mvc.currentGame.gameViewController updateLabels];
                    }
                }
            }
            NSLog(@"disconnected");    
            break;
            
        default:
            break;
    }
}

#pragma mark - Data transmission

- (void) mySendDataToPeers:(NSData *) data
{
    if (self.currentSession) {
        [self.currentSession sendDataToAllPeers:data withDataMode:GKSendDataReliable error:nil];    
    }
}

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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"BLUETOOTH_ALERT_TITLE_COINTOSS_LOST", @"Cointoss Lost") message:NSLocalizedString(@"BLUETOOTH_ALERT_MESSAGE_COINTOSS_LOST", @"The virtual cointoss determined that the other device will decide on the game to be played.") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
            
        } else if (otherDeviceCoinValue == self.cointossResult) {
            [self doCointoss];
        }
    } else if (type == MESSAGE_REVOKE_CONTROL) {
        // handle revoking control of main menu
        self.localUserActAsServer = YES;
        [self.mvc.tableView reloadData];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"BLUETOOTH_ALERT_TITLE_ASSUMED_CONTROL", @"Assumed Game Control") message:NSLocalizedString(@"BLUETOOTH_ALERT_MESSAGE_ASSUMED_CONTROL", @"The other device has relinquished control.") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
        
        // give the main view controller ownership, clean up and display
        self.mvc.currentGame = aGame;
        GameViewController *tempGameViewController = [[GameViewController alloc] initWithSize:CGSizeMake(MAX(FIELDSIZE * (self.mvc.currentGame.gameData.boardWidth + 2), FIELDSIZE * 9), MAX(FIELDSIZE * (self.mvc.currentGame.gameData.boardHeight + 2), FIELDSIZE * 9)) gameData:self.mvc.currentGame.gameData];
        self.mvc.currentGame.gameViewController = tempGameViewController;
        
        self.mvc.currentGame.gameViewController.btDataHandler = self;
        
        // we need to manually deactivate controls on the first turn for the player if it is not his turn
        if (self.mvc.currentGame.gameData.isLocalPlayerBlue != self.mvc.currentGame.gameData.isBluePlayerTurn) {
            [self.mvc.currentGame.gameViewController.tapGestureRecognizer setEnabled:NO];
            [self.mvc.currentGame.gameViewController.navigationItem.rightBarButtonItem setEnabled:NO];
        }
        
        [tempGameViewController release];
        [aGame release];
        
        [self.mvc.navigationController pushViewController:self.mvc.currentGame.gameViewController animated:YES];

    } else if (type == MESSAGE_COMMIT) {
        // handle committing a turn
        // recreate the valid point where the field was committed and tell the game where it is
        int validFieldLocationX = [unarchiver decodeIntForKey:@"commit at x"];
        int validFieldLocationY = [unarchiver decodeIntForKey:@"commit at y"];
        self.mvc.currentGame.gameData.positionOfLastMarkedFieldX = validFieldLocationX;
        self.mvc.currentGame.gameData.positionOfLastMarkedFieldY = validFieldLocationY;
        self.mvc.currentGame.gameData.selection = YES;
        
        // change the status of the field in question to 'marked', so commit will accept it as valid
        NSString* key = [NSString stringWithFormat:@"%i, %i", validFieldLocationX, validFieldLocationY];
        Field *newField;
        if (self.mvc.currentGame.gameData.isBluePlayerTurn) {
           newField = [[Field alloc]initWithStatus:BLUE_MARKED atPositionX:validFieldLocationX atPositionY:validFieldLocationY]; 
        } else {
            newField = [[Field alloc]initWithStatus:RED_MARKED atPositionX:validFieldLocationX atPositionY:validFieldLocationY];
        }
        [self.mvc.currentGame.gameData.fields setObject:newField forKey:key];
        [newField release];
        
        // do the commit
        [self.mvc.currentGame.gameViewController commitTurn];
        
        // re-activate the controls since it's the local device's turn now
        [self.mvc.currentGame.gameViewController.tapGestureRecognizer setEnabled:YES];
        [self.mvc.currentGame.gameViewController.navigationItem.rightBarButtonItem setEnabled:YES];
    
    } else if (type == MESSAGE_RESIGN) {
        // handle resign of the other player
        [self.mvc.currentGame.gameData resignGame];
        [self.mvc.currentGame.gameViewController cleanUpAfterGameOver];
    }
    
    // clean up
    [unarchiver finishDecoding];
    [unarchiver release];
}

- (void)doDisconnect
{
    // first, disconnect and close the session
    [self.currentSession disconnectFromAllPeers];
    
    if (self.currentSession) {
        self.currentSession.available = NO;
        [self.currentSession setDataReceiveHandler:nil withContext:NULL];
        self.currentSession.delegate = nil;
        self.currentSession = nil;
    }
    
    // then, if we had a running game open, set it to hotseat mode again by reactivating controls and updating labels
    if (self.mvc.currentGame) {
        if (!self.mvc.currentGame.gameData.isGameOver) {
            [self.mvc.currentGame.gameViewController.tapGestureRecognizer setEnabled:YES];
            [self.mvc.currentGame.gameViewController.navigationItem.rightBarButtonItem setEnabled:YES];
            [self.mvc.currentGame.gameViewController updateLabels];
        }
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
    [archiver encodeObject:self.mvc.currentGame.gameData forKey:@"game data"];
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
    [archiver encodeInt:self.mvc.currentGame.gameData.positionOfLastMarkedFieldX forKey:@"commit at x"];
    [archiver encodeInt:self.mvc.currentGame.gameData.positionOfLastMarkedFieldY forKey:@"commit at y"];
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

@end
