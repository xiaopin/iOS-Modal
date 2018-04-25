//
//  XPModalConfiguration.h
//  https://github.com/xiaopin/iOS-Modal.git
//
//  Created by xiaopin on 2018/4/23.
//  Copyright © 2018年 xiaopin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XPModalDirection) {
    XPModalDirectionCenter,
    XPModalDirectionTop,
    XPModalDirectionRight,
    XPModalDirectionBottom,
    XPModalDirectionLeft
};



@interface XPModalConfiguration: NSObject

/// 弹出的方向, 默认`XPModalDirectionBottom`从底部弹出
@property (nonatomic, assign) XPModalDirection direction;
/// 动画时长, 默认`0.5s`
@property (nonatomic, assign) NSTimeInterval animationDuration;
/// 点击模态窗口之外的区域是否关闭模态窗口
@property (nonatomic, assign, getter=isAutoDismissModal) BOOL autoDismissModal;
/// 背景透明度, 0.0~1.0, 默认`0.3`
@property (nonatomic, assign) CGFloat backgroundOpacity;

/// 是否使用阴影效果
@property (nonatomic, assign, getter=isEnableShadow) BOOL enableShadow;
/// 阴影颜色, 默认`blackColor`
@property (nonatomic, strong) UIColor *shadowColor;
/// 阴影宽度, 默认`3.0`
@property (nonatomic, assign) CGFloat shadowWidth;
/// 阴影透明度, 0.0~1.0, 默认`0.8`
@property (nonatomic, assign) CGFloat shadowOpacity;
/// 阴影圆角, 默认`5.0`
@property (nonatomic, assign) CGFloat shadowRadius;

/// 是否启用背景动画, 默认`NO`
@property (nonatomic, assign, getter=isEnableBackgroundAnimation) BOOL enableBackgroundAnimation;
/// 背景颜色(需要设置`enableBackgroundAnimation`为YES)
@property (nonatomic, strong) UIColor *backgroundColor;
/// 背景图片(需要设置`enableBackgroundAnimation`为YES)
@property (nonatomic, strong) UIImage *backgroundImage;

/// 是否启用交互式转场动画(当direction == XPModalDirectionCenter时无效, 默认`YES`)
@property (nonatomic, assign, getter=isEnableInteractiveTransitioning) BOOL enableInteractiveTransitioning;

/// 交互手势(内部维护该手势,请忽略该属性)
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
/**
 标记交互手势是否已经开始了(仅限内部使用, Internal use only)
 
 Fix: iOS9.x and iOS10.x tap gesture is failure.
 */
@property (nonatomic, assign, getter=isStartedInteractiveTransitioning) BOOL startedInteractiveTransitioning;


/// 默认配置
+ (instancetype)defaultConfiguration;

@end
