//
//  YEXDateView.h
//  WanCalendar
//
//  Created by 叶希焰 on 16/4/6.
//  Copyright © 2016年 yex. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YEXLunarDay;
@interface YEXDateView : UIView

@property (nonatomic, strong) YEXLunarDay *lunarDay;
@property(nonatomic, weak)UIButton *todayBtn;


@end
