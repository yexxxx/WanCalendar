//
//  UIView+YEXView.h
//  WanCalendar
//
//  Created by 叶希焰 on 16/4/5.
//  Copyright © 2016年 yex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (YEXView)

@property (nonatomic, copy) NSString *ss;

-(CGPoint)orgin;
-(CGFloat)orginX;
-(CGFloat)orginY;
-(CGFloat)width;
-(CGFloat)height;
-(CGPoint)center;
-(CGFloat)centerX;
-(CGFloat)centerY;

@end
