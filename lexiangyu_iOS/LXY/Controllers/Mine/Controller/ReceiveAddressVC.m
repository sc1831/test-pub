//
//  ReceiveAddressVC.m
//  LXY
//
//  Created by guohui on 16/3/16.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "ReceiveAddressVC.h"
#import "ChooseCityVC.h"
#import "UIButton+Block.h"
#import "GHControl.h"
#import "RequestCenter.h"
#import "SaveInfo.h"

@interface ReceiveAddressVC ()

@property (nonatomic )BOOL isReceiveAddressClick;
//收货人
@property (weak, nonatomic) IBOutlet UITextField *getCargoNameTextField;
//收货人联系方式
@property (weak, nonatomic) IBOutlet UITextField *getCargoPhoneTextField;
//收货人详细地址
@property (weak, nonatomic) IBOutlet UITextField *getCargoAddressTextField;
//选择位置城市
- (IBAction)chooseCity:(id)sender;
//位置城市名称
@property (weak, nonatomic) IBOutlet UILabel *receiveAddressCityName;
//提交审核按钮
@property (weak, nonatomic) IBOutlet UIButton *submitAuditButton;

@end

@implementation ReceiveAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收货地址" ;
    
    __weak ReceiveAddressVC *weakSelf = self;
    [_submitAuditButton setOnButtonPressedHandler:^{
        ReceiveAddressVC *strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf submitAuditButtonClick];
        }
    }];
    
    
    //给位置城市赋值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveAddressCityName:) name:@"receiveAddressCityName" object:nil];
    [self sendRequestAddressData];
    
}
-(void)sendRequestAddressData{
    
    RequestCenter * request = [RequestCenter shareRequestCenter];
    NSDictionary *postDic = @{
                              @"user_id":[[SaveInfo shareSaveInfo]user_id]
                              };
    
    [request sendRequestPostUrl:MY_ADDRESS andDic:postDic setSuccessBlock:^(NSDictionary *resultDic) {
        if ([resultDic[@"code"] intValue] != 1) {
            BG_LOGIN ;
            return ;
        }
        if ([resultDic[@"code"] intValue]==0) {
            HUDNormal(@"数据请求失败，请稍后再试");
            return ;
        }
        
        NSDictionary *dic = resultDic[@"data"];
        
        _getCargoNameTextField.text = dic[@"true_name"];
        _getCargoPhoneTextField.text = dic[@"mob_phone"];
        _receiveAddressCityName.text = dic[@"area_info"];
        
        //        _shopName.text = dic[@"shop_name"];
        //        _phoneNum = dic[@"member_phone"];
        //        _iphoneMut = [[NSMutableString alloc] initWithString:dic[@"member_phone"]];
        //        [_iphoneMut replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        //        _phoneNumLabel.text = _iphoneMut;
        
        
    } setFailBlock:^(NSString *errorStr) {
        
    }];
}

//提交审核按钮点击
-(void)submitAuditButtonClick{
    NSLog(@"提交审核按钮点击");
//    [self.navigationController popViewControllerAnimated:YES];
    [self sendRequestData];

}
//给位置城市赋值
-(void)receiveAddressCityName:(NSNotification *)nsnotification{

    NSDictionary *dict = nsnotification.userInfo;
    _receiveAddressCityName.text = dict[@"receiveAddressCityName"];
    
}

//选择位置城市
- (IBAction)chooseCity:(id)sender {
    [GHControl defultsForEmpty];
    _isReceiveAddressClick = YES;
    ChooseCityVC *chooseVC = [[ChooseCityVC alloc]init];
    chooseVC.isReceiveAddressClick = YES;
    [self.navigationController pushViewController:chooseVC animated:YES];
}
-(void)sendRequestData{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *provinceName =  [defaults objectForKey:@"province_name"];
    NSString *provinceId =  [defaults objectForKey:@"province_id"];
    
    NSString *cityName =  [defaults objectForKey:@"city_name"];
    NSString *cityId = [defaults objectForKey:@"city_id"];
    
    NSString *countyName =  [defaults objectForKey:@"county_name"];
    NSString *countyId =  [defaults objectForKey:@"county_id"];
    
    NSString *townName =  [defaults objectForKey:@"town_name"];
    NSString *townId =  [defaults objectForKey:@"town_id"];
    
    NSString *villageName =  [defaults objectForKey:@"village_name"];
    NSString *villageId =  [defaults objectForKey:@"village_id"];
    
    
    if ([_getCargoNameTextField.text length]<1) {
        HUDNormal(@"请输入收货人姓名");
        return;
    }
    if ([_getCargoPhoneTextField.text length]<1) {
        HUDNormal(@"请输入联系电话");
        return;
    }
    if ([_getCargoAddressTextField.text length]<1) {
        HUDNormal(@"请输入详细地址");
        return;
    }
    
    if (![GHControl validateIdentityCard:_getCargoNameTextField.text]) {
        HUDNormal(@"请输入正确的姓名");
        return;
    }
    if (![GHControl lengalPhoneNumber:_getCargoPhoneTextField.text]) {
        HUDNormal(@"请输入正确的手机号");
        return;
    }
    
  RequestCenter  *request = [RequestCenter shareRequestCenter];
    NSDictionary *postDic = @{@"user_id":[[SaveInfo shareSaveInfo]user_id],
                              @"province_id":provinceId,
                              @"province":provinceName,
                              @"city_id":cityId,
                              @"city":cityName,
                              @"area_id":countyId,
                              @"area":countyName,
                              @"town_id":townId,
                              @"town":townName,
                              @"village_id":villageId,
                              @"village":villageName,
                              @"true_name":_getCargoNameTextField.text,
                              @"mob_phone":_getCargoPhoneTextField.text,
                              @"areainfo":_getCargoAddressTextField.text};
    
    [request sendRequestPostUrl:MY_EDIT_ADDRESS andDic:postDic setSuccessBlock:^(NSDictionary *resultDic) {
        if ([resultDic[@"code"] intValue] != 1) {
            BG_LOGIN ;
            return ;
        }
        if ([resultDic[@"code"] intValue]==0) {
            HUDNormal(@"修改失败，请稍后再试");
            return ;
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveAddressCityNameAndPhoneNum" object:self userInfo:nil];
        [self popView];

    } setFailBlock:^(NSString *errorStr) {
        NSLog(@"");
        
    }];
}

-(void)popView{
[self.navigationController popViewControllerAnimated:YES];
}
@end
