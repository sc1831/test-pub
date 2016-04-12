//
//  LoginVC.m
//  LXY
//
//  Created by guohui on 16/3/14.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "LoginVC.h"
#import "MainTabBar.h"
#import "RegisterVC.h"
#import "CheckTelPhoneNumVC.h"
#import "ResetPassword.h"
#import "CheckTelPhoneNumVC.h"
#import "SaveInfo.h"
#import "RequestCenter.h"
#import "GHControl.h"
#import "Common.h"
@interface LoginVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
//登录点击
- (IBAction)login:(id)sender;
//手机注册
- (IBAction)phoneRegisteredClick:(id)sender;
//忘记密码
- (IBAction)forgotPasswordClick:(id)sender;


@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"1" forKey:@"mySignal"];
    
    if (self.not_loginOut != YES) {
        //未赋值
        [[SaveInfo shareSaveInfo]logout];
    }

    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

//登录点击
- (IBAction)login:(id)sender {
    
    if (![GHControl isExistNetwork]) {
        HUDNormal(networkFailed);
        return;
    }
    
    [self sendSMS];
    
//    MainTabBar *mainVC = [[MainTabBar alloc]init];
//    [self presentViewController:mainVC animated:YES completion:nil];
}



#pragma mark - 登录http请求 -
- (void)sendSMS{
    RequestCenter *request = [RequestCenter shareRequestCenter];
    NSDictionary *postDic = @{@"phone":self.userNameTextField.text,@"type":@"9"};//1注册，2找回密码，5绑定手机号，6修改手机绑定确认步骤，9登陆
    
    [request sendRequestPostUrl:REGISTRE_SEND_SMS andDic:postDic setSuccessBlock:^(NSDictionary *resultDic) {
        HUDNormal(@"短信发送成功,请注意查收");
        
        [self showInput];
    } setFailBlock:^(NSString *errorStr) {
        
    }];
}

- (void)login_httpAndCode:(NSString *)code{
    RequestCenter *request = [RequestCenter shareRequestCenter];
    NSDictionary *postDic = @{@"phone":self.userNameTextField.text,@"pwd":self.passwordTextField.text,@"code":code};//1注册，2找回密码，5绑定手机号，6修改手机绑定确认步骤，9登陆
    
   
    
    [request sendRequestPostUrl:LOGIN andDic:postDic setSuccessBlock:^(NSDictionary *resultDic) {
       
        if ([resultDic[@"code"] intValue]==0) {
            HUDNormal(@"用户名或密码错误");
            return;
        }
         HUDNormal(@"登录成功");
        [[SaveInfo shareSaveInfo]setToken:[[resultDic objectForKey:@"data"] objectForKey:@"token"]];
        [[SaveInfo shareSaveInfo]setUser_id:[[resultDic objectForKey:@"data"] objectForKey:@"member_id"]];
        [[SaveInfo shareSaveInfo]setUserInfo:[resultDic objectForKey:@"data"]];
        [[SaveInfo shareSaveInfo]setLoginName:[[resultDic objectForKey:@"data"] objectForKey:@"member_phone"]];
        [[SaveInfo shareSaveInfo]setPassWord:_passwordTextField.text];
        MainTabBar *mainVC = [[MainTabBar alloc]init];
        [self presentViewController:mainVC animated:YES completion:nil];
        
    } setFailBlock:^(NSString *errorStr) {
        
    }];
    
}

- (void)showInput{
    //文本框只能是alert风格
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:nil message:@"验证码已发送请查收" preferredStyle:UIAlertControllerStyleAlert];
    
    
    [alertControl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }]];
    [alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"确定");
        UITextField *codeTestField = alertControl.textFields.lastObject;
        [self.view endEditing:YES];
        [self login_httpAndCode:codeTestField.text];
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
//手机注册
- (IBAction)phoneRegisteredClick:(id)sender {
    NSLog(@"手机注册");
    RegisterVC *registerVC = [[RegisterVC alloc]init];
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:registerVC];
    [self presentViewController:navigationController animated:YES completion:nil];
    
}
//忘记密码
- (IBAction)forgotPasswordClick:(id)sender {
//    [[SaveInfo shareSaveInfo] setPassWord:@"32442342"];
//    GLOG(@"password", [SaveInfo shareSaveInfo].passWord);
    
    CheckTelPhoneNumVC  *checkTelPhoneNumVC = [[CheckTelPhoneNumVC alloc]init];
    
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:checkTelPhoneNumVC];
    [self presentViewController:navigationController animated:YES completion:nil];
    
    
    
}
@end
