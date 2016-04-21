//
//  AllGoodsOrders.h
//  LXY
//
//  Created by guohui on 16/4/11.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AllGoodsOrders : NSObject
@property (nonatomic ,strong)NSString *order_id;

@property (nonatomic ,strong)NSString *store_name;
@property (nonatomic ,strong)NSString *order_state;
@property (nonatomic ,strong)NSString *order_sn;
@property (nonatomic ,strong)NSString *add_time;
@property (nonatomic ,strong)NSString *payment_time;
@property (nonatomic ,strong)NSString *finnshed_time ;
@property (nonatomic ,strong)NSString *order_amount;
@property (nonatomic ,strong)NSString *order_goods;
//小数组内的参数
@property (nonatomic ,strong)NSString *goods_id;
@property (nonatomic ,strong)NSString *goods_name;
@property (nonatomic ,strong)NSString *goods_num ;
@property (nonatomic ,strong)NSString *goods_salenum;
@property (nonatomic ,strong)NSString *goods_image;
@property (nonatomic ,strong)NSString *goods_price;

@property (nonatomic ,strong)NSString *sp_name;
@property (nonatomic ,strong)NSString *sp_value_name;

@property (nonatomic ,strong)NSString *goods_num_total;//商品数量
@property (nonatomic ,strong)NSString *goods_price_total;//商品价格

@property (nonatomic ,strong)NSString *order_goods_price_total;
@property (nonatomic ,strong)NSString *order_goods_num_total;

+(AllGoodsOrders *)modelWithDic:(NSDictionary *)dic;
-(id)initWithDic:(NSDictionary *)dic;
@end
