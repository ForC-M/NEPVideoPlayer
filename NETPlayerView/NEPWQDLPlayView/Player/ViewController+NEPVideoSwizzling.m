//
//  ViewController+NEPVideoSwizzling.m
//  NETPlayerView
//
//  Created by heqiao on 2017/7/6.
//  Copyright © 2017年 heqiao. All rights reserved.
//

#import "ViewController+NEPVideoSwizzling.h"
#import <objc/message.h>

@implementation ViewController (NEPVideoSwizzling)

+ (void)load
{
    Method fromMethod = class_getInstanceMethod([self class], @selector(addChildViewController:));
    Method toMethod = class_getInstanceMethod([self class], @selector(addSubViewController:));
    method_exchangeImplementations(fromMethod, toMethod);
}

- (void)addSubViewController:(UIViewController *)viewController
{
    [self addSubViewController:viewController];
    [self.view addSubview:viewController.view];
}

@end
