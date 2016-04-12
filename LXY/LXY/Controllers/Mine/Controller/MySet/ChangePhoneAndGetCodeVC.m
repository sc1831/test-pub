//
//  ChangePhoneAndGetCodeVC.m
//  LXY
//
//  Created by guohui on 16/3/24.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "ChangePhoneAndGetCodeVC.h"
#import "ChangePhoneSuccessVC.h"
#import "GHControl.h"
#import "RequestCenter.h"
#import "SaveInfo.h"
#import "UIButton+Block.h"

@interface ChangePhoneAndGetCodeVC ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *authTextField;
@property (weak, nonatomic) IBOutlet UIButton *AuthCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
- (IBAction)nestBtnClick:(id)sender;

@end

@implementation ChangePhoneAndGetCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改绑定手机" ;
    _phoneNumTextField.delegate = self;
    _authTextField.delegate = self;
    _AuthCodeButton.userInteractionEnabled = NO;
    _nextButton.userInteractionEnabled = NO;
    
    __weak ChangePhoneAndGetCodeVC  *weakSelf = self;
    [_AuthCodeButton setOnButtonPressedHandler:^{
        ChangePhoneAndGetCodeVC *strongSelf = weakSelf;
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
    
    /**
     phone	是	int	手机号
     type	是	int	1注册，2找回密码，5绑定手机号，6修改手机绑定确认步骤，9登陆

     */
    RequestCenter *request = [RequestCenter shareRequestCenter];
    NSDictionary *postDic = @{@"phone":_phoneNumTextField.text,@"type":@"6"};
    
    [request sendRequestPostUrl:REGISTRE_SEND_SMS andDic:postDic setSuccessBlock:^(NSDictionary *resultDic) {
        if ([resultDic[@"code"] intValue]==0) {
            HUDNormal(@"短信发送失败，请稍后再试");
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
                [_AuthCodeButton setBackgroundImage:[UIImage imageNamed:@"下一步_默认"] forState:UIControlStateNormal];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
-(void)takeKeyBoard{
    
    [_phoneNumTextField resignFirstResponder];
    [_authTextField resignFirstResponder];
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
        if ([toBeString length]>3) {
            textField.text = [toBeString substringToIndex:4];
            _nextButton.userInteractionEnabled = YES;
            [_nextButton setBackgroundImage:[UIImage imageNamed:@"下一步_默认"] forState:UIControlStateNormal];
            return NO;
        }else{
            _nextButton.userInteractionEnabled = NO;
            [_nextButton setBackgroundImage:[UIImage imageNamed:@"保存修改_置灰"] forState:UIControlStateNormal];
            return YES;
        }
    }


    return YES;
}

- (IBAction)nestBtnClick:(id)sender {
    
    
    /**
     user_id	是	int	用户id
     phone	是	int	原手机号
     code	是	int	原手机号验证码
     new_phone	是	int	新手机号
     new_code	是	int	新手机号验证码

     */
    
    RequestCenter *request = [RequestCenter shareRequestCenter];
    NSDictionary *postDic = @{@"user_id":[[SaveInfo shareSaveInfo] user_id],
                              @"phone":_accountNameStr,
                              @"code":_authStr,
                              @"new_phone":_phoneNumTextField.text,
                              @"new_code":_authTextField.text
                              };
    
    [request sendRequestPostUrl:MY_EDIT_BING_PHONE andDic:postDic setSuccessBlock:^(NSDictionary *resultDic) {
        if ([resultDic[@"code"] intValue]==0) {
            HUDNormal(@"修改失败，请稍后再试");
            return ;
        }
        HUDNormal(@"修改绑定手机成功");
        ChangePhoneSuccessVC *changePhoneSuccessVC = [[ChangePhoneSuccessVC alloc]init];
        [self.navigationController pushViewController:changePhoneSuccessVC animated:YES];
    } setFailBlock:^(NSString *errorStr) {
        NSLog(@"");
    }];
    
    
}

@end
