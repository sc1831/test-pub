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
    // Do any additional setup after loading the view from its nib.
    self.title = @"下单完成" ;
    self.name_phoneLab.text = _orderOverModel.userName_phone ;
    self.addressTextView.text = _orderOverModel.user_address ;
    self.moneyLab.text = [NSString stringWithFormat:@"¥ %.2f",[_orderOverModel.order_goods_price_total floatValue]];
    
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

- (IBAction)gotoPay:(id)sender {
    RequestCenter *requestCenter = [RequestCenter shareRequestCenter];
    [requestCenter sendRequestPostUrl:APP_PAY andDic:@{@"t":@"3",@"pay_sn":_orderOverModel.pay_sn} setSuccessBlock:^(NSDictionary *resultDic) {
        if ([resultDic[@"code"] intValue] != 1) {
            HUDNormal(resultDic[@"msg"]);
            BG_LOGIN ;
            return ;
        }
        payUrl = resultDic[@"url"];
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
@end
