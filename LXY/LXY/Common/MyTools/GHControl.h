//
//  ZCControl.h
//  ControlDemo
//
//  Created by guohui on 14/12/18.
//  Copyright (c) 2014年 guohui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "Common.h"


typedef void (^IMAGE_Completion)(id response);

@interface GHControl : NSObject{

    UIImage *image_return;
}
@property (nonatomic,retain)UIImage *image_return;

///将图片的pathurl,转化成唯一表述的图片名称
+(NSString *)resultPicName:(NSString *)picUrl;
///沙盒路径下，是否有指定的图片(通过图片的唯一名称标示)
+(BOOL)isExistPathFile:(NSString *)picname;

///通过图片的url，block返回图片，并保存本地
+(void)add_image:(NSString *)pathurl completion:(IMAGE_Completion)completion;
///将nsdata 图片数据保存到本地
+(BOOL)savePhotoToNativeWithImage:(NSData *) imageData andPicName:(NSString *)name;


#pragma mark --判断设备型号
+(NSString *)platformString;
#pragma mark --创建Label
+(UILabel*)createLabelWithFrame:(CGRect)frame Font:(int)font Text:(NSString*)text;
#pragma mark --创建View
+(UIView*)viewWithFrame:(CGRect)frame;
#pragma mark --创建imageView
+(UIImageView*)createImageViewWithFrame:(CGRect)frame ImageName:(NSString*)imageName;
#pragma mark --创建button
+(UIButton*)createButtonWithFrame:(CGRect)frame ImageName:(NSString*)imageName Target:(id)target Action:(SEL)action Title:(NSString*)title;
#pragma mark --创建UITextField
+(UITextField*)createTextFieldWithFrame:(CGRect)frame placeholder:(NSString*)placeholder passWord:(BOOL)YESorNO leftImageView:(UIImageView*)imageView rightImageView:(UIImageView*)rightImageView Font:(float)font;

//适配器的方法  扩展性方法
//现有方法，已经在工程里面存在，如果修改工程内所有方法，工作量巨大，就需要使用适配器的方法
+(UITextField*)createTextFieldWithFrame:(CGRect)frame placeholder:(NSString*)placeholder passWord:(BOOL)YESorNO leftImageView:(UIImageView*)imageView rightImageView:(UIImageView*)rightImageView Font:(float)font backgRoundImageName:(NSString*)imageName;
#pragma mark 创建UIScrollView
+(UIScrollView*)makeScrollViewWithFrame:(CGRect)frame andSize:(CGSize)size;
#pragma mark 创建UIPageControl
+(UIPageControl*)makePageControlWithFram:(CGRect)frame;
#pragma mark 创建UISlider
+(UISlider*)makeSliderWithFrame:(CGRect)rect AndImage:(UIImage*)image;
#pragma mark 创建时间转换字符串
+(NSString *)stringFromDateWithHourAndMinute:(NSDate *)date;
#pragma mark --判断导航的高度64or44
+(float)isIOS7;

#pragma mark 内涵图需要的方法
+ (NSString *)stringDateWithTimeInterval:(NSString *)timeInterval;

+ (CGFloat)textHeightWithString:(NSString *)text width:(CGFloat)width fontSize:(NSInteger)fontSize;

+ (NSString *)addOneByIntegerString:(NSString *)integerString;


#pragma mark - 图片 - 
+ (UIImage *)getLocalPngImge:(NSString *)imageName ;
+ (UIImage *)getLocalJPGImage:(NSString *)ImageName ;
/**延迟指定的秒数，执行block代码块 */
+ (void)performBlockOnMainThread:(void (^)())block
                withDelaySeconds:(float)delayInSeconds;
+ (void)performBlockOnGlobalThread:(void (^)())block
                  withDelaySeconds:(float)delayInSeconds;

//拨打电话
+(UIWebView*)makeTelPhoneNum;


///手机号码正则法则
//+ (BOOL)lengalPhoneNumber:(NSString *)numStr;
///姓名
//+ (BOOL)validateIdentityCard:(NSString *)identityCard;
//隐藏空白单元格
+(void)setExtraCellLineHidden:(UITableView *)tableView;
//位置信息清空
+(void)defultsForEmpty;
/**
 *  判断有无网络
 */
+ (BOOL)isExistNetwork;
+(BOOL)isNetworkWIFI;


@end
