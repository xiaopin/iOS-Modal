//
//  XPModalTransitioningDelegate.m
//  https://github.com/xiaopin/iOS-Modal.git
//
//  Created by xiaopin on 2018/4/23.
//  Copyright © 2018年 xiaopin. All rights reserved.
//

#import "XPModalTransitioningDelegate.h"
#import "XPModalConfiguration.h"
#import "XPModalAnimatedTransitioning.h"
#import "XPModalPresentationController.h"
#import "XPModalPercentDrivenInteractiveTransition.h"

@implementation XPModalTransitioningDelegate
{
    XPModalConfiguration *_configuration;
}

+ (instancetype)transitioningDelegateWithConfiguration:(XPModalConfiguration *)configuration {
    XPModalTransitioningDelegate *delegate = [[XPModalTransitioningDelegate alloc] init];
    delegate->_configuration = configuration;
    return delegate;
}

#pragma mark - <UIViewControllerTransitioningDelegate>

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [XPModalAnimatedTransitioning transitioningWithConfiguration:_configuration
                                                         isPresentation:YES];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [XPModalAnimatedTransitioning transitioningWithConfiguration:_configuration
                                                         isPresentation:NO];
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    if (_configuration.enableInteractiveTransitioning & _configuration.isStartedInteractiveTransitioning) {
        return [XPModalPercentDrivenInteractiveTransition interactiveTransitionWithConfiguration:_configuration];
    }
    return nil;
}

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    XPModalPresentationController *presentationController = [[XPModalPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    presentationController.configuration = _configuration;
    return presentationController;
}

@end
