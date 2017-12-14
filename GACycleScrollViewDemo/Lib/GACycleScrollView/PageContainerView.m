//
//  PageContainerView.m
//  GACycleScrollViewDemo
//
//  Created by GikkiAres on 08/12/2017.
//  Copyright © 2017 GikkiAres. All rights reserved.
//

#import "PageContainerView.h"
#import "UIView+GAUtility.h"

#pragma mark PageContainerView
@implementation PageContainerView

- (void)addContentView:(UIView *)view {
    UIView *oldView = [self viewWithTag:1000];
    if(oldView) {
        [oldView removeFromSuperview];
    }
    view.tag = 1000;
    [self addSubview:view];
}

- (void)moveDistance:(CGFloat)distance {
    self.xPosition += distance;
}

@end
