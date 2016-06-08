//
//  YEXReminder.h
//  WanCalendar
//
//  Created by 叶希焰 on 16/5/2.
//  Copyright © 2016年 yex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YEXReminder : NSObject

/**标题 */
@property (nonatomic, copy) NSString *title;
/**位置 */
@property (nonatomic, copy) NSString *location;
/**开始时间 */
@property (nonatomic, copy) NSString *beginDate;
/**结束时间 */
@property (nonatomic, copy) NSString *endDate;
/**类别 */
@property (nonatomic, copy) NSString *category;
/**提醒时间 */
@property (nonatomic, copy) NSString *remindTime;


-(UIColor *)lineColor;

@end
