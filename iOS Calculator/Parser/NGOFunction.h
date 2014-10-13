//
//  NGOFunction.h
//  iOS Calculator
//
//  Created by Taras Koval on 10/8/14.
//  Copyright (c) 2014 taras.koval. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NGOFunction : NSObject

// singleton methods
+ (NSDictionary *)unaryOperations;
+ (NSDictionary *)binaryOperations;
+ (NSDictionary *)constants;

- (id)initWithString:(NSString *)string;
- (double)evaluate;
- (double)evaluateWithArguments:(NSDictionary *)arguments;

@end
