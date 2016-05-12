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
#import "UIButton+Block.h"
#import "GHControl.h"
#import "ADView.h"


@interface LoginVC ()<UITextFieldDelegate>
{
    NSString *userName ;
    NSString *password ;
    NSString *codeStr ;

    ADView *adView ;
}
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *messageCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendMessageBtn; //发送验证码
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
//登录点击
- (IBAction)login:(id)sender;
//手机注册
- (IBAction)phoneRegisteredClick:(id)sender;
//忘记密码
- (IBAction)forgotPasswordClick:(id)sender;


@end

@implementation LoginVC
- (void)viewWillAppear:(BOOL)animated{

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    adView = [[[NSBundle mainBundle]loadNibNamed:@"ADView" owner:self options:nil]firstObject];
    adView.adImage.image = [UIImage imageNamed:@"launch_start_image"];
    [self.view addSubview:adView];
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(removeSelfView) userInfo:nil repeats:NO];
    [adView.imageBtn addTarget:self action:@selector(adClick) forControlEvents:UIControlEventTouchUpInside];
    
//    ADVC *adVC = [[ADVC alloc]init];
//    [self presentViewController:adVC animated:NO completion:nil];
    
    
    if (self.not_loginOut != YES) {
        //未赋值
        [[SaveInfo shareSaveInfo]logout];
    }
    
    __weak LoginVC *weakSelf = self;
    [_sendMessageBtn setOnButtonPressedHandler:^{
        LoginVC *strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf sendSMS];
        }
    }];
    self.sendMessageBtn.enabled = YES ;

    self.loginBtn.enabled = YES ;
    [self sendMessageButionStateSuccess];
    
    ///添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(takeTheKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    
   
    

    
}
- (void)adClick{
    NSLog(@"323423423423423");
}

- (void)removeSelfView{
    [adView removeFromSuperview];
}


-(void)takeTheKeyboard{

    [_userNameTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    [_messageCodeTextField resignFirstResponder];
    
    if (M_HEIGHT<=568) {
        [UIView animateWithDuration:0.3f
                         animations:^{
                             
                             self.view.frame = CGRectMake(0,0, M_WIDTH, M_HEIGHT);
                         }];
    }
    
}
//验证码倒计时
- (void)getIdentifyingCodeBtnClick {
    [_sendMessageBtn setEnabled:NO];
    [_sendMessageBtn setBackgroundColor:[UIColor grayColor]];
    [_sendMessageBtn setTitle:@" " forState:UIControlStateNormal];
    
    __block int timeout = 60;  //倒计时时间
    dispatch_queue_t queue =
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer =
    dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0),
                              1.0 * NSEC_PER_SEC, 0);  //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if (timeout <= 0) {  //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示
                [_sendMessageBtn setTitle:@"获取验证码"
                                 forState:UIControlStateNormal];
                [_sendMessageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [_sendMessageBtn setEnabled:YES];
                [_sendMessageBtn setBackgroundImage:[UIImage imageNamed:@"下一步_默认"] forState:UIControlStateNormal];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                //更改按钮名称，提示下载状态
                [_sendMessageBtn
                 setTitle:[NSString stringWithFormat:@"重新获取(%ld)", (long)timeout]
                 forState:UIControlStateNormal];
                //RGBCOLOR(171, 171, 171)
                [_sendMessageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
#pragma mark----delagete
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (M_HEIGHT<=568) {
        [UIView animateWithDuration:0.3f
                         animations:^{
                             
                             self.view.frame = CGRectMake(0, -130, M_WIDTH, M_HEIGHT);
                         }];
    }
    
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField== _userNameTextField) {
        if ([toBeString length] > 10) {
            textField.text = [toBeString substringToIndex:11];
            
            return NO;
        } else {
            return YES;
        }

    }
    
    
    if (textField== _passwordTextField) {
        if ([toBeString length] > 11) {
            textField.text = [toBeString substringToIndex:12];
            
            return NO;
        } else {
            return YES;
        }
        
    }
    if (textField== _messageCodeTextField) {
        if ([toBeString length] > 3) {
            textField.text = [toBeString substringToIndex:4];
            
            return NO;
        } else {
            return YES;
        }
        
    }


    return YES ;
}



