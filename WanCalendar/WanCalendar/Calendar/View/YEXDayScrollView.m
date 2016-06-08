//
//  YEXDayScrollView.m
//  WanCalendar
//
//  Created by 叶希焰 on 16/4/1.
//  Copyright © 2016年 yex. All rights reserved.
//

#import "YEXDayScrollView.h"
#import "YEXDateView.h"
#import "YEXYellowView.h"
#import "YEXNetAPI.h"
#import "YEXLunarDay.h"

typedef enum{
    DirecNone,
    DirecLeft,
    DirecRight
} Direction;
typedef void(^blockType)();

static const CGFloat bottomPercentage = 173.5 / 736;
static const CGFloat topPercentage    = 293.5 / 736;
static const CGFloat middlePercentage = 269.0 / 736;

@interface YEXDayScrollView ()<UIScrollViewDelegate>

{
    NSUInteger currentIndex;
    NSUInteger nextIndex;
}


@property (nonatomic, assign) Direction    direction;
@property (nonatomic, weak  ) UIScrollView *scrollView;
@property (nonatomic, weak  ) UIImageView  *preImageView;
@property (nonatomic, weak  ) UIImageView  *currentImageView;
@property (nonatomic, weak  ) UIImageView  *nextImageView;
@property (nonatomic, weak  ) YEXDateView  *dateView;
@property (nonatomic, weak  ) YEXYellowView  *yellowView;
@property (nonatomic, weak  ) UIView  *tapView;

@end

@implementation YEXDayScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (!self.date) {
            self.date = [NSDate date];
        }
        [self tapView];
//        [self addObserver:self forKeyPath:@"direction" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

-(void)dealloc {
//    [self removeObserver:self forKeyPath:@"direction"];
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
    
    
    
//    self.currentImageView.image = self.nextImageView.image;
    
}

-(void)setLunarDay:(YEXLunarDay *)lunarDay {
    _lunarDay = lunarDay;
    self.dateView.lunarDay = _lunarDay;
    self.yellowView.lunarDay = _lunarDay;
}

#pragma mark - LazyLoading

-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        UIScrollView *view = [[UIScrollView alloc] initWithFrame:self.bounds];
        view.contentSize = CGSizeMake([self width] * 3, [self height]);
        view.showsHorizontalScrollIndicator = NO;
        view.userInteractionEnabled = YES;
        view.delegate = self;
        view.pagingEnabled = YES;
        view.contentOffset = CGPointMake([self width], 0);
        [self addSubview:view];
        _scrollView = view;
    }
    return _scrollView;
}

-(UIImageView *)preImageView
{
    if (!_preImageView) {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.frame = CGRectMake([self width], 0, [self width], [self height]);
        imgView.userInteractionEnabled = YES;
        [self.scrollView addSubview:imgView];
        _preImageView = imgView;
        
    }
    return _currentImageView;
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

-(YEXDateView *)dateView
{
    if (!_dateView) {
        YEXDateView *dateView = [[YEXDateView alloc] initWithFrame:CGRectMake(0, 30,screenW , screenH * topPercentage * 0.8)];
        dateView.todayBtn.hidden = YES;
        [dateView.todayBtn addTarget:self action:@selector(todayBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:dateView];
        _dateView = dateView;
    }
    return _dateView;
}

-(YEXYellowView *)yellowView
{
    if (!_yellowView) {
        YEXYellowView *yellowView = [[YEXYellowView alloc] initWithFrame:CGRectMake(0, self.height * (1 - bottomPercentage),screenW , screenH * bottomPercentage * 0.6)];
        [self addSubview:yellowView];
        _yellowView = yellowView;
    }
    return _yellowView;
}

-(UIView *)tapView
{
    if (!_tapView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.height *topPercentage, self.width, self.height * middlePercentage)];
        view.backgroundColor = [UIColor clearColor];
        UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(viewSwipe:)];
        swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
        [view addGestureRecognizer:tap];
        [view addGestureRecognizer:swipeDown];
        [self.currentImageView addSubview:view];
        _tapView = view;
    }
    return _tapView;
}

-(void)viewTapped:(UITapGestureRecognizer *)tap {
    if (self.tapBlock) {
        self.tapBlock(self.currentDate);
    }
}
-(void)viewSwipe:(UISwipeGestureRecognizer *)swipe {
    if (self.swipeBlock) {
        self.swipeBlock(self.currentDate);
    }
}

