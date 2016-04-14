//
//  ConfirmorderVC.h
//  LXY
//
//  Created by guohui on 16/3/15.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "RootVC.h"



@interface ConfirmorderVC : RootVC
//购物车信息
@property (nonatomic ,strong) NSString *cartIds;
//商品订单id
@property (nonatomic ,strong) NSString *orderIds;
//商品id
@property (nonatomic ,strong) NSString *goodsIds;
//商品数量
@property (nonatomic ,strong) NSString *goodsNum;

@end
