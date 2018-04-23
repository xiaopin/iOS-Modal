//
//  XPModalTransitioningDelegate.h
//  https://github.com/xiaopin/iOS-Modal.git
//
//  Created by xiaopin on 2018/4/23.
//  Copyright © 2018年 xiaopin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XPModalConfiguration;

@interface XPModalTransitioningDelegate: NSObject<UIViewControllerTransitioningDelegate>

+ (instancetype)transitioningDelegateWithConfiguration:(XPModalConfiguration * _Nonnull)configuration;

@end
