//
//  AboutViewController.h
//  Groups
//
//  Created by Benjamin Mies on 04.03.10.
//  Modified by andreas for TechTacToe on 10/13/11.
//  Copyright 2011 os-cillation e.K. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AboutViewController : UIViewController

@property (nonatomic, retain) IBOutlet UILabel *labelProducts;
@property (nonatomic, retain) IBOutlet UILabel *labelVersion;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UITextView *textView;

- (IBAction)openIVideoShow;
- (IBAction)openGroupPlus;
- (IBAction)openGroupMessage;

@end
