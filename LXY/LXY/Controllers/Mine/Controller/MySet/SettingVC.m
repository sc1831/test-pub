//
//  SettingVC.m
//  LXY
//
//  Created by guohui on 16/3/16.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "SettingVC.h"
#import "FeedBackVC.h"
#import "LoginVC.h"
#import "RequestCenter.h"
#import "SaveInfo.h"
#import "AboutUsVC.h"
#import "GHControl.h"
@interface SettingVC ()
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UISwitch *handSwitch;
@property (weak, nonatomic) IBOutlet UILabel *versionLab;
//意见反馈
- (IBAction)opinionClick:(id)sender;
//关于我们
- (IBAction)aboutUs:(id)sender;
- (IBAction)loginOut:(id)sender;
- (IBAction)switchPush:(UISwitch *)sender;

@end

@implementation SettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置" ;
    if ([[SaveInfo shareSaveInfo]pushFlag]) {
         [self.handSwitch setOn:[[[SaveInfo shareSaveInfo] pushFlag] boolValue]];
    }

    NSString *versionStr = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    self.versionLab.text = [NSString stringWithFormat:@"V %@",versionStr];
    
    [_loginButton setBackgroundImage:[UIImage imageNamed:@"下一步_置灰"] forState:UIControlStateHighlighted];
}


- (IBAction)opinionClick:(id)sender {
    NSLog(@"意见反馈点击");
    FeedBackVC *feedBackVC = [[FeedBackVC alloc]init];
    [self.navigationController pushViewController:feedBackVC animated:YES];
}

- (IBAction)aboutUs:(id)sender {
    AboutUsVC *aboutUsVC = [[AboutUsVC alloc] init];
    [self.navigationController pushViewController:aboutUsVC animated:YES];
    
}

- (IBAction)loginOut:(id)sender {
    [self sendRequestData];
}

- (IBAction)switchPush:(UISwitch *)sender {
    if ([sender isOn]) {
        [self openJPush];
    }else{
        [self closeJPush];
    }
    [[SaveInfo shareSaveInfo]setPushFlag:[NSString stringWithFormat:@"%d",sender.isOn]];
}
- (void)openJPush{
//    [UMessage registerRemoteNotificationAndUserNotificationSettings]
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)closeJPush{
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
}
-(void)sendRequestData{
    
    RequestCenter * request = [RequestCenter shareRequestCenter];
    NSDictionary *postDic = @{@"token":[[SaveInfo shareSaveInfo]token],
                              @"phone":[[SaveInfo shareSaveInfo]loginName],
                              @"user_id":[[SaveInfo shareSaveInfo]user_id]
                              };
    
    [request sendRequestPostUrl:LOGIN_OUT andDic:postDic setSuccessBlock:^(NSDictionary *resultDic) {
        
        if ([resultDic[@"code"] intValue]==0) {
            HUDNormal(resultDic[@"msg"]);
        }
        LoginVC *loginVC = [[LoginVC alloc] init];
        [self presentViewController:loginVC animated:YES completion:nil];
        
    } setFailBlock:^(NSString *errorStr) {
        LoginVC *loginVC = [[LoginVC alloc] init];
        [self presentViewController:loginVC animated:YES completion:nil];
    }];


}



@end
