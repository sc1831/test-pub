//
//  CheckTelPhoneNumVC.m
//  LXY
//
//  Created by guohui on 16/3/15.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "CheckTelPhoneNumVC.h"
#import "ResetPassword.h"
#import "GHControl.h"
#import "RequestCenter.h"

@interface CheckTelPhoneNumVC ()<UITextFieldDelegate>
//下一步按钮点击
- (IBAction)nextButtonClick:(id)sender;
//联系客服
- (IBAction)customerService:(id)sender;
//手机号
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextfield;

@property (nonatomic ,strong)UIBarButtonItem *leftBarButton;
@end

@implementation CheckTelPhoneNumVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"验证手机号" ;
    _phoneNumTextfield.delegate = self;
    
}
-(void)leftNavBtnClick:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
//    [super leftNavBtnClick:sender];
}

//下一步按钮点击
- (IBAction)nextButtonClick:(id)sender {
    
    if (![GHControl lengalPhoneNumber:_phoneNumTextfield.text]) {
        HUDNormal(@"请输入正确的手机号");
        return;
    }
     [self nextStepView];

}
-(void)nextStepView{
    ResetPassword *resetPasswordVC = [[ResetPassword alloc]init];
    resetPasswordVC.phoneNumStr = _phoneNumTextfield.text;
    [self.navigationController pushViewController:resetPasswordVC animated:YES];
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
    if (textField == _phoneNumTextfield) {
        
            //更改显示效果，设置为输入就可以验证
            if ([toBeString length] > 10) {
                textField.text = [toBeString substringToIndex:11];

               
                
                return NO;
            } else {
                return YES;
            }

    }
    
    
    
    return YES;
}

//联系客服
- (IBAction)customerService:(id)sender {
}
@end
