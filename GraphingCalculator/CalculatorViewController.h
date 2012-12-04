//
//  CalculatorViewController.h
//  Calculator
//
//  Created by Luis Miguel Delgado on 1/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatorViewController : UIViewController

@property (strong, nonatomic) NSDictionary *testVariableValues;

@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *stackDisplay;
@property (weak, nonatomic) IBOutlet UILabel *variableDisplay;

@end
