//
//  NEPVideoShortView.m
//  NETPlayerView
//
//  Created by heqiao on 2017/6/23.
//  Copyright © 2017年 heqiao. All rights reserved.
//

#define MAS_SHORTHAND
//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS
#import "Masonry.h"
#import "NEPVideoShortView.h"
#import "NEPVideoShortView+Event.h"
#import "NEPVideoShortView+Observer.h"
#import "NEPVideoTopBar.h"
#import "NEPVideoBottomBar.h"
#import "NEPVideoProtocol.h"
#import "NEPVideoProgreeTip.h"
#import "NEPVideoBrightnessView.h"
#import <MediaPlayer/MediaPlayer.h>

@interface NEPVideoShortView ()<NEPVideoTopDelegate, NEPVideoBottomDelegate>

@property (nonatomic, assign) CGPoint touchBeginPoint;

@property (nonatomic, strong) MPVolumeView *volumeView;

@property (nonatomic, weak) UISlider *volumeSlider;

@property (nonatomic, strong) NEPVideoProgreeTip *videoProgressTip;

@property (nonatomic, assign) BOOL controlHasJudged;

@property (nonatomic, assign) BOOL moved;

@property (nonatomic, assign) CGFloat touchBeginVoiceValue;

@property (nonatomic, assign) NEPPlayerScreenPanStatus controlType;

@property (nonatomic, assign) NSInteger totalTime;

@property (nonatomic, weak) NEPVideoBrightnessView *brightnessView;

@property (nonatomic, strong) UIButton *lockFullBtn;

@property (nonatomic, assign) BOOL isSlider;

@end

@implementation NEPVideoShortView

#pragma mark 页面UI
- (instancetype)initWithFrame:(CGRect)frame playerUrl:(NSString *)playUrl titleName:(NSString *)titleName isFavtor:(BOOL)isFavtor isSlider:(BOOL)isSlider isFull:(BOOL)isFull
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpPlayerViewUrl:playUrl];
        
        [self setUPPlayerUI];
        
        [self setUPTopViewtitleName:titleName isFavtor:isFavtor isSlider:isSlider isFull:isFull];
        
        [self setUPbottomViewisSlider:isSlider];
        
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
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.volumeView];
    
    [self addSubview:self.tempFullBtn];
}
- (void)setUPTopViewtitleName:(NSString *)titleName isFavtor:(BOOL)isFavtor isSlider:(BOOL)isSlider isFull:(BOOL)isFull
{
    _isSlider = isSlider;
    NEPVideoTopBar *topView = [[NEPVideoTopBar alloc] initWithFrame:CGRectMake(0, 0, NEP_ScreenHeight, 64) titleName:titleName isFavtor:isFavtor isShow:isSlider];
    topView.delegate = self;
    [self addSubview:topView];
    _topView = topView;
    topView.alpha = isFull;
    [self addSubview:self.lockFullBtn];
    _lockFullBtn.alpha = isFull;
    
    if (!_isSlider) {return;}
    [[UIApplication sharedApplication].keyWindow addSubview:self.videoProgressTip];
    [self.videoProgressTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo([UIApplication sharedApplication].keyWindow);
        make.width.equalTo(@150);
        make.height.equalTo(@90);
    }];
}
- (void)setUPbottomViewisSlider:(BOOL)isSlider
{
    NEPVideoShortBottomBar *bottomBar = [[NEPVideoShortBottomBar alloc] initWithFrame:CGRectMake(0, 0, 0, 0) slider:isSlider];
    bottomBar.delegate = self;
    [self addSubview:bottomBar];
    _bottomBar = bottomBar;
    [_bottomBar makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottom).offset(0);
        make.leading.equalTo(self.leading);
        make.trailing.equalTo(self.trailing);
        make.height.equalTo(40);
    }];
}

