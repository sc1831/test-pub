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
    [self sendRequestData];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    self.submitBtn.enabled = [self submitBtnIsEnable] ;
    
    if (textField.text.length > 12) {
        HUDNormal(@"密码长度不能大于12位");
    }

    return YES ;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.submitBtn.enabled = [self submitBtnIsEnable] ;
    if (textField.text.length > 12) {
        HUDNormal(@"密码长度不能大于12位");
    }
    
}



//- (void)textFieldDidEndEditing:(UITextField *)textField{
//    self.submitBtn.enabled = [self submitBtnIsEnable] ;
//    if (textField.text.length > 12) {
//        HUDNormal(@"密码长度不能大于12位");
//    }
//    
//    
//}
- (BOOL)submitBtnIsEnable{
    NSArray *array = @[self.oldPasswordTextField.text,self.newsPasswordTexyField.text , self.againTextField.text];
    for (NSString *str in array) {
        if (str.length >= 5 && str.length <= 12) {
          
        }else{
            return NO ;
        }
    }
//    if ([array[1] isEqualToString:array[2]]) {
//        
//        return YES ;
//    }else{
//        HUDNormal(@"两次密码不一致");
//        return NO ;
//    }
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
