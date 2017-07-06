//
//  NEPVideoLiveView.m
//  NETPlayerView
//
//  Created by heqiao on 2017/6/23.
//  Copyright © 2017年 heqiao. All rights reserved.
//

#define MAS_SHORTHAND
//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS
#import "Masonry.h"
#import "NEPVideoLiveView.h"
#import "NEPVideoLiveView+Event.h"
#import "NEPVideoLiveView+Observer.h"
#import "NEPVideoTopBar.h"
#import "NEPVideoBottomBar.h"
#import "NEPVideoProtocol.h"
#import "NEPVideoProgreeTip.h"
#import "NEPVideoBrightnessView.h"
#import <MediaPlayer/MediaPlayer.h>

@interface NEPVideoLiveView ()<NEPVideoTopDelegate, NEPVideoBottomDelegate>

@property (nonatomic, weak) NEPVideoBrightnessView *brightnessView;

@property (nonatomic, weak) UIView *playerView;

@property (nonatomic, strong) UIButton *lockFullBtn;

@property (nonatomic, weak) UISlider *volumeSlider;

@property (nonatomic, strong) MPVolumeView *volumeView;

@end

@implementation NEPVideoLiveView

- (instancetype)initWithFrame:(CGRect)frame playerUrl:(NSString *)playUrl titleName:(NSString *)titleName
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpPlayerViewUrl:playUrl];
        
        [self setUPPlayerUI];
        
        [self setUPTopViewtitleName:titleName];
        
        [self setUPbottomView];
        
        [self creatNSNotifion];
    }
    return self;
}

- (void)setUpPlayerViewUrl:(NSString *)url
{
    
    self.liveplayer = [[NELivePlayerController alloc]
                       initWithContentURL:[NSURL URLWithString:url]];//初始化.
    
    if (self.liveplayer == nil) {
        NSLog(@"failed to initialize!");
    }
    
    self.liveplayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.liveplayer.view.frame = CGRectMake(0, 0, NEP_ScreenWidth, self.NEP_height);
    
    [self addSubview:self.liveplayer.view];
    
    //设置播放缓冲策略，直播采用低延时模式，点播采用抗抖动模式，具体可参见API文档
    
    [self.liveplayer setBufferStrategy:NELPAntiJitter];
    
    
    //设置画面显示模式，默认按原始大小进行播放，具体可参见API文档
    
    [self.liveplayer setScalingMode:NELPMovieScalingModeAspectFit];
    //初始化视频文件
    [self.liveplayer prepareToPlay];
    
    [self.liveplayer isLogToFile:YES];
    
    [self.liveplayer.view makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top);
        make.leading.equalTo(self.leading);
        make.trailing.equalTo(self.trailing);
        make.bottom.equalTo(self.bottom);
    }];
    
    self.agaTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(agaTimeAction) userInfo:nil repeats:NO];
}

- (void)setUPPlayerUI
{
    self.backgroundColor = [UIColor blackColor];
    
    UIActivityIndicatorView *bufferingIndicate = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [bufferingIndicate setCenter:CGPointMake(NEP_ScreenWidth/2, self.NEP_height/2)];
    [bufferingIndicate setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [self addSubview:bufferingIndicate];
    [bufferingIndicate startAnimating];
    self.bufferingIndicate = bufferingIndicate;
    
    UILabel *bufferingReminder = [[UILabel alloc] init];
    bufferingReminder.text = @"视频正在加载，请稍后...";
    bufferingReminder.font = NEPFont(14);
    bufferingReminder.textAlignment = NSTextAlignmentCenter; //文字居中
    bufferingReminder.textColor = [UIColor colorWithHexString:@"646464"];
    [self addSubview:bufferingReminder];
    self.bufferingReminder = bufferingReminder;
    
    UIView *panView = [[UIView alloc] init];
    panView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    [self addSubview:panView];
    [panView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottom);
        make.leading.equalTo(self.leading);
        make.trailing.equalTo(self.trailing);
        make.top.equalTo(self.top);
    }];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [panView addGestureRecognizer:pan];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    tap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:tap];
    
    [NEPVideoBrightnessView sharedBrightnessView];
    
    [self addSubview:self.tempFullBtn];
}
- (void)setUPTopViewtitleName:(NSString *)titleName
{
    NEPVideoTopBar *topView = [[NEPVideoTopBar alloc] initWithFrame:CGRectMake(0, 0, 0, 0) titleName:titleName isFavtor:NO isShow:NO];
    topView.delegate = self;
    [self addSubview:topView];
    _topView = topView;
    [_topView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top);
        make.leading.equalTo(self.leading);
        make.trailing.equalTo(self.trailing);
        make.height.equalTo(64);
    }];
    _topView.alpha = 0;
}
- (void)setUPbottomView
{
    NEPVideoLiveBottomBar *bottomBar = [[NEPVideoLiveBottomBar alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    bottomBar.delegate = self;
    [self addSubview:bottomBar];
    _bottomBar = bottomBar;
    [_bottomBar makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottom).offset(0);
        make.leading.equalTo(self.leading);
        make.trailing.equalTo(self.trailing);
        make.height.equalTo(45);
    }];
}


