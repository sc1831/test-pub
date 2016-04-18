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
@interface SettingVC ()
@property (weak, nonatomic) IBOutlet UISwitch *handSwitch;
//意见反馈
- (IBAction)opinionClick:(id)sender;
//关于我们
- (IBAction)aboutUs:(id)sender;
- (IBAction)loginOut:(id)sender;

@end

@implementation SettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置" ;
    
    
}

- (IBAction)opinionClick:(id)sender {
    NSLog(@"意见反馈点击");
    FeedBackVC *feedBackVC = [[FeedBackVC alloc]init];
    [self.navigationController pushViewController:feedBackVC animated:YES];
}

- (IBAction)aboutUs:(id)sender {
//    NSLog(@"关于我们点击");
    AboutUsVC *aboutUsVC = [[AboutUsVC alloc] init];
    [self.navigationController pushViewController:aboutUsVC animated:YES];
    
}

- (IBAction)loginOut:(id)sender {
    [self sendRequestData];
}
-(void)sendRequestData{

    RequestCenter * request = [RequestCenter shareRequestCenter];
    NSDictionary *postDic = @{@"token":[[SaveInfo shareSaveInfo]token],
                              @"phone":[[SaveInfo shareSaveInfo]loginName],
                              @"user_id":[[SaveInfo shareSaveInfo]user_id]
                              };
    
    [request sendRequestPostUrl:LOGIN_OUT andDic:postDic setSuccessBlock:^(NSDictionary *resultDic) {
        
        if (resultDic[@"code"]==0) {
            HUDNormal(@"请求失败");
            return ;
        }
        LoginVC *loginVC = [[LoginVC alloc] init];
        [self presentViewController:loginVC animated:YES completion:nil];
        
    } setFailBlock:^(NSString *errorStr) {
        NSLog(@"");
    }];

}



@end
