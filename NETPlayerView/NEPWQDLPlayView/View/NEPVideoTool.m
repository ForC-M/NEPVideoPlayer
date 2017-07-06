//
//  NEPVideoTool.m
//  NETPlayerView
//
//  Created by heqiao on 2017/6/23.
//  Copyright © 2017年 heqiao. All rights reserved.
//

#import "NEPVideoTool.h"



@implementation NEPVideoRotatoControl

+ (void)forceOrientation: (UIInterfaceOrientation)orientation {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget: [UIDevice currentDevice]];
        int val = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

+ (BOOL)isOrientationLandscape {
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        return YES;
    } else {
        return NO;
    }
}

@end



@implementation UIColor (Hex)

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha
{
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

//默认alpha值为1
+ (UIColor *)colorWithHexString:(NSString *)color
{
    return [self colorWithHexString:color alpha:1.0f];
}
@end

@implementation UIView (VideoFrame)

+(instancetype)NEP_viewFromXib
{
    
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
    
}

-(CGFloat)NEP_height
{
    return self.frame.size.height;
}
-(void)setNEP_height:(CGFloat)NEP_height
{
    CGRect rect = self.frame;
    rect.size.height = NEP_height;
    self.frame = rect;
    
}

- (CGFloat)NEP_width
{
    return self.frame.size.width;
}
-(void)setNEP_width:(CGFloat)NEP_width
{
    CGRect rect = self.frame;
    rect.size.width = NEP_width;
    self.frame = rect;
}

-(CGFloat)NEP_x
{
    return self.frame.origin.x;
}

-(void)setNEP_x:(CGFloat)NEP_x
{
    CGRect rect = self.frame;
    rect.origin.x = NEP_x;
    self.frame = rect;
}

-(CGFloat)NEP_y
{
    return self.frame.origin.y;
}

-(void)setNEP_y:(CGFloat)NEP_y
{
    CGRect rect = self.frame;
    rect.origin.y = NEP_y;
    self.frame = rect;
}
-(void)setNEP_centerX:(CGFloat)NEP_centerX
{
    CGPoint center = self.center;
    center.x = NEP_centerX;
    self.center = center;
}
-(CGFloat)NEP_centerX
{
    return self.center.x;
}
-(void)setNEP_centerY:(CGFloat)NEP_centerY
{
    CGPoint center = self.center;
    center.y = NEP_centerY;
    self.center = center;
}
-(CGFloat)NEP_centerY
{
    return self.center.y;
}

- (BOOL)isShowingOnKeyWindow
{
    // 主窗口
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    // 以主窗口左上角为坐标原点, 计算self的矩形框
    CGRect newFrame = [keyWindow convertRect:self.frame fromView:self.superview];
    CGRect winBounds = keyWindow.bounds;
    
    // 主窗口的bounds 和 self的矩形框 是否有重叠
    BOOL intersects = CGRectIntersectsRect(newFrame, winBounds);
    
    return !self.isHidden && self.alpha > 0.01 && self.window == keyWindow && intersects;
}
@end
