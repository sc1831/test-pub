//
//  ResetPassword.m
//  LXY
//
//  Created by guohui on 16/3/15.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "ResetPassword.h"
#import "GHControl.h"
#import "UIButton+Block.h"
#import "RequestCenter.h"

@interface ResetPassword ()<UITextFieldDelegate>
//手机号
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
//验证码
@property (weak, nonatomic) IBOutlet UITextField *authTextField;
//验证码按钮
@property (weak, nonatomic) IBOutlet UIButton *AuthCodeButton;
//新密码
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
//再次输入的密码
@property (weak, nonatomic) IBOutlet UITextField *againPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

- (IBAction)nextButtonClick:(id)sender;
//联系客服
- (IBAction)customerService:(id)sender;

@end

@implementation ResetPassword

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"重置密码" ;
    _phoneNumTextField.text = _phoneNumStr;
    _passwordTextField.secureTextEntry = YES;
    _againPasswordTextField.secureTextEntry = YES;
    _passwordTextField.delegate = self;
    _phoneNumTextField.delegate = self;
    _againPasswordTextField.delegate = self;
    _authTextField.delegate = self;
     _nextButton.userInteractionEnabled = NO;
    //一进来就开始获取验证码
    [self getVerificationCode];
    
    __weak ResetPassword *weakSelf = self;
    [_AuthCodeButton setOnButtonPressedHandler:^{
        ResetPassword *strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf getVerificationCode];
        }
    }];
   
}
- (void)getVerificationCode{
    
    if (![GHControl lengalPhoneNumber:_phoneNumTextField.text]) {
        HUDNormal(@"请输入正确的手机号");
        return;
    }
    
    
    RequestCenter *request = [RequestCenter shareRequestCenter];
    NSDictionary *postDic = @{@"phone":_phoneNumTextField.text,@"type":@"2"};
    
    [request sendRequestPostUrl:REGISTRE_SEND_SMS andDic:postDic setSuccessBlock:^(NSDictionary *resultDic) {
        
        if ([resultDic[@"code"] intValue]==0) {
            HUDNormal(resultDic[@"msg"]);
            return ;
        }
        
        HUDNormal(@"短信发送成功,请注意查收");
        
        [self getIdentifyingCodeBtnClick];
    } setFailBlock:^(NSString *errorStr) {
        NSLog(@"");
    }];
    
}
//验证码倒计时
- (void)getIdentifyingCodeBtnClick {
    [_AuthCodeButton setEnabled:NO];
    [_AuthCodeButton setBackgroundColor:[UIColor grayColor]];
    [_AuthCodeButton setTitle:@" " forState:UIControlStateNormal];
    
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
                [_AuthCodeButton setTitle:@"获取验证码"
                                 forState:UIControlStateNormal];
                [_AuthCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [_AuthCodeButton setEnabled:YES];
                [_AuthCodeButton setBackgroundImage:[UIImage imageNamed:@"下一步_默认"] forState:UIControlStateNormal];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                //更改按钮名称，提示下载状态
                [_AuthCodeButton
                 setTitle:[NSString stringWithFormat:@"重新获取(%ld)", (long)timeout]
                 forState:UIControlStateNormal];
                //RGBCOLOR(171, 171, 171)
                [_AuthCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
//-(void)leftNavBtnClick:(UIButton *)sender{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

- (IBAction)nextButtonClick:(id)sender {
    
    if ([_phoneNumStr isEqualToString:_phoneNumTextField.text]) {
        
    }else{
    
        HUDNormal(@"两次输入的手机号不一致");
        return;
    }
    
    if (_authTextField.text.length == 0) {
        HUDNormal(@"请输入验证码");
        return;
    }
    
    
    if (_passwordTextField.text.length == 0) {
        HUDNormal(@"请输入新密码");
        return;
    }
    if (_againPasswordTextField.text.length == 0) {
        HUDNormal(@"请再次输入新密码");
        return;
    }
    
   if ([_passwordTextField.text integerValue] !=
               [_againPasswordTextField.text integerValue]) {
        
        HUDNormal(@"两次的密码不一样，请重新输入");
        return;
    } else {
        //发送数据请求
        [self sendSetPassword];
    }
   
}
-(void)sendSetPassword{
    RequestCenter *request = [RequestCenter shareRequestCenter];
    NSDictionary *postDic = @{@"phone":_phoneNumTextField.text,@"pwd":_passwordTextField.text,@"code":_authTextField.text};
    
    [request sendRequestPostUrl:BACK_PASSWORD andDic:postDic setSuccessBlock:^(NSDictionary *resultDic) {
        HUDNormal(@"密码找回成功");
        
        [self dismissViewControllerAnimated:YES completion:nil];
    } setFailBlock:^(NSString *errorStr) {
        NSLog(@"");
    }];
    
    
}

- (IBAction)customerService:(id)sender {
    NSLog(@"联系客服");
}

#pragma mark-------textField协议函数----------
- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        return YES;
    }
    //此处容易出问题
    NSString *toBeString =
    [textField.text stringByReplacingCharactersInRange:range withString:string];
    ///手机号输入框
    if (textField == _phoneNumTextField) {
        
        if ([toBeString length] > 10) {
            //更改显示效果，设置为输入就可以验证
            if ([toBeString length] > 10) {
                textField.text = [toBeString substringToIndex:11];
                _AuthCodeButton.userInteractionEnabled = YES;
                [_AuthCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                [_AuthCodeButton setBackgroundImage:[UIImage imageNamed:@"下一步_默认"] forState:UIControlStateNormal];
                [_AuthCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                return NO;
            } else {
                return YES;
            }
        } else {
            _AuthCodeButton.userInteractionEnabled = NO;
            [_AuthCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
            [_AuthCodeButton setTitleColor:RGBCOLOR(171,171,171)forState:UIControlStateNormal];
            [_AuthCodeButton setBackgroundImage:[UIImage imageNamed:@"获取验证码"] forState:UIControlStateNormal];
        }
    }
    //验证码
    if (textField == _authTextField) {
        if ([toBeString length]>5) {
            textField.text = [toBeString substringToIndex:6];
            return NO;
        }else{
            
            return YES;
        }
    }
    //密码输入框
    if (textField == _againPasswordTextField) {
        if ([toBeString length]>5) {
            _nextButton.userInteractionEnabled = YES;
            [_nextButton setBackgroundImage:[UIImage imageNamed:@"下一步_默认"] forState:UIControlStateNormal];
        }else{
            _nextButton.userInteractionEnabled = NO;
            [_nextButton setBackgroundImage:[UIImage imageNamed:@"保存修改_置灰"] forState:UIControlStateNormal];
            
        }
        if ([toBeString length]>11) {
            textField.text = [toBeString substringToIndex:12];
            return NO;
        }else{
            
            return YES;
        }
    }
    
    
    return YES;
}
@end
