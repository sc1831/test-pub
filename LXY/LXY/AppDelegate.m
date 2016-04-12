//
//  AppDelegate.m
//  LXY
//
//  Created by guohui on 16/3/7.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "AppDelegate.h"
#import "GuiteVC.h"
#import "MainTabBar.h"
#import "LoginVC.h"
#import "SaveInfo.h"
#import "RequestCenter.h"
@interface AppDelegate ()

@end
/**
 Reachability 的网络判断
 */
static BOOL internetActive = YES;
static NetworkStatus hostReachState=NotReachable;
/**
 *AFNetwork 的网络判断
 */
static AFNetworkReachabilityStatus wifi = AFNetworkReachabilityStatusReachableViaWiFi;
@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    
    if (isIos7Version==1) {
        [[UITextField appearance]setTintColor:RGBCOLOR(255, 115, 0)];
        [UITextField appearance].leftView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
        [UITextField appearance].leftView.userInteractionEnabled = NO;
    }
    //开启网络状况的监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
//    hostReach = [Reachability reachabilityWithHostName:@"www.baidu.com"];//可以以多种形式初始化
//    [hostReach startNotifier];  //开始监听,会启动一个run loop
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//        hostReach = [Reachability reachabilityWithHostName:TEST_NET_STATUS_HOST];
//        internetActive = hostReach.isReachable;
//        hostReachState = [hostReach currentReachabilityStatus];
//        hostReach.reachableBlock = ^(Reachability *reachability) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                internetActive = YES;
//                hostReachState = [hostReach currentReachabilityStatus];
//            });
//        };
//        hostReach.unreachableBlock = ^(Reachability *reachability) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                internetActive = NO;
//                hostReachState = NotReachable;
//            });
//        };
//        [hostReach startNotifier]; //开始监听,会启动一个run loop
//    });
    
    
    
    
    
//    [self updateInterfaceWithReachability: hostReach];
    
    //判断版本是否一致 是否重新进入引导页
    if ([[SaveInfo shareSaveInfo] isFistStart]) {
        //版本号一致
        [self changeToken];
//        UIViewController *vc = [[UIViewController alloc]init];
//        vc.view.backgroundColor = [UIColor whiteColor];
//        self.window.rootViewController = vc;
    }else{
        //版本号不一样：第一次使用新版本
        [self intoGuite];
    }

//    UIViewController *vc = [[UIViewController alloc]init];
//    vc.view.backgroundColor = [UIColor whiteColor];
//    self.window.rootViewController = vc;
    LoginVC *loginVC = [[LoginVC alloc]init];
    loginVC.not_loginOut = YES ;
    self.window.rootViewController = loginVC ;


    
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    return YES;
}

//2.进入新手引导界面
- (void)intoGuite{
    GuiteVC *guiteVC = [[GuiteVC alloc]init];
    self.window.rootViewController = guiteVC;
    
}



#pragma mark - 替换token 验证token是否合法 是否进入登录界面
- (void)changeToken{
    RequestCenter *request = [RequestCenter shareRequestCenter];
    
    if ([SaveInfo shareSaveInfo].user_id != nil && [SaveInfo shareSaveInfo].token != nil) {
        //有token
        NSDictionary *postDic = @{@"user_id":[SaveInfo shareSaveInfo].user_id,@"token":[SaveInfo shareSaveInfo].token};
        
        [request sendRequestPostUrl:EDIT_USER_TOKEN andDic:postDic setSuccessBlock:^(NSDictionary *resultDic) {
            if ([[resultDic objectForKey:@"code"] intValue]== 1) {
                //成功 token 替换成功
                [[SaveInfo shareSaveInfo]setToken:[resultDic objectForKey:@"token"]];
                MainTabBar *mainVC = [[MainTabBar alloc]init];
                self.window.rootViewController = mainVC;
            }else{
                HUDNormal(@"请重新登录");
                LoginVC *loginVC = [[LoginVC alloc]init];
                self.window.rootViewController = loginVC ;
            }
        } setFailBlock:^(NSString *errorStr) {
            NSLog(@"error:%@",errorStr);
            //请求失败
            MainTabBar *mainVC = [[MainTabBar alloc]init];
            self.window.rootViewController = mainVC;
        }];
    }else{
        //无token
        LoginVC *loginVC = [[LoginVC alloc]init];
        self.window.rootViewController = loginVC ;
    }
    
  


}
//监听到网络状态改变
- (void) reachabilityChanged: (NSNotification* )note

{
    
    
    Reachability* curReach = [note object];
    
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    
    [self updateInterfaceWithReachability: curReach];
    
}
//处理连接改变后的情况
- (void) updateInterfaceWithReachability: (Reachability*) curReach

{
    //对连接改变做出响应的处理动作。
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    if(status == ReachableViaWWAN)
    {
        NSLog(@"\n3g/2G\n");
        internetActive = YES;
    }
    else if(status == ReachableViaWWAN)
    {
        NSLog(@"\nwifi\n");
        internetActive = YES;
    }else
    {
        NSLog(@"\n无网络\n");
        internetActive = NO;
    }
    
}

- (BOOL)isExistNetwork {
    return internetActive;
}

-(NetworkStatus)getNetworkStatus
{
    return hostReachState;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
