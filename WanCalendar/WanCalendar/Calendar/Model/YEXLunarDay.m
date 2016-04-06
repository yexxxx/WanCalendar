//
//  YEXLunarDay.m
//  WanCalendar
//
//  Created by 叶希焰 on 16/4/1.
//  Copyright © 2016年 yex. All rights reserved.
//

#import "YEXLunarDay.h"

@implementation YEXLunarDay

+(instancetype)lunarDayWithDict:(NSDictionary *)dict {
    YEXLunarDay *lunarDay = [[self alloc] init];
    [lunarDay setValuesForKeysWithDictionary:dict];
    return lunarDay;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"year-month"]) {
        self.month = [value substringFromIndex:4];
    }
}

@end
