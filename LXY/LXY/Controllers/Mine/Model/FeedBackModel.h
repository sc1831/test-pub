//
//  FeedBackModel.h
//  LXY
//
//  Created by guohui on 16/4/7.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedBackModel : NSObject
@property (nonatomic ,strong)NSString *type_id;
@property (nonatomic ,strong)NSString *type_name;
+(FeedBackModel *)modelWithDic:(NSDictionary *)dic;
-(id)initWithDic:(NSDictionary *)dic;
@end
