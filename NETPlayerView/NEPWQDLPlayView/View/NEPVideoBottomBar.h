//
//  NEPVideoBottomBar.h
//  NETPlayerView
//
//  Created by heqiao on 2017/6/22.
//  Copyright © 2017年 heqiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NEPVideoProtocol.h"

@interface NEPVideoLiveBottomBar : UIView

@property (nonatomic, weak) id<NEPVideoBottomDelegate> delegate;

@property (nonatomic, weak) UIButton *startBtn;

@property (nonatomic, weak) UIButton *fullBtn;

@end

@interface NEPVideoShortBottomBar : UIView

@property (nonatomic, weak) id<NEPVideoBottomDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame slider:(BOOL)isSlider;

@property (nonatomic, weak) UIButton *startBtn;

@property (nonatomic, weak) UISlider *sliderView;

@property (nonatomic, weak) UILabel *TimeLabel;

@property (nonatomic, weak) UIButton *fullBtn;

@end

