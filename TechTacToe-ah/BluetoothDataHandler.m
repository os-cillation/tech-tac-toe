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
                // TODO? display alert telling about the session ending
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
        } else if (otherDeviceCoinValue == self.cointossResult) {
            [self doCointoss];
        }
    } else if (type == MESSAGE_REVOKE_CONTROL) {
        // handle revoking control of main menu
        self.localUserActAsServer = YES;
        [self.mvc.tableView reloadData];
        
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
        
        [tempGameViewController release];
        [aGame release];
        
        [self.mvc.navigationController pushViewController:self.mvc.currentGame.gameViewController animated:YES];

    } else if (type == MESSAGE_COMMIT) {
        // handle committing a turn
        // TODO
        
    }
    
    // clean up
    [unarchiver finishDecoding];
    [unarchiver release];
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

@end
