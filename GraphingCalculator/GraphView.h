//
//  GraphView.h
//  GraphingCalculator
//
//  Created by Engels Perez on 06/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GraphView;

@protocol GraphViewDataSource
- (double)ordinateForAbscissa:(double)abscissa forGraph:(GraphView *)requestor;
@end

@interface GraphView : UIView

@property (weak, nonatomic) IBOutlet id <GraphViewDataSource> graphViewDataSource;
@property (nonatomic) double scale;
@property (nonatomic) CGPoint origin;

- (void)pan:(UIPanGestureRecognizer *)gesture;
- (void)tripleTap:(UITapGestureRecognizer *)gesture;
- (void)pinch:(UIPinchGestureRecognizer *)gesture;

@end
