//
//  NGOViewController.m
//  iOS Calculator
//
//  Created by Taras Koval on 10/2/14.
//  Copyright (c) 2014 taras.koval. All rights reserved.
//

#import "NGOViewController.h"
#include "Parser/NGOFunction.h"

@interface NGOViewController ()
@property (weak, nonatomic) IBOutlet UIButton *butEqual;

@property (weak, nonatomic) IBOutlet UIButton *butSqrt;
@property (weak, nonatomic) IBOutlet UIButton *butLn;
@property (weak, nonatomic) IBOutlet UIButton *butSin;
@property (weak, nonatomic) IBOutlet UIButton *butCos;
@property (weak, nonatomic) IBOutlet UIButton *butTg;

@property (weak, nonatomic) IBOutlet UIButton *oneDivX;
@property (weak, nonatomic) IBOutlet UIButton *butXCube;
@property (weak, nonatomic) IBOutlet UIButton *butXsquare;
@property (weak, nonatomic) IBOutlet UIButton *butFact;


@property (weak, nonatomic) IBOutlet UIButton *butSinh;
@property (weak, nonatomic) IBOutlet UIButton *butCosh;
@property (weak, nonatomic) IBOutlet UIButton *butTgh;


@property (weak, nonatomic) IBOutlet UISwitch *switcherForNormalCalc;


@property (weak, nonatomic) IBOutlet UILabel *outputTextLabel;

@property (weak, nonatomic) IBOutlet UITextField *outputTextField;
@property (weak, nonatomic) IBOutlet UIButton *butX;

@end

@implementation NGOViewController

enum {
    plus = 40, minus = 50, multi = 20, divi = 30,
    c = 60, sqr = 70, rBracket=90, lBracket=80, equal = 3000,
    Ln = 2003, Sin = 2000, Cos = 2001, Tg = 2002, Ctg = 2004, oneDivX = 2005, Xcube =2007 , power = 2006, factorial = 2008,
     Tanh =2010, Cosh = 2011, Sinh = 2012
};

BOOL isNewEnter;
double lastValue;
NSInteger lastSign;
BOOL canPushLBracket;
// BOOL canPushRBracket;
BOOL canPushSign;
BOOL isPoint;
bool isMinusPressed;
int countBracket;
BOOL canPushDigit;
bool isSymbolBeforeEqual;

bool canPressX;
bool previousSymbol;

- (void)viewDidLoad
{
    [super viewDidLoad];
    canPressX =YES;
    _butEqual.titleLabel.text=@"y'";
    _butX.hidden = NO;
    isNewEnter = YES;
    isPoint = YES;
    countBracket=0;
    canPushSign = NO;
    self.outputTextField.text = @"0";
    canPushLBracket=YES;
    canPushDigit=YES;
    isMinusPressed =NO;
    isSymbolBeforeEqual=NO;
    previousSymbol=1;
    
	// Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]]];
    [self setNeedsStatusBarAppearanceUpdate];

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
    self.outputTextField.text = @"0";
    lastSign = 0;
    lastValue = 0;
    isPoint = YES;
    isNewEnter = YES;
    canPushDigit=YES;
    previousSymbol=1;
    canPressX =YES;
    countBracket=0;
}

