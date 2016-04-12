

//
//  Encryption.m
//  LXY
//
//  Created by guohui on 16/3/28.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "Encryption.h"
#import "SaveInfo.h"
#import <CommonCrypto/CommonDigest.h>
#define TEST @"test"

@implementation Encryption
+ (Encryption *)shareEncry{
    static Encryption *encryption = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        encryption = [[self alloc] init];
    });
    return encryption ;
}


//转化为大写 MD532位加密
- (NSString *)getEncryptionStrbyPostDic:(NSDictionary *)dic{
    NSMutableString *mtStr = [NSMutableString stringWithCapacity:0];
    NSArray *keyArray = [[NSArray arrayWithArray:dic.allKeys] sortedArrayUsingSelector:@selector(compare:)];
    for (NSString *key in keyArray) {
        [mtStr appendString:[NSString stringWithFormat:@"%@%@",key,[dic objectForKey:key]]];
    }
    //TODO:添加token 和 test
    if ([SaveInfo shareSaveInfo].token.length > 0) {
        [mtStr appendString:[SaveInfo shareSaveInfo].token];
    }
    [mtStr appendString:TEST];
    NSString *str = [mtStr uppercaseString];
    NSLog(@"mtStr:%@",str);
    
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    NSMutableString *mtString = [NSMutableString stringWithCapacity:0];
    NSLog(@"result:%s",result);
    for (int i = 0; i < 16; i ++) {
        [mtString appendString:[NSString stringWithFormat:@"%02x",result[i]]];
    }
    NSLog(@"mtString:%@",mtString);
    return mtString;
    //    CC_MD5(@"",@"",@"");
}


@end
