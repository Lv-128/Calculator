//
//  NGONumber.h
//  iOS Calculator
//
//  Created by Taras Koval on 10/8/14.
//  Copyright (c) 2014 taras.koval. All rights reserved.
//
//  Concrete class, node that represents number in expression tree.
//

#import "NGOExpression.h"

@interface NGONumber : NGOExpression

@property double number;

- (id)initWithNumber:(double)number;

@end
