//
//  GoodsModel.h
//  LXY
//
//  Created by guohui on 16/3/31.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "RootModel.h"

@interface GoodsModel : RootModel
@property (nonatomic,copy)NSString *gc_id ; //商品分类id
@property (nonatomic,copy)NSString *goods_id ; //商品id
@property (nonatomic,copy)NSString *goods_commonid ;//商品公共属性id
@property (nonatomic,copy)NSString *goods_name ;//商品名称
@property (nonatomic,copy)NSString *goods_image ; //商品图片
@property (nonatomic,copy)NSString *goods_jingle ;//商品描述
@property (nonatomic,copy)NSString *goods_price ;//商品价格
@property (nonatomic,copy)NSString *goods_salenum ;//商品销量
@property (nonatomic,copy)NSString *goods_storage ;//库存

//购物车列表
@property (nonatomic,copy)NSString *goods_num ;//商品数量
@property (nonatomic,copy)NSString *goods_pay_price ;//商品实际支付价格

@property (nonatomic,copy)NSString *order_id ;//订单id
@property (nonatomic,copy)NSString *rec_id ;//订单商品 表id



@end
