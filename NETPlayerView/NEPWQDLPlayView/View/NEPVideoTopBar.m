//
//  NEPVideoTopBar.m
//  NETPlayerView
//
//  Created by heqiao on 2017/6/22.
//  Copyright © 2017年 heqiao. All rights reserved.
//

#define MAS_SHORTHAND
//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS
#import "Masonry.h"
#import "NEPVideoTopBar.h"
#import "NEPVideoTool.h"

@implementation NEPVideoTopBar

- (instancetype)initWithFrame:(CGRect)frame titleName:(NSString *)titleName isFavtor:(BOOL)isFvator isShow:(BOOL)isShow
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUPUITitleName:titleName isFavtor:isFvator isShow:isShow];
    }
    return self;
}
- (void)setUPUITitleName:(NSString *)titleName isFavtor:(BOOL)isFvator isShow:(BOOL)isShow
{
    CGFloat viewHeight = 64;
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    exitBtn.frame = CGRectMake(16, 0, 27, 30);
    exitBtn.NEP_centerY = (viewHeight-20)/2+20;
    [exitBtn setImage:NEPImage(NEPVideoPlayerImage(@"short-icon-back")) forState:UIControlStateNormal];
    [exitBtn addTarget:self action:@selector(exitBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:exitBtn];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(exitBtn.frame)+20, 0, 400, 18)];
    label.NEP_centerY = (viewHeight-20)/2+20;
    label.text = titleName;
    label.textColor = [UIColor colorWithHexString:@"FFFFFF"];
    label.textAlignment = NSTextAlignmentLeft;
    [self addSubview:label];
    
    UIButton *favtorsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [favtorsBtn setImage:[UIImage imageNamed:NEPVideoPlayerImage(@"short-icon-collection")] forState:UIControlStateNormal];
    [favtorsBtn setImage:[UIImage imageNamed:NEPVideoPlayerImage(@"short-icon-collection_sel")] forState:UIControlStateSelected];
    [favtorsBtn addTarget:self action:@selector(favtorsAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:favtorsBtn];
    
    [favtorsBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label.centerY);
        make.trailing.equalTo(self.trailing).offset(-15);
        make.size.equalTo(CGSizeMake(20, 20));
    }];
    
    
    if (!isShow) {
        favtorsBtn.hidden = YES;
    }
}

- (void)favtorsAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(NEPVideoTopFavtorsClick:)]) {
        [self.delegate NEPVideoTopFavtorsClick:sender.selected];
    }
}
- (void)exitBtn
{
    if ([self.delegate respondsToSelector:@selector(NEPVideoTopExitClick)]) {
        [self.delegate NEPVideoTopExitClick];
    }
}



@end
