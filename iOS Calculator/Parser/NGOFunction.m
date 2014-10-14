//
//  NGOFunction.m
//  iOS Calculator
//
//  Created by Taras Koval on 10/8/14.
//  Copyright (c) 2014 taras.koval. All rights reserved.
//

#import "NGOBinaryOperation.h"
#import "NGOConstant.h"
#import "NGOFunction.h"
#import "NGONumber.h"
#import "NGOUnaryOperation.h"
#import "NGOVariable.h"

@implementation NGOFunction

// root node of expression tree
NGOExpression *_tree;

// singleton method for receiving dictionary of unary operations
+ (NSDictionary *)unaryOperations
{
    static NSDictionary *unaryOperations = nil;
    if (!unaryOperations) {
        unaryOperations = @{
             @"abs" : ^(double x) { return fabs(x); },
            @"acos" : ^(double x) { return acos(x); },
           @"acosh" : ^(double x) { return acosh(x); },
            @"asin" : ^(double x) { return asin(x); },
           @"asinh" : ^(double x) { return asinh(x); },
            @"atan" : ^(double x) { return atan(x); },
           @"atanh" : ^(double x) { return atanh(x); },
             @"cos" : ^(double x) { return cos(x); },
            @"cosh" : ^(double x) { return cosh(x); },
             @"exp" : ^(double x) { return exp(x); },
             @"log" : ^(double x) { return log(x); },
           @"log10" : ^(double x) { return log10(x); },
          @"negate" : ^(double x) { return -x; },
             @"sin" : ^(double x) { return sin(x); },
            @"sinh" : ^(double x) { return sinh(x); },
            @"sqrt" : ^(double x) { return sqrt(x); },
             @"tan" : ^(double x) { return tan(x); },
            @"tanh" : ^(double x) { return tanh(x); }
        };
    }
    return unaryOperations;
}

// singleton method for receiving dictionary of binary operations
+ (NSDictionary *)binaryOperations
{
    static NSDictionary *binaryOperations = nil;
    if (!binaryOperations) {
        binaryOperations = @{
            @"+" : ^(double x, double y) { return x + y; },
            @"-" : ^(double x, double y) { return x - y; },
            @"*" : ^(double x, double y) { return x * y; },
            @"/" : ^(double x, double y) { return x / y; },
            @"^" : ^(double x, double y) { return pow(x, y); }
        };
    }
    return binaryOperations;
}

// singleton method for receiving dictionary of constants
+ (NSDictionary *)constants
{
    static NSDictionary *constants = nil;
    if (!constants) {
        constants = @{
             @"E" : @2.7182818284590451,
            @"PI" : @3.1415926535897931
        };
    }
    return constants;
}

// determine type of token
+ (BOOL)isParenthesisToken:(NSString *)token
{
    return [token isEqualToString:@"("] || [token isEqualToString:@")"];
}

+ (BOOL)isOperationToken:(NSString *)token
{
    return [[self unaryOperations] objectForKey:token] || [[self binaryOperations] objectForKey:token];
}

+ (BOOL)isUnaryOperationToken:(NSString *)token
{
    return [[self unaryOperations] objectForKey:token] != nil;
}

+ (BOOL)isBinaryFunctionToken:(NSString *)token
{
    return [[self binaryOperations] objectForKey:token] != nil;
}

+ (BOOL)isNumberToken:(NSString *)token
{
    NSScanner *scanner = [NSScanner scannerWithString:token];
    if ([scanner scanDouble:NULL]) {
        return [scanner isAtEnd];
    }
    return NO;
}

+ (BOOL)isConstantToken:(NSString *)token
{
    // method objectForKey will return nil if key doesn't exist so if it's not nil -
    // it will indicate that token is in dictionary so it is a constant
    return [[NGOFunction constants] objectForKey:token] != nil;
}

// determines priority of token
+ (int)priorityOfToken:(NSString *)token
{
    if ([NGOFunction isParenthesisToken:token]) {
        return 0;
    }
    else if ([token isEqualToString:@"+"] || [token isEqualToString:@"-"]) {
        return 1;
    }
    else if ([token isEqualToString:@"*"] || [token isEqualToString:@"/"]) {
        return 2;
    }
    else if ([token isEqualToString:@"^"]) {
        return 3;
    }
    else if ([NGOFunction isUnaryOperationToken:token]) {
        return 4;
    }
    else {
        return -1;
    }
}

// splits input expression into array of tokens
+ (NSMutableArray *)expressionTokensFromString:(NSString *)expression
{
    NSMutableArray *tokens = [[NSMutableArray alloc] init];
    NSMutableString *string = [NSMutableString stringWithString:@""];
    
    for (int i = 0; i < expression.length; ++i) {
        
        NSString *token = [expression substringWithRange:NSMakeRange(i, 1)];
        
        if ([NGOFunction isOperationToken:token] || [NGOFunction isParenthesisToken:token] || [token isEqualToString:@","]) {
            
            if (string.length > 0) {
                [tokens addObject:[NSString stringWithString:string]];
            }
            
            string = [NSMutableString stringWithString:@""];
            [tokens addObject:token];
        }
        else {
            
            if (token.length > 0 && ![token isEqualToString:@" "]) {
                [string appendString:token];
            }
            else {
                if (![string isEqualToString:@""]) {
                    [tokens addObject:string];
                    string = [NSMutableString stringWithString:@""];
                }
            }
        }
    }
    
    if (![string isEqualToString:@""]) {
        [tokens addObject:string];
    }
    
    return tokens;
}

