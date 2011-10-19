//
//  AppDelegate.h
//  TechTacToe-ah
//
//  Created by andreas on 9/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BluetoothDataHandler;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    UIWindow *_mainWindow; // the only window
    UINavigationController *_navigationController; // the navigation controller which is used throughout the whole app
    BluetoothDataHandler *btdh; // the object managing bluetooth data transfers and disconnects - we need a reference to this, so we can disconnect on application termination
}

@property (nonatomic, retain) IBOutlet UIWindow *mainWindow;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, assign) BluetoothDataHandler *btdh;

@end
