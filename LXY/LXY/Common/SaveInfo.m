//
//  SaveInfo.m
//  LXY
//
//  Created by guohui on 16/3/28.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "SaveInfo.h"
#define KPASSWORD @"password"
#define LOGINNAME @"loginName"
#define TOKEN @"token"
#define USER_ID @"user_id"
#define USER_INFO @"userInfo"

@implementation SaveInfo
+ (SaveInfo *)shareSaveInfo{
    static SaveInfo *saveInfo = nil ;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        saveInfo = [[self alloc] init];
    });
    
    return saveInfo ;
}
- (BOOL)isFistStart{
    //此为找到plist文件中版本号所对应的键
    NSString *key = (NSString *)kCFBundleVersionKey ;
    //从plist文件中取出版本号
    NSString *version = [NSBundle mainBundle].infoDictionary[key];
    //从沙盒中取出上次存储的版本号
    NSString *saveVersion = RETURE_MESSAGE(key);
//    NSString *saveVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (![version isEqualToString:saveVersion]) {
        //将新版本号写入沙盒
        SAVE_MESSAGE(version, key);
    }
    return [version isEqualToString:saveVersion] ;
}

#pragma mark - get set 方法 -
- (void)setLoginName:(NSString *)loginName{
    SAVE_MESSAGE(loginName, LOGINNAME);
}
- (NSString *)loginName{
    return RETURE_MESSAGE(LOGINNAME);
}

-(NSString *)passWord{
    return RETURE_MESSAGE(KPASSWORD);
}
- (void)setPassWord:(NSString *)passWord{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setValue:passWord forKey:KPASSWORD];
//    [defaults synchronize];
    SAVE_MESSAGE(passWord, KPASSWORD);
}

- (void)setToken:(NSString *)token{
    SAVE_MESSAGE(token, TOKEN);
}
- (NSString *)token{
    return RETURE_MESSAGE(TOKEN);
//    return @"0" ;
}
- (void)setUser_id:(NSString *)user_id{
    SAVE_MESSAGE(user_id, USER_ID);

}
- (NSString *)user_id{
    return RETURE_MESSAGE(USER_ID);
//    return @"1" ;
}
- (void)setUserInfo:(NSDictionary *)userInfo{
    SAVE_MESSAGE(userInfo, USER_INFO);
}
- (NSDictionary *)userInfo{
    return RETURE_MESSAGE(USER_INFO);
}

- (void)logout{
    self.loginName = nil ;
    self.passWord = nil ;
    self.token = nil ;
    self.user_id = nil ;
    self.userInfo = nil ;
}



@end
