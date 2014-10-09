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

@property (weak, nonatomic) IBOutlet UIButton *butSqrt;
@property (weak, nonatomic) IBOutlet UIButton *butLn;
@property (weak, nonatomic) IBOutlet UIButton *butSin;
@property (weak, nonatomic) IBOutlet UIButton *butCos;
@property (weak, nonatomic) IBOutlet UIButton *butTg;
@property (weak, nonatomic) IBOutlet UIButton *butCtg;
@property (weak, nonatomic) IBOutlet UIButton *oneDivX;
@property (weak, nonatomic) IBOutlet UIButton *butXCube;
@property (weak, nonatomic) IBOutlet UIButton *butXsquare;
@property (weak, nonatomic) IBOutlet UIButton *butFact;

@property (weak, nonatomic) IBOutlet UITextField *outputTextField;
@property BOOL errorState;
@end

@implementation NGOViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isNewEnter = YES;
    isPoint = YES;
    countBracket=0;
    canPushSign = NO;
    self.outputTextField.text = @"0";
    canPushLBracket=YES;
    canPushDigit=YES;
    isMinusPressed =NO;
    isSymbolBeforeEqual=NO;
    
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
    self.outputTextField.text = @"0";
    lastSign = 0;
    lastValue = 0;
    isPoint = YES;
    isNewEnter = YES;
    canPushDigit=YES;
}
//
//- (void)checkAndClearOutputTextFieldIfNeeded
//{
//    if (self.errorState)
//    {
//        [self clearOutputTextField];
//        self.errorState = false;
//    }
//}

//- (IBAction)valueOrOperatorButtonPressed:(UIButton *)sender
//{
//    [self checkAndClearOutputTextFieldIfNeeded];
//    self.outputTextField.text = [self.outputTextField.text
//                             stringByAppendingString:sender.currentTitle];
//}

- (IBAction)deleteDigit
{
    
    NSString * current = self.outputTextField.text;
    NSString * lastSymbol = [current substringFromIndex:[current length] - 1];
    if ( [lastSymbol isEqual:@"+"] || [lastSymbol isEqual:@"-"] || [lastSymbol isEqual:@"*"]|| [lastSymbol isEqual:@"/"])
    {
        canPushSign =YES;
        isPoint=NO;
        
    }
    if ([lastSymbol isEqual:@"("]) canPushLBracket = YES; canPushSign = YES; countBracket--;
    
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

- (NSString*)operationChosen:(int)sign
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
    
    canPushLBracket=YES;
    return res;
    
}

- (IBAction)digitPushedBy:(id)sender // нажатие цифры
{
    
    if(isNewEnter)
    {
        
        if ([sender tag]!= plus && [sender tag]!= minus && [sender tag]!= multi && [sender tag]!= divi){ // новый ввод
            
            canPushSign = NO;
            canPushDigit=YES;
            isPoint = YES;
            self.outputTextField.text= @"0";
        }
        isNewEnter=NO;
    }
    
    
    
    
    NSString * currValue; // текущее значение
    currValue = self.outputTextField.text; // получаем из поля ввода
    
    if ([currValue isEqual:@"0"]&& [sender tag]==0)// если например несколько раз нажат нуль, то повторно он не вносится в строку
    {
        
        return;
    }
    
    NSString * currNum = [ NSString stringWithFormat:@"%i",[sender tag]]; // текущая нажатая кнопочка
    
    
    switch ([sender tag])
    {
            ///
            ////добавляем знак в строку
            
            
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
                    
                    if (([beforeLastSymbol isEqual:@"0"] || [beforeLastSymbol isEqual:@"1"]  ||[beforeLastSymbol isEqual:@"2"] ||
                         [beforeLastSymbol isEqual:@"3"]  ||[beforeLastSymbol isEqual:@"4"]  || [beforeLastSymbol isEqual:@"5"] ||
                         [beforeLastSymbol isEqual:@"6"]  || [beforeLastSymbol isEqual:@"7"]  || [beforeLastSymbol isEqual:@"8"]||
                         [beforeLastSymbol isEqual:@"9"]) || [beforeLastSymbol isEqual:@")"]  )
                    {
                        currValue  = [currValue stringByAppendingString:@")"];
                        countBracket--;
                        canPushDigit=NO;
                    }
                    
                }
            }
            //isPoint = YES;
            //   canPushSign = NO;
            break;
        }
            /////
            /////добавляем цифру в строку
        default:
        {
            if(canPushDigit==YES)
            {
                if ([currValue isEqual:@"0"] && [sender tag]!=0)// если перед вводимой цифрой был нуль, то нуль заменяется на эту цифру
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
            
            canPushLBracket=NO;
            break;
        }
    }
    
    
    
    
    
    self.outputTextField.text= currValue;
    
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


