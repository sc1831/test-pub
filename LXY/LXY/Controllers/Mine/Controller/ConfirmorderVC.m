//
//  ConfirmorderVC.m
//  LXY
//
//  Created by guohui on 16/3/15.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "ConfirmorderVC.h"
#import "CashierDesk.h"
#import "Common.h"

@interface ConfirmorderVC ()

//手机号
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
//收货地址
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
//商品地址
@property (weak, nonatomic) IBOutlet UILabel *shopAddress;
//商品图片
@property (weak, nonatomic) IBOutlet UIImageView *shopImage;
//商品名称
@property (weak, nonatomic) IBOutlet UILabel *shopName;
//价位
@property (weak, nonatomic) IBOutlet UILabel *weightMoney;
//总价位
@property (weak, nonatomic) IBOutlet UILabel *allMoney;
//购买数量
@property (weak, nonatomic) IBOutlet UILabel *number;
//合计
@property (weak, nonatomic) IBOutlet UILabel *combinedMoney;
//商品共计数量
@property (weak, nonatomic) IBOutlet UILabel *allNumber;
//底部商品共计件数
@property (weak, nonatomic) IBOutlet UILabel *bootmAllNum;
//底部商品合计
@property (weak, nonatomic) IBOutlet UILabel *bootmMoney;




//支付方式
- (IBAction)paryMoneyClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIControl *subMitBtn;

- (IBAction)subMitClick:(id)sender;
@end

@implementation ConfirmorderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认订单" ;
    
}


- (IBAction)paryMoneyClick:(id)sender {
    NSLog(@"银联支付");
}
- (IBAction)subMitClick:(id)sender {
    //提交订单
    
    CashierDesk *cashVC = [[CashierDesk alloc]init];
    cashVC.allMoneyStr = _bootmMoney.text;
    [self.navigationController pushViewController:cashVC animated:YES];
}
@end
