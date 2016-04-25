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
#import "GHControl.h"


#import "UMessage.h"
#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define _IPHONE80_ 80000

//银联支付
#import "UPPaymentControl.h"
#import "RSA.h"
#import "MobClick.h"

#import <CommonCrypto/CommonDigest.h>


#define UMENG_APPKEY @"56e7735e67e58e3d78001181"

@interface AppDelegate ()
@property (nonatomic ,strong)Reachability *conn;
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
    //TODO: 推送
    //set AppKey and LaunchOptions
    [UMessage startWithAppkey:@"56e7735e67e58e3d78001181" launchOptions:launchOptions];
    
    //TODO:友盟统计
    //  友盟的方法本身是异步执行，所以不需要再异步调用
    [self umengTrack];

    
    
    //TODO: 微信
    [WXApi registerApp:@"wx24728dea6d8b2f08" withDescription:@"lxy"];
    //向微信注册wxd930ea5d5a258f4f
//    [WXApi registerApp:@"wxb4ba3c02aa476ea1" withDescription:@"demo 2.0"];
    

    
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
    
    //TODO:银联支付:
    
    
    
    
    
    // !!!: 第三方结束
    if (isIos7Version==1) {
        [[UITextField appearance]setTintColor:RGBCOLOR(255, 115, 0)];
    }

    
    // 监听网络状态改变的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStateChange) name:kReachabilityChangedNotification object:nil];
    
    // 创建Reachability
    self.conn = [Reachability reachabilityForInternetConnection];
   self.conn = [Reachability reachabilityWithHostName:@"www.lexianyu.com"];
    // 开始监控网络(一旦网络状态发生改变, 就会发出通知kReachabilityChangedNotification)
    [self.conn startNotifier];
    
    
    
    
    
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

- (void)umengTrack {
    //    [MobClick setCrashReportEnabled:NO]; // 如果不需要捕捉异常，注释掉此行
    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    //
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy) REALTIME channelId:nil];
    //   reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
    //   channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
}

// 处理网络状态改变
- (void)networkStateChange
{
    // 1.检测wifi状态
    Reachability *wifi = [Reachability reachabilityForLocalWiFi];
    
    // 2.检测手机是否能上网络(WIFI\3G\2.5G)
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    
    // 3.判断网络状态
    if ([wifi currentReachabilityStatus] != NotReachable) { // 有wifi
        NSLog(@"有wifi");
        internetActive = YES;
    } else if ([conn currentReachabilityStatus] != NotReachable) { // 没有使用wifi, 使用手机自带网络进行上网
        NSLog(@"使用手机自带网络进行上网");
        internetActive = YES;
    } else { // 没有网络
        NSLog(@"没有网络");
        internetActive = NO;
    }
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

    //银联
    [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
        
        //结果code为成功时，先校验签名，校验成功后做后续处理
        if([code isEqualToString:@"success"]) {
            
            //判断签名数据是否存在
            if(data == nil){
                //如果没有签名数据，建议商户app后台查询交易结果
                return;
            }
            
            //数据从NSDictionary转换为NSString
            NSData *signData = [NSJSONSerialization dataWithJSONObject:data
                                                               options:0
                                                                 error:nil];
            NSString *sign = [[NSString alloc] initWithData:signData encoding:NSUTF8StringEncoding];
            
            
            
            //验签证书同后台验签证书
            //此处的verify，商户需送去商户后台做验签
            if([self verify:sign]) {
                //支付成功且验签成功，展示支付成功提示
            }
            else {
                //验签失败，交易结果数据被篡改，商户app后台查询交易结果
            }
        }
        else if([code isEqualToString:@"fail"]) {
            //交易失败
        }
        else if([code isEqualToString:@"cancel"]) {
            //交易取消
        }
    }];

    //微信
    return [WXApi handleOpenURL:url delegate:self];
//    return YES ;
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

//TODO:银联支付:
- (NSString *) readPublicKey:(NSString *) keyName
{
    if (keyName == nil || [keyName isEqualToString:@""]) return nil;
    
    NSMutableArray *filenameChunks = [[keyName componentsSeparatedByString:@"."] mutableCopy];
    NSString *extension = filenameChunks[[filenameChunks count] - 1];
    [filenameChunks removeLastObject]; // remove the extension
    NSString *filename = [filenameChunks componentsJoinedByString:@"."]; // reconstruct the filename with no extension
    
    NSString *keyPath = [[NSBundle mainBundle] pathForResource:filename ofType:extension];
    
    NSString *keyStr = [NSString stringWithContentsOfFile:keyPath encoding:NSUTF8StringEncoding error:nil];
    
    return keyStr;
}

