//
//  NGOBinaryOperation.m
//  iOS Calculator
//
//  Created by Taras Koval on 10/8/14.
//  Copyright (c) 2014 taras.koval. All rights reserved.
//
//  Concrete class, node that represents binary operation in expression tree.
//

#import "NGOBinaryOperation.h"
#import "NGOConstant.h"
#import "NGOFunction.h"
#import "NGONumber.h"
#import "NGOUnaryOperation.h"

@implementation NGOBinaryOperation

- (id)initWithName:(NSString *)name LeftArgument:(NGOExpression *)leftArgument RightArgument:(NGOExpression *)rightArgument
{
    if (self = [super init]) {
        self.name = name;
        self.args = [[NSMutableArray alloc] initWithObjects:leftArgument, rightArgument, nil];
        return self;
    }
    else {
        return nil;
    }
}

- (id)copyWithZone:(NSZone *)zone
{
    NGOBinaryOperation *objectCopy = [super copyWithZone:zone];
    objectCopy.name = [self.name copyWithZone:zone];
    objectCopy.args = [self.args copyWithZone:zone];
    return objectCopy;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"(%@ %@ %@)", self.args[0], self.name, self.args[1]];
}

- (double)evaluate
{
    return [self evaluateWithArguments:nil];
}

- (double)evaluateWithArguments:(NSDictionary *)arguments
{
    double (^function)(double, double) = [NGOFunction binaryOperations][self.name];
    return function([self.args[0] evaluateWithArguments:arguments], [self.args[1] evaluateWithArguments:arguments]);
}

- (NGOExpression *)differentiateWithVariable:(NSString *)variable
{
    if ([self.name isEqualToString:@"+"]) {
        return [[NGOBinaryOperation alloc] initWithName:@"+"
                                           LeftArgument:[(NGOExpression*)self.args[0] differentiateWithVariable:variable]
                                          RightArgument:[(NGOExpression*)self.args[1] differentiateWithVariable:variable]];
    }
    else if ([self.name isEqualToString:@"-"]) {
        return [[NGOBinaryOperation alloc] initWithName:@"-"
                                           LeftArgument:[(NGOExpression*)self.args[0] differentiateWithVariable:variable]
                                          RightArgument:[(NGOExpression*)self.args[1] differentiateWithVariable:variable]];
    }
    else if ([self.name isEqualToString:@"*"]) {
        return [[NGOBinaryOperation alloc] initWithName:@"+"
                                           LeftArgument:[[NGOBinaryOperation alloc] initWithName:@"*"
                                                                                    LeftArgument:self.args[0]
                                                                                   RightArgument:[(NGOExpression*)self.args[1] differentiateWithVariable:variable]]
                                          RightArgument:[[NGOBinaryOperation alloc] initWithName:@"*"
                                                                                    LeftArgument:[(NGOExpression*)self.args[0] differentiateWithVariable:variable]
                                                                                   RightArgument:self.args[1]]];
    }
    else if ([self.name isEqualToString:@"/"]) {
        NGOBinaryOperation *numerator = [[NGOBinaryOperation alloc] initWithName:@"-"
                                                                    LeftArgument:[[NGOBinaryOperation alloc] initWithName:@"*"
                                                                                                             LeftArgument:self.args[0]
                                                                                                            RightArgument:[(NGOExpression*)self.args[1] differentiateWithVariable:variable]]
                                                                   RightArgument:[[NGOBinaryOperation alloc] initWithName:@"*"
                                                                                                             LeftArgument:[(NGOExpression*)self.args[0] differentiateWithVariable:variable]
                                                                                                            RightArgument:self.args[1]]];
        return [[NGOBinaryOperation alloc] initWithName:@"/"
                                           LeftArgument: numerator
                                          RightArgument:[[NGOBinaryOperation alloc] initWithName:@"*"
                                                                                    LeftArgument:self.args[1]
                                                                                   RightArgument:self.args[1]]];
    }
    else {
        @throw [[NSException alloc] initWithName:@"Unknown operation"
                                          reason:@"Not implemented"
                                        userInfo:nil];
    }
}

- (NGOExpression *)optimize
{
    NGOExpression *arg1 = [self.args[0] optimize];
    NGOExpression *arg2 = [self.args[1] optimize];
    NGOExpression *res;
    
    if (([arg1 isKindOfClass:[NGONumber class]] || [arg1 isKindOfClass:[NGOConstant class]]) &&
        ([arg2 isKindOfClass:[NGONumber class]] || [arg2 isKindOfClass:[NGOConstant class]])) {
        double (^function)(double, double) = [NGOFunction binaryOperations][self.name];
        res = [[NGONumber alloc] initWithNumber:function([arg1 evaluate], [arg2 evaluate])];
    }
    else if ([self.name isEqualToString:@"+"]) {
        if ([arg1 isKindOfClass:[NGONumber class]] && [arg1 evaluate] == 0.0) {
            res = arg2;
        }
        else if ([arg2 isKindOfClass:[NGONumber class]] && [arg2 evaluate] == 0.0) {
            res = arg1;
        }
        else {
            res = [[NGOBinaryOperation alloc] initWithName:self.name LeftArgument:arg1 RightArgument:arg2];
        }
    }
    else if ([self.name isEqualToString:@"-"]) {
        if ([arg1 isKindOfClass:[NGONumber class]] && [arg1 evaluate] == 0.0) {
            NGOExpression *node = [[NGOUnaryOperation alloc] initWithName:@"negate" Argument:arg2];
            res = [node optimize];
        }
        else if ([arg2 isKindOfClass:[NGONumber class]] && [arg2 evaluate] == 0.0) {
            res = arg1;
        }
        else {
            res = [[NGOBinaryOperation alloc] initWithName:self.name LeftArgument:arg1 RightArgument:arg2];
        }
    }
    else if ([self.name isEqualToString:@"*"]) {
        if (([arg1 isKindOfClass:[NGONumber class]] && [arg1 evaluate] == 0) ||
            ([arg2 isKindOfClass:[NGONumber class]] && [arg2 evaluate] == 0)) {
            res = [[NGONumber alloc] initWithNumber:0.0];
        }
        else if ([arg1 isKindOfClass:[NGONumber class]] && [arg1 evaluate] == 1.0) {
            res = arg2;
        }
        else if ([arg2 isKindOfClass:[NGONumber class]] && [arg2 evaluate] == 1.0) {
            res = arg1;
        }
        else {
            res = [[NGOBinaryOperation alloc] initWithName:self.name LeftArgument:arg1 RightArgument:arg2];
        }
    }
    else if ([self.name isEqualToString:@"/"]) {
        if ([arg2 isKindOfClass:[NGONumber class]] && [arg2 evaluate] == 1.0) {
            res = arg1;
        }
        else {
            res = [[NGOBinaryOperation alloc] initWithName:self.name LeftArgument:arg1 RightArgument:arg2];
        }
    }
    else if ([self.name isEqualToString:@"^"]) {
        if ([arg1 isKindOfClass:[NGONumber class]] && [arg1 evaluate] == 1.0) {
            res = [[NGONumber alloc] initWithNumber:1.0];
        }
        else if ([arg2 isKindOfClass:[NGONumber class]] && [arg2 evaluate] == 1.0) {
            res = arg1;
        }
        else {
            res = [[NGOBinaryOperation alloc] initWithName:self.name LeftArgument:arg1 RightArgument:arg2];
        }
    }
    else {
        res = [[NGOBinaryOperation alloc] initWithName:self.name LeftArgument:arg1 RightArgument:arg2];
    }
    
    return res;
}

@end
