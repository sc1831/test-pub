//
//  OrderDetailsVC.h
//  LXY
//
//  Created by guohui on 16/4/14.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "RootVC.h"
#import "AllGoodsOrders.h"
@interface OrderDetailsVC : RootVC
@property (nonatomic,strong) AllGoodsOrders *orderModel ;
@property (nonatomic,strong) NSArray *goodsArray ; //AllGoodsOrders list
@end
