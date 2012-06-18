//
//  ActiveGameViewController.m
//  TechTacToe
//
//  Created by Oliver Schweissgut on 06.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ActiveGameViewController.h"

@interface ActiveGameViewController ()

@end

@implementation ActiveGameViewController

@synthesize textLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.navigationItem.title = NSLocalizedString(@"ACTIVE_GAME_TITLE", @"Active Game");
    self.navigationController.navigationBar.tintColor = [UIColor grayColor];
    // set up the background view
    NSString *resourcePath = [[NSBundle mainBundle]pathForResource:@"ImagePaths" ofType:@"plist"];
    NSDictionary *plist = [[NSDictionary alloc] initWithContentsOfFile:resourcePath];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[plist objectForKey:@"main view background"]]];
    self.textLabel.text = NSLocalizedString(@"ACTIVE_GAME_LABEL", @"no game active - start a new game or load");
    [plist release];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
