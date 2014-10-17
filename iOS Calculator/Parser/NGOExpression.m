//
//  NGOExpression.m
//  iOS Calculator
//
//  Created by Taras Koval on 10/8/14.
//  Copyright (c) 2014 taras.koval. All rights reserved.
//
//  Abstract class, represents nodes of expression tree.
//

#import "NGOExpression.h"

@implementation NGOExpression

// abstract
- (double)evaluate
{
    return 0.0;
}

// abstract
- (double)evaluateWithArguments:(NSDictionary *)arguments
{
    return 0.0;
}

// overriden in operation classes
- (NGOExpression *)optimize
{
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    NGOExpression *objectCopy = self.copy;
    objectCopy.parent = [self.parent copyWithZone:zone];
    return objectCopy;
}

@end
