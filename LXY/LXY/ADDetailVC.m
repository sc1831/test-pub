//
//  ADDetailVC.m
//  LXY
//
//  Created by guohui on 16/5/17.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "ADDetailVC.h"
#import "LoginVC.h"
#import "MainTabBar.h"
@interface ADDetailVC ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *adDetailsWebView;
- (IBAction)leftNavBarClick:(id)sender;

@end

@implementation ADDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadWebView];
}
- (void)loadWebView{
    NSURL *url = [[NSURL alloc]initWithString:self.adUrlStr];
    
    [(UIScrollView *)[[self.adDetailsWebView subviews] objectAtIndex:0]setBounces:NO];//禁止拖动时反弹
    self.adDetailsWebView.scalesPageToFit = NO ;
    [self.adDetailsWebView loadRequest:[NSURLRequest requestWithURL:url]];
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
- (BOOL)webView: (UIWebView *)webView shouldStartLoadWithRequest:(nonnull NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES ;
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

- (IBAction)leftNavBarClick:(id)sender {
    if (self.adDetailsWebView.canGoBack) {
        [self.adDetailsWebView goBack];
    }else{
        [self gotoVC];
    }
}

- (void)gotoVC{    
    MainTabBar *mainVC = [[MainTabBar alloc]init];
    [self presentViewController:mainVC animated:YES completion:nil];
}

@end
