//
//  CompositeVC.h
//  LXY
//
//  Created by guohui on 16/3/15.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootVC.h"
@interface CompositeVC : RootVC
@property (nonatomic,copy)NSString *goods_name ;
@property (nonatomic,copy)NSString *gc_id ;
//超值特价
@property (nonatomic) BOOL isBargainSaleClick;
//促销商品
@property (nonatomic) BOOL isSalesPromotionClick;
//优品推荐
@property (nonatomic) BOOL isRecommendationsShopsClick;
@end