- (IBAction)deleteDigit
{
    
    NSString * current = self.outputTextField.text;
    if( [current isEqualToString:@"∞"])
    {
            self.outputTextField.text = @"0";
    }
    else
    {
        NSString * lastSymbol = [current substringFromIndex:[current length] - 1];
        if ([lastSymbol isEqualToString:@"x"]) canPressX=YES; canPushDigit=YES;
        
        if ( [lastSymbol isEqual:@"+"] || [lastSymbol isEqual:@"-"] || [lastSymbol isEqual:@"*"]|| [lastSymbol isEqual:@"/"])
        {
            canPushSign =YES;
            isPoint=NO;
        }
        
        if ([lastSymbol isEqual:@"("]) {
            
          //  NSString * newstr = [current substringFromIndex:[current length] - 1];
            
            if( [current length]>=4)
            {
                   NSString * beforeLastSymbol = [current substringFromIndex:([current length] - 4)];
                if ([beforeLastSymbol isEqual:@"cos("] || [beforeLastSymbol isEqual:@"sin("]  ||[beforeLastSymbol isEqual:@"tan("] ||
                    [beforeLastSymbol isEqual:@"ctg("]  || [beforeLastSymbol isEqual:@"log("] )
                    current= [current substringToIndex:[current length] - 4];
            }
            if( [current length]>=5)
            {
                NSString * beforeLastSymbol = [current substringFromIndex:([current length] - 5)];
                if ([beforeLastSymbol isEqual:@"sqrt("] )
                    current= [current substringToIndex:[current length] - 5];
            }
            
            canPushLBracket = YES;
            canPushSign = YES;
            countBracket--;
            if ([current length]>0)
            {
                self.outputTextField.text = current;
            }
            else
            {
                self.outputTextField.text = @"0";
            }
            return;
        }
    
        if ([lastSymbol isEqual:@"."]) { isPoint= YES;canPushSign =YES; }
        
        NSString * newstr = [current substringToIndex:[current length] - 1];
        
        if ([newstr length] > 0)
        {
            NSString * beforeLastSymbol = [newstr substringFromIndex:([newstr length] - 1)];
        
            if ([beforeLastSymbol isEqual:@"0"] || [beforeLastSymbol isEqual:@"1"]  ||[beforeLastSymbol isEqual:@"2"] ||
                [beforeLastSymbol isEqual:@"3"]  ||[beforeLastSymbol isEqual:@"4"]  || [beforeLastSymbol isEqual:@"5"] ||
                [beforeLastSymbol isEqual:@"6"]  || [beforeLastSymbol isEqual:@"7"]  || [beforeLastSymbol isEqual:@"8"]||
                [beforeLastSymbol isEqual:@"9"])
            {
                canPushLBracket=NO;
            }
            self.outputTextField.text = newstr;
        }
        else
        {
            self.outputTextField.text = @"0";
        }
    }
}


- (IBAction)clearButtonPressed:(UIButton *)sender
{
    [self clearOutputTextField];
    self.outputTextField.text = @"0";
    lastSign = 0;
    lastValue = 0;
    isPoint = YES;
    isNewEnter = YES;
    canPushDigit=YES;
    canPushLBracket=YES;
    previousSymbol=1;

}

- (NSString *)operationChosen:(int)sign
{
    
    NSString* res=@"";
    if (sign ==   minus && isMinusPressed==NO) // чтобы нажать минус, например -9 в начале ввода
    {
        res = [res stringByAppendingString:@"-"];
        isPoint = YES;
        canPushSign = NO;
        isMinusPressed =YES;
        
    }
    if (canPushSign == YES)// если можно нажать знак,т.е. перед этим знак не нажимали (кроме минуса)
    {
        
        switch (sign)
        {
            case power:
            {
                res = [res stringByAppendingString:@"^"];
                isPoint = YES;
                canPushSign = NO;
                isMinusPressed =NO;
                break;
            
            }
            case multi :
            {
                
                res = [res stringByAppendingString:@"*"];
                isPoint = YES;
                canPushSign = NO;
                isMinusPressed =NO;
                break;
            }
            case divi :
            {
                
                
                res = [res stringByAppendingString:@"/"];
                isPoint = YES;
                canPushSign = NO;
                isMinusPressed =NO;
                //isDoubleVal=YES;
                break;
            }
            case plus:
            {
                
                res = [res stringByAppendingString:@"+"];
                isPoint = YES;
                canPushSign = NO;
                isMinusPressed =NO;
                break;
            }
                
                
                
        }
        
    }
    canPressX =YES;
    previousSymbol = 1;
    canPushLBracket=YES;
    return res;
    
}

