//
//  YEXDateView.m
//  WanCalendar
//
//  Created by 叶希焰 on 16/4/6.
//  Copyright © 2016年 yex. All rights reserved.
//

#import "YEXDateView.h"
#import "YEXLunarDay.h"

static const CGFloat edgeInset = 10;

@interface YEXDateView ()

@property(nonatomic, weak)UILabel *monthLabel;
@property(nonatomic, weak)UILabel *lunarLabel;

@property(nonatomic, strong)NSArray<NSString *> *monthArr;

@end

@implementation YEXDateView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width  = [self width];
    CGFloat height = [self height] - 2 * edgeInset;
    
    self.todayBtn.frame   = CGRectMake((width - 100) *0.5, 20, 100, 20);
    
    CGFloat monthLabelY   = CGRectGetMaxY(self.todayBtn.frame) + 2 * edgeInset;
    self.monthLabel.frame = CGRectMake(0, monthLabelY, width, height * 0.4);

    CGFloat lunarLabelY   = CGRectGetMaxY(self.monthLabel.frame) + 5;
    self.lunarLabel.frame = CGRectMake(0, lunarLabelY, width, height * 0.2);
    
}

-(void)setLunarDay:(YEXLunarDay *)lunarDay {
    _lunarDay = lunarDay;
    self.monthLabel.text = self.monthArr[lunarDay.month.intValue - 1];
    self.lunarLabel.text = [NSString stringWithFormat:@"农历%@·%@",lunarDay.lunar,lunarDay.weekday];
}

#pragma mark - lazyLoading

-(UILabel *)monthLabel
{
    if (!_monthLabel) {
        UILabel *label      = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor     = [UIColor blackColor];
       
//        label.font = [UIFont systemFontOfSize:[UIFont preferredFontForTextStyle:UIFontTextStyleTitle1].pointSize weight:1];
        label.font = [UIFont fontWithName:@"FZXiaoBiaoSong-B05S" size:50];
//        label.adjustsFontSizeToFitWidth = YES;
        [self addSubview:label];
        _monthLabel         = label;
    }
    return _monthLabel;
}

-(UILabel *)lunarLabel
{
    if (!_lunarLabel) {
        UILabel *label      = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor     = [UIColor blackColor];
        label.font = [UIFont fontWithName:@"FZXiaoBiaoSong-B05S" size:[UIFont preferredFontForTextStyle:UIFontTextStyleBody].pointSize];
//        label.adjustsFontSizeToFitWidth = YES;
        [self addSubview:label];
        _lunarLabel         = label;
    }
    return _lunarLabel;
}

-(UIButton *)todayBtn
{
    if (!_todayBtn) {
        UIButton *button                = [[UIButton alloc] init];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.backgroundColor = [UIColor lightGrayColor];
        button.titleLabel.font = [UIFont fontWithName:@"FZXiaoBiaoSong-B05S" size:[UIFont preferredFontForTextStyle:UIFontTextStyleFootnote].pointSize];
        [button setTitle:@"回到今天" forState:UIControlStateNormal];
        button.layer.cornerRadius = 10;
        [self addSubview:button];
        _todayBtn                       = button;
    }
    return _todayBtn;
}

-(NSArray *)monthArr
{
    if (!_monthArr) {
        _monthArr = @[@"一月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月",@"八月",@"九月",@"十月",@"十一月",@"十二月"];
    }
    return _monthArr;
}

@end
