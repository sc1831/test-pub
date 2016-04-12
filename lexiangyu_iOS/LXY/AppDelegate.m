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

#import "UMessage.h"
#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define _IPHONE80_ 80000
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
//static AFNetworkReachabilityStatus wifi = AFNetworkReachabilityStatusReachableViaWiFi;
@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    //TODO: 微信
    [WXApi registerApp:@"wx24728dea6d8b2f08" withDescription:@"lxy"];
    //向微信注册wxd930ea5d5a258f4f
//    [WXApi registerApp:@"wxb4ba3c02aa476ea1" withDescription:@"demo 2.0"];
    
    //TODO: 推送
    //set AppKey and LaunchOptions
    [UMessage startWithAppkey:@"56e7735e67e58e3d78001181" launchOptions:launchOptions];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    if(UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        //register remoteNotification types
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1_identifier";
        action1.title=@"Accept";
        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action2_identifier";
        action2.title=@"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
        
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"category1";//这组动作的唯一标示
        [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        
        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                     categories:[NSSet setWithObject:categorys]];
        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
        
    } else{
        //register remoteNotification types
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
         |UIRemoteNotificationTypeSound
         |UIRemoteNotificationTypeAlert];
    }
#else
    
    //register remoteNotification types
    [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
     |UIRemoteNotificationTypeSound
     |UIRemoteNotificationTypeAlert];
    
#endif
    
    //for log 打开调试日志
    [UMessage setLogEnabled:YES];
    

    
    
    
    
    // !!!: 第三方结束
    if (isIos7Version==1) {
        [[UITextField appearance]setTintColor:RGBCOLOR(255, 115, 0)];
    }
    
    
    LoginVC *loginVC = [[LoginVC alloc]init];
    loginVC.not_loginOut = YES ;
    self.window.rootViewController = loginVC ;
    
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



    
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    return YES;
}

//2.进入新手引导界面
- (void)intoGuite{
    GuiteVC *guiteVC = [[GuiteVC alloc]init];
    self.window.rootViewController = guiteVC;
    
}

//TODO: 微信
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:self];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [WXApi handleOpenURL:url delegate:self];
}
//- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
//    return [WXApi handleOpenURL:url delegate:self];
//}

//TODO:友盟
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"deviceToken:%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]                  stringByReplacingOccurrencesOfString: @">" withString: @""]                 stringByReplacingOccurrencesOfString: @" " withString: @""]);
    
    [UMessage registerDeviceToken:deviceToken];
    
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    //如果注册不成功，打印错误信息，可以在网上找到对应的解决方案
    //如果注册成功，可以删掉这个方法
    NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //关闭友盟自带的弹出框
    //  [UMessage setAutoAlert:NO];
    
    [UMessage didReceiveRemoteNotification:userInfo];
    
    //    self.userInfo = userInfo;
    //    //定制自定的的弹出框
    //    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    //    {
    //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"标题"
    //                                                            message:@"Test On ApplicationStateActive"
    //                                                           delegate:self
    //                                                  cancelButtonTitle:@"确定"
    //                                                  otherButtonTitles:nil];
    //
    //        [alertView show];
    //        
    //    }
}






#pragma mark - 替换token 验证token是否合法 是否进入登录界面
- (void)changeToken{

    [[SaveInfo shareSaveInfo] setUser_id:@"323423"];
    [[SaveInfo shareSaveInfo] setToken:@"2332dfsfdsfsd"];
    MainTabBar *mainVC = [[MainTabBar alloc]init];
    self.window.rootViewController = mainVC;
    
//    RequestCenter *request = [RequestCenter shareRequestCenter];
//    if ([SaveInfo shareSaveInfo].user_id != nil && [SaveInfo shareSaveInfo].token != nil) {
//        //有token
//        NSDictionary *postDic = @{@"user_id":[SaveInfo shareSaveInfo].user_id,@"token":[SaveInfo shareSaveInfo].token};
//        
//        [request sendRequestPostUrl:EDIT_USER_TOKEN andDic:postDic setSuccessBlock:^(NSDictionary *resultDic) {
//            if ([[resultDic objectForKey:@"code"] intValue]== 1) {
//                //成功 token 替换成功
//                [[SaveInfo shareSaveInfo]setToken:[resultDic objectForKey:@"token"]];
//                MainTabBar *mainVC = [[MainTabBar alloc]init];
//                self.window.rootViewController = mainVC;
//            }else{
//                HUDNormal(@"请重新登录");
//                LoginVC *loginVC = [[LoginVC alloc]init];
//                self.window.rootViewController = loginVC ;
//            }
//        } setFailBlock:^(NSString *errorStr) {
//            NSLog(@"error:%@",errorStr);
//            //请求失败
//            MainTabBar *mainVC = [[MainTabBar alloc]init];
//            self.window.rootViewController = mainVC;
//        }];
//    }else{
//        //无token
//        LoginVC *loginVC = [[LoginVC alloc]init];
//        self.window.rootViewController = loginVC ;
//    }
    
  


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
