//
//  NEPVideoPlayerViewController.m
//  NETPlayerView
//
//  Created by heqiao on 2017/6/29.
//  Copyright © 2017年 heqiao. All rights reserved.
//

#import "NEPVideoPlayerViewController.h"
#import "NEPVideoShortView.h"
#import "NEPVideoAgainView.h"
#import "NEPVideoLiveView.h"
#import "AppDelegate.h"
#import "NEPVideoPlayerModel.h"
#import "Masonry.h"

@interface NEPVideoPlayerViewController ()<NEPVideoShortDelegate, NEPVideoAgainDelegate, NEPVideoLiveDelegate>

@property (nonatomic, weak) NEPVideoShortView *shortView;

@property (nonatomic, weak) NEPVideoLiveView *liveView;

@property (nonatomic, strong) NEPVideoPlayerModel *playerModel;

@property (nonatomic, strong) NEPVideoAgainView *ageinView;

@property (nonatomic, assign) BOOL isFull;

@end

@implementation NEPVideoPlayerViewController

- (void)initWithPlayerViewType:(NEPPlayerStatus)type playerUrl:(NSString *)playUrl titleName:(NSString *)titleName isFavtor:(BOOL)isFavtor isSlider:(BOOL)isSlider playerFrame:(CGRect)playerFrame
{
    self.playerModel = [NEPVideoPlayerModel new];
    self.playerModel.type = type;
    self.playerModel.playerFrame = playerFrame;
    self.playerModel.isSlider = isSlider;
    self.playerModel.playUrl = playUrl;
    self.playerModel.titleName = titleName;
    
    [self NEPVideoAgainClick];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self videoViewChangeScreenStatus:NEPPlayerScreenAllStatus];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self videoViewChangeScreenStatus:NEPPlayerScreenVerticalStatus];
}

#pragma mark ***********重试*************
- (void)NEPVideoAgainClick
{
    [self.ageinView removeFromSuperview];
    if (self.playerModel.type == NEPPlayerShortPlayer) {
        NEPVideoShortView *shortView = [[NEPVideoShortView alloc] initWithFrame:self.playerModel.playerFrame playerUrl:self.playerModel.playUrl titleName:self.playerModel.titleName isFavtor:self.playerModel.isFavtor isSlider:self.playerModel.isSlider isFull:_isFull];
        shortView.delegate = self;
        self.shortView = shortView;
        
        if (_isFull) {
            [[UIApplication sharedApplication].keyWindow addSubview:shortView];
            shortView.ScreenState = NEPVideoplayerFullScreen;
            [self.shortView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo([UIApplication sharedApplication].keyWindow);
                make.top.equalTo([UIApplication sharedApplication].keyWindow);
                make.trailing.equalTo([UIApplication sharedApplication].keyWindow);
                make.leading.equalTo([UIApplication sharedApplication].keyWindow);
            }];
        } else {
            [self.view addSubview:shortView];
            [self.shortView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(self.playerModel.playerFrame.size.height));
                make.top.equalTo(self.view);
                make.trailing.equalTo(self.view);
                make.leading.equalTo(self.view);
            }];
        }
        
    } else {
        NEPVideoLiveView *liveView = [[NEPVideoLiveView alloc] initWithFrame:self.playerModel.playerFrame playerUrl:self.playerModel.playUrl titleName:self.playerModel.titleName];
        liveView.delegate = self;
        self.liveView = liveView;
        if (_isFull) {
            [[UIApplication sharedApplication].keyWindow addSubview:liveView];
            liveView.ScreenState = NEPVideoplayerFullScreen;
            [self.liveView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo([UIApplication sharedApplication].keyWindow);
                make.top.equalTo([UIApplication sharedApplication].keyWindow);
                make.trailing.equalTo([UIApplication sharedApplication].keyWindow);
                make.leading.equalTo([UIApplication sharedApplication].keyWindow);
            }];
        } else {
            [self.view addSubview:liveView];
            [self.liveView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(self.playerModel.playerFrame.size.height));
                make.top.equalTo(self.view);
                make.trailing.equalTo(self.view);
                make.leading.equalTo(self.view);
            }];
        }
    }
}

