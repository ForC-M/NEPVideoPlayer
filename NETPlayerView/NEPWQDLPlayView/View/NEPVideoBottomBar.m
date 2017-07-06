//
//  NEPVideoBottomBar.m
//  NETPlayerView
//
//  Created by heqiao on 2017/6/22.
//  Copyright © 2017年 heqiao. All rights reserved.
//

#define MAS_SHORTHAND
//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS
#import "Masonry.h"
#import "NEPVideoBottomBar.h"
#import "NEPVideoTool.h"




#pragma mark *****************短课*************************

@implementation NEPVideoShortBottomBar

- (instancetype)initWithFrame:(CGRect)frame slider:(BOOL)isSlider
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUPUISlider:isSlider];
    }
    return self;
}
- (void)setUPUISlider:(BOOL)isSlider
{
    CGFloat ViewHeight = 40;
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((50*NEPSCALEW-ViewHeight)/2, 0, ViewHeight, ViewHeight);
    [button setImage:NEPImage(NEPVideoPlayerImage(@"net_player_stop")) forState:UIControlStateNormal];
    [button setImage:NEPImage(NEPVideoPlayerImage(@"net_player_play")) forState:UIControlStateSelected];
    [button addTarget:self action:@selector(startAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    _startBtn = button;
    
    UISlider *sliderView = [[UISlider alloc] initWithFrame:CGRectMake(CGRectGetMaxX(button.frame)+(50*NEPSCALEW-ViewHeight)/2, 0, 190*NEPSCALEW, 3)];
    sliderView.maximumValue = 1;
    sliderView.minimumValue = 0;
    sliderView.minimumTrackTintColor = NEPGloabColor;
    sliderView.maximumTrackTintColor = [UIColor colorWithHexString:@"FFFFFF"];
    sliderView.value = 0;
    sliderView.NEP_centerY = ViewHeight/2;
    sliderView.userInteractionEnabled = isSlider;
    [sliderView setThumbImage:NEPImage(NEPVideoPlayerImage(@"net_player_trubm")) forState:UIControlStateNormal];
    [sliderView addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:sliderView];
    self.sliderView = sliderView;
    
    UILabel *TimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(sliderView.frame), 0, 78*NEPSCALEW, 10)];
    TimeLabel.text = @"00:00/00:00";
    TimeLabel.textColor = [UIColor colorWithHexString:@"FFFFFF"];
    TimeLabel.textAlignment = NSTextAlignmentRight;
    TimeLabel.font = [UIFont systemFontOfSize:10];
    TimeLabel.NEP_centerY = ViewHeight/2;
    [self addSubview:TimeLabel];
    self.TimeLabel = TimeLabel;
    
    UIButton *fullBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fullBtn.frame = CGRectMake(CGRectGetMaxX(TimeLabel.frame) + 15 * NEPSCALEW, 0, 30*NEPSCALEW, 30*NEPSCALEW);
    fullBtn.NEP_centerY = ViewHeight/2;
    [fullBtn addTarget:self action:@selector(fullAction) forControlEvents:UIControlEventTouchUpInside];
    [fullBtn setImage:NEPImage(NEPVideoPlayerImage(@"full_screen")) forState:UIControlStateNormal];
    [fullBtn setImage:NEPImage(NEPVideoPlayerImage(@"small_screen")) forState:UIControlStateSelected];
    [self addSubview:fullBtn];
    self.fullBtn = fullBtn;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.startBtn makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.top.equalTo(self);
        make.leading.equalTo(self);
        make.width.equalTo(@(40));
    }];
    [self.fullBtn makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-5);
        make.width.equalTo(30);
        make.height.equalTo(30);
        make.centerY.equalTo(self.startBtn);
    }];
    [self.TimeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.fullBtn.leading).offset(-5);
        make.width.equalTo(@(80*NEPSCALEW));
        make.height.equalTo(@(10));
        make.top.equalTo(@(17.5));
    }];
    [self.sliderView makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.TimeLabel.leading).offset(-5);
        make.leading.equalTo(self.startBtn.trailing).offset(5);
        make.height.equalTo(@(3));
        make.top.equalTo(@(21));
    }];
    
}

- (void)startAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        if ([self.delegate respondsToSelector:@selector(NEPVideoBottomPauseClick)]) {
            [self.delegate NEPVideoBottomPauseClick];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(NEPVideoBottomStartClick)]) {
            [self.delegate NEPVideoBottomStartClick];
        }
    }
}
- (void)fullAction
{
    if ([self.delegate respondsToSelector:@selector(NEPVideoBottomFullClick)]) {
        [self.delegate NEPVideoBottomFullClick];
    }
}
- (void)sliderAction:(UISlider *)sender
{
    if ([self.delegate respondsToSelector:@selector(NEPVideoBottomSliderClick:)]) {
        [self.delegate NEPVideoBottomSliderClick:sender.value];
    }
}
@end




#pragma mark ****************直播*********************

@implementation NEPVideoLiveBottomBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUPUI];
    }
    return self;
}
- (void)setUPUI
{
    CGFloat ViewHeight = 41;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((50-ViewHeight)/2, 0, ViewHeight, ViewHeight);
    [button setImage:NEPImage(NEPVideoPlayerImage(@"net_player_stop")) forState:UIControlStateNormal];
    [button setImage:NEPImage(NEPVideoPlayerImage(@"net_player_play")) forState:UIControlStateSelected];
    [button addTarget:self action:@selector(startAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    _startBtn = button;
    
    UIButton *fullBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fullBtn.frame = CGRectMake(self.NEP_width - 40, 0, 30, 30);
    fullBtn.NEP_centerY = ViewHeight/2;
    [fullBtn addTarget:self action:@selector(fullAction) forControlEvents:UIControlEventTouchUpInside];
    [fullBtn setImage:NEPImage(NEPVideoPlayerImage(@"full_screen")) forState:UIControlStateNormal];
    [fullBtn setImage:NEPImage(NEPVideoPlayerImage(@"small_screen")) forState:UIControlStateSelected];
    [self addSubview:fullBtn];
    _fullBtn = fullBtn;
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_fullBtn makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-5);
        make.width.equalTo(30);
        make.height.equalTo(30);
        make.centerY.equalTo(self.startBtn);
    }];
}

- (void)startAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        if ([self.delegate respondsToSelector:@selector(NEPVideoBottomPauseClick)]) {
            [self.delegate NEPVideoBottomPauseClick];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(NEPVideoBottomPauseClick)]) {
            [self.delegate NEPVideoBottomStartClick];
        }
    }
}
- (void)fullAction
{
    if ([self.delegate respondsToSelector:@selector(NEPVideoBottomFullClick)]) {
        [self.delegate NEPVideoBottomFullClick];
    }
}

@end