-(BOOL) verify:(NSString *) resultStr {
    
    //验签证书同后台验签证书
    //此处的verify，商户需送去商户后台做验签
    return NO;
}
//-(BOOL) verifyLocal:(NSString *) resultStr {
//
//    //从NSString转化为NSDictionary
//    NSData *resultData = [resultStr dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:resultData options:0 error:nil];
//
//    //获取生成签名的数据
//    NSString *sign = data[@"sign"];
//    NSString *signElements = data[@"data"];
//    //NSString *pay_result = signElements[@"pay_result"];
//    //NSString *tn = signElements[@"tn"];
//    //转换服务器签名数据
//    NSData *nsdataFromBase64String = [[NSData alloc]
//                                      initWithBase64EncodedString:sign options:0];
//    //生成本地签名数据，并生成摘要
////    NSString *mySignBlock = [NSString stringWithFormat:@"pay_result=%@tn=%@",pay_result,tn];
//    NSData *dataOriginal = [[self sha1:signElements] dataUsingEncoding:NSUTF8StringEncoding];
//    //验证签名
//    //TODO：此处如果是正式环境需要换成public_product.key
//    NSString *pubkey =[self readPublicKey:@"public_test.key"];
//    OSStatus result=[RSA verifyData:dataOriginal sig:nsdataFromBase64String publicKey:pubkey];
//
//
//
//    //签名验证成功，商户app做后续处理
//    if(result == 0) {
//        //支付成功且验签成功，展示支付成功提示
//        return YES;
//    }
//    else {
//        //验签失败，交易结果数据被篡改，商户app后台查询交易结果
//        return NO;
//    }
//
//    return NO;
//}

- (NSString*)sha1:(NSString *)string
{
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1_CTX context;
    NSString *description;
    
    CC_SHA1_Init(&context);
    
    memset(digest, 0, sizeof(digest));
    
    description = @"";
    
    
    if (string == nil)
    {
        return nil;
    }
    
    // Convert the given 'NSString *' to 'const char *'.
    const char *str = [string cStringUsingEncoding:NSUTF8StringEncoding];
    
    // Check if the conversion has succeeded.
    if (str == NULL)
    {
        return nil;
    }
    
    // Get the length of the C-string.
    int len = (int)strlen(str);
    
    if (len == 0)
    {
        return nil;
    }
    
    
    if (str == NULL)
    {
        return nil;
    }
    
    CC_SHA1_Update(&context, str, len);
    
    CC_SHA1_Final(digest, &context);
    
    description = [NSString stringWithFormat:
                   @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[ 0], digest[ 1], digest[ 2], digest[ 3],
                   digest[ 4], digest[ 5], digest[ 6], digest[ 7],
                   digest[ 8], digest[ 9], digest[10], digest[11],
                   digest[12], digest[13], digest[14], digest[15],
                   digest[16], digest[17], digest[18], digest[19]];
    
    return description;
}


#pragma mark - 替换token 验证token是否合法 是否进入登录界面
- (void)changeToken{

//    [[SaveInfo shareSaveInfo] setUser_id:@"323423"];
//    [[SaveInfo shareSaveInfo] setToken:@"2332dfsfdsfsd"];
//    MainTabBar *mainVC = [[MainTabBar alloc]init];
//    self.window.rootViewController = mainVC;
    
    if (![GHControl isExistNetwork]) {
        HUDNormal(@"服务器无响应，请稍后重试");
        return;
    }
    
    RequestCenter *request = [RequestCenter shareRequestCenter];
    if ([SaveInfo shareSaveInfo].user_id != nil && [SaveInfo shareSaveInfo].token != nil) {
        //有token
        NSDictionary *postDic = @{@"user_id":[SaveInfo shareSaveInfo].user_id,@"token":[SaveInfo shareSaveInfo].token};
        
        
        [request sendRequestPostUrl:EDIT_USER_TOKEN andDic:postDic setSuccessBlock:^(NSDictionary *resultDic) {
            if ([[resultDic objectForKey:@"code"] intValue]== 1) {
                //成功 token 替换成功
//                if (!resultDic[@"token"]) {
//                    [[SaveInfo shareSaveInfo]setToken:[resultDic objectForKey:@"token"]];
//                }else{
//                    
//                }
                
                [[SaveInfo shareSaveInfo]setToken:[[resultDic objectForKey:@"data"] objectForKey:@"token"]];
                [[SaveInfo shareSaveInfo]setUser_id:[[resultDic objectForKey:@"data"] objectForKey:@"member_id"]];
                [[SaveInfo shareSaveInfo]setUserInfo:[resultDic objectForKey:@"data"]];
                [[SaveInfo shareSaveInfo]setLoginName:[[resultDic objectForKey:@"data"] objectForKey:@"member_phone"]];
                [[SaveInfo shareSaveInfo]setShop_name:[[resultDic objectForKey:@"data"] objectForKey:@"shop_name"]];
                
                
                
                MainTabBar *mainVC = [[MainTabBar alloc]init];
                self.window.rootViewController = mainVC ;
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
