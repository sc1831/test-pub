//
//  ADVC.m
//  LXY
//
//  Created by guohui on 16/5/12.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "ADVC.h"
#import "GHControl.h"
#import "RequestCenter.h"
#import "MainTabBar.h"
@interface ADVC ()
{
    /**
     *  0 login 1 mainTab
     */
    NSInteger postType ;
}
@end

@implementation ADVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    postType = 0 ;
    [self changeToken];
    
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(gotoVC) userInfo:nil repeats:NO];
    
}
- (void)gotoVC{
    switch (postType) {
        case 0:
        {
            LoginVC *loginVC = [[LoginVC alloc]init];
            loginVC.not_loginOut = YES ;
            [self presentViewController:loginVC animated:YES completion:nil];
        }
            break;
        case 1:
        {
            MainTabBar *mainVC = [[MainTabBar alloc]init];
            [self presentViewController:mainVC animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 替换token 验证token是否合法 是否进入登录界面
- (void)changeToken{

//    if (![GHControl isExistNetwork]) {
//        HUDNormal(@"服务器无响应，请稍后重试");
//        return;
//    }
    
    RequestCenter *request = [RequestCenter shareRequestCenter];
    if ([SaveInfo shareSaveInfo].user_id != nil && [SaveInfo shareSaveInfo].token != nil) {
        //有token
        NSDictionary *postDic = @{@"user_id":[SaveInfo shareSaveInfo].user_id,@"token":[SaveInfo shareSaveInfo].token};
        
        
        [request sendRequestPostUrl:EDIT_USER_TOKEN andDic:postDic setSuccessBlock:^(NSDictionary *resultDic) {
            if ([[resultDic objectForKey:@"code"] intValue]== 1) {
                
                [[SaveInfo shareSaveInfo]setToken:[[resultDic objectForKey:@"data"] objectForKey:@"token"]];
                [[SaveInfo shareSaveInfo]setUser_id:[[resultDic objectForKey:@"data"] objectForKey:@"member_id"]];
                [[SaveInfo shareSaveInfo]setUserInfo:[resultDic objectForKey:@"data"]];
                [[SaveInfo shareSaveInfo]setLoginName:[[resultDic objectForKey:@"data"] objectForKey:@"member_phone"]];
                [[SaveInfo shareSaveInfo]setShop_name:[[resultDic objectForKey:@"data"] objectForKey:@"shop_name"]];
                
                
                
//                MainTabBar *mainVC = [[MainTabBar alloc]init];
//                self.window.rootViewController = mainVC ;
                postType = 1;
                
            }else{
//                HUDNormal(@"请重新登录");
//                LoginVC *loginVC = [[LoginVC alloc]init];
//                self.window.rootViewController = loginVC ;
                postType = 0 ;
            }
        } setFailBlock:^(NSString *errorStr) {
            NSLog(@"error:%@",errorStr);
            //请求失败
//            MainTabBar *mainVC = [[MainTabBar alloc]init];
//            self.window.rootViewController = mainVC;
            postType = 1;
        }];
    }else{
        //无token
//        LoginVC *loginVC = [[LoginVC alloc]init];
//        self.window.rootViewController = loginVC ;
        postType = 0 ;
    }

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)adclick:(UIButton *)sender {
    NSLog(@"3232");
    
}
@end
