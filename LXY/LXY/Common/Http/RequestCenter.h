//
//  RequestCenter.h
//  LXY
//
//  Created by guohui on 16/3/9.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"
#import "GHAPI.h"
@interface RequestCenter : NSObject

+ (RequestCenter *)shareRequestCenter;

//普通接口
//get
- (void)sendRequestGetUrl:(NSMutableString *)myUrl
                      andDic:(NSDictionary *)info_dic
              setSuccessBlock:(void (^)(NSDictionary *resultDic))success_block
                 setFailBlock:(void (^)(NSString *errorStr))fail_block;
//post
- (void)sendRequestPostUrl:(NSString *)myUrl
                   andDic:(NSDictionary *)info_dic setSuccessBlock:(void (^)(NSDictionary *resultDic))success_block setFailBlock:(void (^)(NSString *errorStr))fail_block;

- (void)requestBackStrPostUrl:(NSString *)myUrl
                    andDic:(NSDictionary *)info_dic setSuccessBlock:(void (^)(NSString *resultHtml))success_block setFailBlock:(void (^)(NSString *errorStr))fail_block;


//单图片的接口
- (void)sendRequestImageUrl:(NSString *)myUrl
               infoDic:(NSDictionary *)info_dict
                    andImageDic:(NSDictionary *)imageDic
            setSuccessBlock:(void (^)(NSDictionary *resultDic))success_block setFailBlock:(void (^)(NSString *errorStr))fail_block ;
- (void)sendRequestImageUrl:(NSString *)myUrl andImage:(UIImage *)imageDic setSuccessBlock:(void (^)(NSDictionary *resultDic))success_block setFailBlock:(void (^)(NSString *errorStr))fail_block ;



@end
