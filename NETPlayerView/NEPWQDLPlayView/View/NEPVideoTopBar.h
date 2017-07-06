//
//  NEPVideoTopBar.h
//  NETPlayerView
//
//  Created by heqiao on 2017/6/22.
//  Copyright © 2017年 heqiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NEPVideoProtocol.h"

@interface NEPVideoTopBar : UIView

@property (nonatomic, weak) id<NEPVideoTopDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame titleName:(NSString *)titleName isFavtor:(BOOL)isFvator isShow:(BOOL)isShow;

@end
