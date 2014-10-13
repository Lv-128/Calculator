//
//  NGOUnaryOperation.m
//  iOS Calculator
//
//  Created by Taras Koval on 10/8/14.
//  Copyright (c) 2014 taras.koval. All rights reserved.
//
//  Concrete class, node that represents unary operation in expression tree.
//

#import "NGONumber.h"
#import "NGOConstant.h"
#import "NGOUnaryOperation.h"
#import "NGOFunction.h"

@implementation NGOUnaryOperation

- (id)initWithName:(NSString *)name Argument:(NGOExpression *)argument
{
    if (self = [super init]) {
        self.name = name;
        self.args = [[NSMutableArray alloc] initWithObjects:argument, nil];
        return self;
    }
    else {
        return nil;
    }
}

- (id)copyWithZone:(NSZone *)zone
{
    NGOUnaryOperation *objectCopy = [super copyWithZone:zone];
    objectCopy.name = [self.name copyWithZone:zone];
    objectCopy.args = [self.args copyWithZone:zone];
    return objectCopy;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@", [self.name isEqualToString:@"negate" ] ? @"-" : self.name, self.args[0]];
}

- (double)evaluate
{
    return [self evaluateWithArguments:nil];
}

- (double)evaluateWithArguments:(NSDictionary *)arguments
{
    double (^function)(double) = [NGOFunction unaryOperations][self.name];
    return function([self.args[0] evaluateWithArguments:arguments]);
}

- (NGOExpression *)optimize
{
    NGOExpression *arg = [self.args[0] optimize];
    
    if ([arg isKindOfClass:[NGONumber class]] || [arg isKindOfClass:[NGOConstant class]]) {
        double (^function)(double) = [NGOFunction unaryOperations][self.name];
        return [[NGONumber alloc] initWithNumber:function([arg evaluate])];
    }
    else {
        return [[NGOUnaryOperation alloc] initWithName:self.name Argument:arg];
    }
}

@end
