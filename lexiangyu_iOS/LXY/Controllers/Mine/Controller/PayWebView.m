//
//  PayWebView.m
//  LXY
//
//  Created by guohui on 16/4/21.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "PayWebView.h"

@interface PayWebView ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *payWebView;
- (IBAction)leftNavClick:(id)sender;

@end

@implementation PayWebView
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO ;
}
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES ;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"支付" ;
    [self loadWebView];
}
- (void)loadWebView{

    
    [(UIScrollView *)[[self.payWebView subviews] objectAtIndex:0]setBounces:NO];//禁止拖动时反弹
    self.payWebView.scalesPageToFit = NO ;
//    [self.payWebView loadHTMLString:self.htmlStr baseURL:[NSURL URLWithString:@""]];
    [self.payWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
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
    
//    if ([request.URL.relativeString rangeOfString:@"super_key"].location == NSNotFound) {
//        
//        NSMutableString *mutStr =[NSMutableString stringWithString:request.URL.relativeString];
//        
//        NSArray *array = [mutStr componentsSeparatedByString:@"?"];
//        NSString *str = array[1];
//        
//        
//        NSArray *subArray = [str componentsSeparatedByString:@"&"];
//        NSMutableArray *mutArray = [NSMutableArray array];
//        for (NSMutableString *subStr in subArray) {
//            NSArray *allArray = [subStr componentsSeparatedByString:@"="];
//            [mutArray addObject:allArray];
//        }
////        ConfirmorderVC *confirmVC = [[ConfirmorderVC alloc]init];
////        confirmVC.orderIds = @"";
////        confirmVC.cartIds = @"";
////        confirmVC.goodsIds = mutArray[0][1];
////        confirmVC.goodsNum = mutArray[1][1];
////        confirmVC.hidesBottomBarWhenPushed = YES;
////        [self.navigationController pushViewController:confirmVC animated:YES];
//        return NO ;
//        
//    }
    
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

- (IBAction)leftNavClick:(id)sender {
    if (self.payWebView.canGoBack) {
        [self.payWebView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
