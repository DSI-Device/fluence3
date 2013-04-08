//
//  RemoveEventView.m
//  Fluence3
//
//  Created by Joseph Armand Baroi on 4/3/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "RemoveEventView.h"
#import "OBShapedButton.h"

@implementation RemoveEventView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *hitView = [super hitTest:point withEvent:event];
    
    // If the hitView is THIS view, return nil and allow hitTest:withEvent: to
    // continue traversing the hierarchy to find the underlying view.
    if (hitView == self) {
        return nil;
    }
    // Else return the hitView (as it could be one of this view's buttons):
    return hitView;
}/*
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    for (UIView * view in [self subviews]) {
        if([view isKindOfClass:[UIButton class]]){
        CGSize s = self.frame.size;
        CGPoint o = self.frame.origin;
        NSLog(NSStringFromCGSize(s));
        NSLog(NSStringFromCGPoint(o));
        CGSize bs = view.frame.size;
        CGPoint bo = view.frame.origin;
        
        NSLog(@"now view button");
        NSLog(NSStringFromCGSize(bs));
        NSLog(NSStringFromCGPoint(bo));
        }
        
        BOOL t = [view pointInside:[self convertPoint:point toView:view] withEvent:event]; 
        if (view.userInteractionEnabled && [view pointInside:[self convertPoint:point toView:view] withEvent:event]) {
            return YES;
        }
    }
    return NO;
}*/
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
