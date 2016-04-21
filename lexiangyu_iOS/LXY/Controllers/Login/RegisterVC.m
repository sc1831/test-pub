//
//  RegisterVC.m
//  LXY
//
//  Created by guohui on 16/3/15.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "RegisterVC.h"
#import "RegisterShopMessageVC.h"
#import "GHControl.h"
#import "Common.h"
#import "RequestCenter.h"
#import "UIButton+Block.h"

@interface RegisterVC ()<UITextFieldDelegate>
//下一步按钮点击
- (IBAction)nextButtonClick:(id)sender;
//联系客服
- (IBAction)customerService:(id)sender;
//手机输入框
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
//验证码输入框
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextField;
//密码输入框
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
//获取验证码按钮
@property (weak, nonatomic) IBOutlet UIButton *AuthCodeButton;
//下一步按钮
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (nonatomic,strong)UIBarButtonItem *leftBarButton;

@end

@implementation RegisterVC
{

    NSString *statcPhoneNum;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新用户注册" ;
    
    _phoneTextField.delegate = self;
    _verificationCodeTextField.delegate = self;
    _passwordTextField.delegate = self;
    _nextButton.userInteractionEnabled = NO;
    _AuthCodeButton.userInteractionEnabled = NO;
    _passwordTextField.secureTextEntry = YES;

    __weak RegisterVC *weakSelf = self;
    [_AuthCodeButton setOnButtonPressedHandler:^{
        RegisterVC *strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf getVerificationCode];

        }
    }];
    
    
    
}
//继承父类做返回
-(void)leftNavBtnClick:(UIButton *)sender{
     [self dismissViewControllerAnimated:YES completion:nil];
}

//下一步按钮点击
- (IBAction)nextButtonClick:(id)sender {
    [self takeKeyBoard];
    NSLog(@"下一步按钮点击完成");
    NSUserDefaults *define = [NSUserDefaults standardUserDefaults];
    [define setObject:@"0" forKey:@"isNewPhone"];

    if (![GHControl lengalPhoneNumber:_phoneTextField.text]) {
        HUDNormal(@"请输入正确的手机号");
        return;
    }
    if ([statcPhoneNum isEqualToString:_phoneTextField.text]) {
        
    }else{
    
        HUDNormal(@"输入的手机号与获取验证码的手机号不一致");
        return;
    }
    if (_verificationCodeTextField.text.length==0) {
        HUDNormal(@"请输入验证码");
        return;
    }
    if (_verificationCodeTextField.text.length <4) {
        HUDNormal(@"请输入完整的验证码");
        return;
    }
    
    
    RequestCenter *request = [RequestCenter shareRequestCenter];
    NSDictionary *postDic = @{@"phone":_phoneTextField.text,@"type":@"1",@"code":_verificationCodeTextField.text};
    
    [request sendRequestPostUrl:REGISTRE_SEND_AUTH_CODE andDic:postDic setSuccessBlock:^(NSDictionary *resultDic) {

        if ([resultDic[@"code"] intValue] != 1) {
            HUDNormal([resultDic objectForKey:@"msg"]);
            return ;
        }
        

        
        HUDNormal(@"验证成功");
        RegisterShopMessageVC *shopMessageVC = [[RegisterShopMessageVC alloc]init];
        shopMessageVC.phoneNumStr = _phoneTextField.text;
        shopMessageVC.passwordStr = _passwordTextField.text;
        [self.navigationController pushViewController:shopMessageVC animated:YES];

        
    } setFailBlock:^(NSString *errorStr) {
        NSLog(@"");
    }];
    
}
//联系客服
- (IBAction)customerService:(id)sender {
    NSLog(@"联系客服点击");
    
    [self.view addSubview:[GHControl makeTelPhoneNum]];

    
}


- (void)getVerificationCode{
    
    if (![GHControl lengalPhoneNumber:_phoneTextField.text]) {
        HUDNormal(@"请输入正确的手机号");
        return;
    }
    
    
    RequestCenter *request = [RequestCenter shareRequestCenter];
    NSDictionary *postDic = @{@"phone":_phoneTextField.text,@"type":@"1"};
    statcPhoneNum = _phoneTextField.text;
    [request sendRequestPostUrl:REGISTRE_SEND_SMS andDic:postDic setSuccessBlock:^(NSDictionary *resultDic) {

       
        if ([resultDic[@"code"] intValue] != 1) {
            HUDNormal([resultDic objectForKey:@"msg"]);
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
            timeout -- ;
        }
    });
    dispatch_resume(_timer);
}
-(void)takeKeyBoard{

    [_phoneTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    [_verificationCodeTextField resignFirstResponder];
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
    if (textField == _phoneTextField) {
        
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
    if (textField == _verificationCodeTextField) {
        if ([toBeString length]>3) {
            textField.text = [toBeString substringToIndex:4];
            return NO;
        }else{
        
            return YES;
        }
    }
    //密码输入框
    if (textField == _passwordTextField) {
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