// 中部stop按钮
- (UIButton *)tempFullBtn
{
    if (_tempFullBtn == nil) {
        _tempFullBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _tempFullBtn.frame = CGRectMake(0, 0, 90, 90);
        [_tempFullBtn setImage:[UIImage imageNamed:NEPVideoPlayerImage(@"home_icon_play")] forState:UIControlStateNormal];
        _tempFullBtn.hidden = YES;
        _tempFullBtn.center = CGPointMake(self.NEP_width/2, self.NEP_height/2);
        [_tempFullBtn addTarget:self action:@selector(tempFullAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tempFullBtn;
}
- (UIButton *)lockFullBtn
{
    if (_lockFullBtn == nil) {
        _lockFullBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lockFullBtn setImage:[UIImage imageNamed:NEPVideoPlayerImage(@"home_live_full_unlock")] forState:UIControlStateNormal];
        [_lockFullBtn setImage:[UIImage imageNamed:NEPVideoPlayerImage(@"home_live_full_lock")] forState:UIControlStateSelected];
        [_lockFullBtn addTarget:self action:@selector(lockBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _lockFullBtn.alpha = 0;
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

- (NEPVideoProgreeTip *)videoProgressTip {
    
    if (!_videoProgressTip) {
        _videoProgressTip = [[NEPVideoProgreeTip alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _videoProgressTip.hidden = YES;
        _videoProgressTip.layer.cornerRadius = 10.0;
    }
    return _videoProgressTip;
}


#pragma mark 播放器操作
- (void)destroyPlayer
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(asynUIAction) object:nil];
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

#pragma mark 修改时间
- (void)asynUIAction
{
    
    NSTimeInterval mDuration = [self.liveplayer duration];
    NSInteger duration = floor(mDuration);
    
    NSTimeInterval mCurrPos  = [self.liveplayer currentPlaybackTime];
    NSInteger currPos  = floor(mCurrPos);
    
    // 上传时间    
    if (currPos % 30 == 0) {
        if ([self.delegate respondsToSelector:@selector(updataTime:)]) {
            [self.delegate updataTime:currPos];
        }
    }
    _curTime = floor(mCurrPos);
    _totalTime = floor(mDuration);
    
    if (duration > 0) {
        self.bottomBar.TimeLabel.text = [NSString stringWithFormat:@"%02d:%02d/%02d:%02d", (int)(currPos > 3600 ? (currPos - (currPos / 3600)*3600) / 60 : currPos/60), (int)(currPos % 60), (int)(duration > 3600 ? (duration - 3600 * (duration / 3600)) / 60 : duration/60), (int)(duration > 3600 ? ((duration - 3600 * (duration / 3600)) % 60) :(duration % 60))];
        self.bottomBar.sliderView.value = mCurrPos;
        self.bottomBar.sliderView.maximumValue = mDuration;
    } else {
        [self.bottomBar.sliderView setValue:0.0f];
    }
    //延时调用
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(asynUIAction) object:nil];
    [self performSelector:@selector(asynUIAction) withObject:nil afterDelay:1];
}

#pragma mark 横竖屏切换
- (void)setVideoScreenFull
{
    [self resetTimer];
    self.bottomBar.fullBtn.selected = YES;
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self.videoProgressTip];
    if (_lockFullBtn.selected) {
        _topView.alpha = 0;
        _bottomBar.alpha = 0;
    } else {
        _topView.alpha = 1;
        _bottomBar.alpha = 1;
    }
    if (!_isSlider) {return;}
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:[NEPVideoBrightnessView sharedBrightnessView]];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self.volumeView];
}
- (void)setVideoScreenSmall
{
    [self resetTimer];
    _topView.alpha = 0;
    _bottomBar.alpha = 1;
    self.bottomBar.fullBtn.selected = NO;
    _lockFullBtn.alpha = 0;
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


#pragma mark 手势
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self resetTimer];
    if (_lockFullBtn.selected) {
        [self videoLockAppear];
    } else {
        [self videoViewAppear];
    }
}

- (void)tapAction
{
    self.bottomBar.startBtn.selected = !self.bottomBar.startBtn.selected;
    if (self.bottomBar.startBtn.selected) {
        [self.liveplayer pause];
        _tempFullBtn.hidden = NO;
    } else {
        [self.liveplayer play];
        _tempFullBtn.hidden = YES;
    }
}

- (void)panAction:(UIPanGestureRecognizer *)pan
{
    
    CGPoint touchPoint = [pan locationInView:pan.view];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        _touchBeginPoint = touchPoint;
        _moved = NO;
        _controlHasJudged = NO;
        _touchBeginVoiceValue = _volumeSlider.value;
    }
    
    if (pan.state == UIGestureRecognizerStateChanged) {
        if (fabs(touchPoint.x - _touchBeginPoint.x) < 10 && fabs(touchPoint.y - _touchBeginPoint.y) < 10) {
            return;
        }
        _moved = YES;
        
        if (!_controlHasJudged) {
            float tan = fabs(touchPoint.y - _touchBeginPoint.y) / fabs(touchPoint.x - _touchBeginPoint.x);
            if (tan < 1 / sqrt(3)) { // Sliding angle is less than 30 degrees.
                _controlType = NEPPlayerScreenPanProgress;
                _controlHasJudged = YES;
            } else if (tan > sqrt(3)) { // Sliding angle is greater than 60 degrees
                if (_touchBeginPoint.x < pan.view.frame.size.width / 2) { // The left side of the screen controls the brightness.
                    _controlType = NEPPlayerScreenPanLight;
                } else { // The right side of the screen controls the volume.
                    _controlType = NEPPlayerScreenPanVolum;
                }
                _controlHasJudged = YES;
            } else {
                _controlType = NEPPlayerScreenPanNone;
                return;
            }
        }
        
        if (_controlType == NEPPlayerScreenPanProgress) {
            NSTimeInterval videoCurrentTime = [self videoCurrentTimeWithTouchPoint:touchPoint];
            if (videoCurrentTime > _curTime) {
                [self.videoProgressTip setTipImageViewImage:[UIImage imageNamed:NEPVideoPlayerImage(@"progress_right")]];
            } else if(videoCurrentTime < _curTime) {
                [self.videoProgressTip setTipImageViewImage:[UIImage imageNamed:NEPVideoPlayerImage(@"progress_left")]];
            }
            self.videoProgressTip.hidden = NO;
            _curTime = [self videoCurrentTimeWithTouchPoint:touchPoint];
            
            [self.videoProgressTip setTipLabelText:[NSString stringWithFormat:@"%02d:%02d/%02d:%02d", (int)(_curTime > 3600 ? (_curTime - (_curTime / 3600)*3600) / 60 : _curTime/60), (int)(_curTime % 60), (int)(_totalTime > 3600 ? (_totalTime - 3600 * (_totalTime / 3600)) / 60 : _totalTime/60), (int)(_totalTime > 3600 ? ((_totalTime - 3600 * (_totalTime / 3600)) % 60) :(_totalTime % 60))]];
            
        } else if (_controlType == NEPPlayerScreenPanVolum) {
            float voiceValue = _touchBeginVoiceValue - ((touchPoint.y - _touchBeginPoint.y) / CGRectGetHeight(pan.view.frame));
            if (voiceValue < 0) {
                self.volumeSlider.value = 0;
            } else if (voiceValue > 1) {
                self.volumeSlider.value = 1;
            } else {
                self.volumeSlider.value = voiceValue;
            }
            
        } else if (_controlType == NEPPlayerScreenPanLight) {
            [UIScreen mainScreen].brightness -= ((touchPoint.y - _touchBeginPoint.y) / 5000);
            
        } else if (_controlType == NEPPlayerScreenPanNone) {
            
        }
    }
    
    if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled) {
        _controlHasJudged = NO;
        if (_moved && _controlType == NEPPlayerScreenPanProgress) {
            self.videoProgressTip.hidden = YES;
            [self seekShortPlayer:[self videoCurrentTimeWithTouchPoint:touchPoint]];
        }
    }
}

