//
//  NEPVideoShortView+Event.h
//  NETPlayerView
//
//  Created by heqiao on 2017/6/23.
//  Copyright © 2017年 heqiao. All rights reserved.
//

#import "NEPVideoShortView.h"

@interface NEPVideoShortView (Event)

- (void)tempFullAction:(UIButton *)sender;

- (void)lockBtnAction:(UIButton *)sender;

- (void)NEPVideoTopExitClick;

- (void)NEPVideoTopFavtorsClick;

- (void)NEPVideoBottomStartClick;

- (void)NEPVideoBottomPauseClick;

- (void)NEPVideoBottomFullClick;

- (void)NEPVideoBottomSliderClick:(NSTimeInterval)SliderValue;



@end
