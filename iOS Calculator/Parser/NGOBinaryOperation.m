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
#import "NGOVariable.h"

@implementation NGOBinaryOperation

- (id)initWithName:(NSString *)name LeftArgument:(NGOExpression *)leftArgument RightArgument:(NGOExpression *)rightArgument
{
    if (self = [super init]) {
        self.name = name;
        self.args = [[NSMutableArray alloc] initWithObjects:leftArgument, rightArgument, nil];
        
        [self.args[0] setParent:self];
        [self.args[1] setParent:self];
        
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
    NSMutableString *result = [NSMutableString stringWithFormat:@"%@%@%@", self.args[0], self.name, self.args[1]];
    
    // Parentheses around the root of tree are not needed
    if (!self.parent) {
        return result;
    }
    else
    {
        NGOOperation *parentOperation = (NGOOperation *)self.parent;
        int selfPrecedence = [NGOFunction priorityOfToken:self.name];
        int parentPrecedence = [NGOFunction priorityOfToken:parentOperation.name];
        
        // if self has higher precedence than its parent, parentheses can be ommited
        if (selfPrecedence > parentPrecedence) {
            return result;
        }
        // if self is left-associative and is the left child of a left-associative
        // operation with the same precedence, the parentheses around self can be omitted
        else if (([self.name isEqualToString:@"+"] || [self.name isEqualToString:@"-"] ||
                  [self.name isEqualToString:@"*"] || [self.name isEqualToString:@"/"]) &&
                 self == parentOperation.args[0] && selfPrecedence == parentPrecedence) {
            return result;
        }
        // if self is right-associative and is the right child of a right-associative
        // operation with the same precedence, the parentheses around self can be omitted
        else if ([self.name isEqualToString:@"^"] && (([self.parent isKindOfClass:[NGOBinaryOperation class]] &&
                 self == parentOperation.args[1] && selfPrecedence == parentPrecedence) || [self.parent isKindOfClass:[NGOUnaryOperation class]])) {
            return result;
        }
        // if self is associative and is the child of the same operation, parentheses can be ommited
        else if (([self.name isEqualToString:@"+"] || [self.name isEqualToString:@"*"] || [self.name isEqualToString:@"/"]) &&
                 [self.name isEqualToString:parentOperation.name]) {
            return result;
        }

    }
    
    [result insertString:@"(" atIndex:0];
    [result appendString:@")"];
    
    return result;
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
    NGOExpression *leftOperand = self.args[0];
    NGOExpression *rightOperand = self.args[1];
    NGOExpression *derivedLeftOperand = [leftOperand differentiateWithVariable:variable];
    NGOExpression *derivedRightOperand = [rightOperand differentiateWithVariable:variable];
    
    // The sum rule:
    // (f + g)' = f' + g'
    if ([self.name isEqualToString:@"+"]) {
        return [[NGOBinaryOperation alloc] initWithName:@"+"
                                           LeftArgument:derivedLeftOperand
                                          RightArgument:derivedRightOperand];
    }
    // The subtraction rule:
    // (f - g)' = f' - g'
    else if ([self.name isEqualToString:@"-"]) {
        return [[NGOBinaryOperation alloc] initWithName:@"-"
                                           LeftArgument:derivedLeftOperand
                                          RightArgument:derivedRightOperand];
    }
    // The product rule:
    // (f * g)' = f' * g + f * g'
    else if ([self.name isEqualToString:@"*"]) {
        return [[NGOBinaryOperation alloc] initWithName:@"+"
                                           LeftArgument:[[NGOBinaryOperation alloc] initWithName:@"*"
                                                                                    LeftArgument:leftOperand
                                                                                   RightArgument:derivedRightOperand]
                                          RightArgument:[[NGOBinaryOperation alloc] initWithName:@"*"
                                                                                    LeftArgument:derivedLeftOperand
                                                                                   RightArgument:rightOperand]];
    }
    // The quotient rule:
    // (f / g)' = (f' * g - g' * f) / (g ^ 2)
    else if ([self.name isEqualToString:@"/"]) {
        NGOBinaryOperation *numerator = [[NGOBinaryOperation alloc]
                                         initWithName:@"-"
                                         LeftArgument:[[NGOBinaryOperation alloc] initWithName:@"*"
                                                                                  LeftArgument:leftOperand
                                                                                 RightArgument:derivedRightOperand]
                                         RightArgument:[[NGOBinaryOperation alloc] initWithName:@"*"
                                                                                   LeftArgument:derivedLeftOperand
                                                                                  RightArgument:rightOperand]];
        return [[NGOBinaryOperation alloc] initWithName:@"/"
                                           LeftArgument: numerator
                                          RightArgument:[[NGOBinaryOperation alloc] initWithName:@"*"
                                                                                    LeftArgument:rightOperand
                                                                                   RightArgument:rightOperand]];
    }
    // Generalized power rule:
    // (f ^ g) = (f ^ g) * (g' * log(f) + g * (log(f))')
    else if ([self.name isEqualToString:@"^"]) {
        
        NGOBinaryOperation *leftMultiplier = [[NGOBinaryOperation alloc] initWithName:@"^"
                                                                         LeftArgument:leftOperand
                                                                        RightArgument:rightOperand];
        
        NGOUnaryOperation *logarithm = [[NGOUnaryOperation alloc] initWithName:@"log" Argument:leftOperand];
        NGOExpression *derivedLogarithm = [logarithm differentiateWithVariable:variable];
        
        NGOBinaryOperation *leftTerm = [[NGOBinaryOperation alloc] initWithName:@"*"
                                                                   LeftArgument:derivedRightOperand
                                                                  RightArgument:logarithm];
        NGOBinaryOperation *rightTerm = [[NGOBinaryOperation alloc] initWithName:@"*"
                                                                    LeftArgument:rightOperand
                                                                   RightArgument:derivedLogarithm];
        NGOBinaryOperation *rightMultiplier = [[NGOBinaryOperation alloc] initWithName:@"+"
                                                                          LeftArgument:leftTerm
                                                                         RightArgument:rightTerm];
        return [[NGOBinaryOperation alloc] initWithName:@"*" LeftArgument:leftMultiplier RightArgument:rightMultiplier];
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
        else if ([arg1 isKindOfClass:[NGONumber class]] && [arg2 isKindOfClass:[NGOBinaryOperation class]] &&
                 [[(NGOBinaryOperation*)arg2 args][0] isKindOfClass:[NGONumber class]]) {
            NGOBinaryOperation *operation = (NGOBinaryOperation*)arg2;
            res = [[NGOBinaryOperation alloc] initWithName:operation.name
                                              LeftArgument:[[NGONumber alloc] initWithNumber:[arg1 evaluate] * [operation.args[0] evaluate]]
                                             RightArgument:operation.args[1]];
        }
        else if ([arg1 isKindOfClass:[NGOBinaryOperation class]] && [[(NGOBinaryOperation*)arg1 name] isEqualToString:@"^"] &&
                 [[(NGOBinaryOperation*)arg1 args][0] isKindOfClass:[NGOVariable class]] && [arg2 isKindOfClass:[NGOBinaryOperation class]] &&
                 [arg2 isKindOfClass:[NGOBinaryOperation class]] && [[(NGOBinaryOperation*)arg2 name] isEqualToString:@"/"] &&
                 [[(NGOBinaryOperation*)arg2 args][0] isKindOfClass:[NGONumber class]] &&
                 [[(NGOBinaryOperation*)arg2 args][1] isKindOfClass:[NGOVariable class]]) {
            
            NGOBinaryOperation *leftOperation = (NGOBinaryOperation*)arg1;
            NGOBinaryOperation *rightOperation = (NGOBinaryOperation*)arg2;
            NGONumber *power = [[NGONumber alloc] initWithNumber:[leftOperation.args[1] number] - 1.0];
            NGOBinaryOperation *powerOperation = [[NGOBinaryOperation alloc] initWithName:@"^" LeftArgument:leftOperation.args[0] RightArgument:power];
            
            res = [[[NGOBinaryOperation alloc] initWithName:self.name LeftArgument:powerOperation RightArgument:rightOperation.args[0]] optimize];
            
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
        else if ([arg2 isKindOfClass:[NGONumber class]] && [arg2 evaluate] == 0.0) {
            res = [[NGONumber alloc] initWithNumber:1.0];
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