- (IBAction)digitPushedBy:(id)sender // нажатие цифры
{
    
    if(isNewEnter)
    {
        
        if ([sender tag]!= plus && [sender tag]!= minus && [sender tag]!= power && [sender tag]!= multi && [sender tag]!= divi){ // новый ввод
            
            canPushSign = NO;
            canPushDigit=YES;
            isPoint = YES;
            self.outputTextField.text= @"0";
        }
        isNewEnter=NO;
        countBracket=0;
    }
    
    
    
    
    NSString * currValue; // текущее значение
    currValue = self.outputTextField.text; // получаем из поля ввода
    
    if ([currValue isEqual:@"0"]&& [sender tag]==0)// если например несколько раз нажат нуль, то повторно он не вносится в строку
    {
        canPushSign =YES;
        return;
    }
    
    NSString * currNum = [ NSString stringWithFormat:@"%i",[sender tag]]; // текущая нажатая кнопочка
    
    
    switch ([sender tag])
    {
            ///
            ////добавляем знак в строку
            
        case power:
        case multi :
        case divi :
        case plus:
        case minus :
            
        {
            NSString * current = self.outputTextField.text;
            NSString * lastSymbol = [current substringFromIndex:[current length] - 1];
            if ( [lastSymbol isEqual:@"+"] || [lastSymbol isEqual:@"-"] || [lastSymbol isEqual:@"*"]|| [lastSymbol isEqual:@"/"]){ //canPushSign =YES;
                
                NSString * newstr = [current substringToIndex:[current length] - 1];
                if ([newstr length] > 0)
                {
                    currValue= newstr;
                }
                else
                {
                    
                    currValue= @"0";
                }
                canPushSign = YES;
                
            }
            previousSymbol=1;
            canPushDigit = YES;
            NSString * temp =  [self  operationChosen:[sender tag]];  //вызываем функцию добавления простого знака
            currValue = [currValue stringByAppendingString:temp];
            canPushLBracket=YES;
            break;
        }
        case lBracket :
        {
            if ([self.outputTextField.text isEqualToString:@"0"])
            {
                self.outputTextField.text=@"";
                 currValue=@"";
                
            }
            if (canPushLBracket==YES){
                currValue= [currValue stringByAppendingString:@"("]; //скобочки
                countBracket++;
                //  isPoint = YES;
                canPushSign = NO;
                
            }
              isMinusPressed=NO;
            canPressX =YES;
            previousSymbol=1;
            break;
        }
            
        case rBracket :
        {
            if (canPushSign==YES)
            {
                
                //  NSString * new = [currValue substringToIndex:[currValue length] - 1];
                if ( countBracket!=0)
                {
                    NSString * beforeLastSymbol = [currValue substringFromIndex:([currValue length] - 1)];
                    
                    
                    if ([beforeLastSymbol isEqual:@"0"] || [beforeLastSymbol isEqual:@"1"]  ||[beforeLastSymbol isEqual:@"2"] ||
                         [beforeLastSymbol isEqual:@"3"]  ||[beforeLastSymbol isEqual:@"4"]  || [beforeLastSymbol isEqual:@"5"] ||
                         [beforeLastSymbol isEqual:@"6"]  || [beforeLastSymbol isEqual:@"7"]  || [beforeLastSymbol isEqual:@"8"]||
                         [beforeLastSymbol isEqual:@"9"] || [beforeLastSymbol isEqual:@")"] || [beforeLastSymbol isEqual:@"x"]  )
                    {
                        currValue  = [currValue stringByAppendingString:@")"];
                        countBracket--;
                        canPressX = NO;
                        canPushDigit=NO;
                    }
                    
                }
            }
            isMinusPressed=NO;
               previousSymbol=1;
            //isPoint = YES;
            //   canPushSign = NO;
            break;
        }
            /////
            /////добавляем цифру в строку
        default:
        {
            if ([currValue isEqual:@"0"] &&  [sender tag]== 10)// если перед вводимой цифрой был нуль, то нуль заменяется на эту цифру
            {
                currValue =@"x";
                canPushDigit=NO;
            }
            else
                if ([sender tag] ==10 && ![currValue isEqual:@"0"])
                {
                    if ( canPressX == YES)
                    {
                        currValue = [currValue stringByAppendingString:@"x"];/// добавляем цифру в строкy
                        canPushSign = YES; // разрешаем ввод знака
                        isMinusPressed =NO;
                        isSymbolBeforeEqual = NO;
                        
                        isPoint =NO;
                          canPushDigit=NO;
                    }
                }
            else
            if(canPushDigit==YES)
            {
                if ([currValue isEqual:@"0"] && [sender tag]!=0 && [sender tag]!= 10)// если перед вводимой цифрой был нуль, то нуль заменяется на эту цифру
                {
                    currValue =[NSString stringWithFormat:@"%i", [sender tag]];
                }
                
                
              
                else
                    currValue = [currValue stringByAppendingString:currNum];/// добавляем цифру в строкy
                canPushSign = YES; // разрешаем ввод знака
                isMinusPressed =NO;
                 isSymbolBeforeEqual = NO;
            }
            // canPushRBracket =NO;
            canPressX = NO;
            previousSymbol=0;
            canPushLBracket=NO;
            break;
        }
    }
    
    
    
    
    
    self.outputTextField.text= currValue;
    
}

