/*-
 * Copyright 2012 os-cillation GmbH
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "ActiveGameViewController.h"
#import "AppDelegate.h"

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
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated
{
    AppDelegate *tempAppDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    self.navigationItem.title = NSLocalizedString(@"ACTIVE_GAME_TITLE", @"Active Game");
    self.navigationController.navigationBar.tintColor = [UIColor grayColor];
    // set up the background view
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[tempAppDelegate.plist objectForKey:@"main view background"]]];
    self.textLabel.text = NSLocalizedString(@"ACTIVE_GAME_LABEL", @"no game active - start a new game or load");
    [super viewDidAppear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    [textLabel release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
