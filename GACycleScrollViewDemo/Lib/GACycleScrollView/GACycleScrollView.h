//
//  GACycleScrollView.h
//  GACycleScrollViewDemo
//
//  Created by GikkiAres on 08/12/2017.
//  Copyright © 2017 GikkiAres. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageContainerView.h"



typedef NS_OPTIONS(NSUInteger,GALogLevel) {
    GALogLevelNone = 0,
    GALogLevelNormal = 1,
    GALogLevelException = 1<<1,
    GALogLevelTest = 1<<2,
    GALogLevelUndefined = 1<<3,
    GALogLevelAll = 0xFFFFFFFF
};

#define DisplayLogLevel GALogLevelNone

#ifdef DEBUG
#define GALog(CurrentLogLevel,ftmt,...) \
if((DisplayLogLevel)&CurrentLogLevel) {\
NSLog(ftmt,##__VA_ARGS__);\
}
#else
#define GALog(...)
#endif


#pragma mark gaCycleScrollViewDelegate
@class GACycleScrollView;
@protocol GACycleScrollViewDelegate <NSObject>
@required
- (UIView *)gaCycleScrollView:(GACycleScrollView *)gaView contentViewAtIndex:(NSInteger)index;

@end

@interface GACycleScrollView : UIView


@property(nonatomic,assign) BOOL shouldAutoScroll;
@property(nonatomic,weak)id<GACycleScrollViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame pages:(NSInteger)pageNum NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;


@end
