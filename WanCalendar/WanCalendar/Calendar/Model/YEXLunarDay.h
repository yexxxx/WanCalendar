//
//  YEXLunarDay.h
//  WanCalendar
//
//  Created by 叶希焰 on 16/4/1.
//  Copyright © 2016年 yex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YEXLunarDay : NSObject

/*
 "holiday" : "元旦" ,
 "avoid" : "伐木.纳畜.破土.安葬.开生坟.嫁娶.开市.动土.交易.作梁." ,
 "animalsYear" : "兔" ,
 "desc" : "2012年1月1日至3日放假调休，共3天，2011年12月31日（星期六）上班" ,
 "weekday" : "星期日" ,
 "suit" : "祭祀.开光.理发.整手足甲.安床.作灶.扫舍.教牛马." ,
 "lunarYear" : "辛卯年" ,
 "lunar" : "腊月初八" ,
 "year-month" : "2012-1" ,
 "date" : "2012-1-1"
 */
@property (nonatomic, copy) NSString *holiday;
@property (nonatomic, copy) NSString *avoid;
@property (nonatomic, copy) NSString *animalsYear;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *weekday;
@property (nonatomic, copy) NSString *suit;
@property (nonatomic, copy) NSString *lunarYear;
@property (nonatomic, copy) NSString *lunar;
@property (nonatomic, copy) NSString *month;
@property (nonatomic, copy) NSString *date;

+(instancetype)lunarDayWithDict:(NSDictionary *)dict;

@end
