//
//  NGOSetingsViewController.h
//  iOS Calculator
//
//  Created by Oleg on 17.10.14.
//  Copyright (c) 2014 taras.koval. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NGOViewController.h"

@interface NGOSetingsViewController : UIViewController

- (IBAction)Default:(id)sender;
- (IBAction)Steal:(id)sender;

@property (strong,nonatomic) NSString * skin;

@end
