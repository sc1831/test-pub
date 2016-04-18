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

@interface ShopingDetailsVC ()<UIWebViewDelegate>
{
    NSString *goods_detail_url ;

}
@property (weak, nonatomic) IBOutlet UIWebView *goodsDetails;
- (IBAction)leftNavBtnClick:(id)sender;

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

//    self.navigationController.navigationBarHidden = YES ;
    

    
    RequestCenter *request = [RequestCenter shareRequestCenter];
    [request sendRequestPostUrl:DETAIL_URL andDic:@{@"goods_id":self.goods_commonid} setSuccessBlock:^(NSDictionary *resultDic) {
        if ([[resultDic[@"code"] stringValue]isEqualToString:@"1"]) {
            goods_detail_url = STR_A_B(@"http://", resultDic[@"data"][@"goods_detail_url"]);
            [self loadWebView];

            
        }else{
            HUDNormal(@"商品信息正在维护");
            [self.navigationController popViewControllerAnimated:YES];
        }
    } setFailBlock:^(NSString *errorStr) {
            HUDNormal(@"商品信息正在维护");
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
        confirmVC.goodsIds = mutArray[0][1];
        confirmVC.goodsNum = mutArray[1][1];
        confirmVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:confirmVC animated:YES];
        
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
@end