- (IBAction)moveToProizvodnaya:(id)sender {
    
   // UISwitch *mySwitch = (UISwitch *)sender;
    if(self.switcherForNormalCalc.on) {
        
        
        _butEqual.titleLabel.text=@"y'";
        _butX.hidden = NO;
    }
   else
    {
      _butEqual.titleLabel.text=@"=";
        _butX.hidden=YES;
    }
   [ self clearButtonPressed:0];
    
}

-(IBAction)pointPushed:(id)sender{  // нажатие точки
    
    //    NSRange range = [self.textField.text rangeOfString:@"."];
    //    if (range.location != NSNotFound){
    //        return;
    //    }
    
    if (isNewEnter  ) {
        self.outputTextField.text = @"0.";
        isPoint = NO;
        canPushSign =NO;
        canPushDigit=YES;
        isNewEnter = NO;
        isMinusPressed=YES;
        countBracket=0;
        return;
    }
    if (isPoint == YES && canPushSign == YES ){
        self.outputTextField.text =[  self.outputTextField.text  stringByAppendingString:@"."];
        isPoint = NO;
        canPushSign =NO;
        canPushDigit=YES;
        isNewEnter = NO;
        isMinusPressed=YES;
    }
    
}

-(NSString*)chooseTheOperation:(int)chosedSign ForRightExpression:(NSString*)curExpression{
    if  ( _switcherForNormalCalc.on)
    {
        if (previousSymbol==1)
        {
            if(lastSign == Sin){
                curExpression = [curExpression stringByAppendingString:@"sin("];
                countBracket++;
                self.outputTextField.text = curExpression;
            }
            else if(lastSign == Cos) {
                curExpression = [curExpression stringByAppendingString:@"cos("];
                countBracket++;
                self.outputTextField.text = curExpression;
            }
            else if(lastSign == Tg) {
                curExpression = [curExpression stringByAppendingString:@"tan("];
                countBracket++;
                self.outputTextField.text = curExpression;
            }
            else if(lastSign == sqr) {
                curExpression = [curExpression stringByAppendingString:@"sqrt("];
                countBracket++;
                self.outputTextField.text = curExpression;
            }
            else if(lastSign == Ln) {
                curExpression = [curExpression stringByAppendingString:@"log("];
                countBracket++;
                self.outputTextField.text = curExpression;
            }
            else if(lastSign == Sinh) {
                curExpression = [curExpression stringByAppendingString:@"sinh("];
                countBracket++;
                self.outputTextField.text = curExpression;
            }
            else if(lastSign == Cosh) {
                curExpression = [curExpression stringByAppendingString:@"cosh("];
                countBracket++;
                self.outputTextField.text = curExpression;
            }
            else if(lastSign == Tanh) {
                curExpression = [curExpression stringByAppendingString:@"tanh("];
                countBracket++;
                self.outputTextField.text = curExpression;
            }
            else if(lastSign == oneDivX) { // 1/x
                curExpression = [@"1.0/( " stringByAppendingString:curExpression];
                countBracket++;
                self.outputTextField.text = curExpression;
            }
          
            canPressX = YES;
            canPushSign = NO;
            canPushDigit = YES;
            isMinusPressed=NO;
            isNewEnter=NO;
        }
    }
        else
        {
            if (previousSymbol == 0)
            {
                if(lastSign == Sin)    {
                    curExpression = [@"sin(" stringByAppendingString:curExpression];
                    curExpression = [curExpression stringByAppendingString:@")"];
                }
                
                else if(lastSign == Cos)
                {
                    curExpression = [@"cos(" stringByAppendingString:curExpression ];
                    curExpression = [curExpression stringByAppendingString:@")"];
                }
                
                else if(lastSign == Tg)
                {
                    curExpression = [@"tan(" stringByAppendingString:curExpression];
                    curExpression = [curExpression stringByAppendingString:@")"];
                }
                else if(lastSign == sqr)
                {
                    curExpression = [@"sqrt(" stringByAppendingString:curExpression];
                    curExpression = [curExpression stringByAppendingString:@")"];
                }
                
                else if(lastSign == Ln)
                {
                    
                    curExpression = [@"log(" stringByAppendingString:curExpression];
                    curExpression = [curExpression stringByAppendingString:@")"];
                }
                
                else if(lastSign == Sinh)
                {
                    curExpression = [@"sinh("stringByAppendingString:curExpression ];
                    curExpression = [curExpression stringByAppendingString:@")"];
                }
                
                else if(lastSign == Cosh)
                {
                    
                    curExpression = [@"cosh(" stringByAppendingString:curExpression];
                    curExpression = [curExpression stringByAppendingString:@")"];
                }
            
                else if(lastSign == Tanh)
                {
                    curExpression = [@"tanh(" stringByAppendingString:curExpression];
                    curExpression = [curExpression stringByAppendingString:@")"];
                }
                
                else if(lastSign == oneDivX)
                {
                    curExpression = [@"1.0/( " stringByAppendingString:curExpression];
                    curExpression = [curExpression stringByAppendingString:@")"];
                }
                

               
                lastSign = equal;
                
            }
        }
        
    

    return curExpression;
    
}

