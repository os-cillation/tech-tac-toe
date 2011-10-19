//
//  GameViewController.h
//  TechTacToe-ah
//
//  Created by andreas on 9/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameData.h"
#import "RulesViewController.h"

// change this to have smaller (faster, less memory consuming) or bigger (prettier) fields - between 40 and 100 should work - do only use integer values!
#define FIELDSIZE 50

@class BluetoothDataHandler;

@interface GameViewController : UIViewController <UIScrollViewDelegate, UIGestureRecognizerDelegate, UIActionSheetDelegate, UIAlertViewDelegate>
{
    UIScrollView *gameScrollView; // the scroller for the big board
    UIView *containerView; // the containing view for the big board
    UIImageView *displayedGameFields; // the image view displaying the big board
    UIImage *redField, *blueField, *emptyField, *unavailableField, *redFieldMarked, *blueFieldMarked, *redFieldLine, *blueFieldLine; // graphics for the different types of fields
    UIImage *lastDrawn; // copy of the last drawn big board - need this to speed up drawing at expense of memory
    GameData *gameData; // the data (and logic) of the game
    CGSize currentSize; // the current size of the big board - need this to check if we resized
    UIButton *rulesButton; // the button to display the rules of the current game in a new view
    UITapGestureRecognizer *tapGestureRecognizer; // this is used to select fields in the containerView
    UILabel *turnInfo, *gameInfo; // labels describing player turn by color and turn number and current score
    BluetoothDataHandler *btDataHandler; // the data handler for a Bluetooth-enabled game - use this to check for status and send data to remote
    UIAlertView *backToMenuGameOver, *backToMenuReqView, *backToMenuWaitView, *backToMenuAckView; // alert views we need to reuse and be able to dismiss from elsewhere on certain conditions: going back to menu on a Bluetooth game and waiting for the other device to confirm
    UIActivityIndicatorView *activityIndicator; // we use this for the waiting dialogue on going back to menu
}

@property (nonatomic, retain) UIScrollView *gameScrollView;
@property (nonatomic, retain) UIView *containerView;
@property (nonatomic, retain) UIImageView *displayedGameFields;
@property (nonatomic, retain) UIImage *redField, *blueField, *emptyField, *unavailableField, *redFieldMarked, *blueFieldMarked, *redFieldLine, *blueFieldLine;
@property (nonatomic, retain) UIImage *lastDrawn;
// the game object is the owner of the data, just assign here
@property (nonatomic, assign) GameData *gameData;
@property (nonatomic) CGSize currentSize;
@property (nonatomic, retain) UIButton *rulesButton;
@property (nonatomic, retain) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, retain) UILabel *turnInfo, *gameInfo;
// the Bluetooth data handler belongs to the main view controller, but we need it - so just assign
@property (nonatomic, assign) BluetoothDataHandler *btDataHandler;
@property (nonatomic, retain) UIAlertView *backToMenuGameOver, *backToMenuReqView, *backToMenuWaitView, *backToMenuAckView;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;

// creates a new gamefield - if no field data is present a new field will be generated; if no second player is set, the game will use hotseat mode - don't use the standard init
-(GameViewController*) initWithSize:(CGSize) size gameData:(GameData*) data;

// will draw over existing field at point or draw the entire board by data
-(void) changeGameFields:(NSArray*)fieldsOrNil orDrawAll:(BOOL)redrawEverything;

// method called by the tap gesture recognizer: handles taps on the contentView, selects a field if valid, sets it in data, calls changeGameFieldAtPoint
-(void) selectFieldByTap:(UITapGestureRecognizer*)tapRecognizer;

// resizes the container, the drawing context and updates the content for the scroller and a new minimum zoom scale
-(void)resizeBoard;

// will be called when the rules button is activated: will create and display a view explaining the current rules of the game in progress
-(void) showRules;

// will be called when the commit turn button is activated: commits a turn - this means changing data, consulting rules and drawing changes. also, views might be resized and more memory needs to be allocated.
-(void) commitTurn;

// will be called if the left nav item is pressed and displays an action sheet with options (resign, save, main menu...)
-(void) showMenu;

// handles changing the labels to reflect current game status
-(void) updateLabels;

// disables the tap recognizer, hides the commit button, etc.
-(void) cleanUpAfterGameOver;

// will be called on autorotation or on appearing view and layouts the elements according to device orientation
-(void) layoutElements:(UIInterfaceOrientation)orientation;

@end
