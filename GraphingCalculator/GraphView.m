//
//  GraphView.m
//  GraphingCalculator
//
//  Created by Engels Perez on 06/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"

@implementation GraphView

@synthesize graphViewDataSource = _graphViewDataSource;
@synthesize scale = _scale;
@synthesize origin = _origin;

- (double)scale {
    if (!_scale) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"scale"]) {
            self.scale = [[[NSUserDefaults standardUserDefaults] objectForKey:@"scale"] doubleValue];
        } else {
            self.scale = 20;
        }
    }
        
    return _scale;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [AxesDrawer drawAxesInRect:self.bounds originAtPoint:self.center scale:self.scale];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, 0, self.bounds.size.height/2);
    //NSLog(@"Content Scale Factor: %f", [self contentScaleFactor]);
    for (int x = 0; x < self.bounds.size.width; x++) {
        CGContextAddLineToPoint(context, x, (self.bounds.size.height/2) - [self.graphViewDataSource ordinateForAbscissa:(x-self.bounds.size.width/2)/self.scale forGraph:self]*self.scale);
    }
    CGContextStrokePath(context);
}

- (void)pinch:(UIPinchGestureRecognizer *)gesture {
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        self.scale *= gesture.scale; // adjust our scale
        gesture.scale = 1;           // reset gestures scale to 1 (so future changes are incremental, not cumulative)
        
        [[NSUserDefaults standardUserDefaults] setDouble:self.scale forKey:@"scale"];
        
        [self setNeedsDisplay];
    }
}

- (void)pan:(UIPanGestureRecognizer *)gesture {

}

- (void)tripleTap:(UITapGestureRecognizer *)gesture {
    self.origin = [gesture locationInView:self];
    [self setNeedsDisplay];
}


@end
