//
//  NGOViewController.h
//  iOS Calculator
//
//  Created by Taras Koval on 10/2/14.
//  Copyright (c) 2014 taras.koval. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NGOViewController : UIViewController

- (IBAction)digitPushedBy:(id)sender;
- (NSString *)operationChosen:(int)sign;
- (IBAction)pointPushed:(id)sender;

@end
