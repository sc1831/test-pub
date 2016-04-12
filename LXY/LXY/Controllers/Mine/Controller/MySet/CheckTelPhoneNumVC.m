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

@interface CheckTelPhoneNumVC ()
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
//联系客服
- (IBAction)customerService:(id)sender {
}
@end
