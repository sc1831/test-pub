//
//  Common.h
//  LXY
//
//  Created by guohui on 16/3/9.
//  Copyright © 2016年 guohui. All rights reserved.
//

#ifndef Common_h
#define Common_h

#import "MBProgressHUD/MBProgressHUD.h"
#import "AFNetworking/AFHTTPSessionManager.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "LoginVC.h"
#import "SaveInfo.h"
/** 系统版本 */
#define isIos7Version  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f ? 1 : 0)

/**
 *  常用变量
 */
#define M_WIDTH [UIScreen mainScreen].bounds.size.width
#define M_HEIGHT [UIScreen mainScreen].bounds.size.height

/*
 * 通过RGB创建UIColor
 */
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

// RGB颜色转换（16进制->10进制）
#define UIColorFromRGBA(rgbValue, alphaValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:1.0]


/**
 *  Show HUD In Normal State
 */
#define gFTHUDFontSize  15
//常规的信息提示 可以设置显示时间/延时消失时间
#define HUDNormal(msg) {MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:NO];\
hud.mode = MBProgressHUDModeText;\
hud.detailsLabelText = msg ;\
hud.minShowTime = 0.5;\
hud.detailsLabelFont = [UIFont systemFontOfSize:gFTHUDFontSize];\
[hud hide:YES afterDelay:1];\
}

//类似于alertView的 警示
#define HUDNoStop(msg) {MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:NO];\
hud.detailsLabelText = msg ;\
hud.detailsLabelFont = [UIFont systemFontOfSize:gFTHUDFontSize];\
hud.mode = MBProgressHUDModeText;}
//请求等待图 常规
#define HUDSelfStart(msg) {MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:NO];\
hud.detailsLabelText = msg ;\
hud.detailsLabelFont = [UIFont systemFontOfSize:gFTHUDFontSize];\
hud.mode = MBProgressHUDModeIndeterminate;}
//loading 延时 类似于上传文件时
#define HUDSelefDelay(msg) {MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:NO];\
hud.detailsLabelText = msg ;\
hud.detailsLabelFont = [UIFont systemFontOfSize:gFTHUDFontSize];\
[hud hide:YES afterDelay:1];\
hud.mode = MBProgressHUDModeIndeterminate;}
//结束
#define HUDSelfEnd [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication].delegate window] animated:NO];


/**
 *  alertView
 */
#define ALERTNORMAL(msg,buttonTitle) 


/**
 *  Log
 */
#define GLOG(msg_key,msg_value)  NSLog(@"%@:%@",msg_key,msg_value)
//#define G3LOG(msg_key,msg_value1,msg_value2) NSLog(@"%@ :%@ , %@",msg_key,msg_value1,msg_value1)

/**
 *  网络加载 菊花
 */
#define NETWORKVIEW(flag) [UIApplication sharedApplication].networkActivityIndicatorVisible = flag



/**
 *  字符串拼接
 */
#define STR_a_ADD_b_(rootUrl,subUrl) [NSString stringWithFormat:@"%@/%@",rootUrl,subUrl]
#define STR_A_B(str1,str2) [NSString stringWithFormat:@"%@%@",str1,str2]
#define STR_A_B_C(str1,str2,str3) [NSString stringWithFormat:@"%@%@%@",str1,str2,str3]

/**
 *tableview 点击一定时间 消失点击效果
*/
#define CELLSELECTANIMATE [UIView animateWithDuration:0.3f\
                 animations:^{\
                     [tableView deselectRowAtIndexPath:indexPath animated:YES];\
                 }];

//缓存设置

#define RETURE_MESSAGE(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]

#define SAVE_MESSAGE(msg,key) {    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];\
[defaults setValue:msg forKey:key];\
[defaults synchronize];\
}

//数据类型转换
#define VALUETOSTR(value) [NSString stringWithFormat:@"%d",value]

//刷新
#define MY_REFRESH(count)  [indexPaths addObject:[NSIndexPath indexPathForRow:0 inSection: count+ i]]
#define MY_REFRESH_TWO  [_waitPayTableView reloadData]

//返回登录
#define BG_LOGIN {\
    if ([resultDic[@"msg"] isEqualToString:@"Hacker!"]) {\
    [[SaveInfo shareSaveInfo] logout];\
    [self presentViewController:[[LoginVC alloc]init] animated:YES completion:nil];\
    return ;}\
}

#endif /* Common_h */
