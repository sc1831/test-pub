//
//  MyFooterModel.h
//  LXY
//
//  Created by guohui on 16/3/30.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyFooterModel : NSObject

@property (nonatomic ,strong)NSString *goods_id;
@property (nonatomic ,strong)NSString *goods_name;
@property (nonatomic ,strong)NSString *goods_price;
@property (nonatomic ,strong)NSString *goods_image;
@property (nonatomic,copy)NSString *goods_commonid ;


+(MyFooterModel *)modelWithDic:(NSDictionary *)dic;
-(id)initWithDic:(NSDictionary *)dic;
@end
