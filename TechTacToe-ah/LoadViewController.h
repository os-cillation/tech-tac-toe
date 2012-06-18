//
//  LoadViewController.h
//  TechTacToe-ah
//
//  Created by andreas on 07/10/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadDetailViewController.h"
#import "AppDelegate.h"

@interface LoadViewController : UITableViewController {
    NSString *path; // the path to the documents folder of the app
    NSMutableArray *files; // array containing the files of the document folder - will be fetched in loadDidLoad
}

@property (nonatomic, retain) NSString *path;
@property (nonatomic, retain) NSMutableArray *files;
@property (nonatomic, retain) AppDelegate *appDelegate;

@end
