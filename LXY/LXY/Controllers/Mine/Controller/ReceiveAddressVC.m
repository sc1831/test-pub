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

#import "ChooseTownVC.h"

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
{

    NSString *provinceName;
    NSString *provinceId ;
    
    NSString *cityName ;
    NSString *cityId ;
    
    NSString *countyName ;
    NSString *countyId ;
    
    NSString *townName ;
    NSString *townId ;
    
    NSString *villageName ;
    NSString *villageId;
    
    NSString *addressId;
}
-(void)viewWillAppear:(BOOL)animated{

    
}
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
        addressId = dic[@"address_id"];
        
        provinceName = dic[@"province_name"];
        cityName =  dic[@"city_name"];
        countyName =  dic[@"county_name"];



        provinceId =  dic[@"province_id"];
        cityId = dic[@"city_id"];
        countyId =  dic[@"area_id"];
        townId =  dic[@"town_id"];
        villageId =  dic[@"village_id"];
        
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
    [_getCargoAddressTextField resignFirstResponder];
    [_getCargoNameTextField resignFirstResponder];
    [_getCargoPhoneTextField resignFirstResponder];
//    [self.navigationController popViewControllerAnimated:YES];
    [self sendRequestData];

}
//给位置城市赋值
-(void)receiveAddressCityName:(NSNotification *)nsnotification{

    NSDictionary *dict = nsnotification.userInfo;
    _receiveAddressCityName.text = [NSString stringWithFormat:@"%@ %@ %@ %@",provinceName,cityName,countyName,dict[@"receiveAddressCityName"]];
    
    
}

//选择位置城市
- (IBAction)chooseCity:(id)sender {
    [GHControl defultsForEmpty];
    _isReceiveAddressClick = YES;

        
        
        if (![GHControl isExistNetwork]) {
            HUDNormal(@"服务器无响应，请稍后重试");
            
            return;
        }
        
        RequestCenter * request = [RequestCenter shareRequestCenter];
        NSDictionary *postDic = @{@"parent_id":countyId,
                                  @"region":@"town",
                                  };
        
        [request sendRequestPostUrl:GET_CITY_ADDRESS andDic:postDic setSuccessBlock:^(NSDictionary *resultDic) {
            
            if ([resultDic[@"code"] intValue] != 1) {
                BG_LOGIN ;
                return ;
            }
            
            GLOG(@"---------post:", resultDic);
            if ([resultDic[@"code"] intValue]==0) {
                HUDNormal(@"数据请求失败，请稍后再试");
                return ;
            }
            NSArray *array = resultDic[@"data"];
            if (array.count==0) {
                HUDNormal(@"您所在的区域暂时没有其它可以选择的地址");
                return;
            }else{
                ChooseTownVC *chooseVC = [[ChooseTownVC alloc]init];
                chooseVC.receiveAddressClick = YES;
                chooseVC.townId = countyId;
                chooseVC.isAddressClick = YES;
                [self.navigationController pushViewController:chooseVC animated:YES];
                
            }
            

        } setFailBlock:^(NSString *errorStr) {
            NSLog(@"");
            
        }];
    
    
}
-(void)sendRequestData{
    NSUserDefaults *dic = [NSUserDefaults standardUserDefaults];

    if ([[dic objectForKey:@"village_id"] isEqualToString:@""]) {
        
    }else{
        townName =  [dic objectForKey:@"town_name"];
        townId =  [dic objectForKey:@"town_id"];
        
        villageName =  [dic objectForKey:@"village_name"];
        villageId =  [dic objectForKey:@"village_id"];
        
    }
    
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
    if (![GHControl isExistNetwork]) {
        HUDNormal(@"服务器无响应，请稍后重试");

        return;
    }
    
  RequestCenter  *request = [RequestCenter shareRequestCenter];

    NSDictionary *postDic = @{@"member_id":[[SaveInfo shareSaveInfo]user_id],
                              @"address_id":addressId,
                              @"province_id":provinceId,
                              @"city_id":cityId,
                              @"area_id":countyId,
                              @"town_id":townId,
                              @"village_id":villageId,
                              @"true_name":_getCargoNameTextField.text,
                              @"mob_phone":_getCargoPhoneTextField.text,
                              @"area_info":_receiveAddressCityName.text,
                              @"address":_getCargoAddressTextField.text};
    
    [request sendRequestPostUrl:MY_EDIT_ADDRESS andDic:postDic setSuccessBlock:^(NSDictionary *resultDic) {
        if ([resultDic[@"code"] intValue] != 1) {
            BG_LOGIN ;
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
