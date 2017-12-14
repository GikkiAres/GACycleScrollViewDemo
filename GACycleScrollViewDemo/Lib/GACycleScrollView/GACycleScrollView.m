//
//  GACycleScrollView.m
//  GACycleScrollViewDemo
//
//  Created by GikkiAres on 08/12/2017.
//  Copyright © 2017 GikkiAres. All rights reserved.
//

#import "GACycleScrollView.h"
#import "UIView+GAUtility.h"


typedef NS_ENUM(NSUInteger,CycleScrollViewState) {
    CycleScrollViewStateUninitailized,
    CycleScrollViewStateShowingCurrentPage,
    CycleScrollViewStateLeftScrolling,
    CycleScrollViewStateRightScrolling,
    CycleScrollViewStateShowingNextPage,
    CycleScrollViewStateShowingPreviousPage
};
#define RepeatTime 3

@interface GACycleScrollView ()<
UIScrollViewDelegate
>
@property (nonatomic,strong)UIScrollView *scrollView;

@property (nonatomic,assign)NSInteger pageNum;
@property (nonatomic,assign)NSInteger currentPage;
@property (nonatomic,assign)CGFloat width;
@property (nonatomic,assign)CGFloat height;

@property (nonatomic,assign)CGFloat currentPageLimit;
@property (nonatomic,assign)CGFloat nextPageLimit;


@property (nonatomic,assign)CycleScrollViewState state;

@property (nonatomic,strong)NSMutableDictionary *mdicPageContainerView;
@property (nonatomic,strong)NSMutableArray <PageContainerView *> *marrPageContainerView;
@property (nonatomic,assign)CGFloat xDelta;

@property (nonatomic,strong)UIPageControl *pageControl;

@property (nonatomic,strong)NSTimer *timer;

@end

@implementation GACycleScrollView

#pragma mark 1 LifeCycle

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self initWithFrame:self.frame pages:3];
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame pages:3];
}

- (instancetype)initWithFrame:(CGRect)frame pages:(NSInteger)pageNum {
    if(self=[super initWithFrame:frame]) {
        _width = frame.size.width;
        _height = frame.size.height;
        _currentPageLimit = _width/3;
        _nextPageLimit = _width/3*2;
        _pageNum = pageNum;
        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        [self addSubview:_scrollView];
        _scrollView.contentSize = CGSizeMake(_width*3, _height);
        _scrollView.backgroundColor = [UIColor greenColor];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        
        _mdicPageContainerView = [NSMutableDictionary new];
        _marrPageContainerView = [NSMutableArray new];
        //初始显示的是第0页,左边是第-1页,右边是1页.
        for(int i = -1;i<=1;i++) {
            PageContainerView *containerView = [PageContainerView new];
            containerView.factIndex=i;
            containerView.logicIndex=i%_pageNum;
            [_marrPageContainerView addObject:containerView];
            [_scrollView addSubview:containerView];
        }
        self.currentPage = 0;
        _state = CycleScrollViewStateUninitailized;
                _scrollView.contentOffset = CGPointMake(_width, 0);
        
        //初始化page control;
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, _height-20, _width, 20)];
        [self addSubview:_pageControl];
        
        _pageControl.numberOfPages = _pageNum;
        _pageControl.pageIndicatorTintColor = [UIColor blackColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.userInteractionEnabled = NO;
    }
    
    GALog(GALogLevelNormal, @"Open Normal Log");
    GALog(GALogLevelException, @"Open Exception Log");
    GALog(GALogLevelTest, @"Open Test Log");
    GALog(GALogLevelUndefined, @"Open Undefined Log");
    
    return self;
}

- (void)dealloc {
}

- (void)showCurrentPage {
    //LeftPage
    PageContainerView *previousContainerView = _marrPageContainerView[0];
    [previousContainerView setXPosition:0*_width];
    UIView *previousContentView = [self contentViewAtIndex:self.currentPage-1];
    [previousContainerView addContentView:previousContentView];
    
    
    //CurrentPage
    PageContainerView *currentContainerView = _marrPageContainerView[1];
    [currentContainerView setXPosition:1*_width];
    
    
    UIView *contentView = [self contentViewAtIndex:self.currentPage];
    [currentContainerView addContentView:contentView];
    
    //RightPage
    PageContainerView *nextContainerView = _marrPageContainerView[2];
    [nextContainerView setXPosition:2*_width];
    UIView *nextContentView = [self contentViewAtIndex:self.currentPage+1];
    [nextContainerView addContentView:nextContentView];
    
    
    
}


