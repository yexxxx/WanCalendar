//
//  YEXUnflodTransiation.m
//  WanCalendar
//
//  Created by 叶希焰 on 16/4/29.
//  Copyright © 2016年 yex. All rights reserved.
//

#import "YEXUnflodTransiation.h"
#import "YEXUnflodTransiationAnimator.h"

@implementation YEXUnflodTransiation

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    YEXUnflodTransiationAnimator *transiation = [[YEXUnflodTransiationAnimator alloc] init];
    transiation.presenting = YES;
    return transiation;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    YEXUnflodTransiationAnimator *transiation = [[YEXUnflodTransiationAnimator alloc] init];
    transiation.presenting = NO;
    return transiation;
}


@end
