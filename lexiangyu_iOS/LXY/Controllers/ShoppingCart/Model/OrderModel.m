//
//  OrderModel.m
//  LXY
//
//  Created by guohui on 16/4/15.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderModel

+(OrderModel *)modelWithDic:(NSDictionary *)dic{
    return [[self alloc]initWithDic:dic];
}

-(id)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        //kvc将字典的数据储存到模型中
        [self setValuesForKeysWithDictionary:dic];
        
        
    }
    return self;
}
@end
