//
//  NEPVideoShortView+Event.m
//  NETPlayerView
//
//  Created by heqiao on 2017/6/23.
//  Copyright © 2017年 heqiao. All rights reserved.
//

#import "NEPVideoShortView+Event.h"
#import "NEPVideoBottomBar.h"
#import "NEPVideoTopBar.h"

@implementation NEPVideoShortView (Event)


- (void)tempFullAction:(UIButton *)sender
{
    [self.liveplayer play];
    self.bottomBar.startBtn.selected = NO;
    self.tempFullBtn.hidden = YES;
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

- (void)NEPVideoTopFavtorsClick:(BOOL)isCollection
{
    [self resetTimer];
    if ([self.delegate respondsToSelector:@selector(btnActionWithCollect:)]) {
        [self.delegate btnActionWithCollect:isCollection];
    }
}

- (void)NEPVideoBottomStartClick
{
    [self resetTimer];
    [self.liveplayer play];
    self.bottomBar.startBtn.selected = NO;
    self.tempFullBtn.hidden = YES;
    [self performSelector:@selector(asynUIAction) withObject:nil afterDelay:1];
}

- (void)NEPVideoBottomPauseClick
{
    [self resetTimer];
    [self.liveplayer pause];
    self.bottomBar.startBtn.selected = YES;
    self.tempFullBtn.hidden = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(asynUIAction) object:nil];
}

- (void)NEPVideoBottomFullClick
{
    [self resetTimer];
    if ([self.delegate respondsToSelector:@selector(changePlayerViewScreen)]) {
        [self.delegate changePlayerViewScreen];
    }
}

- (void)NEPVideoBottomSliderClick:(NSTimeInterval)SliderValue
{
    [self.liveplayer setCurrentPlaybackTime:SliderValue];
    [self resetTimer];
}



@end
