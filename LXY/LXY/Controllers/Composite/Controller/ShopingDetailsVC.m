//
//  ShopingDetailsVC.m
//  LXY
//
//  Created by guohui on 16/3/23.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "ShopingDetailsVC.h"
#import "Common.h"
#import "GHAPI.h"
#import "RequestCenter.h"
#import "GoodsModel.h"
#import "ConfirmorderVC.h"
#import "LoginVC.h"
#import "GHControl.h"

#import "UMSocialSnsService.h"
#import "UMSocialSnsPlatformManager.h"
@interface ShopingDetailsVC ()<UIWebViewDelegate,UMSocialUIDelegate>
{
    NSString *goods_detail_url ;

}
@property (weak, nonatomic) IBOutlet UIWebView *goodsDetails;
- (IBAction)leftNavBtnClick:(id)sender;
- (IBAction)showShareView:(id)sender;

@end

@implementation ShopingDetailsVC
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO ;
}
- (void)viewWillAppear:(BOOL)animated{
   self.navigationController.navigationBarHidden = YES ;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品详情" ;
    // Do any additional setup after loading the view from its nib.

//    self.navigationController.navigationBarHidden = YES ;
    
    if (![GHControl isExistNetwork]) {
        HUDNormal(@"服务器无响应，请稍后再试");
        return;
    }
    
    RequestCenter *request = [RequestCenter shareRequestCenter];
    [request sendRequestPostUrl:DETAIL_URL andDic:@{@"goods_id":self.goods_commonid} setSuccessBlock:^(NSDictionary *resultDic) {
        
        if ([resultDic[@"msg"] isEqualToString:@"Hacker"]) {
            LoginVC *login = [[LoginVC alloc]init];
            [self presentViewController:login animated:YES completion:nil];
            return ;
        }
        if ([[resultDic[@"code"] stringValue]isEqualToString:@"1"]) {
            goods_detail_url = STR_A_B(@"http://", resultDic[@"data"][@"goods_detail_url"]);
            [self loadWebView];

            
        }else{
            HUDNormal(resultDic[@"msg"]);
            [self.navigationController popViewControllerAnimated:YES];
        }
    } setFailBlock:^(NSString *errorStr) {
            HUDNormal(@"服务器无响应，请稍后再试");
        [self.navigationController popViewControllerAnimated:YES];
    }];

}
- (void)loadWebView{
    NSURL *url = [[NSURL alloc]initWithString:goods_detail_url];
    
    [(UIScrollView *)[[self.goodsDetails subviews] objectAtIndex:0]setBounces:NO];//禁止拖动时反弹
    self.goodsDetails.scalesPageToFit = NO ;
    [self.goodsDetails loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"webViewDidStartLoad");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"webViewDidFinishLoad");

}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"didFailLoadWithError");
}
- (BOOL)webView: (UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest
                                                                  *)request navigationType:(UIWebViewNavigationType)navigationType{
    //http://www.lexianyu.com/index.php/app/goods/confirm?super_key=1&user_id=52267&goods_id=106255&goods_num=1
    
    NSLog(@"request.URL.relativeString:%@",request.URL.relativeString);

    
    if ([request.URL.relativeString rangeOfString:@"super_key"].location == NSNotFound) {
        
        NSMutableString *mutStr =[NSMutableString stringWithString:request.URL.relativeString];
        
        NSArray *array = [mutStr componentsSeparatedByString:@"?"];
        NSString *str = array[1];
        
        
        NSArray *subArray = [str componentsSeparatedByString:@"&"];
        NSMutableArray *mutArray = [NSMutableArray array];
        for (NSMutableString *subStr in subArray) {
         NSArray *allArray = [subStr componentsSeparatedByString:@"="];
            [mutArray addObject:allArray];
        }
        ConfirmorderVC *confirmVC = [[ConfirmorderVC alloc]init];
        confirmVC.orderIds = @"";
        confirmVC.cartIds = @"";
        confirmVC.pay_sn = @"" ;
        confirmVC.goodsIds = mutArray[0][1];
        confirmVC.goodsNum = mutArray[1][1];
        confirmVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:confirmVC animated:YES];
        
        return NO ;
        
    }
    
   
    
    
    return YES;
}


- (IBAction)leftNavBtnClick:(id)sender {
    if (self.goodsDetails.canGoBack) {
        [self.goodsDetails goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - 分享
- (IBAction)showShareView:(id)sender {

        NSString *shareText = @"友盟社会化组件可以让移动应用快速具备社会化分享、登录、评论、喜欢等功能，并提供实时、全面的社会化数据统计分析服务。 http://www.lexianyu.com";             //分享内嵌文字
        //    UIImage *shareImage = [UIImage imageNamed:@"UMS_social_demo"];          //分享内嵌图片
        UIImage *shareImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"UMS_social_demo" ofType:@"png"]];
        //调用快速分享接口
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:@"56e7735e67e58e3d78001181"
                                          shareText:shareText
                                         shareImage:shareImage
                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToWechatTimeline,UMShareToQzone,UMShareToWechatSession,UMShareToWechatFavorite,nil]
                                           delegate:self];


        //    [NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToQQ,UMShareToQzone,UMShareToDouban,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite, nil];
    
    
}
@end
