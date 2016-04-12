//
//  JsonTool.h
//  LXY
//
//  Created by guohui on 16/3/9.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonTool : NSObject
#pragma mark String -> Dic
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString ;
#pragma mark String -> Array
+ (NSArray *)arrayWithJsonString:(NSString *)jsonString ;
#pragma mark String -> Id
+ (id)toNoArrayOrNSDictionaryWithJsonString:(NSString *)jsonString ;
#pragma mark Dic -> String
+ (NSString*)dictionaryToJson:(NSDictionary *)dic ;
#pragma mark Array -> String 
+ (NSString*)arrayToJson:(NSArray *)array ;
@end
