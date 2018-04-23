//
//  XPModalPercentDrivenInteractiveTransition.m
//  https://github.com/xiaopin/iOS-Modal.git
//
//  Created by xiaopin on 2018/4/23.
//  Copyright © 2018年 xiaopin. All rights reserved.
//

#import "XPModalPercentDrivenInteractiveTransition.h"
#import "XPModalConfiguration.h"

@interface XPModalPercentDrivenInteractiveTransition ()

@property (nonatomic, strong) XPModalConfiguration *configuration;
@property (nonatomic, strong) id<UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, assign) CGPoint beganTouchPoint;

@end

@implementation XPModalPercentDrivenInteractiveTransition

+ (instancetype)interactiveTransitionWithConfiguration:(XPModalConfiguration *)configuration {
    XPModalPercentDrivenInteractiveTransition *interactiveTransition = [[XPModalPercentDrivenInteractiveTransition alloc] init];
    interactiveTransition.configuration = configuration;
    [configuration.panGestureRecognizer addTarget:interactiveTransition action:@selector(gestureRecognizeDidUpdate:)];
    return interactiveTransition;
}

/// 重写以便获取到上下文参数
- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    _transitionContext = transitionContext;
    [super startInteractiveTransition:transitionContext];
}

/// 手势事件
- (void)gestureRecognizeDidUpdate:(UIPanGestureRecognizer *)sender {
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            // 开始状态由`XPModalPresentationController`进行处理,不会走到这里
            break;
        case UIGestureRecognizerStateChanged: {
            if (CGPointEqualToPoint(_beganTouchPoint, CGPointZero)) {
                _beganTouchPoint = [sender locationInView:_transitionContext.containerView];
            }
            CGFloat percent = [self percentForGesture:sender];
            [self updateInteractiveTransition:percent];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            CGFloat percent = [self percentForGesture:sender];
            _beganTouchPoint = CGPointZero;
            if (percent >= 0.3) {
                [self finishInteractiveTransition];
            } else {
                [self cancelInteractiveTransition];
            }
            break;
        }
        default:
            _beganTouchPoint = CGPointZero;
            [self cancelInteractiveTransition];
            break;
    }
}

/// 计算手势滑动百分比
- (CGFloat)percentForGesture:(UIPanGestureRecognizer *)sender {
    UIView *modalView = [_transitionContext viewForKey:UITransitionContextFromViewKey];
    CGPoint currentPoint = [sender locationInView:_transitionContext.containerView];
    CGFloat width = modalView.bounds.size.width;
    CGFloat height = modalView.bounds.size.height;
    
    switch (_configuration.direction) {
        case XPModalDirectionTop:
            if (currentPoint.y < _beganTouchPoint.y) {
                return (_beganTouchPoint.y - currentPoint.y) / height;
            }
            break;
        case XPModalDirectionRight:
            if (currentPoint.x > _beganTouchPoint.x) {
                return (currentPoint.x - _beganTouchPoint.x) / width;
            }
            break;
        case XPModalDirectionBottom:
            if (currentPoint.y > _beganTouchPoint.y) {
                return (currentPoint.y - _beganTouchPoint.y) / height;
            }
            break;
        case XPModalDirectionLeft:
            if (currentPoint.x < _beganTouchPoint.x) {
                return (_beganTouchPoint.x - currentPoint.x) / width;
            }
            break;
        case XPModalDirectionCenter:
            // Not support.
            break;
    }
    return 0.0;
}

@end
