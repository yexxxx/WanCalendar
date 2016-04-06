//
//  YEXDayScrollView.m
//  WanCalendar
//
//  Created by 叶希焰 on 16/4/1.
//  Copyright © 2016年 yex. All rights reserved.
//

#import "YEXDayScrollView.h"
#import "Masonry.h"

typedef enum{
    DirecNone,
    DirecLeft,
    DirecRight
} Direction;

@interface YEXDayScrollView ()<UIScrollViewDelegate>

{
    NSUInteger currentIndex;
    NSUInteger nextIndex;
}

@property (nonatomic, strong) NSDate    *currentDate;
@property (nonatomic, assign) Direction    direction;
@property (nonatomic, weak  ) UIScrollView *scrollView;
@property (nonatomic, weak  ) UIImageView  *currentImageView;
@property (nonatomic, weak  ) UIImageView  *nextImageView;


@end

@implementation YEXDayScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (!self.date) {
            self.date = [NSDate date];
        }
        [self addObserver:self forKeyPath:@"direction" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

-(void)setDate:(NSDate *)date {
    _date = date;
    self.currentDate = date;
    self.currentImageView.image = [self imageFromDate:date];
}

- (UIImage *)imageFromDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger dayNum = [calendar component:NSCalendarUnitDay fromDate:date];
    NSString *pathStr = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%li",dayNum] ofType:@".png"];
    return [UIImage imageWithContentsOfFile:pathStr];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    //self.currIndex表示当前显示图片的索引，self.nextIndex表示将要显示图片的索引
    //_images为图片数组
    if(change[NSKeyValueChangeNewKey] == change[NSKeyValueChangeOldKey]) return;
    
    if ([change[NSKeyValueChangeNewKey] intValue] == DirecRight) {
        self.nextImageView.frame = CGRectMake(0, 0, [self width], [self height]);
        self.currentDate = [self.currentDate dateByAddingTimeInterval:-60 * 60 *24];
        self.nextImageView.image = [self imageFromDate:self.currentDate];
    } else if ([change[NSKeyValueChangeNewKey] intValue] == DirecLeft){
        self.nextImageView.frame = CGRectMake([self width] * 2, 0, [self width], [self height]);
        self.currentDate = [self.currentDate dateByAddingTimeInterval:60 * 60 * 24];
        self.nextImageView.image = [self imageFromDate:self.currentDate];
    }
    
//    self.currentImageView.image = self.nextImageView.image;
    
}

#pragma mark - LazyLoading

-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        UIScrollView *view = [[UIScrollView alloc] initWithFrame:self.bounds];
        view.contentSize = CGSizeMake([self width] * 3, [self height]);
        view.showsHorizontalScrollIndicator = NO;
        view.delegate = self;
        view.pagingEnabled = YES;
        view.contentOffset = CGPointMake([self width], 0);
        [self addSubview:view];
        _scrollView = view;
    }
    return _scrollView;
}

-(UIImageView *)currentImageView
{
    if (!_currentImageView) {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.frame = CGRectMake([self width], 0, [self width], [self height]);
        imgView.userInteractionEnabled = YES;
        [self.scrollView addSubview:imgView];
        _currentImageView = imgView;

    }
    return _currentImageView;
}

-(UIImageView *)nextImageView
{
    if (!_nextImageView) {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.userInteractionEnabled = YES;
        [self.scrollView addSubview:imgView];
        _nextImageView = imgView;
    }
    return _nextImageView;
}


#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x == [self width]) return;
     self.direction = scrollView.contentOffset.x > [self width] ? DirecLeft : DirecRight;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self pauseScroll];
}

- (void)pauseScroll {
    self.direction = DirecNone;//清空滚动方向
    //判断最终是滚到了右边还是左边
    int index = self.scrollView.contentOffset.x / [self width];
    if (index == 1) return; //等于1表示最后没有滚动，返回不做任何操作
    self.currentImageView.image = self.nextImageView.image;
    self.scrollView.contentOffset = CGPointMake([self width], 0);
}

@end
