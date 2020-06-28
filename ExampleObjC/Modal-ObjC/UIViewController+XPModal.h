//
//  UIViewController+XPModal.h
//  https://github.com/xiaopin/iOS-Modal.git
//
//  Created by xiaopin on 2018/4/23.
//  Copyright © 2018年 xiaopin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XPModalConfiguration.h"
/** 配置的Block */
typedef void (^XPModalConfigBlock)(XPModalConfiguration * _Nonnull configuration);

typedef void(^XPModalCompletionHandler)(void);


@interface UIViewController (XPModal)

/**
 显示一个模态视图控制器
 
 @param controller      模态视图控制器
 @param configBlock     模态窗口的配置信息
 @param completion      模态窗口显示完毕时的回调
 */
- (void)presentModalWithViewController:(UIViewController *_Nonnull)controller configBlock:(XPModalConfigBlock _Nullable )configBlock  completion:(XPModalCompletionHandler _Nullable)completion NS_AVAILABLE_IOS(8_0);

/**
 显示一个模态视图
 
 @param view             内容视图
 @param configBlock      模态窗口的配置信息
 @param completion       模态窗口显示完毕时的回调
 */
- (void)presentModalWithView:(UIView *_Nonnull)view configBlock:(XPModalConfigBlock _Nullable )configBlock completion:(XPModalCompletionHandler _Nullable)completion NS_AVAILABLE_IOS(8_0);


/**
 显示一个模态视图控制器

 @param viewController  视图控制器
 @param contentSize     模态窗口大小(内部会限制宽高最大值为屏幕的宽高)
 @param configuration   模态窗口的配置信息
 @param completion      模态窗口显示完毕时的回调
 */
- (void)presentModalWithViewController:(UIViewController * _Nonnull)viewController contentSize:(CGSize)contentSize configuration:(XPModalConfiguration * _Nonnull)configuration completion:(XPModalCompletionHandler _Nullable)completion NS_DEPRECATED_IOS(8_0, 8_0, "Use `-presentModalWithViewController:configBlock:completion:` instead") NS_AVAILABLE_IOS(8_0);

/**
 显示一个模态视图
 
 @param view            内容视图
 @param contentSize     模态窗口大小(内部会限制宽高最大值为屏幕的宽高)
 @param configuration   模态窗口的配置信息
 @param completion      模态窗口显示完毕时的回调
 */
- (void)presentModalWithView:(UIView * _Nonnull)view contentSize:(CGSize)contentSize configuration:(XPModalConfiguration * _Nonnull)configuration completion:(XPModalCompletionHandler _Nullable)completion NS_DEPRECATED_IOS(8_0, 8_0, "Use `-presentModalWithView:configBlock:completion:` instead") NS_AVAILABLE_IOS(8_0);

@end
