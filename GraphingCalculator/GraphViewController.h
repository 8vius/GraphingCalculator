//
//  GraphViewController.h
//  GraphingCalculator
//
//  Created by Engels Perez on 06/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphView.h"

@interface GraphViewController : UIViewController

@property (strong, nonatomic) id program;
@property (weak, nonatomic) IBOutlet UILabel *programDisplay;


@end
