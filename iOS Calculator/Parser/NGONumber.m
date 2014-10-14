//
//  NGONumber.m
//  iOS Calculator
//
//  Created by Taras Koval on 10/8/14.
//  Copyright (c) 2014 taras.koval. All rights reserved.
//
//  Concrete class, node that represents number in expression tree.
//

#import "NGONumber.h"

@implementation NGONumber

- (id)initWithNumber:(double)number
{
    if (self = [super init]) {
        self.number = number;
        return self;
    }
    else {
        return nil;
    }
}

- (id)copyWithZone:(NSZone *)zone
{
    NGONumber *objectCopy = [super copyWithZone:zone];
    objectCopy.number = self.number;
    return objectCopy;
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"%g", self.number];
}

- (double)evaluate
{
    return self.number;
}

- (double)evaluateWithArguments:(NSDictionary *)arguments
{
    return self.number;
}

@end
