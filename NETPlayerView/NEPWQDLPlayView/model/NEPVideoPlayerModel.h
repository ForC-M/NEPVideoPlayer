//
//  NEPVideoPlayerModel.h
//  NETPlayerView
//
//  Created by heqiao on 2017/6/27.
//  Copyright © 2017年 heqiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NEPVideoTool.h"

@interface NEPVideoPlayerModel : NSObject

@property (nonatomic, assign) NEPPlayerStatus type;

@property (nonatomic, assign) BOOL isFavtor;

@property (nonatomic, assign) BOOL isSlider;

@property (nonatomic, assign) CGRect playerFrame;

@property (nonatomic, copy) NSString *playUrl;

@property (nonatomic, copy) NSString *titleName;

@end
