//
//  ChangePhoneNumVC.m
//  LXY
//
//  Created by guohui on 16/3/16.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "ChangePhoneNumVC.h"
#import "CheckTelPhoneNumVC.h"
#import "ChangePhoneAndGetCodeVC.h"
#import "RequestCenter.h"
#import "SaveInfo.h"
#import "GHControl.h"

@interface ChangePhoneNumVC ()<UITextFieldDelegate>

//@property (nonatomic,strong)NSString *authNum;


//修改绑定手机
- (IBAction)changePhoneClick:(id)sender;

@end

@implementation ChangePhoneNumVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改绑定手机" ;
}



- (IBAction)changePhoneClick:(id)sender {
    
   
    [self sendSMS];

}
- (void)sendSMS{
    
    if (![GHControl isExistNetwork]) {
        HUDNormal(@"服务器无响应，请稍后重试");
        return;
    }
    RequestCenter *request = [RequestCenter shareRequestCenter];
    NSDictionary *postDic = @{@"phone":_accountNameStr,@"type":@"5"};//1注册，2找回密码，5绑定手机号，6修改手机绑定确认步骤，9登陆
    
    [request sendRequestPostUrl:REGISTRE_SEND_SMS andDic:postDic setSuccessBlock:^(NSDictionary *resultDic) {
        HUDNormal(resultDic[@"msg"]);
        [self showInput];
        if ([resultDic[@"code"] intValue] != 1) {
            
            BG_LOGIN ;
            return ;
        }
        
    } setFailBlock:^(NSString *errorStr) {
        
    }];
    
}

-(void)showInput{

    NSString *str = [NSString stringWithFormat:@"输入手机尾号%@接受到的短信验证码",_phoneNumStr];
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"验证手机号" message:str preferredStyle:UIAlertControllerStyleAlert];

    [alertControl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }]];
    [alertControl addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"确认");
        UITextField *codeTestField = alertControl.textFields.lastObject;
        [self.view endEditing:YES];
        [self checkSMS_byCodeStr:codeTestField.text];
        
       
  
        
    }]];
    
    //限制,如果listen输入长度要限制5个字内,否则不允许点击默认defalut 键
    UIAlertAction *action = alertControl.actions.lastObject ;
    action.enabled = NO ;
    
    [alertControl addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"验证码" ;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
    }];
    [self presentViewController:alertControl animated:YES completion:nil];
    
}

- (void)checkSMS_byCodeStr:(NSString *)codeStr{
    if (![GHControl isExistNetwork]) {
        HUDNormal(@"服务器无响应，请稍后重试");
        return;
    }
    
    RequestCenter *request = [RequestCenter shareRequestCenter];
    [request sendRequestPostUrl:CHECK_SMS andDic:@{@"phone":_accountNameStr,@"code":codeStr,@"type":@"5"} setSuccessBlock:^(NSDictionary *resultDic) {
        HUDNormal([resultDic objectForKey:@"msg"]);
        if ([resultDic[@"code"] intValue] != 1) {
            [self showInput];
        }else if ([resultDic[@"code"] intValue] == 1){
            ChangePhoneAndGetCodeVC *changePhoneAndGetCodeVC = [[ChangePhoneAndGetCodeVC alloc]init];
            changePhoneAndGetCodeVC.accountNameStr = _accountNameStr;
            changePhoneAndGetCodeVC.authStr = codeStr;
            [self.navigationController pushViewController:changePhoneAndGetCodeVC animated:YES];
        }
        
        
    } setFailBlock:^(NSString *errorStr) {
        
    }];
    
    
   
}

- (void)alertTextFieldDidChange:(NSNotification *)notification{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;  // 不要错写为self.presentedViewController
    if (alertController) {
        //下标为2的是添加了坚挺的 也是最后一个alertcontroller.textfields.lastObject
        UITextField *listrn = alertController.textFields.lastObject;
//        NSMutableString *mtStr = [NSMutableString stringWithString:listrn.text];
        if (listrn.text.length >= 4) {
            listrn.text = [listrn.text substringToIndex:4];
        }
        //限制,如果listen输入长度要限制5个字内,否则不允许点击默认defalut 键
        UIAlertAction *action = alertController.actions.lastObject ;
        action.enabled = listrn.text.length == 4 ;
    }
}
@end
