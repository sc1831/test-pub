//
//  RegisterShopMessageVC.m
//  LXY
//
//  Created by guohui on 16/3/15.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "RegisterShopMessageVC.h"
#import "ChooseCityVC.h"
#import "RequestCenter.h"
#import "GHControl.h"

@interface RegisterShopMessageVC ()
//提交审核
- (IBAction)submitAuditClick:(id)sender;
//位置点击
- (IBAction)locationClick:(id)sender;

//店铺名
@property (weak, nonatomic) IBOutlet UITextField *storeNameTextField;
//省市县
@property (weak, nonatomic) IBOutlet UILabel *cityName;
//详细地址
@property (weak, nonatomic) IBOutlet UITextField *deatilsAddressTextField;
//联系人
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
//联系电话
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;

@end

@implementation RegisterShopMessageVC
{

    RequestCenter *request;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册店铺信息" ;
    ///添加手势让其点击空白处键盘收回
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(takeTheKeyboard)];
    [self.view addGestureRecognizer:tap];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cityName:) name:@"cityName" object:nil];
    
}
-(void)takeTheKeyboard{
    [_storeNameTextField resignFirstResponder];
    [_deatilsAddressTextField resignFirstResponder];
    [_nameTextField resignFirstResponder];
    [_phoneNumTextField resignFirstResponder];
    
}
//省市县----地址
-(void)cityName:(NSNotification *)nsnotifition{

    NSDictionary *dict = nsnotifition.userInfo;
    _cityName.text = dict[@"cityName"];
    
}
- (void)leftNavBtnClick:(UIButton *)sender{
    [super leftNavBtnClick:sender];

}
//提交审核
- (IBAction)submitAuditClick:(id)sender {
    NSLog(@"提交审核");

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
    
    
    if ([_storeNameTextField.text length]<1) {
        HUDNormal(@"请输入店铺名称");
        return;
    }
    if ([_deatilsAddressTextField.text length]<1) {
        HUDNormal(@"请输入详细地址");
        return;
    }
   
//    if (![GHControl validateIdentityCard:_nameTextField.text]) {
//        HUDNormal(@"请输入正确的姓名");
//        return;
//    }
//    if (![GHControl lengalPhoneNumber:_phoneNumTextField.text]) {
//        HUDNormal(@"请输入正确的手机号");
//        return;
//    }
    if (![GHControl isExistNetwork]) {
        HUDNormal(@"服务器无响应，请稍后重试");

        return;
    }
    
    request = [RequestCenter shareRequestCenter];
    NSDictionary *postDic = @{@"phone":_phoneNumStr,
                              @"pwd":_passwordStr,
                              @"shop_name":_storeNameTextField.text,
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
                              @"true_name":_nameTextField.text,
                              @"tel_phone":_phoneNumTextField.text,
                              @"areainfo":[NSString stringWithFormat:@"%@",_deatilsAddressTextField.text]
                              };
    
    [request sendRequestPostUrl:REGISTRE_STOR_NAME andDic:postDic setSuccessBlock:^(NSDictionary *resultDic) {
        HUDNormal([resultDic objectForKey:@"msg"]);
        if ([resultDic[@"code"] intValue] != 1) {
            
            return ;
        }

        
        
        [self dismissViewControllerAnimated:YES completion:nil];
    } setFailBlock:^(NSString *errorStr) {
        NSLog(@"");
        
    }];
    
    
    
    
}
//位置点击
- (IBAction)locationClick:(id)sender {
    NSLog(@"位置点击");
    [GHControl defultsForEmpty];
    
    ChooseCityVC *chooseVC = [[ChooseCityVC alloc]init];
    [self.navigationController pushViewController:chooseVC animated:YES];
}


@end
