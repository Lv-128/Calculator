//
//  NGOUnaryOperation.m
//  iOS Calculator
//
//  Created by Taras Koval on 10/8/14.
//  Copyright (c) 2014 taras.koval. All rights reserved.
//
//  Concrete class, node that represents unary operation in expression tree.
//

#import "NGOBinaryOperation.h"
#import "NGOConstant.h"
#import "NGOFunction.h"
#import "NGONumber.h"
#import "NGOUnaryOperation.h"

@implementation NGOUnaryOperation

- (id)initWithName:(NSString *)name Argument:(NGOExpression *)argument
{
    if (self = [super init]) {
        self.name = name;
        self.args = [[NSMutableArray alloc] initWithObjects:argument, nil];
        
        [self.args[0] setParent:self];
        
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
    if ([self.name isEqualToString:@"negate"]) {
        return [NSString stringWithFormat:@"(-%@)", self.args[0]];
    }
    else {
        return [NSString stringWithFormat:@"%@(%@)", self.name, self.args[0]];
    }
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

- (NGOExpression *)differentiateWithVariable:(NSString *)variable
{
    NGOExpression *operand = self.args[0];
    NGOExpression *derivedOperand = [operand differentiateWithVariable:variable];
    
    // Negation derivative:
    // -f'
    if ([self.name isEqualToString:@"negate"]) {
        return [[NGOUnaryOperation alloc] initWithName:@"negate" Argument:derivedOperand];
    }
    // Square root derivative:
    // (sqrt(f))' = f' /(2 * cos(f))
    else if ([self.name isEqualToString:@"sqrt"]) {
        NGOBinaryOperation *denominator = [[NGOBinaryOperation alloc] initWithName:@"*"
                                                                      LeftArgument:[[NGONumber alloc] initWithNumber:2.0]
                                                                     RightArgument:[[NGOUnaryOperation alloc] initWithName:@"sqrt"
                                                                                                                  Argument:operand]];
        return [[NGOBinaryOperation alloc ] initWithName:@"/" LeftArgument:derivedOperand RightArgument:denominator];
    }
    // Sine derivative:
    // (sin(f))' = f' * cos(f)
    else if ([self.name isEqualToString:@"sin"]) {
        NGOExpression *derivedOperation = [[NGOUnaryOperation alloc] initWithName:@"cos" Argument:operand];
        return [[NGOBinaryOperation alloc] initWithName:@"*" LeftArgument:derivedOperand RightArgument:derivedOperation];
    }
    // Hyperbolic sine derivative:
    // (sinh(f))' = f' * cosh(f)
    else if ([self.name isEqualToString:@"sinh"]) {
        NGOExpression *derivedOperation = [[NGOUnaryOperation alloc] initWithName:@"cosh" Argument:operand];
        return [[NGOBinaryOperation alloc] initWithName:@"*" LeftArgument:derivedOperand RightArgument:derivedOperation];
    }
    // Cosine derivative:
    // (sin(f))' = -f' * cos(f)
    else if ([self.name isEqualToString:@"cos"]) {
        NGOExpression *derivedOperation = [[NGOUnaryOperation alloc] initWithName:@"sin" Argument:operand];
        NGOExpression *multiplication = [[NGOBinaryOperation alloc] initWithName:@"*" LeftArgument:derivedOperand RightArgument:derivedOperation];
        return [[NGOUnaryOperation alloc] initWithName:@"negate" Argument:multiplication];
    }
    // Hyperbolic cosine derivative:
    // (sin(f))' = f' * cos(f)
    else if ([self.name isEqualToString:@"cosh"]) {
        NGOExpression *derivedOperation = [[NGOUnaryOperation alloc] initWithName:@"sinh" Argument:operand];
        return [[NGOBinaryOperation alloc] initWithName:@"*" LeftArgument:derivedOperand RightArgument:derivedOperation];
    }
    // Tangent derivative:
    // (tan(f))' = f' / (cos(f) ^ 2)
    else if ([self.name isEqualToString:@"tan"]) {
        NGOExpression *cosinus = [[NGOUnaryOperation alloc] initWithName:@"cos" Argument:operand];
        NGOExpression *denominator = [[NGOBinaryOperation alloc] initWithName:@"^"
                                                                 LeftArgument:cosinus
                                                                RightArgument: [[NGONumber alloc] initWithNumber:2.0]];
        return [[NGOBinaryOperation alloc] initWithName:@"/" LeftArgument:derivedOperand RightArgument:denominator];
        
    }
    // Hyperbolic tangent derivative:
    // (sin(f))' = f' * cos(f)
    else if ([self.name isEqualToString:@"tanh"]) {
        NGOExpression *derivedOperation = [[NGOBinaryOperation alloc] initWithName:@"^"
                                                                      LeftArgument:[[NGOUnaryOperation alloc] initWithName:@"cosh" Argument:operand]
                                                                     RightArgument:[[NGONumber alloc] initWithNumber:-2.0]];
        return [[NGOBinaryOperation alloc] initWithName:@"*" LeftArgument:derivedOperand RightArgument:derivedOperation];
    }
    // Absolute value derivative:
    
    // Logarithmic derivative:
    // (log(f))' = f' / f
    else if ([self.name isEqualToString:@"log"]) {
        return [[NGOBinaryOperation alloc ] initWithName:@"/" LeftArgument:derivedOperand RightArgument:operand];
    }
    // Square root derivative:
    // (log10(f))' = f' /(f * log(10))
    else if ([self.name isEqualToString:@"log10"]) {
        NGOBinaryOperation *denominator = [[NGOBinaryOperation alloc] initWithName:@"*"
                                                                      LeftArgument:operand
                                                                     RightArgument:[[NGOUnaryOperation alloc] initWithName:@"log10"
                                                                                                                  Argument:[[NGONumber alloc] initWithNumber:10.0]]];
        return [[NGOBinaryOperation alloc ] initWithName:@"/" LeftArgument:derivedOperand RightArgument:denominator];
    }
    else {
        @throw [[NSException alloc] initWithName:@"Unknown operation"
                                          reason:@"Not implemented"
                                        userInfo:nil];
    }
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
