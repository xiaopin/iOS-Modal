//
//  XPModalAnimatedTransitioning.h
//  https://github.com/xiaopin/iOS-Modal.git
//
//  Created by xiaopin on 2018/4/23.
//  Copyright © 2018年 xiaopin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XPModalConfiguration;

@interface XPModalAnimatedTransitioning: NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign, getter=isPresentation) BOOL presentation;
@property (nonatomic, strong) XPModalConfiguration *configuration;

+ (instancetype)transitioningWithConfiguration:(XPModalConfiguration *)configuration isPresentation:(BOOL)presentation;

@end
