//
//  RequestCenter.m
//  LXY
//
//  Created by guohui on 16/3/9.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "RequestCenter.h"
#import "Encryption.h"
#import "SaveInfo.h"
#import "GHControl.h"

#define MD5KEY @"mk"
// mk   加密的数据
@implementation RequestCenter
+ (RequestCenter *)shareRequestCenter{
    @synchronized(self) { //创建一个互斥锁，保证此时没有其它线程对self对象进行修改。这个是objective-c的一个锁定令牌，防止self对象在同一时间内被其它线程访问，起到线程的保护作用。 一般在公用变量的时候使用，如单例模式或者操作类的static变量中使用。
        static RequestCenter *_self ; //局部变量在代码块结束后将不会回收，下次使用保持上次使用后的值；static用在方法与全局变量，表示该方法与全局变量只在本文件中有效，外部无法使用extern引用该全局变量或方法。
        if (!_self) {
            
            _self = [[RequestCenter alloc]init];
        }
        return _self ;
    }
}
#pragma mark - get
-(void)sendRequestGetUrl:(NSMutableString *)myUrl andDic:(NSDictionary *)info_dic setSuccessBlock:(void (^)(NSDictionary *))success_block setFailBlock:(void (^)(NSString *))fail_block{
    HUDSelfStart(@"正在上传数据...");
    NETWORKVIEW(YES);
    [myUrl appendFormat:@"&%@=%@",MD5KEY,[self md5Dic:info_dic]];
    [myUrl appendString:[self md5Dic:info_dic]];
    AFHTTPSessionManager *session_manager = [AFHTTPSessionManager manager];
    NSLog(@"\n%@\n%@\n",myUrl,info_dic);
    
    //TODO: 设置格式
    {
    [session_manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    session_manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain",@"text/html", nil];
    }
//    // 设置请求格式
//    session_manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    // 设置返回格式
//    session_manager.responseSerializer = [AFHTTPResponseSerializer serializer]; //返回为nsdata
    
    session_manager.requestSerializer.timeoutInterval = 8 ; //默认60秒超时
    [session_manager GET:STR_a_ADD_b_(HTTPSERVICE, myUrl) parameters:info_dic progress:^(NSProgress * _Nonnull downloadProgress) {
         NSLog(@"下载进度:%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject:%@",responseObject);
        NETWORKVIEW(NO);
        //TODO:Data转换为Json
//        //data 转化为json
//        NSError *err = nil ;
//        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&err];
//        if (!err) {
//            HUDSelfEnd;
//            if (success_block) {
//                HUDSelfEnd;
//                success_block(resultDic);
//            }
//        }else{
//            if (fail_block) {
//                fail_block([err description]);
//            }
//        }
        HUDSelfEnd;
        if (responseObject) {
            
            success_block(responseObject);
        }else{
            HUDNormal(@"服务器异常");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
        HUDSelfEnd;
        NETWORKVIEW(NO);
        HUDNormal(@"请求失败");
        if (fail_block) {
            fail_block([error description]);
        }
    }];
    
}
- (void)sendRequestPostUrl:(NSString *)myUrl andDic:(NSDictionary *)info_dic setSuccessBlock:(void (^)(NSDictionary *))success_block setFailBlock:(void (^)(NSString *))fail_block{
    HUDSelfStart(@"正在请求数据...");
    NETWORKVIEW(YES);
    
    
    AFHTTPSessionManager *session_manager = [AFHTTPSessionManager manager];
    session_manager.requestSerializer.timeoutInterval = 8 ;//
    {
//    图片上传
//    [session_manager POST:myurl parameters:info_dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        <#code#>
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        <#code#>
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        <#code#>
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        <#code#>
//    }];
    }
    //TODO: 设置格式
    {
//        [session_manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        session_manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain",@"text/html", nil];
    }
        //TODO:测试
    
    NSMutableDictionary *info_mtdic = [[NSMutableDictionary alloc]initWithDictionary:info_dic];
    if([[SaveInfo shareSaveInfo] token] != nil && [[SaveInfo shareSaveInfo] user_id] != nil){
        [info_mtdic setValue:[[SaveInfo shareSaveInfo] token] forKey:TOKEN];
        [info_mtdic setValue:[[SaveInfo shareSaveInfo] user_id] forKey:USER_ID];
    
    }
    //TODO:测试
//    [info_mtdic setValue:@"ceshi1" forKey:@"ceshi1"];
    
    NSMutableDictionary *postMtDic = [[NSMutableDictionary alloc]initWithDictionary:info_mtdic];
    [postMtDic setValue:[self md5Dic:info_mtdic] forKey:MD5KEY];
    
//    [info_dic setValue:[self md5Dic:info_dic] forKey:MD5KEY];
    GLOG(@"inforMD5", postMtDic);
    NSLog(@"%@",STR_a_ADD_b_(HTTPSERVICE, myUrl));
    [session_manager POST:STR_a_ADD_b_(HTTPSERVICE, myUrl) parameters:postMtDic progress:^(NSProgress * _Nonnull uploadProgress) {
        GLOG(@"Post_uploadProgress", uploadProgress);

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        GLOG(@"responseObject", responseObject);
        GLOG(@"信息", [responseObject objectForKey:@"msg"]);
        
        NETWORKVIEW(NO);
        HUDSelfEnd;
 
        if (responseObject) {
            success_block(responseObject);
        }else{
            HUDNormal(@"服务器异常");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        GLOG(@"error", error);
        NETWORKVIEW(NO);
        HUDSelfEnd ;
        HUDNormal(@"请求失败");
        if (fail_block) {
            fail_block([error description]);
        }
    }];

}

- (void)sendRequestImageUrl:(NSString *)myUrl infoDic:(NSDictionary *)info_dict andImageDic:(NSDictionary *)imageDic setSuccessBlock:(void (^)(NSDictionary *))success_block setFailBlock:(void (^)(NSString *))fail_block{
    NETWORKVIEW(YES);
    HUDSelfStart(@"图片正在上传 ...");
    GLOG(@"url", myUrl);
    GLOG(@"dic", info_dict);
    GLOG(@"imageDic", imageDic);
    
    UIImage *image = [imageDic allValues].firstObject;
    image = [self imageWithImage:image scaledToSize:CGSizeMake(120, 120)];
    NSData *myDate = UIImageJPEGRepresentation(image, 1);
    AFHTTPSessionManager *session_manager = [AFHTTPSessionManager manager];
    session_manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain",@"text/html", nil];
    
    [session_manager POST:STR_a_ADD_b_(HTTPSERVICE, myUrl) parameters:info_dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        /**
         *  appendPartWithFileData: 图片的data
                              name: 上传图片的名字
                          fileName: 图片的后缀名
                          mimeType: 上传图片类型
         */
        GLOG(@"formData", formData);
        [formData appendPartWithFileData:myDate name:imageDic.allKeys.firstObject fileName:@".png" mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        GLOG(@"uploadProgress", uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        GLOG(@"responseObject", responseObject);
        NETWORKVIEW(NO);
        HUDSelfEnd;
        if (responseObject) {
            
            success_block(responseObject);
        }else{
            HUDNormal(@"服务器异常");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        GLOG(@"error", error);
        NETWORKVIEW(NO);
        HUDSelfEnd;
        HUDNormal(@"上传失败");
        if (fail_block) {
            fail_block([error description]);
        }
    }];
}

- (void)sendRequestImageUrl:(NSString *)myUrl andImage:(UIImage *)image setSuccessBlock:(void (^)(NSDictionary *resultDic))success_block setFailBlock:(void (^)(NSString *))fail_block{
    NETWORKVIEW(YES);
    HUDSelfStart(@"图片正在上传 ...");
    GLOG(@"url", myUrl);
    GLOG(@"image", image);
    
    //加密
    NSMutableDictionary *info_mtdic = [[NSMutableDictionary alloc]initWithCapacity:0];
    if([[SaveInfo shareSaveInfo] token] != nil && [[SaveInfo shareSaveInfo] user_id] != nil){
        [info_mtdic setValue:[[SaveInfo shareSaveInfo] token] forKey:TOKEN];
        [info_mtdic setValue:[[SaveInfo shareSaveInfo] user_id] forKey:USER_ID];
        
    }
    NSMutableDictionary *postMtDic = [[NSMutableDictionary alloc]initWithDictionary:info_mtdic];
    [postMtDic setValue:[self md5Dic:info_mtdic] forKey:MD5KEY];
    
    image = [self imageWithImage:image scaledToSize:CGSizeMake(120, 120)];
    NSData *myDate = UIImageJPEGRepresentation(image, 1);
    AFHTTPSessionManager *session_manager = [AFHTTPSessionManager manager];
    session_manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain",@"text/html", nil];
    [session_manager POST:STR_a_ADD_b_(HTTPSERVICE, myUrl) parameters:postMtDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        /**
         *  appendPartWithFileData: 图片的data
         name: 上传图片的名字
         fileName: 图片的后缀名
         mimeType: 上传图片类型
         */
        GLOG(@"formData", formData);
        [formData appendPartWithFileData:myDate name:@"img" fileName:@".png" mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        GLOG(@"uploadProgress", uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        GLOG(@"responseObject", responseObject);
        GLOG(@"信息", [responseObject objectForKey:@"message"]);
        NETWORKVIEW(NO);
        HUDSelfEnd;
        if (responseObject) {
            
            success_block(responseObject);
        }else{
            HUDNormal(@"服务器异常");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        GLOG(@"error", error);
        NETWORKVIEW(NO);
        HUDSelfEnd;
        HUDNormal(@"上传失败");
        if (fail_block) {
            fail_block([error description]);
        }
    }];
}


#pragma mark -  对图片尺寸进行压缩
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}




#pragma - 加密 -
- (NSString *)md5Dic:(NSDictionary *)pushDic{
    return [[Encryption shareEncry] getEncryptionStrbyPostDic:pushDic];
}
















@end