// 中部stop按钮
- (UIButton *)tempFullBtn
{
    if (_tempFullBtn == nil) {
        _tempFullBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _tempFullBtn.frame = CGRectMake(0, 0, 90, 90);
        [_tempFullBtn setImage:[UIImage imageNamed:@"home_icon_play"] forState:UIControlStateNormal];
        _tempFullBtn.center = CGPointMake(self.NEP_width/2, self.NEP_height/2);
        [_tempFullBtn addTarget:self action:@selector(tempFullAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tempFullBtn;
}
- (UIButton *)lockFullBtn
{
    if (_lockFullBtn == nil) {
        _lockFullBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _lockFullBtn.frame = CGRectMake(14.5*NEPSCALEH, 0, 50*NEPSCALEH, 50*NEPSCALEH);
        [_lockFullBtn setImage:[UIImage imageNamed:@"home_live_full_unlock"] forState:UIControlStateNormal];
        [_lockFullBtn setImage:[UIImage imageNamed:@"home_live_full_lock"] forState:UIControlStateSelected];
        _lockFullBtn.NEP_centerY = self.NEP_height/2;
        [_lockFullBtn addTarget:self action:@selector(lockBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lockFullBtn;
}
- (MPVolumeView *)volumeView {
    
    if (!_volumeView) {
        _volumeView = [[MPVolumeView alloc] init];
        _volumeView.showsRouteButton = NO;
        _volumeView.showsVolumeSlider = NO;
        for (UIView *view in _volumeView.subviews) {
            if ([NSStringFromClass(view.class) isEqualToString:@"MPVolumeSlider"]) {
                _volumeSlider = (UISlider *)view;
                break;
            }
        }
    }
    return _volumeView;
}


- (void)setVideoScreenFull
{
    [self resetTimer];
    self.bottomBar.fullBtn.selected = YES;
    if (_lockFullBtn.selected) {
        _topView.alpha = 0;
        _bottomBar.alpha = 0;
    } else {
        _topView.alpha = 1;
        _bottomBar.alpha = 1;
    }
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:[NEPVideoBrightnessView sharedBrightnessView]];
}
- (void)setVideoScreenSmall
{
    [self resetTimer];
    _topView.alpha = 0;
    _bottomBar.alpha = 1;
    _lockFullBtn.alpha = 0;
    self.bottomBar.fullBtn.selected = NO;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_tempFullBtn makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.height.equalTo(@(90));
        make.width.equalTo(@(90));
    }];
    [_bufferingIndicate makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.height.equalTo(@(30));
        make.width.equalTo(@(100));
    }];
    [_bufferingReminder makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(30);
        make.height.equalTo(@(30));
        make.width.equalTo(@(100));
    }];
    [_topView makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.trailing.equalTo(self);
        make.top.equalTo(self);
        make.height.equalTo(64);
    }];
    [_lockFullBtn makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(20);
        make.centerY.equalTo(self);
        make.height.equalTo(@(50 * NEPSCALEH));
        make.width.equalTo(@(50 * NEPSCALEH));
    }];
}



- (void)agaTimeAction
{
    if ([self.delegate respondsToSelector:@selector(changePlayerViewToAgainView)]) {
        [self.delegate changePlayerViewToAgainView];
    }
}

- (void)destroyPlayer
{
    [self.liveplayer shutdown];
    [self.liveplayer.view removeFromSuperview];
    self.liveplayer = nil;
    [self.agaTimer invalidate];
    self.agaTimer = nil;
}
- (void)pausePlayer
{
    [self.liveplayer pause];
    self.bottomBar.startBtn.selected = YES;
    _tempFullBtn.hidden = NO;
}
- (void)startPlayer
{
    [self.liveplayer play];
    self.bottomBar.startBtn.selected = NO;
    _tempFullBtn.hidden = YES;
}


- (void)resetTimer
{
    // 定时器中断
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:_lockFullBtn.selected ? @selector(videoLockDisAppear) : @selector(videoViewDisAppear) object:nil];
    [self performSelector:_lockFullBtn.selected ? @selector(videoLockDisAppear) : @selector(videoViewDisAppear) withObject:nil afterDelay:6];
}

#pragma mark private
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self resetTimer];
    if (self.lockFullBtn.selected) {
        [self videoLockAppear];
    } else {
        [self videoViewAppear];
    }
}

// 定时器重置相关
- (void)videoLockAppear
{
    [UIView animateWithDuration:.5 animations:^{
        self.lockFullBtn.alpha = 1;
    }];
}
- (void)videoLockDisAppear
{
    [UIView animateWithDuration:.5 animations:^{
        self.lockFullBtn.alpha = 0;
    }];
}
- (void)videoViewAppear
{
    if (self.ScreenState == NEPVideoplayerFullScreen) {
        [UIView animateWithDuration:1 animations:^{
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            self.bottomBar.NEP_y = self.NEP_height - 45;
            self.topView.NEP_y = 0;
        }];
    } else {
        [UIView animateWithDuration:1 animations:^{
            self.bottomBar.alpha = 1;
        }];
    }
}
- (void)videoViewDisAppear
{
    if (self.ScreenState == NEPVideoplayerFullScreen) {
        [UIView animateWithDuration:1 animations:^{
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
            self.bottomBar.NEP_y = self.NEP_height;
            self.topView.NEP_y = -64;
        }];
    } else {
        [UIView animateWithDuration:1 animations:^{
            self.bottomBar.alpha = 0;
        }];
    }
}


@end
