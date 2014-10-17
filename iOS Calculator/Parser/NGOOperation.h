//
//  NGOOperation.h
//  iOS Calculator
//
//  Created by Taras Koval on 10/8/14.
//  Copyright (c) 2014 taras.koval. All rights reserved.
//
//  Abstract class, used as interface for unary and binary operations.
//

#import <Foundation/Foundation.h>
#import "NGOExpression.h"

@interface NGOOperation : NGOExpression

@property NSString *name;
@property NSMutableArray *args;

@end