- (NEPVideoAgainView *)ageinView
{
    if (_ageinView == nil) {
        _ageinView = [[NEPVideoAgainView alloc] initWithFrame:self.playerModel.playerFrame];
        _ageinView.delegate = self;
    }
    return _ageinView;
}


#pragma mark 横竖屏
// ios8以上
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        if ([NEPVideoRotatoControl isOrientationLandscape]) {
            [self prepareFullScreen];
        } else {
            [self prepareSmallScreen];
        }
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
    }];
}
// iOS7
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    if (toInterfaceOrientation == UIDeviceOrientationLandscapeRight || toInterfaceOrientation == UIDeviceOrientationLandscapeLeft) {
        [self prepareFullScreen];
    } else {
        [self prepareSmallScreen];
    }
}

- (void)prepareFullScreen
{
    _isFull = YES;
    if (self.shortView) {
        self.shortView.ScreenState = NEPVideoplayerFullScreen;
        [[UIApplication sharedApplication].keyWindow addSubview:self.shortView];
        [self.shortView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo([UIApplication sharedApplication].keyWindow);
            make.top.equalTo([UIApplication sharedApplication].keyWindow);
            make.trailing.equalTo([UIApplication sharedApplication].keyWindow);
            make.leading.equalTo([UIApplication sharedApplication].keyWindow);
        }];
        [self.shortView setVideoScreenFull];
    } else if (self.liveView) {
        self.liveView.ScreenState = NEPVideoplayerFullScreen;
        [[UIApplication sharedApplication].keyWindow addSubview:self.liveView];
        [self.liveView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo([UIApplication sharedApplication].keyWindow);
            make.top.equalTo([UIApplication sharedApplication].keyWindow);
            make.trailing.equalTo([UIApplication sharedApplication].keyWindow);
            make.leading.equalTo([UIApplication sharedApplication].keyWindow);
        }];
        [self.liveView setVideoScreenFull];
    } else {
        [[UIApplication sharedApplication].keyWindow addSubview:self.ageinView];
        [self.ageinView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo([UIApplication sharedApplication].keyWindow);
            make.top.equalTo([UIApplication sharedApplication].keyWindow);
            make.trailing.equalTo([UIApplication sharedApplication].keyWindow);
            make.leading.equalTo([UIApplication sharedApplication].keyWindow);
        }];
    }
}
- (void)prepareSmallScreen
{
    _isFull = NO;
    if (self.shortView) {
        self.shortView.ScreenState = NEPVideoplayerSmallScreen;
        [self.view addSubview:self.shortView];
        [self.shortView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(self.playerModel.playerFrame.size.height));
            make.top.equalTo(self.view);
            make.trailing.equalTo(self.view);
            make.leading.equalTo(self.view);
        }];
        [self.shortView setVideoScreenSmall];
    } else if (self.liveView) {
        self.liveView.ScreenState = NEPVideoplayerSmallScreen;
        [self.view addSubview:self.liveView];
        [self.liveView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(self.playerModel.playerFrame.size.height));
            make.top.equalTo(self.view);
            make.trailing.equalTo(self.view);
            make.leading.equalTo(self.view);
        }];
        [self.liveView setVideoScreenSmall];
    } else {
        [self.view addSubview:self.ageinView];
        [self.ageinView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(self.playerModel.playerFrame.size.height));
            make.top.equalTo(self.view);
            make.trailing.equalTo(self.view);
            make.leading.equalTo(self.view);
        }];
    }
}
- (void)videoViewChangeScreenStatus:(NEPPlayerScreenStatus)status
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.screenStatus = status;
}

#pragma mark **************短课or直播代理*******************
- (void)changePlayerViewScreen
{
    // 顺序颠倒无法更换
    if (self.shortView.ScreenState || self.liveView.ScreenState) {
        [NEPVideoRotatoControl forceOrientation:UIInterfaceOrientationPortrait];
        [self prepareSmallScreen];
    } else {
        [NEPVideoRotatoControl forceOrientation:UIInterfaceOrientationLandscapeRight];
        [self prepareFullScreen];
    }
}

