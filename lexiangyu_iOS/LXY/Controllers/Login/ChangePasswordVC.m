//
//  ChangePasswordVC.m
//  LXY
//
//  Created by guohui on 16/3/16.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "ChangePasswordVC.h"
#import "RequestCenter.h"
#import "SaveInfo.h"
#import "LoginVC.h"
#import "Common.h"
@interface ChangePasswordVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *newsPasswordTexyField;
@property (weak, nonatomic) IBOutlet UITextField *againTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

- (IBAction)keepChangePassword:(id)sender;

@end

@implementation ChangePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码" ;
    _oldPasswordTextField.delegate = self ;
    
}

- (IBAction)keepChangePassword:(id)sender {
    
    NSLog(@"保存修改");
    [self finishNextSetUp];
    [self sendRequestData];
}
-(void)finishNextSetUp{

    if ([_oldPasswordTextField.text length] == 0) {
        HUDNormal(@"当前密码不可以为空");
        return;
        
    } else if ([_oldPasswordTextField.text length] < 6) {
        HUDNormal(@"密码由6-12位字母或数字组成，请重新输入");
        return;
        
    }
    
    if ([_newsPasswordTexyField.text length] == 0) {
        HUDNormal(@"新密码不可以为空");
        return;
    } else if ([_newsPasswordTexyField.text length] < 6) {
        HUDNormal(@"密码由6-12位字母或数字组成，请重新输入");
        return;
        
    }
    
    if ([_againTextField.text isEqualToString:_newsPasswordTexyField.text] == NO) {
        HUDNormal(@"两次输入的密码不一致，请重新输入");
        return;
    }
    if ([_oldPasswordTextField.text isEqualToString:_newsPasswordTexyField.text] == YES) {
        HUDNormal(@"新密码与当前密码不能一致");
        _againTextField.text = @"";
        _newsPasswordTexyField.text = @"";
        return;
    }

}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    self.submitBtn.enabled = YES;
    
    //此处容易出问题
    NSString *toBeString =
    [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == _againTextField) {
        if ([toBeString length]>5) {
            self.submitBtn.enabled = YES;
            
        }else{
            self.submitBtn.enabled = NO;
            
        }
    }
    
    ///手机号输入框
    if (textField == _oldPasswordTextField || textField == _newsPasswordTexyField || textField == _againTextField) {
            //更改显示效果，设置为输入就可以验证
            if ([toBeString length] > 11) {
                textField.text = [toBeString substringToIndex:12];
                
                return NO;
            } else {
                return YES;
            }
        
       
    }
    
   
    
    return YES ;
}

-(void)sendRequestData{
    NSArray *array = @[self.oldPasswordTextField.text,self.newsPasswordTexyField.text , self.againTextField.text];
    if ([array[1] isEqualToString:array[2]]) {
    }else{
        HUDNormal(@"两次密码不一致,请重新输入");
        return ;
    }
    RequestCenter * request = [RequestCenter shareRequestCenter];
    NSLog(@"%@",[[SaveInfo shareSaveInfo]loginName]);
    NSDictionary *postDic = @{@"phone":[[SaveInfo shareSaveInfo]loginName],
                              @"pwd":_oldPasswordTextField.text,
                              @"token":[[SaveInfo shareSaveInfo]token],
                              @"new_pwd":_newsPasswordTexyField.text
                              };
    
    [request sendRequestPostUrl:MY_EDIT_PWD andDic:postDic setSuccessBlock:^(NSDictionary *resultDic) {
        if ([[resultDic[@"code"] stringValue] isEqualToString:@"1"]) {
             [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            HUDNormal([resultDic objectForKey:@"msg"]);
        }
        
       
        
    } setFailBlock:^(NSString *errorStr) {
        NSLog(@"");
        
    }];
    
}


//-(void)gonTOLogin{
//    LoginVC *loginVC = [[LoginVC alloc]init];
//    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:loginVC];
//    [self presentViewController:navigationController animated:YES completion:nil];
//    
//}

@end
