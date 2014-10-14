//
//  NGOUITextField.m
//  iOS Calculator
//
//  Created by Taras Koval on 10/5/14.
//  Copyright (c) 2014 taras.koval. All rights reserved.
//

#import "NGOTextField.h"

@implementation NGOTextField

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x + 15.0, bounds.origin.y + 8.0,
                      bounds.size.width - 30.0, bounds.size.height - 16.0);
}
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return [self textRectForBounds:bounds];
}

@end
