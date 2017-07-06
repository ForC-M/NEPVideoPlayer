//
//  NEPVideoShortView.h
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
@class NEPVideoShortBottomBar;

@interface NEPVideoShortView : UIView

@property (nonatomic, strong)NELivePlayerController *liveplayer;

@property (nonatomic, weak) NEPVideoTopBar *topView;

@property (nonatomic, weak) NEPVideoShortBottomBar *bottomBar;

@property (nonatomic, weak) UIActivityIndicatorView *bufferingIndicate;

@property (nonatomic, weak) UILabel *bufferingReminder;

@property (nonatomic, assign) NSInteger curTime;

@property (nonatomic, strong) UIButton *tempFullBtn;

@property (nonatomic, assign)NEPVideoPlayerScreenState ScreenState;

@property (nonatomic, strong)NSTimer *agaTimer; // 重试定时器

@property (nonatomic, weak) id<NEPVideoShortDelegate> delegate;


#pragma mark private
- (void)asynUIAction;

- (void)resetTimer;


#pragma mark Public
- (void)setVideoScreenFull;

- (void)setVideoScreenSmall;

- (instancetype)initWithFrame:(CGRect)frame playerUrl:(NSString *)playUrl titleName:(NSString *)titleName isFavtor:(BOOL)isFavtor isSlider:(BOOL)isSlider isFull:(BOOL)isFull;

- (void)startPlayer;

- (void)destroyPlayer;

- (void)pausePlayer;

- (void)agaTimeAction;

- (void)seekShortPlayer:(NSInteger)shortTime;
@end
