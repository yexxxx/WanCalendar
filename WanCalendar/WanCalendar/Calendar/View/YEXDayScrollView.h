//
//  YEXDayScrollView.h
//  WanCalendar
//
//  Created by 叶希焰 on 16/4/1.
//  Copyright © 2016年 yex. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YEXLunarDay;
typedef void(^viewTapBlock)();
@interface YEXDayScrollView : UIView

@property(nonatomic, strong)NSDate *date;
@property(nonatomic, strong)YEXLunarDay *lunarDay;
@property(nonatomic, strong)YEXLunarDay *lunarToday;
@property (nonatomic, copy) viewTapBlock tapBlock;

@end
