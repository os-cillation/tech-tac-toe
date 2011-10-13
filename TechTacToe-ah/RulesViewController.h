//
//  RulesViewController.h
//  TechTacToe-ah
//
//  Created by andreas on 04/10/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameData.h"

@interface RulesViewController : UIViewController {
    UILabel *numericValuesLabel;
    UILabel *extraSettingsLabel;
}

@property (nonatomic, retain) IBOutlet UILabel *numericValuesLabel;
@property (nonatomic, retain) IBOutlet UILabel *extraSettingsLabel;

-(void) displayRules:(GameData*)gameData;

@end
