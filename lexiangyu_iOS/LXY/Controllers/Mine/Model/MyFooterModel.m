//
//  MyFooterModel.m
//  LXY
//
//  Created by guohui on 16/3/30.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "MyFooterModel.h"

@implementation MyFooterModel
+(MyFooterModel *)modelWithDic:(NSDictionary *)dic{
    return [[self alloc]initWithDic:dic];
}

-(id)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        //kvc将字典的数据储存到模型中
        [self setValuesForKeysWithDictionary:dic];
        
        
    }
    return self;
}
-(id)valueForUndefinedKey:(NSString *)key{
    return nil;
}
- (void)setValue:(nullable id)value forUndefinedKey:(NSString *)key{
    
}
@end
