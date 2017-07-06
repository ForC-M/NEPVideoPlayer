//
//  NEPVideoLiveView+Event.h
//  NETPlayerView
//
//  Created by heqiao on 2017/6/23.
//  Copyright © 2017年 heqiao. All rights reserved.
//

#import "NEPVideoLiveView.h"

@interface NEPVideoLiveView (Event)

- (void)tempFullAction:(UIButton *)sender;

- (void)lockBtnAction:(UIButton *)sender;

- (void)NEPVideoTopExitClick;

- (void)NEPVideoBottomStartClick;

- (void)NEPVideoBottomPauseClick;

- (void)NEPVideoBottomFullClick;


@end
