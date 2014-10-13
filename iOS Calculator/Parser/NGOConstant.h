//
//  NGOConstant.h
//  iOS Calculator
//
//  Created by Taras Koval on 10/12/14.
//  Copyright (c) 2014 taras.koval. All rights reserved.
//
//  Concrete class, node that represents constant in expression tree.
//

#import "NGOExpression.h"

@interface NGOConstant : NGOExpression

@property NSString *name;

- (id)initWithName:(NSString *)name;

@end
