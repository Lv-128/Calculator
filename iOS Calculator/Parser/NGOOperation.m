//
//  NGOOperation.m
//  iOS Calculator
//
//  Created by Taras Koval on 10/8/14.
//  Copyright (c) 2014 taras.koval. All rights reserved.
//
//  Abstract class, used as interface for unary and binary operations.
//

#import "NGOOperation.h"

@implementation NGOOperation

- (id)initWithName:(NSString *)string
{
    if (self = [super init]) {
        self.name = string;
        self.args = [NSMutableArray array];
        return self;
    }
    else {
        return nil;
    }
}

@end
