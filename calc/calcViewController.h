//
//  calcViewController.h
//  calc
//
//  Created by Katolyk S. on 10/2/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface calcViewController : UIViewController{
    bool newEnter;
    double lastValue;
    NSInteger lastActions;
    bool AC_Button;
    bool C_Button;
}
@property (nonatomic, strong) IBOutlet UITextField *textfield;
-(IBAction) Buttons:(id)sender;
@end