-(void)sendMessageButionStateSuccess{

    self.sendMessageBtn.userInteractionEnabled = YES;
    _sendMessageBtn.enabled = YES;
    [self.sendMessageBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.sendMessageBtn setBackgroundImage:[UIImage imageNamed:@"下一步_默认"] forState:UIControlStateNormal];
    [self.sendMessageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

//登录点击
- (IBAction)login:(id)sender {
    
    [self takeTheKeyboard];
    
    if ([_userNameTextField.text length] == 0) {
        HUDNormal(@"手机号不可以为空");
        return;
    }else if (![GHControl lengalPhoneNumber:_userNameTextField.text]){
        HUDNormal(@"请输入正确的手机号");
        return;
    
    }
    else if ([_passwordTextField.text length] < 6) {
        HUDNormal(@"密码由6-12位字母或数字组成，请重新输入");
        return;
        
    }
    
    if ([_messageCodeTextField.text length] == 0) {
        HUDNormal(@"请输入验证码");
        return;
    }
    if ([_messageCodeTextField.text length] < 4) {
        HUDNormal(@"请输入正确的验证码");
        return;
    }
    
    
    [self login_httpAndCode:self.messageCodeTextField.text];

}



#pragma mark - 登录http请求 -
- (void)sendSMS{
    
    if ([_userNameTextField.text length] == 0) {
        HUDNormal(@"手机号不可以为空");
        return;
    }else if (![GHControl lengalPhoneNumber:_userNameTextField.text]){
        HUDNormal(@"请输入正确的手机号");
        return;
        
    }
    if (![GHControl isExistNetwork]) {
        HUDNormal(@"服务器无响应，请稍后重试");

        return;
    }
    RequestCenter *request = [RequestCenter shareRequestCenter];
    NSDictionary *postDic = @{@"phone":self.userNameTextField.text,@"type":@"9"};//1注册，2找回密码，5绑定手机号，6修改手机绑定确认步骤，9登陆
    
    [request sendRequestPostUrl:REGISTRE_SEND_SMS andDic:postDic setSuccessBlock:^(NSDictionary *resultDic) {

        if ([resultDic[@"code"] intValue]==0) {
            HUDNormal(resultDic[@"msg"]);
            return ;
        }
        [self getIdentifyingCodeBtnClick];
        
    } setFailBlock:^(NSString *errorStr) {
        
    }];
}

- (void)login_httpAndCode:(NSString *)code{
    
    if (![GHControl isExistNetwork]) {
        HUDNormal(@"服务器无响应，请稍后重试");

        return;
    }
    
    RequestCenter *request = [RequestCenter shareRequestCenter];
    NSDictionary *postDic = @{@"phone":self.userNameTextField.text,@"pwd":self.passwordTextField.text,@"code":code};
   
    
    [request sendRequestPostUrl:LOGIN andDic:postDic setSuccessBlock:^(NSDictionary *resultDic) {
        if ([resultDic[@"code"] intValue]==0) {
            HUDNormal(resultDic[@"msg"]);
            return ;
        }

         HUDNormal(@"登录成功");
        [[SaveInfo shareSaveInfo]setToken:[[resultDic objectForKey:@"data"] objectForKey:@"token"]];
        [[SaveInfo shareSaveInfo]setUser_id:[[resultDic objectForKey:@"data"] objectForKey:@"member_id"]];
        [[SaveInfo shareSaveInfo]setUserInfo:[resultDic objectForKey:@"data"]];
        [[SaveInfo shareSaveInfo]setLoginName:[[resultDic objectForKey:@"data"] objectForKey:@"member_phone"]];
        [[SaveInfo shareSaveInfo]setShop_name:[[resultDic objectForKey:@"data"] objectForKey:@"shop_name"]];
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
