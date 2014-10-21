//
//  NGOSetingsViewController.m
//  iOS Calculator
//
//  Created by Oleg on 17.10.14.
//  Copyright (c) 2014 taras.koval. All rights reserved.
//

#import "NGOSetingsViewController.h"

@interface NGOSetingsViewController ()

@end

@implementation NGOSetingsViewController

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Default:(id)sender {
    self.skin = @"Background.png";
}

- (IBAction)Steal:(id)sender {
    self.skin = @"icon.png";
}

@end
