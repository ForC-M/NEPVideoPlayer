//
//  NEPVideoLiveView.h
//  NETPlayerView
//
//  Created by heqiao on 2017/6/23.
//  Copyright © 2017年 heqiao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <NELivePlayer/NELivePlayer.h>
#import <NELivePlayer/NELivePlayerController.h>
#import "NEPVideoTool.h"
#import "NEPVideoProtocol.h"

@class NEPVideoTopBar;
@class NEPVideoLiveBottomBar;

@interface NEPVideoLiveView : UIView

@property (nonatomic, strong)NELivePlayerController *liveplayer;

@property (nonatomic, weak) NEPVideoTopBar *topView;

@property (nonatomic, weak) NEPVideoLiveBottomBar *bottomBar;

@property (nonatomic, weak) UIActivityIndicatorView *bufferingIndicate;

@property (nonatomic, weak) UILabel *bufferingReminder;

@property (nonatomic, strong) UIButton *tempFullBtn;

@property (nonatomic, assign) NSInteger curTime;

@property (nonatomic, assign)NEPVideoPlayerScreenState ScreenState;

@property (nonatomic, strong)NSTimer *agaTimer; // 重试定时器

@property (nonatomic, weak) id<NEPVideoLiveDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame playerUrl:(NSString *)playUrl titleName:(NSString *)titleName;

- (void)asynUIAction;

- (void)resetTimer;

- (void)destroyPlayer;

- (void)startPlayer;

- (void)agaTimeAction;

- (void)pausePlayer;

- (void)setVideoScreenFull;

- (void)setVideoScreenSmall;

@end
