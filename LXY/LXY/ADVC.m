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
#import "ShopingDetailsVC.h"
#import "ADDetailVC.h"
@interface ADVC ()
{
    /**
     *  0 login 1 mainTab
     */
    RequestCenter *request ;
    NSNumber *type ;
    NSString *adUrlStr ;
    NSString *adTitle ;
}
@property (weak, nonatomic) IBOutlet UILabel *showLab;


@end

@implementation ADVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    request = [RequestCenter shareRequestCenter];
    [request sendRequestPostUrl:EXCESSIVE andDic:nil setSuccessBlock:^(NSDictionary *resultDic) {
        if ([resultDic[@"code"] intValue] == 1) {
            [self.adImageView sd_setImageWithURL:[NSURL URLWithString:resultDic[@"data"][@"imageUrl"]]];
            type = resultDic[@"data"][@"adv_type"];
            adUrlStr = resultDic[@"data"][@"dataUrl"];
            adTitle = resultDic[@"data"][@"title"];
            if ([type intValue] == 1) {
                self.showLab.hidden = NO ;
            }
            
        }
    } setFailBlock:^(NSString *errorStr) {
        
    }];
  
    
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(gotoVC) userInfo:nil repeats:NO];
    
}
- (void)gotoVC{

    MainTabBar *mainVC = [[MainTabBar alloc]init];
    [self presentViewController:mainVC animated:YES completion:nil];
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
    if ([type intValue]==1) {
        ADDetailVC *adDetailVC = [[ADDetailVC alloc]init];
        adDetailVC.adUrlStr = adUrlStr ;
        adDetailVC.adtitle = adTitle ;
        [self presentViewController:adDetailVC animated:YES completion:nil];
    }else{
    }
    
}
@end
