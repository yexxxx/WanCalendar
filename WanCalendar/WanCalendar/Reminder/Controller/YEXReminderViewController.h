//
//  YEXReminderViewController.h
//  WanCalendar
//
//  Created by 叶希焰 on 16/4/28.
//  Copyright © 2016年 yex. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YEXReminder;
@interface YEXReminderViewController : UIViewController

@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *currentDate;
@property (nonatomic, strong) YEXReminder *reminder;
@property (nonatomic, copy) NSString *remindePath;
@property (nonatomic, assign) BOOL isNotification;


@end
