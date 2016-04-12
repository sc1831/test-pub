//
//  AppDelegate.h
//  LXY
//
//  Created by guohui on 16/3/7.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "Common.h"
#import "WXApi.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;

///有无网络存在
- (BOOL)isExistNetwork;
///判断网络的状态类型
-(NetworkStatus)getNetworkStatus;

@end

