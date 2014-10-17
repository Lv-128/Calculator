//
//  NGOConstant.m
//  iOS Calculator
//
//  Created by Taras Koval on 10/12/14.
//  Copyright (c) 2014 taras.koval. All rights reserved.
//
//  Concrete class, node that represents constant in expression tree.
//

#import "NGOConstant.h"
#import "NGOFunction.h"
#import "NGONumber.h"

@implementation NGOConstant

- (id)initWithName:(NSString *)name
{
    if (self = [super init]) {
        self.name = name;
        return self;
    }
    else {
        return nil;
    }
}

- (id)copyWithZone:(NSZone *)zone
{
    NGOConstant *objectCopy = [super copyWithZone:zone];
    objectCopy.name = [self.name copyWithZone:zone];
    return objectCopy;
}

- (NSString *)description
{
    return self.name;
}

- (double)evaluate
{
    return [[NGOFunction constants][self.name] doubleValue];
}

- (double)evaluateWithArguments:(NSDictionary *)arguments
{
    return [[NGOFunction constants][self.name] doubleValue];
}

- (NGOExpression *)differentiateWithVariable:(NSString *)variable
{
    return [[NGONumber alloc] initWithNumber:0.0];
}

@end
