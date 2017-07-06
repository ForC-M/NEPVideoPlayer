//
//  ViewController.m
//  NETPlayerView
//
//  Created by heqiao on 2017/6/9.
//  Copyright © 2017年 heqiao. All rights reserved.
//

#import "ViewController.h"
#import "NEPVideoShortView.h"
#import "AppDelegate.h"
#import "Masonry.h"
#import "NEPVideoPlayerViewController.h"

@interface ViewController ()<NEPVideoPlayerViewControllerDelegate>

@property (nonatomic, weak) NEPVideoPlayerViewController *playControlelr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NEPVideoPlayerViewController *videoController = [NEPVideoPlayerViewController new];
    [self addChildViewController:videoController];
    [videoController initWithPlayerViewType:NEPPlayerShortPlayer playerUrl:@"http://flv3.bn.netease.com/videolib3/1706/26/mlkNV3108/SD/mlkNV3108-mobile.mp4" titleName:@"sdasda" isFavtor:NO isSlider:NO playerFrame:CGRectMake(0, 0, NEP_ScreenWidth, 210*NEPSCALEH)];
    videoController.delegate = self;
    self.playControlelr = videoController;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.playControlelr destroyPlayer];
}
- (void)changeplayerURLWithPlayerFinish
{
    [self.playControlelr switchVideoUrl:@"http://flv3.bn.netease.com/videolib3/1706/26/mlkNV3108/SD/mlkNV3108-mobile.mp4"];
}
- (void)cancelCollection
{
    //http
}
- (void)getCollection
{
    //http
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
