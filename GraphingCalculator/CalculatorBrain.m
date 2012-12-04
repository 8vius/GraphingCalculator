//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Luis Miguel Delgado on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain() 
@property (nonatomic, strong) NSMutableArray *programStack;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;

-(NSMutableArray *)programStack {
    if (!_programStack) {
        _programStack = [[NSMutableArray alloc] init];
    }
    
    return _programStack;
}

- (void)clearStack {
    [self.programStack removeAllObjects];
}

- (void)removeTopOfStack {
    if ([self.programStack lastObject]) [self.programStack removeLastObject];
}

- (void)pushVariable:(NSString *)variable {
    [self.programStack addObject:variable];
}

- (void)pushOperand:(double)operand {
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (double)performOperation:(NSString *)operation {
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram:self.program];
}

- (double)performOperation:(NSString *)operation withVariableValues:(NSDictionary *)variableValues {
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram:self.program usingVariables:variableValues];
}

- (id)program {
    return [self.programStack copy];
}

+ (BOOL)isDoubleOperandOperation:(NSString *)operation {
    NSSet *operationSet = [NSSet setWithObjects:@"+", @"-", @"*", @"/", nil];
    return [operationSet containsObject:operation];
}

+ (BOOL)isSingleOperandOperation:(NSString *)operation {
    NSSet *operationSet = [NSSet setWithObjects:@"cos", @"sin", @"sqrt", nil];
    return [operationSet containsObject:operation];
}

+ (BOOL)isNoOperandOperation:(NSString *)operation {
    NSSet *operationSet = [NSSet setWithObjects:@"π", nil];
    return [operationSet containsObject:operation];
}

+ (BOOL)isVariable:(NSString *)operation {
    NSSet *operationSet = [NSSet setWithObjects:@"x", @"y", @"z", nil];
    return [operationSet containsObject:operation];
}

+ (BOOL)isOperation:(NSString *)operation {
    NSSet *operationSet = [NSSet setWithObjects:@"+", @"-", @"*", @"/", @"cos", @"sin", @"sqrt", @"π", nil];
    return [operationSet containsObject:operation];
}

+ (double)popOperandOffStack:(NSMutableArray *)stack {
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        result = [topOfStack doubleValue];
    } else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
        } else if ([operation isEqualToString:@"*"]) {
            result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
        } else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffStack:stack];
            result = [self popOperandOffStack:stack] - subtrahend;
        } else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOffStack:stack];
            if (divisor) result = [self popOperandOffStack:stack] / divisor;
        } else if ([operation isEqualToString:@"sin"]) {
            result = sin([self popOperandOffStack:stack]);
        } else if ([operation isEqualToString:@"cos"]) {
            result = cos([self popOperandOffStack:stack]);
        } else if ([operation isEqualToString:@"π"]) {
            result = M_PI;
        } else if ([operation isEqualToString:@"sqrt"]) {
            result = sqrt([self popOperandOffStack:stack]);
        } else if ([operation isEqualToString:@"+/-"]) {
            result = [self popOperandOffStack:stack]*-1;
        }

    }
    
    return result;
}

+ (double)runProgram:(id)program {
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    
    return [self popOperandOffStack:stack];
}

+ (double)runProgram:(id)program usingVariables:(NSDictionary *)variableValues {
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    
    for (int i = 0; i < [stack count]; i++) {
        if ([[stack objectAtIndex:i] isKindOfClass:[NSString class]]) {
            if ([self isVariable:[stack objectAtIndex:i]]) {
                if ([[self variablesUsedInProgram:program] containsObject:[stack objectAtIndex:i]] && variableValues) {
                    [stack replaceObjectAtIndex:i withObject:[variableValues objectForKey:[stack objectAtIndex:i]]];
                } else {
                    [stack replaceObjectAtIndex:i withObject:[NSNumber numberWithDouble:0]];
                }
            }
        }
    }
    
    return [self popOperandOffStack:stack];
}

+ (NSString *)descriptionOfTopOfStack:(NSMutableArray *)stack {
    NSMutableString *programFragment = [NSMutableString stringWithString:@""];
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        [programFragment appendFormat:@"%g", [topOfStack doubleValue]];
    } else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack;
        if ([self isDoubleOperandOperation:operation]) {
            [programFragment appendFormat:@"(%@ %@ %@)", [self descriptionOfTopOfStack:stack], operation, [self descriptionOfTopOfStack:stack]];
        } else if ([self isSingleOperandOperation:operation]) {
            [programFragment appendFormat:@"%@( %@ )", operation, [self descriptionOfTopOfStack:stack]];
        } else if ([ self isNoOperandOperation:operation]) {
            [programFragment appendFormat:@"%@", operation];
        } else if ([self isVariable:operation]) {
            [programFragment appendFormat:@"%@", operation];
        }
    }
    
    return programFragment;
}

+ (NSString *)descriptionOfProgram:(id)program {
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    
    return [self descriptionOfTopOfStack:stack];
}

+ (NSSet *)variablesUsedInProgram:(id)program {
    NSMutableSet *variableSet = [NSMutableSet set];
    
    for (id object in (NSArray *)program) {
        if ([object isKindOfClass:[NSString class]]) {
            NSString *tempString = object;
            if ([tempString isEqualToString:@"x"] ||[tempString isEqualToString:@"y"] || [tempString isEqualToString:@"z"]) {
                [variableSet addObject:tempString];
            }
        }
    }
    
    if (![variableSet count]) {
        return nil;
    }
    return variableSet;
}

@end
