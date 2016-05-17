//
//  JsonTool.m
//  LXY
//
//  Created by guohui on 16/3/9.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "JsonTool.h"

@implementation JsonTool
/**
 options:
 NSJSONReadingMutableContainers 返回  NSMutableDictionary或NSMutableArray
 NSJSONReadingMutableLeaves     返回  NSMutableString
 NSJSONReadingAllowFragments    返回 允许JSON字符串最外层既不是NSArray也不是NSDictionary，但必须是有效的JSON Fragment。例如使用这个选项可以解析 @“123” 这样的字符串。参见： http://www.cnblogs.com/linyc/p/4272060.html
 */

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (NSArray *)arrayWithJsonString:(NSString *)jsonString{
    if (jsonString == nil) {
        return nil ;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSArray *array = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingMutableContainers
                                                      error:&error];
    
    if (array != nil && error == nil){
        return array;
    }else{
        NSLog(@"json解析失败：%@",error);
        // 解析错误
        return nil;
    }
}

+ (id)toNoArrayOrNSDictionaryWithJsonString:(NSString *)jsonString{
    if (jsonString == nil) {
        return nil ;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    
    if (jsonObject != nil && error == nil){
        return jsonObject;
    }else{
        // 解析错误
        NSLog(@"json解析失败：%@",error);
        return nil;
    }
}

+ (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (NSString*)arrayToJson:(NSArray *)array{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}



@end