- (BOOL)isSameDay:(NSDate*)date1 date2:(NSDate*)date2
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}

-(void)todayBtnTapped:(UIButton *)button {
    self.currentDate = self.date;
    self.currentImageView.image = [self imageFromDate:self.currentDate];
    self.lunarDay = self.lunarToday;
    self.dateView.todayBtn.hidden = YES;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.dateView.hidden = YES;
    self.yellowView.hidden = YES;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x < self.width) {
        self.nextImageView.frame = CGRectMake(0, 0, [self width], [self height]);
        self.nextImageView.image = [self imageFromDate:[self.currentDate dateByAddingTimeInterval:-60 * 60 *24]];
        
    } else if (scrollView.contentOffset.x > self.width){
        self.nextImageView.frame = CGRectMake([self width] * 2, 0, [self width], [self height]);
        self.nextImageView.image = [self imageFromDate:[self.currentDate dateByAddingTimeInterval:60 * 60 * 24]];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.x == [self width]) {
        self.dateView.hidden = NO;
        self.yellowView.hidden = NO;
    };
    if (scrollView.contentOffset.x <= [self width] * 0.5) {
        [[YEXNetAPI netAPI] getDataWithType:YEXNetTypeDay andDate:[self.currentDate dateByAddingTimeInterval:-60 * 60 *24] success:^(id responseObject) {
            if ([responseObject[@"reason"] isEqualToString:@"Success"]) {
                YEXLunarDay *lunarDay = [YEXLunarDay lunarDayWithDict:responseObject[@"result"][@"data"]];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    self.lunarDay = lunarDay;
                    self.dateView.hidden = NO;
                    self.yellowView.hidden = NO;
                   
                });
            }else{
                [SVProgressHUD showInfoWithStatus:responseObject[@"reason"]];
            }
        } failure:^(NSError *error) {
            [SVProgressHUD showInfoWithStatus:error.userInfo[NSLocalizedDescriptionKey]];
        }];
    }else if (scrollView.contentOffset.x >= [self width] * 1.5) {
        [[YEXNetAPI netAPI] getDataWithType:YEXNetTypeDay andDate:[self.currentDate dateByAddingTimeInterval:60 * 60 *24] success:^(id responseObject) {
            if ([responseObject[@"reason"] isEqualToString:@"Success"]) {
                YEXLunarDay *lunarDay = [YEXLunarDay lunarDayWithDict:responseObject[@"result"][@"data"]];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    self.lunarDay = lunarDay;
                    self.dateView.hidden = NO;
                    self.yellowView.hidden = NO;
                });
            }else{
                [SVProgressHUD showInfoWithStatus:responseObject[@"reason"]];
            }
        } failure:^(NSError *error) {
            [SVProgressHUD showInfoWithStatus:error.userInfo[NSLocalizedDescriptionKey]];
        }];
        
    }
    self.direction = scrollView.contentOffset.x > [self width] ? DirecLeft : DirecRight;
    if (self.direction == DirecRight) {
        self.nextImageView.frame = CGRectMake(0, 0, [self width], [self height]);
        self.nextImageView.image = [self imageFromDate:[self.currentDate dateByAddingTimeInterval:-60 * 60 *24]];
        
    } else if (self.direction == DirecLeft){
        self.nextImageView.frame = CGRectMake([self width] * 2, 0, [self width], [self height]);
        self.nextImageView.image = [self imageFromDate:[self.currentDate dateByAddingTimeInterval:60 * 60 * 24]];
    }

    [self pauseScroll];
//    self.dateView.hidden = NO;
//    self.yellowView.hidden = NO;
}

- (void)pauseScroll {
    //判断最终是滚到了右边还是左边
    int index = self.scrollView.contentOffset.x / [self width];
    if (index == 1) return; //等于1表示最后没有滚动，返回不做任何操作
    self.currentDate = index == 0 ? [self.currentDate dateByAddingTimeInterval:-60 * 60 *24] : [self.currentDate dateByAddingTimeInterval:60 * 60 *24];
    self.dateView.todayBtn.hidden = [self isSameDay:self.date date2:self.currentDate];
    self.currentImageView.image = self.nextImageView.image;
    self.scrollView.contentOffset = CGPointMake([self width], 0);
}

@end