-(IBAction)signPushed:(id)sender{ // нажатие знака
    //if (isNewEnter)  return;
    
    
    double currValue;
    
    lastValue = currValue;
    lastSign = [sender tag];
    
    if (canPushSign){
        
        
        if (!(countBracket==0))
        {
            for (int i=0; i< countBracket;++i)
            {
                //self.outputTextField.text= [self.textField.text stringByAppendingString:@")"];
            }
            
        }
        
        NSString * curExpression = self.outputTextField.text;
        /// cинус
        if(lastSign == Sin){
            curExpression = [@"sin( " stringByAppendingString:curExpression];
         
     
              self.outputTextField.text = curExpression;
            
        }
        else
            ///kosinus
            if(lastSign == Cos){
          
                curExpression = [@"cos( " stringByAppendingString:curExpression];
              
                
            }
            else
                /// tangens
                if(lastSign == Tg){
 
                    curExpression = [@"tg( " stringByAppendingString:curExpression];
            

                }
                else
                    /// koren
                    if(lastSign == sqr){
                        
                      
                        curExpression = [@"sqrt( " stringByAppendingString:curExpression];
               
     
                        
                        
                    }
                    else
                        /// логарифм
                        if(lastSign == Ln){
                         
                            curExpression = [@"log( " stringByAppendingString:curExpression];
                            
                        
                            
                            
                            
                        }
                        else
                            /// cotangens
                            if(lastSign == Ctg){
                     
                                curExpression = [@"ctg( " stringByAppendingString:curExpression];
                             
                     
                            }
                            else
                                /// 1/x
                                if(lastSign == oneDivX){

                                    curExpression = [@"1.0/( " stringByAppendingString:curExpression];
                       
  
                                }
                                else
                                    /// x^2
                                    if(lastSign == XSquare){

                                        curExpression = [@"( " stringByAppendingString:curExpression];
                                       curExpression = [curExpression stringByAppendingString:@"^"];
                                        isSymbolBeforeEqual = YES;
                            
                                    }
                                    else
                                        /// x^3
                                        if(lastSign == Xcube){
                                           
                                            curExpression = [@"x^3( " stringByAppendingString:curExpression];
                                        
                                 
                                        }
//                                        else
//                                            /// x!
//                                            if(lastSign == factorial){
//                                             
//                                                for (int n=(currValue-1); n>0; --n) {
//                                                    currValue*=n;
//                                                }
//                                                curExpression = [@"x!( " stringByAppendingString:curExpression];
//                                                curExpression = [curExpression stringByAppendingString:@" ) = "];
//                                                
//                                                self.textLabel.text = curExpression;
//                                                self.textField.text =[NSString stringWithFormat:@"%f", currValue];
//                                            }
        
                                if(lastSign == equal)
                                            {
                                                ///////////
                                                //
                                                ///////////
                                                // считываем введенное пользователем выражение и вычисляем
                                             
                                                //NSExpression *e = [NSExpression expressionWithFormat:curExpression];
                                                //currValue= [[e expressionValueWithObject:nil context:nil] doubleValue];
                                                
                                                
                                                 if( isSymbolBeforeEqual ==YES)
                                                 {
                                                       curExpression = [curExpression stringByAppendingString:@"1"];
                                                 }
                                                isSymbolBeforeEqual = NO;
                                                Evaluator evaluator([curExpression UTF8String]);
                                                currValue = evaluator.evaluate();
                                                
                                                // curExpression = [curExpression stringByAppendingString:@" = "];
                                                //self.textLabel.text = [NSS] /*curExpression*/;
                                                
                                                //  self.textField.text =[NSString stringWithFormat:@"%f", currValue];
                                                //self.textField.text = [[NSNumber numberWithDouble: currValue] stringValue];
                                                self.outputTextField.text = [NSString stringWithFormat:@"%g", currValue];
                                                isPoint = YES;
                                                
                                                isNewEnter = YES;
                                                
                                            }
                                else{
      curExpression = [curExpression stringByAppendingString:@" )"];
                                    self.outputTextField.text = curExpression;}
        
        isNewEnter=YES;
        canPushDigit=NO;
        isPoint=NO;
        lastValue = currValue;
        lastSign = 0;
        canPushSign = YES;
    }
    
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
        toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        _butTg.hidden = NO;
        _butSqrt.hidden = NO;
        _butSin.hidden = NO;
        _butLn.hidden = NO;
        _butCos.hidden = NO;
        _butCtg.hidden=NO;
        _oneDivX.hidden= NO;
        _butXCube.hidden=NO;
        _butXsquare.hidden=NO;
        _butFact.hidden= NO;
        
    }
    else
    {
        _butCos.hidden = YES;
        _butLn.hidden = YES;
        _butSin.hidden=YES;
        _butSqrt.hidden = YES;
        _butTg.hidden=YES;
        _butCtg.hidden=YES;
        _oneDivX.hidden= YES;
        _butXCube.hidden=YES;
        _butXsquare.hidden=YES;
        _butFact.hidden = YES;
    }
}


@end
