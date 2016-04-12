//
//  Encryption.h
//  LXY
//
//  Created by guohui on 16/3/28.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Encryption : NSObject
+ (Encryption *)shareEncry ;
- (NSString *)getEncryptionStrbyPostDic:(NSDictionary *)dic ;

@end
