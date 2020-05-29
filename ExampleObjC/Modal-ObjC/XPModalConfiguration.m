//
//  XPModalConfiguration.m
//  https://github.com/xiaopin/iOS-Modal.git
//
//  Created by xiaopin on 2018/4/23.
//  Copyright © 2018年 xiaopin. All rights reserved.
//

#import "XPModalConfiguration.h"

@implementation XPModalConfiguration

+ (instancetype)defaultConfiguration {
    return [[XPModalConfiguration alloc] init];
}

- (instancetype)init {
    if (self = [super init]) {
        _direction = XPModalDirectionBottom;
        _animationDuration = 0.5;
        _autoDismissModal = YES;
        _backgroundOpacity = 0.3;
        
        _enableShadow = YES;
        _shadowColor = [UIColor blackColor];
        _shadowWidth = 3.0;
        _shadowOpacity = 0.8;
        _shadowRadius = 5.0;
        
        _enableBackgroundAnimation = NO;
        _backgroundColor = [UIColor blackColor];
        _backgroundImage = nil;
        
        _enableInteractiveTransitioning = YES;
    }
    return self;
}

@end
