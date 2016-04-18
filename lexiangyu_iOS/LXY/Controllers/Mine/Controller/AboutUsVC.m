

//
//  AboutUsVC.m
//  LXY
//
//  Created by guohui on 16/4/15.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "AboutUsVC.h"

@interface AboutUsVC ()<UIWebViewDelegate>

@end

@implementation AboutUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"关于我们" ;
}

- (void)loadWebView{
//    NSURL *url = [[NSURL alloc]initWithString:goods_detail_url];
//    
//    [(UIScrollView *)[[self.goodsDetails subviews] objectAtIndex:0]setBounces:NO];//禁止拖动时反弹
//    self.goodsDetails.scalesPageToFit = NO ;
//    [self.goodsDetails loadRequest:[NSURLRequest requestWithURL:url]];
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
    
    return YES;
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

@end
