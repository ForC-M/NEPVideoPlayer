//
//  NEPVideoAgainView.m
//  NETPlayerView
//
//  Created by heqiao on 2017/6/23.
//  Copyright © 2017年 heqiao. All rights reserved.
//

#import "NEPVideoAgainView.h"
#import "NEPVideoTool.h"
#import "Masonry.h"

@interface NEPVideoAgainView ()
@property (nonatomic, weak) UILabel *againLabel;
@property (nonatomic, weak) UIButton *againbutton;
@end

@implementation NEPVideoAgainView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}
- (void)setUpUI
{
    self.backgroundColor = [UIColor blackColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 98*NEPSCALEH, NEP_ScreenWidth, 14*NEPSCALEH)];
    label.text = @"网络不给力，请重试";
    label.textColor = [UIColor colorWithHexString:@"646464"];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = NEPFont(13);
    [self addSubview:label];
    _againLabel = label;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, CGRectGetMaxY(label.frame)+20*NEPSCALEH, 90, 30);
    button.NEP_centerX = NEP_ScreenWidth/2;
    [button setTitle:@"    刷新" forState:UIControlStateNormal];
    button.titleLabel.font = NEPFont(13);
    [button setTitleColor:NEPGloabColor forState:UIControlStateNormal];
    [button setImage:NEPImage(NEPVideoPlayerImage(@"net_player_again")) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    button.layer.borderWidth = 1;
    button.layer.borderColor = NEPGloabColor.CGColor
    ;
    button.layer.cornerRadius = 15;
    [self addSubview:button];
    _againbutton = button;
    
}
- (void)buttonAction
{
    if ([self.delegate respondsToSelector:@selector(NEPVideoAgainClick)]) {
        [self.delegate NEPVideoAgainClick];
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [_againLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.trailing.equalTo(self);
        make.height.equalTo(@(14*NEPSCALEH));
        make.centerY.equalTo(self).offset(39);
    }];
    [_againbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(90));
        make.height.equalTo(@(30));
        make.centerY.equalTo(self);
        make.centerX.equalTo(self);
    }];
}


@end
