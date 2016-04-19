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
    RequestCenter *request = [RequestCenter shareRequestCenter];
    NSDictionary *postDic = @{@"phone":_accountNameStr,@"type":@"5"};//1注册，2找回密码，5绑定手机号，6修改手机绑定确认步骤，9登陆
    
    [request sendRequestPostUrl:REGISTRE_SEND_SMS andDic:postDic setSuccessBlock:^(NSDictionary *resultDic) {
        if ([resultDic[@"code"] intValue] != 1) {
            BG_LOGIN ;
            return ;
        }
//        if ([resultDic[@"code"] intValue]==0) {
//            HUDNormal(@"发送失败，请稍后再试");
//            return ;
//        }
        
        HUDNormal(@"短信发送成功,请注意查收");
//        _authNum = resultDic[@"sms"];
        [self showInput];
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
        

        
            ChangePhoneAndGetCodeVC *changePhoneAndGetCodeVC = [[ChangePhoneAndGetCodeVC alloc]init];
            changePhoneAndGetCodeVC.accountNameStr = _accountNameStr;
            changePhoneAndGetCodeVC.authStr = codeTestField.text;
            [self.navigationController pushViewController:changePhoneAndGetCodeVC animated:YES];
  
        
    }]];
    
    //限制,如果listen输入长度要限制5个字内,否则不允许点击默认defalut 键
    UIAlertAction *action = alertControl.actions.lastObject ;
    action.enabled = NO ;
    
    [alertControl addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"验证码" ;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
    }];
    [self presentViewController:alertControl animated:YES completion:nil];
    
}
- (void)alertTextFieldDidChange:(NSNotification *)notification{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;  // 不要错写为self.presentedViewController
    if (alertController) {
        //下标为2的是添加了坚挺的 也是最后一个alertcontroller.textfields.lastObject
        UITextField *listrn = alertController.textFields.lastObject;
        //限制,如果listen输入长度要限制5个字内,否则不允许点击默认defalut 键
        UIAlertAction *action = alertController.actions.lastObject ;
        action.enabled = listrn.text.length == 4 ;
    }
}
@end
