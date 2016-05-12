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

        NSString *shareText = @"乐村淘是中国第一家村镇O2O电商平台，是互联网+传统农村市场的大平台，乐村淘";             //分享内嵌文字
        //    UIImage *shareImage = [UIImage imageNamed:@"UMS_social_demo"];          //分享内嵌图片
        UIImage *shareImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"UMS_social_demo" ofType:@"png"]];
        //调用快速分享接口
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:@"56e7735e67e58e3d78001181"
                                          shareText:shareText
                                         shareImage:shareImage
                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQQ,UMShareToQzone,nil]
                                           delegate:self];

    
    
//    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
//                                        @"http://www.baidu.com/img/bdlogo.gif"];
    
    //仅支持一个平台
//    [[UMSocialDataService defaultDataService]  postSNSWithTypes:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQQ,UMShareToQzone,nil] content:shareText image:shareImage location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
//        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
//            NSLog(@"分享成功！");
//        }
//    }];
    
    
    
    
//直接分享接口，分享过程没有分享编辑页，适用于希望直接在后台进行分享或希望自定义分享编辑页的开发者
    //仅支持一个平台
//    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:@"qq分享文字" image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
//        if (response.responseCode == UMSResponseCodeSuccess) {
//            NSLog(@"qq分享成功！");
//        }
//    }];

}

//实现回调方法（可选）：
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}



@end
