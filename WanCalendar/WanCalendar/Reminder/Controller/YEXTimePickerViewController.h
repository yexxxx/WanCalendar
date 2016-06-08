//
//  YEXTimePickerViewController.h
//  WanCalendar
//
//  Created by 叶希焰 on 16/5/1.
//  Copyright © 2016年 yex. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^transDateBlock)(NSDate *date);

@interface YEXTimePickerViewController : UIViewController

@property (nonatomic, strong) NSDate *currentDate;

-(void)transDate:(transDateBlock)block;

@end
