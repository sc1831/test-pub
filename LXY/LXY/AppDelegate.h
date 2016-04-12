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
#import "GHControl.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{

@private
    Reachability *hostReach;
}


@property (strong, nonatomic) UIWindow *window;
- (void) reachabilityChanged: (NSNotification* )note;//网络连接改变
- (void) updateInterfaceWithReachability: (Reachability*) curReach;//处理连接改变后的情况
///有无网络存在
- (BOOL)isExistNetwork;
///判断网络的状态类型
-(NetworkStatus)getNetworkStatus;

@end

