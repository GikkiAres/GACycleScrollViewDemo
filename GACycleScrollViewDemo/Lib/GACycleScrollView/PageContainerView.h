//
//  PageContainerView.h
//  GACycleScrollViewDemo
//
//  Created by GikkiAres on 08/12/2017.
//  Copyright © 2017 GikkiAres. All rights reserved.
//

#import <UIKit/UIKit.h>




#pragma mark PageContainerView
@interface PageContainerView : UIView

//代表实际的页数
@property (nonatomic,assign)NSInteger factIndex;
//代表逻辑的页数
@property (nonatomic,assign)NSInteger logicIndex;

//代表当前页实际在scrv中的位置.
@property (nonatomic,assign)CGFloat pageLeftPosition;
@property (nonatomic,assign)CGFloat pageRightPosition;

- (void)addContentView:(UIView *)view;
- (void)moveDistance:(CGFloat)distance;

@end
