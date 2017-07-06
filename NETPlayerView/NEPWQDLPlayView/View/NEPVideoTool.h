//
//  NEPVideoTool.h
//  NETPlayerView
//
//  Created by heqiao on 2017/6/23.
//  Copyright © 2017年 heqiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define NEP_ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define NEP_ScreenHeight  [UIScreen mainScreen].bounds.size.height
#define NEPSCALEW [UIScreen mainScreen].bounds.size.width / 375
#define NEPSCALEH [UIScreen mainScreen].bounds.size.height / 667
#define NEPFont(font) iphone5 ? [UIFont systemFontOfSize:font-2] : [UIFont systemFontOfSize:font]
#define NEPFontName(name, font) iphone5 ? [UIFont fontWithName:name size:font-2] : [UIFont fontWithName:name size:font]
#define NEPImage(name) [UIImage imageNamed:name]
#define iphone5 (NEP_ScreenWidth == 320)
#define NEPGloabColor [UIColor colorWithHexString:@"#e55624"]
#define NEPVideoPlayerImage(fileName) [@"NEPVideoPlayer.bundle/en.lproj" stringByAppendingPathComponent:fileName]

typedef enum NEPVideoPlayerScreenState {
    NEPVideoplayerSmallScreen,      // 视频小屏播放
    NEPVideoplayerFullScreen        // 视频全屏播放
} NEPVideoPlayerScreenState;        // 视频屏幕大小

typedef NS_ENUM(NSUInteger, NEPPlayerScreenPanStatus) {
    NEPPlayerScreenPanProgress,
    NEPPlayerScreenPanLight,
    NEPPlayerScreenPanVolum,
    NEPPlayerScreenPanNone
};

typedef NS_ENUM(NSUInteger, NEPPlayerScreenStatus) {
    NEPPlayerScreenVerticalStatus         = 0,
    NEPPlayerScreenAllStatus              = 2,
    NEPPlayerScreenRightOrLeftStatus      = 3
};

typedef NS_ENUM(NSUInteger, NEPPlayerStatus) {
    NEPPlayerShortPlayer,
    NEPPlayerLivePlayer
};


@interface NEPVideoRotatoControl : NSObject

+ (void)forceOrientation:(UIInterfaceOrientation)orientation;

+ (BOOL)isOrientationLandscape;

@end

@interface UIColor (Hex)

// 默认alpha位1
+ (UIColor *)colorWithHexString:(NSString *)color;

//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

@end


@interface UIView (VideoFrame)
@property CGFloat NEP_x;
@property CGFloat NEP_y;
@property CGFloat NEP_width;
@property CGFloat NEP_height;
@property CGFloat NEP_centerY;
@property CGFloat NEP_centerX;


+(instancetype)NEP_viewFromXib;

- (BOOL)isShowingOnKeyWindow;
@end
