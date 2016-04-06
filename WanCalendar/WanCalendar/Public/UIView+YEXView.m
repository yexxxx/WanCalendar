//
//  UIView+YEXView.m
//  WanCalendar
//
//  Created by 叶希焰 on 16/4/5.
//  Copyright © 2016年 yex. All rights reserved.
//

#import "UIView+YEXView.h"

@implementation UIView (YEXView)

-(CGPoint)orgin {
    return self.frame.origin;
}
-(CGFloat)orginX {
    return [self orgin].x;
}

-(CGFloat)orginY {
    return [self orgin].y;
}

-(CGFloat)width {
    return self.frame.size.width;
}

-(CGFloat)height {
    return self.frame.size.height;
}

-(CGPoint)center {
    return CGPointMake([self centerX], [self centerY]);
}

-(CGFloat)centerX {
    return [self orgin].x + [self width] * 0.5;
}

-(CGFloat)centerY {
    return [self orgin].y + [self height] * 0.5;
}

@end
