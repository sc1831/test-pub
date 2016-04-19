

//
//  AboutUsVC.m
//  LXY
//
//  Created by guohui on 16/4/15.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "AboutUsVC.h"
#import "GHAPI.h"
#import "Common.h"
#import "RequestCenter.h"
@interface AboutUsVC ()<UIWebViewDelegate>
{
    NSString *webUrlStr ;
}
@property (weak, nonatomic) IBOutlet UIWebView *aboutWebView;

- (IBAction)leftNavBtnClick:(id)sender;

@end

@implementation AboutUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"关于我们" ;
//    RequestCenter *request = [RequestCenter shareRequestCenter];
//    [request sendRequestPostUrl:ABOUT_US andDic:nil setSuccessBlock:^(NSDictionary *resultDic) {
//        if ([[resultDic[@"code"] stringValue]isEqualToString:@"1"]) {
//            webUrlStr = resultDic[@"data"][@"url"];
//            [self loadWebView];
//        }else{
//            HUDNormal(@"商品信息正在维护");
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//    } setFailBlock:^(NSString *errorStr) {
//        HUDNormal(@"商品信息正在维护");
//        [self.navigationController popViewControllerAnimated:YES];
//    }];
    webUrlStr = ABOUT_US ;
    [self loadWebView];
}

- (void)loadWebView{
    NSURL *url = [[NSURL alloc]initWithString:webUrlStr];
    [(UIScrollView *)[[self.aboutWebView subviews] objectAtIndex:0]setBounces:NO];//禁止拖动时反弹
    self.aboutWebView.scalesPageToFit = NO ;
    [self.aboutWebView loadRequest:[NSURLRequest requestWithURL:url]];
    
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

- (IBAction)leftNavBtnClick:(id)sender {
    if (self.aboutWebView.canGoBack) {
        [self.aboutWebView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
