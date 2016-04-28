//
//  DetailAddressVC.m
//  LXY
//
//  Created by guohui on 16/4/15.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "DetailAddressVC.h"
#import "DeatilAddressView.h"
#import "Common.h"
#import "GHControl.h"
#import "ReceiveAddressVC.h"
#import "RequestCenter.h"
#import "SaveInfo.h"
#import "UIButton+Block.h"

@interface DetailAddressVC ()

@end

@implementation DetailAddressVC
{

    DeatilAddressView *headTabView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收货地址";
    self.view.backgroundColor = RGBCOLOR(241, 245, 246);
   
    [self createView];
    [self.view addSubview:headTabView];
    //给位置城市赋值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveAddressCityNameAndPhoneNum:) name:@"receiveAddressCityNameAndPhoneNum" object:nil];
    [self sendRequestData];
    
}
-(void)createView{

    //添加表头
    headTabView =
    [[[NSBundle mainBundle] loadNibNamed:@"DeatilAddressView"
                                   owner:self
                                 options:nil] firstObject];
    headTabView.frame = CGRectMake(0,72,M_WIDTH, 84);
    
    
    //收货地址编辑
    headTabView.changeAdressBtn.userInteractionEnabled = NO;
//    [headTabView.changeAdressBtn setBackgroundImage:[UIImage imageNamed:@"编辑_点击"] forState:UIControlStateHighlighted];
//    [headTabView.changeAdressBtn setBackgroundImage:[UIImage imageNamed:@"编辑_默认"] forState:UIControlStateNormal];
    
    __weak DetailAddressVC *weakSelf = self;
    [headTabView.changeAdressBtn setOnButtonPressedHandler:^{
        DetailAddressVC *strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf changeAddressBtnClick];
        }
    }];
}
-(void)receiveAddressCityNameAndPhoneNum:(NSNotification *)notifition{
    
    [self sendRequestData];
    
}
-(void)changeAddressBtnClick{
    NSUserDefaults *define = [NSUserDefaults standardUserDefaults];
    [define setObject:@"1" forKey:@"isNewPhone"];
    ReceiveAddressVC *receiveVC = [[ReceiveAddressVC alloc]init];
    receiveVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:receiveVC animated:YES];
    
}

-(void)sendRequestData{
    
    if (![GHControl isExistNetwork]) {
        HUDNormal(@"服务器无响应，请稍后重试");

        return;
    }
    RequestCenter * request = [RequestCenter shareRequestCenter];
    NSDictionary *postDic = @{
                              @"user_id":[[SaveInfo shareSaveInfo]user_id]
                              };
    
    [request sendRequestPostUrl:MY_ADDRESS andDic:postDic setSuccessBlock:^(NSDictionary *resultDic) {
        if ([resultDic[@"code"] intValue] != 1) {
            BG_LOGIN ;
             HUDNormal(@"请求失败");
            return ;
        }

        
        NSDictionary *dic = resultDic[@"data"];
        
        headTabView.nameLabel.text = dic[@"true_name"];
        headTabView.phoneNum.text = dic[@"mob_phone"];
        headTabView.addressLabel.text = dic[@"ress"];
        
//        _shopName.text = dic[@"shop_name"];
//        _phoneNum = dic[@"member_phone"];
//        _iphoneMut = [[NSMutableString alloc] initWithString:dic[@"member_phone"]];
//        [_iphoneMut replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
//        _phoneNumLabel.text = _iphoneMut;
    
        
    } setFailBlock:^(NSString *errorStr) {

    }];
}
@end
