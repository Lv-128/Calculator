//
//  NGOUnaryOperation.h
//  iOS Calculator
//
//  Created by Taras Koval on 10/8/14.
//  Copyright (c) 2014 taras.koval. All rights reserved.
//
//  Concrete class, node that represents unary operation in expression tree.
//

#import <Foundation/Foundation.h>
#import "NGOOperation.h"

@interface NGOUnaryOperation : NGOOperation

- (id)initWithName:(NSString *)name Argument:(NGOExpression *)argument;

@end
