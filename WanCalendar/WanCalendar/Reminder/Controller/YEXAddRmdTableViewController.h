//
//  YEXAddRmdTableViewController.h
//  WanCalendar
//
//  Created by 叶希焰 on 16/5/2.
//  Copyright © 2016年 yex. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^transSeconds)(NSInteger seconds,NSString *text);

@interface YEXAddRmdTableViewController : UITableViewController

-(void)transBlock:(transSeconds)Block;

@end
