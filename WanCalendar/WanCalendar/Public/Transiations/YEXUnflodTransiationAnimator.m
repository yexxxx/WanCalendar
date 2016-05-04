//
//  YEXUnflodTransiationAnimator.m
//  WanCalendar
//
//  Created by 叶希焰 on 16/4/29.
//  Copyright © 2016年 yex. All rights reserved.
//

#import "YEXUnflodTransiationAnimator.h"

@implementation YEXUnflodTransiationAnimator


-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext
                                viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC   = [transitionContext
                                viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    if(!self.presenting){
        [self executeReverseAnimation:transitionContext fromVC:fromVC toVC:toVC fromView:fromView toView:toView];
    } else {
        [self executeForwardsAnimation:transitionContext fromVC:fromVC toVC:toVC fromView:fromView toView:toView];
    }
    
}

- (void)executeForwardsAnimation:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView {
    
    UIView *containerView = [transitionContext containerView];
    // Add the from-view to the container
    [containerView addSubview:fromView];
    
    // add the to- view and send offscreen (we need to do this in order to allow snapshotting)
    toView.frame = containerView.bounds;
    [containerView addSubview:toView];
    
    // Add a reduced snapshot of the toView to the container
    UIView *toViewSnapshot = [toView resizableSnapshotViewFromRect:toView.frame afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
    [containerView addSubview:toViewSnapshot];
    [containerView sendSubviewToBack:toViewSnapshot];
    
    
    // Create two-part snapshots of the from- view
    
    // snapshot the left-hand side of the from- view
    CGRect upSnapshotRegion = CGRectMake(0, 0, fromView.frame.size.width , fromView.frame.size.height/ 2);
    UIView *upHandView = [fromView resizableSnapshotViewFromRect:upSnapshotRegion  afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
    upHandView.frame = upSnapshotRegion;
    [containerView addSubview:upHandView];
    
    // snapshot the right-hand side of the from- view
    CGRect downSnapshotRegion = CGRectMake(0, fromView.frame.size.height/ 2, fromView.frame.size.width, fromView.frame.size.height / 2);
    UIView *downHandView = [fromView resizableSnapshotViewFromRect:downSnapshotRegion  afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
    downHandView.frame = downSnapshotRegion;
    [containerView addSubview:downHandView];
    
    // remove the view that was snapshotted
    [fromView removeFromSuperview];
    
    // animate
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         // Open the portal doors of the from-view
                         upHandView.frame = CGRectOffset(upHandView.frame, 0, - upHandView.height);
                         downHandView.frame = CGRectOffset(downHandView.frame, 0, downHandView.height);
                         
                     } completion:^(BOOL finished) {
                         
                         // remove all the temporary views
                         if ([transitionContext transitionWasCancelled]) {
                             [containerView addSubview:fromView];
                             [self removeOtherViews:fromView];
                         } else {
                             // add the real to- view and remove the snapshots
                             [containerView addSubview:toView];
                             [self removeOtherViews:toView];
                             toView.frame = containerView.bounds;
                         }
                         
                         // inform the context of completion
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];
    
}



- (void)executeReverseAnimation:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView {
    
    UIView *containerView = [transitionContext containerView];
    
    
    // Create two-part snapshots of the to- view
    
    // snapshot the left-hand side of the to- view
    CGRect upSnapshotRegion = CGRectMake(0, 0, toView.frame.size.width , toView.frame.size.height / 2);
    UIView *upHandView = [toView resizableSnapshotViewFromRect:upSnapshotRegion  afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
    upHandView.frame = upSnapshotRegion;
    // reverse animation : start from beyond the edges of the screen
    upHandView.frame = CGRectOffset(upHandView.frame, 0, -upHandView.height);
    [containerView addSubview:upHandView];
    
    // snapshot the right-hand side of the to- view
    CGRect downSnapshotRegion = CGRectMake(0, toView.height / 2, toView.frame.size.width, toView.frame.size.height / 2);
    UIView *downHandView = [toView resizableSnapshotViewFromRect:downSnapshotRegion  afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
    downHandView.frame = downSnapshotRegion;
    // reverse animation : start from beyond the edges of the screen
    downHandView.frame = CGRectOffset(downHandView.frame, 0, downHandView.height);
    [containerView addSubview:downHandView];
    
    // animate
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         // Close the portal doors of the to-view
                         upHandView.frame = CGRectOffset(upHandView.frame, 0, upHandView.height);
                         downHandView.frame = CGRectOffset(downHandView.frame, 0, -downHandView.height);
                         
                         
                     } completion:^(BOOL finished) {
                         
                         // remove all the temporary views
                         if ([transitionContext transitionWasCancelled]) {
                             [self removeOtherViews:fromView];
                         } else {
                             [self removeOtherViews:toView];
                             toView.frame = containerView.bounds;
                         }
                         
                         // inform the context of completion
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];
}


// removes all the views other than the given view from the superview
- (void)removeOtherViews:(UIView*)viewToKeep {
    UIView *containerView = viewToKeep.superview;
    for (UIView *view in containerView.subviews) {
        if (view != viewToKeep) {
            [view removeFromSuperview];
        }
    }
}
@end
