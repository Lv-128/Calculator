//
//  NGOExpression.h
//  iOS Calculator
//
//  Created by Taras Koval on 10/8/14.
//  Copyright (c) 2014 taras.koval. All rights reserved.
//
//  Abstract class, represents nodes of expression tree.
//

#import <Foundation/Foundation.h>

@interface NGOExpression : NSObject <NSCopying>

@property NGOExpression *parent;

// returns result of expression node
// nodes call approprite functions if they are operations
// and then call this method to evaluate their arguments(leafs)
// if leaf is number, constant or variable it simply returns its value
// in operation classes method actually returns evaluateWithArguments:nil
- (double)evaluate;

// string key represents name of argument, key value is the value of argument
- (double)evaluateWithArguments:(NSDictionary *)arguments;

// returns differentated expression node
- (NGOExpression *)differentiateWithVariable:(NSString *)variable;

// optimizes operation nodes if necessary
// (for example when binary operation is '+' and has zero as operand)
- (NGOExpression*)optimize;

@end
