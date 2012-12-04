//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Luis Miguel Delgado on 1/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"
#import "GraphViewController.h"

@interface CalculatorViewController()
@property (nonatomic) BOOL userTypingNumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize userTypingNumber = _userTypingNumber; 
@synthesize brain = _brain;
@synthesize stackDisplay = _stackDisplay;
@synthesize testVariableValues = _testVariableValues;
@synthesize variableDisplay = _variableDisplay;

- (CalculatorBrain *)brain {
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (void)updateVariableDisplay {
    self.variableDisplay.text = @"";
    for (NSString *object in [CalculatorBrain variablesUsedInProgram:self.brain.program]) {
        self.variableDisplay.text = [self.variableDisplay.text stringByAppendingFormat:@"%@ = %g   ", object, [(NSNumber *)[self.testVariableValues objectForKey:object] doubleValue]];
    }
}

- (void)updateDisplays {
    self.stackDisplay.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
    if (![CalculatorBrain variablesUsedInProgram:self.brain.program]) {
        self.display.text = [NSString stringWithFormat:@"%g", [CalculatorBrain runProgram:self.brain.program]];
    } else {
        self.display.text = [NSString stringWithFormat:@"%g", [CalculatorBrain runProgram:self.brain.program usingVariables:self.testVariableValues]];
    }
}

- (IBAction)digitPressed:(UIButton *)sender {
    if (self.userTypingNumber) {
        if (![sender.currentTitle isEqualToString:@"."]) 
            self.display.text = [self.display.text stringByAppendingString:sender.currentTitle]; 
        else {
            NSRange range = [self.display.text rangeOfString:@"."];
            if (range.location == NSNotFound) { 
                self.display.text = [self.display.text stringByAppendingString:sender.currentTitle];
            }
        }
    } else {
        if (![sender.currentTitle isEqualToString:@"0"]) {
            self.display.text = sender.currentTitle;
            self.userTypingNumber = YES;
        } 
    }
}

- (IBAction)variablePressed:(UIButton *)sender {
    if (self.userTypingNumber) {
        self.userTypingNumber = NO;
    } 
    self.display.text = sender.currentTitle;
    [self.brain pushVariable:sender.currentTitle];
    
    self.stackDisplay.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
    [self updateVariableDisplay];
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.stackDisplay.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
    self.userTypingNumber = NO;
    self.display.text = @"0";
}

- (IBAction)clearPressed {
    [self.brain clearStack];
    self.display.text = @"0";
    self.stackDisplay.text = @"";
}
- (IBAction)undoPressed {
    if (self.userTypingNumber) self.display.text = [self.display.text substringToIndex:[self.display.text length]-1];
    else {
        [self.brain removeTopOfStack];
        [self updateDisplays];
    }
    if ([self.display.text isEqualToString:@""]) { 
        [self updateDisplays];
        self.userTypingNumber = NO;
    }
}

- (IBAction)operationPressed:(UIButton *)sender {
    if (self.userTypingNumber && ![sender.currentTitle isEqualToString:@"+/-"]) [self enterPressed];
    
    if ([sender.currentTitle isEqualToString:@"+/-"] && self.userTypingNumber) {
        NSRange range = [self.display.text rangeOfString:@"-"];
        if (range.location == NSNotFound) {
            self.display.text = [NSString stringWithFormat:@"-%@", self.display.text];
        }
    } else {
        if (![CalculatorBrain variablesUsedInProgram:self.brain.program]) {
            self.display.text = [NSString stringWithFormat:@"%g", [self.brain performOperation:sender.currentTitle]];
        } else {
            self.display.text = [NSString stringWithFormat:@"%g", [self.brain performOperation:sender.currentTitle withVariableValues:self.testVariableValues]];
        }
        self.stackDisplay.text = [CalculatorBrain descriptionOfProgram:self.brain.program];        
    }
}

- (IBAction)testCasePressed:(UIButton *)sender {
    double x, y, z = 0;
    
    if ([sender.currentTitle isEqualToString:@"Test 1"]) {
        x = 5;
        y = 2;
        z = 10;
    } else if ([sender.currentTitle isEqualToString:@"Test 2"]) {
        x = 3;
        y = 6;
        z = 9;
    } 
    
    self.testVariableValues = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithDouble:x], [NSNumber numberWithDouble:y], [NSNumber numberWithDouble:z], nil] forKeys:[NSArray arrayWithObjects:@"x", @"y", @"z", nil]];
    [self updateVariableDisplay];
}

- (IBAction)runProgram:(UIButton *)sender {
    self.stackDisplay.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
}

- (IBAction)getDescription {
    NSLog(@"%@", [CalculatorBrain descriptionOfProgram:self.brain.program]);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"graphProgram"]) {
        [segue.destinationViewController setProgram:self.brain.program];
        [[segue.destinationViewController programDisplay] setText:[CalculatorBrain descriptionOfProgram:self.brain.program]];
    }
}

@end
