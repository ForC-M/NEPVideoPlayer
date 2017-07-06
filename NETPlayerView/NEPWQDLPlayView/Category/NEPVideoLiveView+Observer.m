//
//  NEPVideoLiveView+Observer.m
//  NETPlayerView
//
//  Created by heqiao on 2017/6/23.
//  Copyright © 2017年 heqiao. All rights reserved.
//

#import "NEPVideoLiveView+Observer.h"

@implementation NEPVideoLiveView (Observer)

- (void)creatNSNotifion
{
    //     播放器媒体流初始化完成后触发，收到该通知表示可以开始播放
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NELivePlayerDidPreparedToPlay:) name:NELivePlayerDidPreparedToPlayNotification object:self.liveplayer];
    // 播放器加载状态发生变化时触发，如开始缓冲，缓冲结束
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NeLivePlayerloadStateChanged:) name:NELivePlayerLoadStateChangedNotification object:self.liveplayer];
    // 正常播放结束或播放过程中发生错误导致播放结束时触发的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NELivePlayerPlayBackFinished:) name:NELivePlayerPlaybackFinishedNotification object:self.liveplayer];
    // 第一帧视频图像显示时触发的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NELivePlayerFirstVideoDisplayed:) name:NELivePlayerFirstVideoDisplayedNotification object:self.liveplayer];
    // 第一帧音频播放时触发的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NELivePlayerFirstAudioDisplayed:) name:NELivePlayerFirstAudioDisplayedNotification object:self.liveplayer];
    // 资源释放成功后触发的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NELivePlayerReleaseSuccess:) name:NELivePlayerReleaseSueecssNotification object:self.liveplayer];
    // 视频码流解析失败时触发的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NELivePlayerVideoParseError:) name:NELivePlayerVideoParseErrorNotification object:self.liveplayer];
}

#pragma mark  -   通知监听播放器状态

- (void)NELivePlayerDidPreparedToPlay:(NSNotification *)notification
{
    self.bufferingIndicate.hidden = YES;
    self.bufferingReminder.hidden = YES;
    [self.bufferingIndicate stopAnimating];
    
    [self.agaTimer invalidate];
    self.agaTimer = nil;
    
    //定时器开始，slider时间开始
    [self resetTimer];
    
    
}
- (void)NeLivePlayerloadStateChanged:(NSNotification*)notification
{
    NSLOG(@"断网测试 ------------- 缓冲开始");
    NELPMovieLoadState nelpLoadState = self.liveplayer.loadState;
    
    if (nelpLoadState == NELPMovieLoadStatePlaythroughOK)
    {
        NSLOG(@"点播－－－ 加载结束");
        self.bufferingIndicate.hidden = YES;
        self.bufferingReminder.hidden = YES;
        [self.bufferingIndicate stopAnimating];
        [self.agaTimer invalidate];
        self.agaTimer = nil;
    }
    else if (nelpLoadState == NELPMovieLoadStateStalled)
    {
        NSLOG(@"开始加载");
        self.bufferingReminder.text = @"视频正在加载，请稍后...";
        self.bufferingIndicate.hidden = NO;
        self.bufferingReminder.hidden = NO;
        [self.bufferingIndicate startAnimating];
        if (self.agaTimer == nil) {
            self.agaTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(agaTimeAction) userInfo:nil repeats:NO];
        }
    }
}

// 播放完成
- (void)NELivePlayerPlayBackFinished:(NSNotification*)notification
{
    switch ([[[notification userInfo] valueForKey:NELivePlayerPlaybackDidFinishReasonUserInfoKey] intValue])
    {
        case NELPMovieFinishReasonPlaybackEnded:
        {
            NSLOG(@"播放完成");
            
            if ([self.delegate respondsToSelector:@selector(changeplayerURLWithPlayerFinish)]) {
                [self.delegate changeplayerURLWithPlayerFinish];
                
            }
            
            break;
        }
        case NELPMovieFinishReasonPlaybackError:
        {
            //  [NEPTool showErrorWithStaus:@"发生未知错误"];
            NSLOG(@"断网测试 ------------- 错误");
            
            self.bufferingIndicate.hidden = NO;
            self.bufferingReminder.hidden = NO;
            [self.bufferingIndicate startAnimating];
            self.agaTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(agaTimeAction) userInfo:nil repeats:NO];
            
        }
            
        case NELPMovieFinishReasonUserExited:
            break;
            
        default:
            break;
    }
    
}
- (void)NELivePlayerFirstVideoDisplayed:(NSNotification*)notification
{
    NSLOG(@"断网测试 ------------- 第一针视频出现");
}

- (void)NELivePlayerFirstAudioDisplayed:(NSNotification*)notification
{
    NSLOG(@"断网测试 ------------- 第一针音频出现");
}

- (void)NELivePlayerVideoParseError:(NSNotification*)notification
{
    NSLOG(@"断网测试 ------------- 错误");
}

- (void)NELivePlayerReleaseSuccess:(NSNotification*)notification
{
    NSLOG(@"资源释放成功");
    // 播放器资源释放成功，未再主线程操作
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(videoPlayerViewDestory)]) {
            [self.delegate videoPlayerViewDestory];
        }
    });
}

@end
