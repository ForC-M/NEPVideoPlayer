//
//  NEPVideoProtocol.h
//  NETPlayerView
//
//  Created by heqiao on 2017/6/23.
//  Copyright © 2017年 heqiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NEPVideoTool.h"


@protocol NEPVideoAgainDelegate <NSObject>

- (void)NEPVideoAgainClick;

@end

@protocol NEPVideoTopDelegate <NSObject>

- (void)NEPVideoTopExitClick;

- (void)NEPVideoTopFavtorsClick:(BOOL)isCollection;

@end

@protocol NEPVideoBottomDelegate <NSObject>

- (void)NEPVideoBottomStartClick;

- (void)NEPVideoBottomPauseClick;

- (void)NEPVideoBottomFullClick;

- (void)NEPVideoBottomSliderClick:(NSTimeInterval)SliderValue;

@end

@protocol NEPVideoShortDelegate <NSObject>

- (void)changePlayerViewScreen;               //换屏

- (void)btnActionWithCollect:(BOOL)isCollection;                 // 收藏

- (void)changeplayerURLWithPlayerFinish;      // 播放完成

- (void)updataTime:(NSInteger)upTime;         // 上传时间

- (void)seekCurrentPlayer;                    //加载上次记录

- (void)videoPlayerViewDestory;               // 销毁

- (void)shortViewChangeScreenStatus:(NEPPlayerScreenStatus)status; // 锁屏

- (void)changePlayerViewToAgainView; //  重试

- (void)setShortTime:(NSInteger)shortTime; // 记录时间

@end

@protocol NEPVideoLiveDelegate <NSObject>

- (void)changePlayerViewScreen;               //换屏

- (void)btnActionWithCollect;                 // 收藏

- (void)changeplayerURLWithPlayerFinish;      // 播放完成

- (void)videoPlayerViewDestory;               // 销毁

- (void)shortViewChangeScreenStatus:(NEPPlayerScreenStatus)status; // 锁屏

- (void)changePlayerViewToAgainView; //  重试

@end


