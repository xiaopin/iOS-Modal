//
//  XPModalAnimatedTransitioning.m
//  https://github.com/xiaopin/iOS-Modal.git
//
//  Created by xiaopin on 2018/4/23.
//  Copyright © 2018年 xiaopin. All rights reserved.
//

#import "XPModalAnimatedTransitioning.h"
#import "UIViewController+XPModal.h"

@implementation XPModalAnimatedTransitioning

+ (instancetype)transitioningWithConfiguration:(XPModalConfiguration *)configuration isPresentation:(BOOL)presentation {
    XPModalAnimatedTransitioning *transitioning = [[XPModalAnimatedTransitioning alloc] init];
    transitioning.configuration = configuration;
    transitioning.presentation = presentation;
    return transitioning;
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return self.configuration.animationDuration;
}

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    BOOL isPresentation = self.isPresentation;
    if (isPresentation && toView) {
        [transitionContext.containerView addSubview:toView];
    }
    
    UIViewController *animatingVC = isPresentation ? toVC : fromVC;
    CGRect finalFrame = [transitionContext finalFrameForViewController:animatingVC];
    UIView *animatingView = isPresentation ? toView : fromView;
    
    switch (_configuration.direction) {
        case XPModalDirectionTop:
            animatingView.frame = isPresentation ? CGRectOffset(finalFrame, 0.0, -finalFrame.size.height) : finalFrame;
            break;
        case XPModalDirectionRight:
            animatingView.frame = isPresentation ? CGRectOffset(finalFrame, finalFrame.size.width, 0.0) : finalFrame;
            break;
        case XPModalDirectionBottom:
            animatingView.frame = isPresentation ? CGRectOffset(finalFrame, 0.0, finalFrame.size.height) : finalFrame;
            break;
        case XPModalDirectionLeft:
            animatingView.frame = isPresentation ? CGRectOffset(finalFrame, -finalFrame.size.width, 0.0) : finalFrame;
            break;
        case XPModalDirectionCenter:
            animatingView.frame = finalFrame;
            animatingView.alpha = isPresentation ? 0.0 : 1.0;
            break;
    }
    
    [UIView animateWithDuration:self.configuration.animationDuration delay:0.0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^{
        switch (self.configuration.direction) {
            case XPModalDirectionTop:
                animatingView.frame = isPresentation ? finalFrame : CGRectOffset(finalFrame, 0.0, -finalFrame.size.height);
                break;
            case XPModalDirectionRight:
                animatingView.frame = isPresentation ? finalFrame : CGRectOffset(finalFrame, finalFrame.size.width, 0.0);
                break;
            case XPModalDirectionBottom:
                animatingView.frame = isPresentation ? finalFrame : CGRectOffset(finalFrame, 0.0, finalFrame.size.height);
                break;
            case XPModalDirectionLeft:
                animatingView.frame = isPresentation ? finalFrame : CGRectOffset(finalFrame, -finalFrame.size.width, 0.0);
                break;
            case XPModalDirectionCenter:
                animatingView.alpha = isPresentation ? 1.0 : 0.0;
                break;
        }
    } completion:^(BOOL finished) {
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        if (!self.isPresentation && !wasCancelled) {
            [fromView removeFromSuperview];
        }
        [transitionContext completeTransition:!wasCancelled];
    }];
}

@end