- (NSTimeInterval)videoCurrentTimeWithTouchPoint:(CGPoint)touchPoint {
    
    float videoCurrentTime = _curTime + 20 * ((touchPoint.x - _touchBeginPoint.x) / [UIScreen mainScreen].bounds.size.width);
    
    if (videoCurrentTime > _totalTime) {
        videoCurrentTime = _totalTime;
    }
    if (videoCurrentTime < 0) {
        videoCurrentTime = 0;
    }
    return videoCurrentTime;
}

#pragma mark Private
- (void)seekShortPlayer:(NSInteger)shortTime
{
    if (!_isSlider) {return;}
    [self.liveplayer setCurrentPlaybackTime:shortTime];
}


#pragma mark 定时器重置相关
- (void)agaTimeAction
{
    if ([self.delegate respondsToSelector:@selector(changePlayerViewToAgainView)]) {
        [self.delegate changePlayerViewToAgainView];
    }
}
- (void)resetTimer
{
    // 定时器中断
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:_lockFullBtn.selected ? @selector(videoLockDisAppear) : @selector(videoViewDisAppear) object:nil];
    [self performSelector:_lockFullBtn.selected ? @selector(videoLockDisAppear) : @selector(videoViewDisAppear) withObject:nil afterDelay:6];
}
- (void)videoLockAppear
{
    [UIView animateWithDuration:.5 animations:^{
        _lockFullBtn.alpha = 1;
    }];
}
- (void)videoLockDisAppear
{
    [UIView animateWithDuration:.5 animations:^{
        _lockFullBtn.alpha = 0;
    }];
}
- (void)videoViewAppear
{
    if (self.ScreenState == NEPVideoplayerFullScreen) {
        [UIView animateWithDuration:1 animations:^{
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            self.bottomBar.NEP_y = self.NEP_height - 40;
            self.topView.NEP_y = 0;
            _lockFullBtn.alpha = 1;
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
            _lockFullBtn.alpha = 0;
        }];
    } else {
        [UIView animateWithDuration:1 animations:^{
            self.bottomBar.alpha = 0;
        }];
    }
}



@end
