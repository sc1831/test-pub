//
//  MineAccountVC.h
//  LXY
//
//  Created by guohui on 16/3/16.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "RootVC.h"

@interface MineAccountVC : RootVC
//账户名
@property (strong, nonatomic)  NSString *accountNameStr;
//超市名称
@property (strong, nonatomic)  NSString *shopNameStr;
//绑定手机号
@property (strong, nonatomic)  NSString *bindPhoneNumStr;

@property (strong, nonatomic)  NSString *phoneNum;
@property (strong, nonatomic) UIImage *image;
@end