// receives array of tokens in infix notation
// returns array of tokens in reverse polish notation
// based on shunting yard algorithm
+ (NSMutableArray *)reversePolishNotationFromInfixNotationTokens:(NSMutableArray *)tokens
{
    for (int i = 0; i < tokens.count; ++i) {
        if ([tokens[i] isEqualToString:@"-"] && (i == 0 || ([tokens[i - 1] isEqualToString:@"("] || [NGOFunction isOperationToken:tokens[i - 1]]))) {
            [tokens[i] isEqualToString:@"negate"];
        }
    }
    
    NSMutableArray *rpn = [[NSMutableArray alloc] init];
    NSMutableArray *stack = [[NSMutableArray alloc] init];
    
    for (NSString* token in tokens) {
        if ([NGOFunction isUnaryOperationToken:token]) {
            while (stack.count > 0 && [NGOFunction priorityOfToken:token] < [NGOFunction priorityOfToken:stack.lastObject]) {
                [rpn addObject:stack.lastObject];
                [stack removeLastObject];
            }
            
            [stack addObject:token];
        }
        else if ([NGOFunction isBinaryFunctionToken:token]) {
            while (stack.count > 0 && [NGOFunction priorityOfToken:token] <= [NGOFunction priorityOfToken:stack.lastObject]) {
                [rpn addObject:stack.lastObject];
                [stack removeLastObject];
            }
            
            [stack addObject:token];
        }
        else if ([token isEqualToString:@"("]) {
            [stack addObject:token];
        }
        else if ([token isEqualToString:@")"]) {
            while (stack.count > 0 && ![stack.lastObject isEqualToString:@"("]) {
                [rpn addObject:stack.lastObject];
                [stack removeLastObject];
            }
            
            if (stack.count > 0) {
                [stack removeLastObject];
            }
            else {
                @throw [[NSException alloc] initWithName:@"Invalid expression"
                                                  reason:@"Stack ran out of elements"
                                                userInfo:nil];
            }
        }
        else if ([token isEqualToString:@","]) {
            // TODO: add functions with multiple arguments
        }
        else {
            [rpn addObject:token];
        }
    }
    
    while (stack.count > 0) {
        if ([NGOFunction isParenthesisToken:stack.lastObject]) {
            @throw [[NSException alloc] initWithName:@"Invalid expression"
                                              reason:@"Unclosed brackets"
                                            userInfo:nil];
        }
        else {
            [rpn addObject:stack.lastObject];
            [stack removeLastObject];
        }
    }
    
    return rpn;
}

// receives array of tokens in reverse polish notation
// creates expression tree using stack machine principle and returns its root
+ (NGOExpression *)makeTreeFromReversePolishNotationTokens:(NSMutableArray *)rpn
{
    NSMutableArray *stack = [[NSMutableArray alloc] init];
    
    for (NSString* token in rpn) {
        if (![NGOFunction isOperationToken:token]) {
            if ([NGOFunction isNumberToken:token]) {
                [stack addObject:[[NGONumber alloc] initWithNumber:[token doubleValue]]];
            }
            else if ([NGOFunction isConstantToken:token]) {
                [stack addObject:[[NGOConstant alloc ] initWithName:token]];
            }
            else {
                [stack addObject:[[NGOVariable alloc] initWithName:token]];
            }
        }
        else if ([NGOFunction isUnaryOperationToken:token]) {
            if (stack.count > 0) {
                NGOExpression *arg = stack.lastObject;
                
                [stack removeLastObject];
                [stack addObject:[[NGOUnaryOperation alloc] initWithName:token Argument:arg]];
            }
            else {
                @throw [[NSException alloc] initWithName:@"Invalid expression"
                                                  reason:@"Stack ran out of elements"
                                                userInfo:nil];
            }
        }
        else if ([NGOFunction isBinaryFunctionToken:token]) {
            if (stack.count > 1) {
                NGOExpression *arg2 = stack.lastObject;
                [stack removeLastObject];
                
                NGOExpression *arg1 = stack.lastObject;
                [stack removeLastObject];
                [stack addObject:[[NGOBinaryOperation alloc] initWithName:token
                                                             LeftArgument:arg1
                                                            RightArgument:arg2]];
            }
            else {
                @throw [[NSException alloc] initWithName:@"Invalid expression"
                                                  reason:@"Stack had not enough arguments for binary function"
                                                userInfo:nil];
            }
        }
    }
    
    if (stack.count == 1) {
        return stack.lastObject;
    }
    else {
        @throw [[NSException alloc] initWithName:@"Invalid expression"
                                          reason:@"Stack machine hadn't end with one element"
                                        userInfo:nil];
    }
}

// returns root of the tree by parsing input expression
+ (NGOExpression *)parseString:(NSString *)string
{
    if (string.length > 0) {
        NSMutableArray *tokens = [NGOFunction expressionTokensFromString:string];
        NSMutableArray *rpn = [NGOFunction reversePolishNotationFromInfixNotationTokens:tokens];
        
        NGOExpression *root = [NGOFunction makeTreeFromReversePolishNotationTokens:rpn];
        
        return [root optimize];
    }
    else {
        return nil;
    }
}

- (id)initWithString:(NSString *)string
{
    if (self = [super init]) {
        _tree = [NGOFunction parseString:string];
        return self;
    }
    else {
        return nil;
    }
}

// evaluates expression by evaluating its nodes
- (double)evaluate
{
    return [_tree evaluate];
}

- (double)evaluateWithArguments:(NSDictionary *)arguments
{
    return [_tree evaluateWithArguments:arguments];
}

- (void)differentiateWithVariable:(NSString *)variable
{
    _tree = [[_tree differentiateWithVariable:variable] optimize];
}

- (NSString *)description
{
    if (_tree) {
        return [_tree description];
    }
    else {
        return [[NSString alloc] init];
    }
}

@end
