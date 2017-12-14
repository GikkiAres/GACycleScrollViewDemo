//
//  MainViewController.m
//  GACycleScrollViewDemo
//
//  Created by GikkiAres on 08/12/2017.
//  Copyright © 2017 GikkiAres. All rights reserved.
//

#import "MainViewController.h"
#import "GACycleScrollView.h"
#import "UIColor+GAUtility.h"

@interface MainViewController ()<
GACycleScrollViewDelegate
>

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    GACycleScrollView *sv = [[GACycleScrollView alloc]initWithFrame:CGRectMake(20, 20, 400, 200) pages:7];
    sv.delegate = self;
    
    sv.shouldAutoScroll = YES;
    sv.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:sv];
    
    
}

- (UIView *)gaCycleScrollView:(GACycleScrollView *)gaView contentViewAtIndex:(NSInteger)index {
    UIView *contentView = [[UIView alloc]initWithFrame:gaView.bounds];
    contentView.backgroundColor = [UIColor randomColor];
    UILabel *label = [[UILabel alloc]initWithFrame:gaView.bounds];
    [contentView addSubview:label];
    label.text = @(index+1).description;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:50];
    return contentView;
}

@end