- (void)didMoveToSuperview {
    [self showCurrentPage];
    [super didMoveToSuperview];
}

#pragma mark 2 Access
//处理每个滑动,有点不精确,所以,处理状态的切换,是不会有问题的.
//对于滑动这种情况,要进行区间判断,而不要单点判断.
//只对考虑中的状态进入下一状态才改变,其余状态不变.
- (void)setState:(CycleScrollViewState)state {
    //状态相同,不需要处理
    if (state == _state) return;
    switch (_state) {
        case CycleScrollViewStateUninitailized: {
            if(state == CycleScrollViewStateShowingCurrentPage) {
                 GALog(GALogLevelNormal,@"显示初始页面!");
                _state = state;
            }
            else {
                GALog(GALogLevelNormal,@"异常状态1, delta is %.2f",_xDelta);
            }
            break;
        }
            
        case CycleScrollViewStateShowingCurrentPage:{
            //从当前页状态,只能进入左滑或者右滑状态
            if(state == CycleScrollViewStateLeftScrolling){
                //进入左滑状态的相关逻辑
                GALog(GALogLevelNormal,@"进入左滑状态! delta is %.2f",_xDelta);
                PageContainerView *previousContainerView = _marrPageContainerView[0];
                [_marrPageContainerView removeObjectAtIndex:0];
                [_marrPageContainerView addObject:previousContainerView];
                [previousContainerView setXPosition:3*_width];
                UIView *previousContentView = [self contentViewAtIndex:self.currentPage+2];
                [previousContainerView addContentView:previousContentView];
                _state = state;
            }
            else if(state == CycleScrollViewStateRightScrolling){
                //进入右滑状态的逻辑
                GALog(GALogLevelNormal,@"进入右滑状态! delta is %.2f",_xDelta);
                PageContainerView *lastContainerView = _marrPageContainerView[2];
                [_marrPageContainerView removeObjectAtIndex:2];
                [_marrPageContainerView insertObject:lastContainerView atIndex:0];
                [lastContainerView setXPosition:-1*_width];
                UIView *newContentView = [self contentViewAtIndex:self.currentPage-2];
                [lastContainerView addContentView:newContentView];
                _state = state;
            }
            else {
                GALog(GALogLevelException,@"异常状态2, delta is %.2f",_xDelta);
            }
            break;
        }
        case CycleScrollViewStateLeftScrolling: {
            //左滑状态要么进入NextPage,要么回到CurrentPage
            if(state == CycleScrollViewStateShowingCurrentPage) {
                        PageContainerView *lastContainerView = [_marrPageContainerView lastObject];
                        [_marrPageContainerView removeObjectAtIndex:2];
                        [_marrPageContainerView insertObject:lastContainerView atIndex:0];
                        [lastContainerView setXPosition:0*_width];
                
                        UIView *previousContentView = [self contentViewAtIndex:self.currentPage-1];
                        [lastContainerView addContentView:previousContentView];
                GALog(GALogLevelNormal,@"左滑后返回");
                _state = state;
                
            }
            else if(state == CycleScrollViewStateShowingNextPage) {
                GALog(GALogLevelNormal,@"进入NextPage! delta is %.2f",_xDelta);
                self.currentPage++;
                
                [_marrPageContainerView enumerateObjectsUsingBlock:^(PageContainerView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [obj moveDistance:-_width];
                }];
                
                _scrollView.xInnerPosition -= _width;
                _xDelta -= _width;
                GALog(GALogLevelNormal,@"距离全部减去一个width");
                _state = CycleScrollViewStateShowingCurrentPage;
            }
            else {
                GALog(GALogLevelNormal,@"异常状态3, delta is %.2f",_xDelta);
                //这个异常原因是,左滑了width+20个单位,进入了Next状态一次,没有第二次设定...考虑移除第二次设定
            }
            break;
        }
        case CycleScrollViewStateRightScrolling: {
            if(state == CycleScrollViewStateShowingPreviousPage) {
                GALog(GALogLevelNormal,@"进入PreviousPage! delta is %.2f",_xDelta);
                        self.currentPage--;
                
                        [_marrPageContainerView enumerateObjectsUsingBlock:^(PageContainerView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            [obj moveDistance:_width];
                        }];
                
                _scrollView.xInnerPosition += _width;
                _xDelta += _width;
                GALog(GALogLevelNormal,@"距离全部减去加一个width");
                _state = state;
                _state = CycleScrollViewStateShowingCurrentPage;
            }
            else if(state == CycleScrollViewStateShowingCurrentPage) {
                        PageContainerView *firstContainerView = [_marrPageContainerView firstObject];
                        [_marrPageContainerView removeObjectAtIndex:0];
                        [_marrPageContainerView insertObject:firstContainerView atIndex:2];
                        [firstContainerView setXPosition:2*_width];
                
                        UIView *newContentView = [self contentViewAtIndex:self.currentPage+1];
                        [firstContainerView addContentView:newContentView];
                GALog(GALogLevelNormal,@"右滑后返回");
                _state = state;
            }
            else {
                GALog(GALogLevelException,@"异常状态4, delta is %.2f",_xDelta);
            }
            break;
        }
        default:
            break;
    }
}

