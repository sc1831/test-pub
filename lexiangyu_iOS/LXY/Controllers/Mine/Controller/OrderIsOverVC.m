//
//  OrderIsOverVC.m
//  LXY
//
//  Created by guohui on 16/4/19.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "OrderIsOverVC.h"
#import "OrderModel.h"
#import "Common.h"
#import "RequestCenter.h"
//#import "OrderSuccessVC.h"
#import "PayWebView.h"
#import "GHControl.h"

@interface OrderIsOverVC ()
{
    NSString *payUrl ;
}
@property (weak, nonatomic) IBOutlet UILabel *name_phoneLab;
@property (weak, nonatomic) IBOutlet UITextView *addressTextView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
- (IBAction)gotoPay:(id)sender;

@end

@implementation OrderIsOverVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"下单完成" ;
    self.name_phoneLab.text = _orderOverModel.userName_phone ;
    self.addressTextView.text = _orderOverModel.user_address ;
    self.moneyLab.text = [NSString stringWithFormat:@"¥ %.2f",[_orderOverModel.order_goods_price_total floatValue]];
    
}

- (IBAction)gotoPay:(id)sender {
    if (![GHControl isExistNetwork]) {
        HUDNormal(@"服务器无响应，请稍后重试");
        return;
    }
    RequestCenter *requestCenter = [RequestCenter shareRequestCenter];
    [requestCenter requestBackStrPostUrl:APP_PAY andDic:@{@"t":@"2",@"pay_sn":_orderOverModel.pay_sn}  setSuccessBlock:^(NSString *resultHtml) {
        GLOG(@"resultHtml : \n\n\n\n", resultHtml);
        PayWebView *payWebView = [[PayWebView alloc]init];
        payWebView.htmlStr = resultHtml ;
        [self.navigationController pushViewController:payWebView animated:YES];
        
    } setFailBlock:^(NSString *errorStr) {
        
    }];
//    [requestCenter sendRequestPostUrl:APP_PAY andDic:@{@"t":@"2",@"pay_sn":_orderOverModel.pay_sn} setSuccessBlock:^(NSDictionary *resultDic) {
//        if ([resultDic[@"code"] intValue] != 1) {
//            HUDNormal(resultDic[@"msg"]);
//            BG_LOGIN ;
//            return ;
//        }
//        
//        payUrl = resultDic[@"data"][@"url"];
//        PayWebView *payWebView = [[PayWebView alloc]init];
//        payWebView.urlStr = payUrl ;
//        [self.navigationController pushViewController:payWebView animated:YES];
//        
//    } setFailBlock:^(NSString *errorStr) {
//        if (payUrl.length > 6) {
//            PayWebView *payWebView = [[PayWebView alloc]init];
//            payWebView.urlStr = payUrl ;
//            [self.navigationController pushViewController:payWebView animated:YES];
//        }
//    }];
    
}
@end
