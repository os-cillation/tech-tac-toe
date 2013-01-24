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

#import "AboutViewController.h"


@implementation AboutViewController

@synthesize labelProducts = _labelProducts;
@synthesize labelVersion = _labelVersion;
@synthesize scrollView = _scrollView;
@synthesize textView = _textView;

- (void)dealloc
{
    [_labelProducts release], _labelProducts = nil;
    [_labelVersion release], _labelVersion = nil;
    [_scrollView release], _scrollView = nil;
    [_textView release], _textView = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad
{
	[super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.scrollView.contentSize = CGSizeMake(320, 700);
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    self.labelVersion.text = [NSString stringWithFormat:@"%@ (%@)",
                              [infoDictionary objectForKey:@"CFBundleShortVersionString"],
                              [infoDictionary objectForKey:@"BuildNumber"]];
	self.labelProducts.text = NSLocalizedString(@"otherProducts", @"");
	self.textView.text = NSLocalizedString(@"aboutText", @"");
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.labelProducts = nil;
    self.labelVersion = nil;
    self.scrollView = nil;
    self.textView = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.tintColor = [UIColor grayColor];
}

#pragma mark -
#pragma mark Actions


- (IBAction)openIVideoShow
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=428492557&amp;amp;amp;amp;mt=8"]];
}


- (IBAction)openGroupPlus
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=377201940&amp;amp;amp;amp;mt=8"]];
}

@end
