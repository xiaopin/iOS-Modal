//
//  UIViewController+XPModal.m
//  https://github.com/xiaopin/iOS-Modal.git
//
//  Created by xiaopin on 2018/4/23.
//  Copyright © 2018年 xiaopin. All rights reserved.
//

#import "UIViewController+XPModal.h"
#import "XPModalTransitioningDelegate.h"
#import <objc/message.h>

#pragma mark -
@implementation UIViewController (XPModal)

/**
显示一个模态视图控制器
@param configBlock     模态窗口的配置信息
@param controller      模态视图控制器
@param completion      模态窗口显示完毕时的回调
*/
- (void)presentModalWithController:(UIViewController *_Nonnull)controller
configBlock:(ModalConfigBlock _Nullable )configBlock  completion:(ModalCompletionHandler _Nullable)completion{
    if (self.presentedViewController) { return; }
    XPModalConfiguration *config=[XPModalConfiguration defaultConfiguration];
    configBlock ? configBlock(config) : nil;
    
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.preferredContentSize =config.contentSize;
    
    XPModalTransitioningDelegate *transitioningDelegate = [XPModalTransitioningDelegate transitioningDelegateWithConfiguration:config];
    controller.transitioningDelegate = transitioningDelegate;
    objc_setAssociatedObject(controller, _cmd, transitioningDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self presentViewController:controller animated:true completion:completion];
}

/**
显示一个模态视图控制器
@param view             模态视图控制器
@param configBlock      模态窗口的配置信息
@param completion       模态窗口显示完毕时的回调
*/
- (void)presentModalWithView:(UIView *_Nonnull)view configBlock:(ModalConfigBlock _Nullable )configBlock completion:(ModalCompletionHandler _Nullable)completion NS_AVAILABLE_IOS(8_0) {
    UIViewController *modalVC = [[UIViewController alloc] init];
    modalVC.view.backgroundColor = [UIColor clearColor];
    [modalVC.view addSubview:view];
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = @{@"view": view};
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    
      [self presentModalWithController:modalVC configBlock:configBlock completion:completion];
}

@end
