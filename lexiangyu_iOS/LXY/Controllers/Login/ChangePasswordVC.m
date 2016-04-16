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

@interface ChangePasswordVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *newsPasswordTexyField;
@property (weak, nonatomic) IBOutlet UITextField *againTextField;

- (IBAction)keepChangePassword:(id)sender;

@end

@implementation ChangePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码" ;
    _oldPasswordTextField.delegate = self;
    _newsPasswordTexyField.delegate = self;
    _againTextField.delegate = self;
    
}

- (IBAction)keepChangePassword:(id)sender {
    NSLog(@"保存修改");
    [self sendRequestData];
}
-(void)sendRequestData{
    
    RequestCenter * request = [RequestCenter shareRequestCenter];
    NSLog(@"%@",[[SaveInfo shareSaveInfo]loginName]);
    NSDictionary *postDic = @{@"phone":[[SaveInfo shareSaveInfo]loginName],
                              @"pwd":_oldPasswordTextField.text,
                              @"token":[[SaveInfo shareSaveInfo]token],
                              @"new_pwd":_newsPasswordTexyField.text
                              };
    
    [request sendRequestPostUrl:MY_EDIT_PWD andDic:postDic setSuccessBlock:^(NSDictionary *resultDic) {
//        [self gonTOLogin];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } setFailBlock:^(NSString *errorStr) {
        NSLog(@"");
        
    }];
    
}
-(void)gonTOLogin{
    LoginVC *loginVC = [[LoginVC alloc]init];
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:navigationController animated:YES completion:nil];
    
}

@end
