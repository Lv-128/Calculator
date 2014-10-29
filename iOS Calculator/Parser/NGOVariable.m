//
//  NGOVariable.m
//  iOS Calculator
//
//  Created by Taras Koval on 10/12/14.
//  Copyright (c) 2014 taras.koval. All rights reserved.
//
//  Concrete class, node that represents variable in expression tree.
//

#import "NGONumber.h"
#import "NGOVariable.h"

@implementation NGOVariable

- (id)initWithName:(NSString *)name
{
    if (self = [super init]) {
        self.name = name;
        return self;
    }
    else {
        return nil;
    }
}

- (id)copyWithZone:(NSZone *)zone
{
    NGOVariable *objectCopy = [super copyWithZone:zone];
    objectCopy.name = [self.name copyWithZone:zone];
    return objectCopy;
}

- (NSString *)description
{
    return self.name;
}

- (double)evaluate
{
    return [self evaluateWithArguments:nil];
}

- (double)evaluateWithArguments:(NSDictionary *)arguments
{
    NSNumber* varivaleValue = [arguments objectForKey:self.name];
    
    if (varivaleValue) {
        return varivaleValue.doubleValue;
    }
    else {
        @throw [[NSException alloc] initWithName:@"Wrong arguments"
                                          reason:@"Not enough arguments"
                                        userInfo:nil];
    }
}

- (NGOExpression *)differentiateWithVariable:(NSString *)variable
{
    if ([self.name isEqualToString:variable]) {
        return [[NGONumber alloc] initWithNumber:1.0];
    }
    else {
        return [[NGONumber alloc] initWithNumber:0.0];
    }
}

@end
