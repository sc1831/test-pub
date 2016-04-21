//
//  OrderModel.h
//  LXY
//
//  Created by guohui on 16/4/15.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "RootModel.h"

@interface OrderModel : RootModel
@property (nonatomic,copy)NSString *add_time ; //订单添加时间
@property (nonatomic,copy)NSString *address ; //买家详细街道店铺地址
@property (nonatomic,copy)NSString *area_info ;//买家地址
@property (nonatomic,copy)NSString *buyer_id ;//用户id（买家id）
@property (nonatomic,copy)NSString *close_order ; //订单自动关闭时间
@property (nonatomic,copy)NSString *finnshed_time ;//订单完成时间
@property (nonatomic,copy)NSString *mob_phone ;//买家电话
@property (nonatomic,copy)NSString *order_amount ;//订单总额
@property (nonatomic,copy)NSString *order_id ;//订单id
@property (nonatomic,copy)NSString *order_sn ; //订单号
@property (nonatomic,copy)NSString *pay_sn ; //支付号
@property (nonatomic,copy)NSString *order_state ;//订单状态 0已取消，10未付款，20已付款，30已发货，40已收货
@property (nonatomic,copy)NSString *payment_time ;//支付时间
@property (nonatomic,copy)NSString *store_name ;//店铺名

@property (nonatomic,copy)NSString *order_goods_price_total;

+(OrderModel *)modelWithDic:(NSDictionary *)dic;
-(id)initWithDic:(NSDictionary *)dic;
@end
