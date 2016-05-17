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
    NSTimer *myTimer ;
    NSTimeInterval timeInterval ;
}
@property (weak, nonatomic) IBOutlet UILabel *name_phoneLab;
@property (weak, nonatomic) IBOutlet UITextView *addressTextView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
- (IBAction)gotoPay:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *noticeLab;

@end

@implementation OrderIsOverVC
- (void)viewWillAppear:(BOOL)animated{
    //开启定时器
    [myTimer setFireDate:[NSDate distantPast]];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //关闭定时器
    [myTimer setFireDate:[NSDate distantFuture]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    timeInterval = 0 ;
    self.title = @"下单完成" ;
    self.name_phoneLab.text = _orderOverModel.userName_phone ;
    self.addressTextView.text = _orderOverModel.user_address ;
    self.moneyLab.text = [NSString stringWithFormat:@"¥%.2f",[_orderOverModel.order_goods_price_total floatValue]];
    myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reloadCountDownDate) userInfo:nil repeats:YES];
    
}
- (void)reloadCountDownDate{
    ++timeInterval ;
    [self showCountDownTime];
    
    
}
- (void)showCountDownTime{
    int secondTotal = 24*60*60 - timeInterval ;
    if (secondTotal > 0) {
        int second = secondTotal%60 ;
        int minute = (secondTotal/60)%60 ;
        int hour = (secondTotal/3600)%60 ;
        self.noticeLab.text = [NSString stringWithFormat:@"(%02d : %02d : %02d 后自动关闭订单)",hour,minute,second];
    }
    
}

- (IBAction)gotoPay:(id)sender {
    if (![GHControl isExistNetwork]) {
        HUDNormal(@"服务器无响应，请稍后重试");
        return;
    }
//    //银联
//    RequestCenter *requestCenter = [RequestCenter shareRequestCenter];
//    [requestCenter requestBackStrPostUrl:APP_PAY andDic:@{@"t":@"3",@"pay_sn":_orderOverModel.pay_sn}  setSuccessBlock:^(NSString *resultHtml) {
//        GLOG(@"resultHtml : \n\n\n\n", resultHtml);
//        PayWebView *payWebView = [[PayWebView alloc]init];
//        payWebView.htmlStr = resultHtml ;
//        [self.navigationController pushViewController:payWebView animated:YES];
//    } setFailBlock:^(NSString *errorStr) {
//        
//    }];
    RequestCenter *requestCenter = [RequestCenter shareRequestCenter];
    [requestCenter sendRequestPostUrl:APP_PAY andDic:@{@"t":@"3",@"pay_sn":_orderOverModel.pay_sn} setSuccessBlock:^(NSDictionary *resultDic) {
        if ([resultDic[@"code"] intValue] != 1) {
            HUDNormal(resultDic[@"msg"]);
            BG_LOGIN ;
            return ;
        }
        
        payUrl = resultDic[@"data"][@"url"];
        PayWebView *payWebView = [[PayWebView alloc]init];
        payWebView.urlStr = payUrl ;
        [self.navigationController pushViewController:payWebView animated:YES];
        
    } setFailBlock:^(NSString *errorStr) {
        if (payUrl.length > 6) {
            PayWebView *payWebView = [[PayWebView alloc]init];
            payWebView.urlStr = payUrl ;
            [self.navigationController pushViewController:payWebView animated:YES];
        }
    }];
    
}

- (void)leftNavBtnClick:(UIButton *)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}


@end
