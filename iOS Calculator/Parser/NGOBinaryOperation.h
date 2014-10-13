//
//  NGOBinaryOperation.h
//  iOS Calculator
//
//  Created by Taras Koval on 10/8/14.
//  Copyright (c) 2014 taras.koval. All rights reserved.
//
//  Concrete class, node that represents binary operation in expression tree.
//

#import <Foundation/Foundation.h>
#import "NGOOperation.h"

@interface NGOBinaryOperation : NGOOperation

- (id)initWithName:(NSString *)name LeftArgument:(NGOExpression *)leftArgument RightArgument:(NGOExpression *)rightArgument;

@end
