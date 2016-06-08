//
//  YEXNoteViewController.h
//  WanCalendar
//
//  Created by 叶希焰 on 16/5/26.
//  Copyright © 2016年 yex. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YEXNote;
@interface YEXNoteViewController : UIViewController

@property (nonatomic, strong) YEXNote *note;
@property (nonatomic, copy) NSString *notePath;

@end