- (void)btnActionWithCollect:(BOOL)isCollection
{
    if (isCollection) {//收藏接口
        if ([self.delegate respondsToSelector:@selector(getCollection)]) {
            [self.delegate getCollection];
        }
    } else { // 取消接口
        if ([self.delegate respondsToSelector:@selector(cancelCollection)]) {
            [self.delegate cancelCollection];
        }
    }
}

#pragma mark 废弃
- (void)videoPlayerViewDestory
{
    //V1.2.6废弃
}

#pragma mark 时间相关（企U有效）
- (void)updataTime:(NSInteger)upTime
{
    if ([self.delegate respondsToSelector:@selector(updataTime:)]) {
        [self.delegate updataTime:upTime];
    }
}
- (void)seekCurrentPlayer//正常播放完成
{
    if ([self.delegate respondsToSelector:@selector(seekCurrentPlayer)]) {
        [self.delegate seekCurrentPlayer];
    }
}
- (void)seekVideoPlayerWithTime:(NSInteger)shortTime
{
    [self.shortView seekShortPlayer:shortTime];
}
- (void)setShortTime:(NSInteger)shortTime//播放一部分卡顿
{
    [self updataTime:shortTime];
}
- (NSInteger)currentTime
{
    return self.shortView.curTime;
}


#pragma mark 屏幕相关
- (void)shortViewChangeScreenStatus:(NEPPlayerScreenStatus)status //锁屏
{
    [self videoViewChangeScreenStatus:status];
}

- (void)changePlayerViewToAgainView //重试
{
    if (self.shortView) {
        [self.shortView destroyPlayer];
        [self.shortView removeFromSuperview];
        self.shortView = nil;
        
        if (_isFull) {
            [[UIApplication sharedApplication].keyWindow addSubview:self.ageinView];
            [self.ageinView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo([UIApplication sharedApplication].keyWindow);
                make.top.equalTo([UIApplication sharedApplication].keyWindow);
                make.trailing.equalTo([UIApplication sharedApplication].keyWindow);
                make.leading.equalTo([UIApplication sharedApplication].keyWindow);
            }];
        } else {
            [self.view addSubview:self.ageinView];
            [self.ageinView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(self.playerModel.playerFrame.size.height));
                make.top.equalTo(self.view);
                make.trailing.equalTo(self.view);
                make.leading.equalTo(self.view);
            }];
        }
    } else {
        [self.liveView destroyPlayer];
        [self.liveView removeFromSuperview];
        self.liveView = nil;
        
        if (_isFull) {
            [[UIApplication sharedApplication].keyWindow addSubview:self.liveView];
            [self.ageinView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo([UIApplication sharedApplication].keyWindow);
                make.top.equalTo([UIApplication sharedApplication].keyWindow);
                make.trailing.equalTo([UIApplication sharedApplication].keyWindow);
                make.leading.equalTo([UIApplication sharedApplication].keyWindow);
            }];
        } else {
            [self.view addSubview:self.liveView];
            [self.ageinView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(self.playerModel.playerFrame.size.height));
                make.top.equalTo(self.view);
                make.trailing.equalTo(self.view);
                make.leading.equalTo(self.view);
            }];
        }
    }
    
}

#pragma mark 播放器相关
- (void)destroyPlayer
{
    [self.shortView destroyPlayer];
    [self.liveView destroyPlayer];
}
- (void)pausePlayer
{
    [self.shortView pausePlayer];
    [self.liveView pausePlayer];
}
- (void)startPlayer
{
    [self.shortView startPlayer];
    [self.liveView startPlayer];
}
- (void)switchVideoUrl:(NSString *)url
{
    [self.shortView.liveplayer switchContentUrl:[NSURL URLWithString:url]];
}
- (void)changeplayerURLWithPlayerFinish
{
    // 更换url
    if ([self.delegate respondsToSelector:@selector(changeplayerURLWithPlayerFinish)]) {
        [self.delegate changeplayerURLWithPlayerFinish];
    }
}


@end
