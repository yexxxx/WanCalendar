//
//  YEXCategoryCell.m
//  WanCalendar
//
//  Created by 叶希焰 on 16/5/2.
//  Copyright © 2016年 yex. All rights reserved.
//

#import "YEXCategoryCell.h"

@implementation YEXCategoryCell

-(void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context =  UIGraphicsGetCurrentContext();
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(15, 17, 10, 10)];
    CGContextAddPath(context, [path CGPath]);
    [self.roundColor setFill];
    CGContextFillPath(context);
    
    [self.title drawInRect:CGRectMake(30, 12, 40, 18) withAttributes:@{NSFontAttributeName:textFont}];
}

@end
