//
//  NGOViewController.m
//  iOS Calculator
//
//  Created by Taras Koval on 10/2/14.
//  Copyright (c) 2014 taras.koval. All rights reserved.
//

#import "NGOViewController.h"
#include "Parser/Evaluator.h"

@interface NGOViewController ()

@property (weak, nonatomic) IBOutlet UITextField *outputTextField;
@property BOOL errorState;
@end

@implementation NGOViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]]];
    [self setNeedsStatusBarAppearanceUpdate];
    self.errorState = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)clearOutputTextField
{
    self.outputTextField.text = @"";
}

- (void)checkAndClearOutputTextFieldIfNeeded
{
    if (self.errorState)
    {
        [self clearOutputTextField];
        self.errorState = false;
    }
}

- (IBAction)valueOrOperatorButtonPressed:(UIButton *)sender
{
    [self checkAndClearOutputTextFieldIfNeeded];
    self.outputTextField.text = [self.outputTextField.text
                             stringByAppendingString:sender.currentTitle];
}

- (IBAction)clearButtonPressed:(UIButton *)sender
{
    [self clearOutputTextField];
}

- (IBAction)backButtonPressed:(UIButton *)sender
{
    if (self.outputTextField.text.length > 0) {
        if (!self.errorState) {
            self.outputTextField.text = [self.outputTextField.text
                                     substringToIndex:self.outputTextField.text.length - 1];
        }
        else {
            [self clearButtonPressed:sender];
            self.errorState = NO;
        }
    }
}

- (IBAction)equalsButtonPressed:(UIButton *)sender
{
    if (self.outputTextField.text.length > 0) {
        try {
            Evaluator evaluator([self.outputTextField.text UTF8String]);
            self.outputTextField.text = [NSString stringWithFormat:@"%.10g", evaluator.evaluate()];
        }
        catch (std::runtime_error& e) {
            self.outputTextField.text = [NSString stringWithFormat:@"%s", e.what()];
            self.errorState = YES;
        }
    }
}

@end
