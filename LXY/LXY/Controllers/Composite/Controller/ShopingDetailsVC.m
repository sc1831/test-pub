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
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = YES ;
    RequestCenter *request = [RequestCenter shareRequestCenter];
    [request sendRequestPostUrl:DETAIL_URL andDic:@{@"goods_commonid":self.goods_commonid} setSuccessBlock:^(NSDictionary *resultDic) {
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)leftNavBtnClick:(id)sender {
    if (self.goodsDetails.canGoBack) {
        [self.goodsDetails goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
