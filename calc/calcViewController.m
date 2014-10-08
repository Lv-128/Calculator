//
//  calcViewController.m
//  calc
//
//  Created by Katolyk S. on 10/2/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import "calcViewController.h"
#import "math.h"

@interface calcViewController ()

@end

@implementation calcViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    newEnter = YES;
    //self.textfield.text = @"0";
}

//функція для чисел... по таку присвоєння текстовому полю
-(IBAction) Buttons:(id)sender{
    if (newEnter||[self.textfield.text isEqual:@"0"]){
        self.textfield.text = @"";
        
        newEnter = NO;
    }
    
   
    while ([self.textfield.text isEqual:@"0"]&&[sender tag]==0) {
        self.textfield.text=@"0";
        return;
    }
       
    
    NSString* keyButton=[NSString stringWithFormat:@"%i", [sender tag] ];
    NSString* symbols = self.textfield.text;
    symbols = [symbols stringByAppendingString:keyButton];
    
        self.textfield.text = symbols;
    
}

//функція для поставлення крапки
-(IBAction)pointPushed:(id)sender{
    NSRange point = [self.textfield.text rangeOfString:@"."];
    
        if (point.location != NSNotFound ) {
        return;
        }
    
    self.textfield.text=[self.textfield.text stringByAppendingString:@"."];
}

// С
-(IBAction) clearFields:(id)sender{
    self.textfield.text=@"";
    newEnter = YES;
    C_Button=YES;
}

// АС
-(IBAction) AllClear:(id)sender{
    newEnter=YES;
    self.textfield.text=@"";
    lastValue=0;
    lastActions=0;
    AC_Button=YES;
}

// фунеції дій
-(IBAction) actions:(id)sender{
    /*if (newEnter && lastActions!=0) {
        return;
    }*/
    double currentValue = [self.textfield.text doubleValue];
    AC_Button=NO;
    C_Button=NO;
    while (!(AC_Button)&&!(C_Button)) {
        
    
    if (lastActions == 101) {
        currentValue = lastValue + currentValue;
    }
        
    if (lastActions == 102) {
        currentValue = lastValue - currentValue;
    }
        
    if (lastActions == 103) {
        currentValue = lastValue * currentValue;
    }
        
    if (lastActions == 104 && currentValue !=0) {
        currentValue = lastValue / currentValue;
    }
    
    
    lastValue = currentValue;
    lastActions = [sender tag];
    
    
    if (lastActions == 105) {
        currentValue -= 2*currentValue;
        self.textfield.text = [[NSNumber numberWithDouble:currentValue]stringValue];
        currentValue = [self.textfield.text doubleValue];
        return;
    }
    
    if (lastActions == 106) {
        currentValue /= 100.0;
        self.textfield.text = [[NSNumber numberWithDouble:currentValue]stringValue];
        currentValue = [self.textfield.text doubleValue];
        return;
    }
    
    if (lastActions == 107) {
        currentValue *= currentValue;
        self.textfield.text = [[NSNumber numberWithDouble:currentValue]stringValue];
        currentValue = [self.textfield.text doubleValue];
        return;
    }
    
    if (lastActions == 108) {
        currentValue = sqrt(currentValue);
        self.textfield.text = [[NSNumber numberWithDouble:currentValue]stringValue];
        currentValue = [self.textfield.text doubleValue];
        return;
    }
    
    if (lastActions == 120) {
        currentValue = sin(currentValue);
        self.textfield.text = [[NSNumber numberWithDouble:currentValue]stringValue];
        currentValue = [self.textfield.text doubleValue];
        return;
    }
    
    if (lastActions == 121) {
        currentValue = cos(currentValue);
        self.textfield.text = [[NSNumber numberWithDouble:currentValue]stringValue];
        currentValue = [self.textfield.text doubleValue];
        return;
    }
    
    if (lastActions == 122) {
        currentValue = tan(currentValue);
        self.textfield.text = [[NSNumber numberWithDouble:currentValue]stringValue];
        currentValue = [self.textfield.text doubleValue];
        return;
    }
    
    if (lastActions == 123) {
        currentValue = 1/tan(currentValue);
        self.textfield.text = [[NSNumber numberWithDouble:currentValue]stringValue];
        currentValue = [self.textfield.text doubleValue];
        return;
    }

    //факторіал
    if (lastActions == 124) {
        for (int n=(currentValue-1); n>0; --n) {
            currentValue*=n;
        }
        newEnter=YES;
        self.textfield.text = [[NSNumber numberWithDouble:currentValue]stringValue];
        currentValue = [self.textfield.text doubleValue];
        return;
    }
        
        //=
        if (lastActions == 100) {
            self.textfield.text = [[NSNumber numberWithDouble:currentValue]stringValue];
            currentValue = [self.textfield.text doubleValue];
            return;
        }

    newEnter = YES;
    
    self.textfield.text = [[NSNumber numberWithDouble:currentValue]stringValue];
   
    currentValue = [self.textfield.text doubleValue];
        return;
        }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
