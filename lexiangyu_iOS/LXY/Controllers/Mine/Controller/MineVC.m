//
//  MineVC.m
//  LXY
//
//  Created by guohui on 16/3/14.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "MineVC.h"
#import "MineAccountVC.h"
#import "GHControl.h"
#import "SettingVC.h"
#import "CollectVC.h"
#import "MyfootprintVC.h"
#import "ConfirmorderVC.h"
#import "WaitSendVC.h"
#import "WaitGetVC.h"
#import "WaitPayFirstViewController.h"
#import "DetailAddressVC.h"
#import "AllShopViewController.h"
#import "RequestCenter.h"
#import "SaveInfo.h"
#import "Common.h"

@interface MineVC ()
//头像
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
//@property (nonatomic ,strong) UIImage *headImage;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UIImageView *mineImageView;
@property (nonatomic ,strong)UIBarButtonItem *rightBarButton;
@property (nonatomic ,strong)NSMutableString *iphoneMut;
@property (nonatomic ,strong)NSString *phoneNum;
@end

@implementation MineVC
- (void)viewWillAppear:(BOOL)animated{
     [self sendRequestData];
    if ([[SaveInfo shareSaveInfo]userImageUrl]) {
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:[[SaveInfo shareSaveInfo]userImageUrl]] placeholderImage:[UIImage imageNamed:@"火影1"]] ;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *rightNarBtn = [GHControl createButtonWithFrame:CGRectMake(0, 0, 20, 20) ImageName:@"设置" Target:self Action:@selector(rightBarButtonClick) Title:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightNarBtn];
    
    //设置导航背景图片
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabBarBgImage.png"] forBarMetrics:UIBarMetricsDefault];
    //设置字体大小和颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName:[UIColor blackColor]}];
   
    
    
//    _headImage = [UIImage imageNamed:@"火影1"];
    _headImageView.image = [UIImage imageNamed:@"火影1"];
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = 39;
    
    
}
-(void)sendRequestData{
    
    RequestCenter * request = [RequestCenter shareRequestCenter];
    NSDictionary *postDic = @{@"token":[[SaveInfo shareSaveInfo]token],
                              @"user_id":[[SaveInfo shareSaveInfo]user_id]
                              };
    
    [request sendRequestPostUrl:MY_USER_ACCOUNT andDic:postDic setSuccessBlock:^(NSDictionary *resultDic) {
        if ([resultDic[@"code"] intValue] != 1) {
            BG_LOGIN ;
            return ;
        }
        if ([resultDic[@"code"] intValue]==0) {
            HUDNormal(@"请求失败");
            return ;
        }
        
        NSDictionary *dic = resultDic[@"data"];
        _shopName.text = dic[@"shop_name"];
        _phoneNum = dic[@"member_phone"];
        _iphoneMut = [[NSMutableString alloc] initWithString:dic[@"member_phone"]];
        [_iphoneMut replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        _phoneNumLabel.text = _iphoneMut;
        
        

        [[SaveInfo shareSaveInfo]setUserImageUrl:dic[@"member_avatar"]];
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"member_avatar"]] placeholderImage:[UIImage imageNamed:@"产品图片"]];
        
    } setFailBlock:^(NSString *errorStr) {
        _mineImageView.image = [UIImage imageNamed:@"产品图片"];
    }];
}


-(void)rightBarButtonClick{
    SettingVC *setVC = [[SettingVC alloc]init];
    setVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:setVC animated:YES];
}

//我的收藏点击
- (IBAction)collectionViewClick:(id)sender {
    NSLog(@"我的收藏点击");
//    self.hidesBottomBarWhenPushed = YES;
    CollectVC *collVC = [[CollectVC alloc]init];
    collVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:collVC animated:YES];
//    self.hidesBottomBarWhenPushed = NO;
}
//我的足迹
- (IBAction)footprintClick:(id)sender {
    NSLog(@"我的足迹点击");
    MyfootprintVC *footVC = [[MyfootprintVC alloc]init];
    footVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:footVC animated:YES];
}
//代付款
- (IBAction)parymentClick:(id)sender {
    NSLog(@"代付款点击");
    //如果没有待付款单走下面
    /*
    WaitPayVC *waitPayVC = [[WaitPayVC alloc]init];
    waitPayVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:waitPayVC animated:YES];
    
    */
    //如果有待付款单
    WaitPayFirstViewController *waitPayVC = [[WaitPayFirstViewController alloc]init];
    waitPayVC.hidesBottomBarWhenPushed = YES;
    waitPayVC.isMinePush = YES;
    [self.navigationController pushViewController:waitPayVC animated:YES];
    
    
}
//代发货
- (IBAction)sendCargoClick:(id)sender {
    NSLog(@"代发货点击");
    WaitSendVC *waitSendVC = [[WaitSendVC alloc]init];
    waitSendVC.hidesBottomBarWhenPushed = YES;
    waitSendVC.isMineSendPush = YES;
    [self.navigationController pushViewController:waitSendVC animated:YES];
}
//代收货
- (IBAction)getCargoClick:(id)sender {
    NSLog(@"代收货点击");
    WaitGetVC *waitGetVC = [[WaitGetVC alloc]init];
    waitGetVC.hidesBottomBarWhenPushed = YES;
    waitGetVC.isMineGetPush = YES;
    [self.navigationController pushViewController:waitGetVC animated:YES];
}
//查看全部订单
- (IBAction)lookAllOrderClick:(id)sender {
    NSLog(@"查看全部订单点击");
    AllShopViewController *allShopVC = [[AllShopViewController alloc]init];
    allShopVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:allShopVC animated:YES];
}

//管理账户收货地址
- (IBAction)ManagementAccountClick:(id)sender {
    NSLog(@"管理账户收货地址点击");
    DetailAddressVC *receiveAddressVC = [[DetailAddressVC alloc]init];
    receiveAddressVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:receiveAddressVC animated:YES];
}
//顶部view点击
- (IBAction)topViewClick:(id)sender {
    NSLog(@"顶部view点击----我的账户");
    self.hidesBottomBarWhenPushed= YES;
    MineAccountVC *mineAccountVC = [[MineAccountVC alloc]init];
    mineAccountVC.bindPhoneNumStr = _phoneNumLabel.text;
    mineAccountVC.shopNameStr = _shopName.text;
    mineAccountVC.accountNameStr = _iphoneMut;
    mineAccountVC.phoneNum = _phoneNum;
    mineAccountVC.image = _headImageView.image;
    [self.navigationController pushViewController:mineAccountVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
@end
