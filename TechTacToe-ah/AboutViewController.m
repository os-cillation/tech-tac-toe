//
//  AboutViewController.m
//  Groups
//
//  Created by Benjamin Mies on 04.03.10.
//  Modified by andreas for TechTacToe on 10/13/11.
//  Copyright 2011 os-cillation e.K. All rights reserved.
//

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

    self.scrollView.contentSize = CGSizeMake(320, 700);
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    self.labelVersion.text = [NSString stringWithFormat:@"%@ (%@)",
                              [infoDictionary objectForKey:@"CFBundleShortVersionString"],
                              [infoDictionary objectForKey:@"CFBundleVersion"]];
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
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
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
