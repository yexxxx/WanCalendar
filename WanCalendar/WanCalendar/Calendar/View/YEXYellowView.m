//
//  YEXYellowView.m
//  WanCalendar
//
//  Created by 叶希焰 on 16/4/6.
//  Copyright © 2016年 yex. All rights reserved.
//

#import "YEXYellowView.h"
#import "YEXLunarDay.h"
#import "YEXRowView.h"

@interface YEXYellowView ()

@property (nonatomic, weak) YEXRowView *suitView;
@property (nonatomic, weak) YEXRowView *avoidView;

@end

@implementation YEXYellowView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
//    CGFloat centerX = [self centerX];
    CGFloat labelX = 20;
    CGFloat edgeInset = 10;
    
    self.suitView.frame = CGRectMake(labelX, edgeInset, self.width - 40, self.height * 0.5);
    
    CGFloat avoidViewY = CGRectGetMaxY(self.suitView.frame) + edgeInset ;
    self.avoidView.frame = CGRectMake(labelX, avoidViewY, self.width - 40, self.height * 0.5);
    
}

-(void)setLunarDay:(YEXLunarDay *)lunarDay {
    _lunarDay = lunarDay;
    self.suitView.text = [lunarDay.suit stringByReplacingOccurrencesOfString:@"." withString:@" "];
    self.avoidView.text = [lunarDay.avoid stringByReplacingOccurrencesOfString:@"." withString:@" "];
}

#pragma mark - lazyLoading

-(YEXRowView *)suitView
{
    if (!_suitView) {
        YEXRowView *rowView = [[YEXRowView alloc] init];
        rowView.title = @"宜";
        rowView.titleColor = [UIColor colorWithRed:13/255.0  green:153/255.0  blue:252/255.0  alpha:1.0];
        rowView.layer.cornerRadius = self.height * 0.2;
        [self addSubview:rowView];
        _suitView = rowView;
    }
    return _suitView;
}

-(YEXRowView *)avoidView
{
    if (!_avoidView) {
        YEXRowView *rowView = [[YEXRowView alloc] init];
        rowView.title = @"忌";
        rowView.titleColor = [UIColor redColor];
        rowView.layer.cornerRadius = self.height * 0.2;
        [self addSubview:rowView];
        _avoidView = rowView;
    }
    return _avoidView;
}

@end
