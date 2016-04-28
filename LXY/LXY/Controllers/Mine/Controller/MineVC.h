//
//  MineVC.h
//  LXY
//
//  Created by guohui on 16/3/14.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineVC : UIViewController
//顶部view点击
- (IBAction)topViewClick:(id)sender;

//管理账户收货地址
- (IBAction)ManagementAccountClick:(id)sender;

//查看全部订单
- (IBAction)lookAllOrderClick:(id)sender;
//代收货
- (IBAction)getCargoClick:(id)sender;

//代发货
- (IBAction)sendCargoClick:(id)sender;
//代付款
- (IBAction)parymentClick:(id)sender;
//我的收藏点击
- (IBAction)collectionViewClick:(id)sender;
//我的足迹点击
- (IBAction)footprintClick:(id)sender;

@end
