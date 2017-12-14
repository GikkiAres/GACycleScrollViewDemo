//
//  UIView+GAUtility.m
//  GACycleScrollViewDemo
//
//  Created by GikkiAres on 09/12/2017.
//  Copyright © 2017 GikkiAres. All rights reserved.
//

#import "UIView+GAUtility.h"

@implementation UIView (GAUtility)

- (CGFloat)xPosition {
    return self.frame.origin.x;
}

- (void)setXPosition:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)xInnerPosition {
    return self.bounds.origin.x;
}

- (void)setXInnerPosition:(CGFloat)xInnerPosition {
    CGRect bounds = self.bounds;
    bounds.origin.x = xInnerPosition;
    self.bounds = bounds;
}



@end
