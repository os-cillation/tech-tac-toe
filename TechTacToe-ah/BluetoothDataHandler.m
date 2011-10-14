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
@synthesize localUserBlue=_localUserBlue;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        
        // we might change it when we connect
        self.localUserBlue = YES;
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
            break;
            
        case GKPeerStateDisconnected:
            // since we only ever have one peer connected, thrash the session if he leaves
            if (self.currentSession) {
                self.currentSession.available = NO;
                [self.currentSession setDataReceiveHandler:nil withContext:NULL];
                self.currentSession.delegate = nil;
                self.currentSession = nil;
                [self.currentSession release];
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
	// TODO
}

@end
