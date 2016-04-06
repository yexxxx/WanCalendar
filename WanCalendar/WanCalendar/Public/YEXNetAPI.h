//
//  YEXNetAPI.h
//  WanCalendar
//
//  Created by 叶希焰 on 16/4/1.
//  Copyright © 2016年 yex. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, YEXNetType) {
    YEXNetTypeDay   = 1,
    YEXNetTypeMonth = 2,
    YEXNetTypeYear  = 3,
};


@interface YEXNetAPI : NSObject


+(instancetype)netAPI;
- (void)getDataWithType:(YEXNetType)type andDate:(NSDate *)date
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure;

@end
