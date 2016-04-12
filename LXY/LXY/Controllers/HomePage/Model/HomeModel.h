//
//  HomeModel.h
//  LXY
//
//  Created by guohui on 16/3/31.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "RootModel.h"

@interface HomeModel : RootModel
//广告
@property (nonatomic,copy)NSString *adv_id ;
@property (nonatomic,copy)NSString *adv_image ;

//商品顶级分类
@property (nonatomic,copy)NSString *gc_id ;
@property (nonatomic,copy)NSString *gc_name ;

//商品
@property (nonatomic,copy)NSString *goods_id ; //商品id
@property (nonatomic,copy)NSString *goods_commonid ;//商品公共属性id
@property (nonatomic,copy)NSString *goods_name ;//商品名称
@property (nonatomic,copy)NSString *goods_image ; //商品图片
@property (nonatomic,copy)NSString *goods_jingle ; //商品描述
@property (nonatomic,copy)NSString *goods_price ;//商品价格
@property (nonatomic,copy)NSString *goods_salenum ;//商品销量
@property (nonatomic,copy)NSString *evaluation_good_star ;//商品评星


@end
