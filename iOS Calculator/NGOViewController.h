//
//  NGOViewController.h
//  iOS Calculator
//
//  Created by Taras Koval on 10/2/14.
//  Copyright (c) 2014 taras.koval. All rights reserved.
//

#import <UIKit/UIKit.h>


enum {plus = 40, minus = 50, multi = 20, divi = 30 , sqr = 70, c = 60 ,
    rBracket=90, lBracket=80 , equal = 3000,
    Ln = 2003, Sin = 2000, Cos = 2001, Tg = 2002, Ctg = 2004, oneDivX = 2005, Xcube =2007 , power = 2006, factorial = 2008};
@interface NGOViewController : UIViewController{
BOOL isNewEnter;

double lastValue;

NSInteger lastSign;

BOOL canPushLBracket;

//BOOL canPushRBracket;
BOOL canPushSign;

BOOL isPoint;

bool isMinusPressed;

int countBracket;

BOOL canPushDigit;
 
    bool isSymbolBeforeEqual;
    
    
}
- (IBAction)digitPushedBy:(id)sender;
- (NSString*)operationChosen:(int)sign;
-(IBAction)pointPushed:(id)sender;
@end
