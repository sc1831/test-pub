//
//  CityNameModel.h
//  LXY
//
//  Created by guohui on 16/3/29.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityNameModel : NSObject
//省份
@property (copy,nonatomic) NSString *province_id;
@property (copy,nonatomic) NSString *province_name;
//城市
@property (copy,nonatomic) NSString *city_id;
@property (copy,nonatomic) NSString *city_name;

//  县/区
@property (copy,nonatomic) NSString *county_id;
@property (copy,nonatomic) NSString *county_name;

//乡、镇
@property (copy,nonatomic) NSString *town_id;
@property (copy,nonatomic) NSString *town_name;


// 村
@property (copy,nonatomic) NSString *village_id;
@property (copy,nonatomic) NSString *village_name;


+(CityNameModel *)modelWithDic:(NSDictionary *)dic;
-(id)initWithDic:(NSDictionary *)dic;

@property (nonatomic, strong) NSArray *snapshotArray;
@end
