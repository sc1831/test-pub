//
//  ShoppingCartModel.h
//  LXY
//
//  Created by guohui on 16/3/30.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShoppingCartModel : NSObject

@property (copy,nonatomic) NSString *address;//超市名称
@property (copy,nonatomic) NSString *address_id;//超市id


@property (copy,nonatomic) NSString *cart_id;//购物记录id
@property (copy,nonatomic) NSString *goods_commonid;//商品公共id

@property (copy,nonatomic) NSString *store_id;//商家id
@property (copy,nonatomic) NSString *store_name;//商家名称
@property (copy,nonatomic) NSString *goods_state;//商品状态:0下架 1正常   10违规、禁售


@property (copy,nonatomic) NSString *goods_id;//物品id
@property (copy,nonatomic) NSString *goods_name;//物品名字
@property (copy,nonatomic) NSString *goods_price;//物品价格
@property (copy,nonatomic) NSString *goods_num;//物品数量
@property (copy,nonatomic) NSString *goods_image;//物品图片

@property (copy,nonatomic) NSString *sp_value_name;//颜色
@property (copy,nonatomic) NSString *sp_name;//尺码

@property (nonatomic ,copy)NSString  *goods_num_total;//每组总件数
@property (nonatomic ,copy)NSString  *goods_price_total;//每组总价格
@property (nonatomic ,copy)NSString  *goods_storage;//库存

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic ,assign) int allGoods;

//@property (nonatomic, assign) BOOL isHeadSelected;

+(ShoppingCartModel *)modelWithDic:(NSDictionary *)dic;
-(id)initWithDic:(NSDictionary *)dic;

@end
