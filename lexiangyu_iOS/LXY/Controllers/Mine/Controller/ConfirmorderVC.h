//
//  ConfirmorderVC.h
//  LXY
//
//  Created by guohui on 16/3/15.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "RootVC.h"


@class AllGoodsOrders;
@interface ConfirmorderVC : RootVC
@property (nonatomic ,strong)NSString *addressStr;
@property (nonatomic ,strong)AllGoodsOrders *model;
@property (nonatomic ,strong)NSMutableArray *mutArray;
@property (nonatomic ,strong)NSMutableArray *dataArray;
@end