-(IBAction)signPushed:(id)sender{ // нажатие знака
    
    NSString * curExpression = self.outputTextField.text;
    
    double currValue;
    
    lastValue = currValue;
    lastSign = [sender tag];
    
       if ([curExpression isEqualToString:@"0"] && _switcherForNormalCalc.on == YES)
        {
           curExpression =@"";
          self.outputTextField.text=@"";
        }
       else if ([curExpression isEqualToString:@"0"] && _switcherForNormalCalc.on == NO)previousSymbol =0;
    
       self.outputTextField.text = [self chooseTheOperation: lastSign ForRightExpression: curExpression];
        
       

    
 if (canPushSign == true)
 {
    
     if(lastSign == equal) {
         
        
            if (!(countBracket==0))
            {
                for (int i=0; i< countBracket;++i)
                {
                    self.outputTextField.text= [self.outputTextField.text stringByAppendingString:@")"];
                    
                }
                
            }
         
         curExpression = self.outputTextField.text;
         if (_switcherForNormalCalc.on )
         {
         NSLog(curExpression);
          @try {
              NGOFunction *function = [[NGOFunction alloc] initWithString:curExpression];
              self.outputTextLabel.text = [@"y'( "stringByAppendingString:curExpression];
              self.outputTextLabel.text = [self.outputTextLabel.text stringByAppendingString:@" ) = "];
              [function differentiateWithVariable:@"x"];
              curExpression = [NSString stringWithFormat:@"%@", function];
              NSLog(@"%@",function);
              self.outputTextField.text = curExpression;
              
          }
          @catch(NSException *exception) {
              self.outputTextField.text = @"∞";
          }

         }
         else
         {
         
                
                
            if( isSymbolBeforeEqual ==YES) {
                curExpression = [curExpression stringByAppendingString:@"1"];
            }
            isSymbolBeforeEqual = NO;
            
            @try {
                NGOFunction *function = [[NGOFunction alloc] initWithString:curExpression];
                currValue = [function evaluate];
                
                self.outputTextField.text = [NSString stringWithFormat:@"%g", currValue];
            }
            @catch(NSException *exception) {
                self.outputTextField.text = @"∞";
            }
            self.outputTextLabel.text = curExpression;
         }
            canPushSign = YES;
            isPoint = YES;
            isNewEnter = YES;
            canPushDigit=NO;
            isNewEnter=YES;
          if (_switcherForNormalCalc.on ==YES)
          {
              _butEqual.titleLabel.text=@"y'";
          }

            isPoint=NO;
            countBracket =0;
            lastSign = 0;
        }

                          
        
     lastValue = currValue;
 }

    
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait)
    {
        _switcherForNormalCalc.on =NO;
        _butX.hidden = YES;
        
    }
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
        toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        _butTg.hidden = NO;
        _butSqrt.hidden = NO;
        _butSin.hidden = NO;
        _butLn.hidden = NO;
        _butCos.hidden = NO;
        //_butCtg.hidden=NO;
        _oneDivX.hidden= NO;
        _butXCube.hidden=NO;
        _butXsquare.hidden=NO;
        _butFact.hidden= NO;
     
        _butSinh.hidden= NO;
        _butCosh.hidden=NO;
      
        _butTgh.hidden=NO;
        
    }
    else
    {
        _butCos.hidden = YES;
        _butLn.hidden = YES;
        _butSin.hidden=YES;
        _butSqrt.hidden = YES;
        _butTg.hidden=YES;
      //  _butCtg.hidden=YES;
        _oneDivX.hidden= YES;
        _butXCube.hidden=YES;
        _butXsquare.hidden=YES;
        _butFact.hidden = YES;
        
        _butSinh.hidden= YES;
        _butCosh.hidden=YES;
     
        _butTgh.hidden=YES;
    }
}


@end
