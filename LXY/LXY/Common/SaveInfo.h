//
//  SaveInfo.h
//  LXY
//
//  Created by guohui on 16/3/28.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"
#define KPASSWORD @"password"
#define LOGINNAME @"loginName"
#define TOKEN @"token"
#define USER_ID @"user_id"
#define USER_INFO @"userInfo"

@interface SaveInfo : NSObject
@property (nonatomic,copy)NSString *loginName ;
@property (nonatomic,copy)NSString *passWord ;
@property (nonatomic,copy)NSString *token ;
@property (nonatomic,copy)NSString *user_id ;
@property (nonatomic,strong)NSDictionary *userInfo ;
@property (nonatomic,copy)NSString *shop_name;
@property (nonatomic,copy)NSString *userImageUrl ;
/**
pushFlag 0 不推送, 1推送 
 */
@property (nonatomic,copy)NSString *pushFlag ;
+ (SaveInfo *)shareSaveInfo;//全局共享
- (void)logout;
- (BOOL)isFistStart ;

@end
