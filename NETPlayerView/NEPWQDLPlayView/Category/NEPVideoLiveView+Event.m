//
//  NEPVideoLiveView+Event.m
//  NETPlayerView
//
//  Created by heqiao on 2017/6/23.
//  Copyright © 2017年 heqiao. All rights reserved.
//

#import "NEPVideoLiveView+Event.h"
#import "NEPVideoBottomBar.h"
#import "NEPVideoTopBar.h"


@implementation NEPVideoLiveView (Event)
- (void)tempFullAction:(UIButton *)sender
{
    [self.liveplayer play];
    self.bottomBar.startBtn.selected = NO;
    [self.tempFullBtn removeFromSuperview];
    [self resetTimer];
}

- (void)lockBtnAction:(UIButton *)sender
{
    [self resetTimer];
    sender.selected = !sender.selected;
    if (sender.selected) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        self.bottomBar.NEP_y = self.NEP_height;
        self.topView.NEP_y = -64;
        if ([self.delegate respondsToSelector:@selector(shortViewChangeScreenStatus:)]) {
            [self.delegate shortViewChangeScreenStatus:NEPPlayerScreenRightOrLeftStatus];
        }
    } else {
        self.bottomBar.alpha = 1;
        self.topView.alpha = 1;
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        self.bottomBar.NEP_y = self.NEP_height - 45;
        self.topView.NEP_y = 0;
        if ([self.delegate respondsToSelector:@selector(shortViewChangeScreenStatus:)]) {
            [self.delegate shortViewChangeScreenStatus:NEPPlayerScreenAllStatus];
        }
    }
}

- (void)NEPVideoTopExitClick
{
    [self resetTimer];
    if ([self.delegate respondsToSelector:@selector(changePlayerViewScreen)]) {
        [self.delegate changePlayerViewScreen];
    }
}

- (void)NEPVideoBottomStartClick
{
    [self resetTimer];
    [self.liveplayer play];
    self.bottomBar.startBtn.selected = NO;
    [self.tempFullBtn removeFromSuperview];
    
}

- (void)NEPVideoBottomPauseClick
{
    [self resetTimer];
    [self.liveplayer pause];
    self.bottomBar.startBtn.selected = YES;
    self.tempFullBtn.center = CGPointMake(self.NEP_width/2, self.NEP_height/2);
    [self addSubview:self.tempFullBtn];
}

- (void)NEPVideoBottomFullClick
{
    [self resetTimer];
    if ([self.delegate respondsToSelector:@selector(changePlayerViewScreen)]) {
        [self.delegate changePlayerViewScreen];
    }
}


@end
