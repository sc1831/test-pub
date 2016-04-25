//
//  AddressModel.h
//  LXY
//
//  Created by guohui on 16/4/25.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "RootModel.h"

@interface AddressModel : RootModel
@property (nonatomic,copy)NSString *address ; //买家详细街道店铺地址
@property (nonatomic,copy)NSString *address_id ; //买家详细街道店铺地址 id
@property (nonatomic,copy)NSString *area_info ;//买家地址
@property (nonatomic,copy)NSString *mob_phone ;//买家电话
@property (nonatomic,copy)NSString *true_name ;//真实姓名
@end
