//
//  NEPVideoPlayerViewController.h
//  NETPlayerView
//
//  Created by heqiao on 2017/6/29.
//  Copyright © 2017年 heqiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NEPVideoTool.h"
#import "ViewController+NEPVideoSwizzling.h"

@protocol NEPVideoPlayerViewControllerDelegate <NSObject>

- (void)changeplayerURLWithPlayerFinish;

- (void)cancelCollection;

- (void)getCollection;

- (void)updataTime:(NSInteger)upTime;

- (void)seekCurrentPlayer;

@end

@interface NEPVideoPlayerViewController : UIViewController

@property (nonatomic, weak) id<NEPVideoPlayerViewControllerDelegate> delegate;

- (void)initWithPlayerViewType:(NEPPlayerStatus)type playerUrl:(NSString *)playUrl titleName:(NSString *)titleName isFavtor:(BOOL)isFavtor isSlider:(BOOL)isSlider playerFrame:(CGRect)playerFrame;

- (void)destroyPlayer;

- (void)pausePlayer;

- (void)startPlayer;

- (void)switchVideoUrl:(NSString *)url;

@end