- (UIView *)contentViewAtIndex:(NSInteger)index {
    NSInteger logicIndex = [self logicIndexForFactIndex:index];
    GALog(GALogLevelNormal,@"获取第%zi页内容",logicIndex);
    return [_delegate gaCycleScrollView:self contentViewAtIndex:logicIndex];
}

- (void)setCurrentPage:(NSInteger)currentPage {
    _currentPage = currentPage;
    _pageControl.currentPage = [self logicIndexForFactIndex:currentPage];
}

- (NSInteger)logicIndexForFactIndex:(NSInteger)factIndex {
    NSInteger logicIndex = factIndex%_pageNum;
    if(logicIndex<0) {
        logicIndex+=_pageNum;
    }
    return logicIndex;
}

- (void)setShouldAutoScroll:(BOOL)shouldAutoScroll {
    _shouldAutoScroll = shouldAutoScroll;
    if(_shouldAutoScroll) {
        if(!_timer) {
            __weak typeof (self) weakSelf = self;
            _timer = [NSTimer scheduledTimerWithTimeInterval:RepeatTime repeats:YES block:^(NSTimer * _Nonnull timer) {
                [weakSelf goToNextPage];
            }];
            
        }
    }
    else {
        if(_timer) {
            [_timer invalidate];
            _timer = nil;
        }
    }
}

- (void)goToNextPage {
    CGPoint nextPageOffset = CGPointMake(_width*2, 0);
    [_scrollView setContentOffset:nextPageOffset animated:YES];
}

#pragma mark 4 Delegate

//scrollViewDidScroll对滑动的检测不是很准确,有时候快读会很大.达到了40!!!
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateScrollViewState];
}

- (void)updateScrollViewState {
    NSInteger xOffset = _scrollView.contentOffset.x;
    _xDelta = xOffset - _width;
    GALog(GALogLevelTest, @"delat is %.2f",_xDelta);
    if(fabs(_xDelta)<=_currentPageLimit) {
        self.state = CycleScrollViewStateShowingCurrentPage;
    }
    else if(_xDelta>_currentPageLimit&&_xDelta<=_nextPageLimit) {
        self.state = CycleScrollViewStateLeftScrolling;
    }
    else if (_xDelta<-_currentPageLimit&&_xDelta>=-_nextPageLimit){
        self.state = CycleScrollViewStateRightScrolling;
    }
    else if (_xDelta>_nextPageLimit) {
        self.state = CycleScrollViewStateShowingNextPage;
    }
    else if (_xDelta<-_nextPageLimit) {
        self.state = CycleScrollViewStateShowingPreviousPage;
    }
    else {
        GALog(GALogLevelException,@"进入了没考虑到的状态!!!");
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if(_timer) {
        [_timer setFireDate:[NSDate distantFuture]];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if(_timer) {
        [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:RepeatTime]];
    }
}






#pragma mark 5 Event

@end

