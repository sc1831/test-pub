//
//  MainTabBar.m
//  LXY
//
//  Created by guohui on 16/3/14.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "MainTabBar.h"
#import "HomePageVC.h"
#import "ClassifyVC.h"
#import "ShoppingCartVC.h"
#import "MineVC.h"
#import "Common.h"

@interface MainTabBar ()
@property (nonatomic,strong)UITabBarItem * tabBarItemOfMessage;
@end

@implementation MainTabBar

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNav];
    [self createViewControllers];
    [self createTabBarItems];

    
    
    self.tabBarItemOfMessage =[self.tabBarController.tabBar.items objectAtIndex:2];
    self.tabBarItemOfMessage.badgeValue = @"99+";
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(isReferredClick) name:@"isReferred" object:nil];
     // postNotificationName:@"isReferred" object:self userInfo:nil];
}

#pragma mark - createNav
- (void)createNav{
    //设置导航背景图片
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@""] forBarMetrics:UIBarMetricsDefault];
    //设置字体大小和颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20],NSForegroundColorAttributeName:[UIColor blackColor]}];
    
}

#pragma mark - createViewControllers
- (void)createViewControllers{
    HomePageVC *vc1 = [[HomePageVC alloc]init];
    vc1.title = @"首页" ;
    UINavigationController *nc1 = [[UINavigationController alloc]initWithRootViewController:vc1];
    
    ClassifyVC *vc2 = [[ClassifyVC alloc]init];
    vc2.title = @"分类" ;
    UINavigationController *nc2 = [[UINavigationController alloc]initWithRootViewController:vc2];
    
    ShoppingCartVC *vc3 = [[ShoppingCartVC alloc]init];
    vc3.title = @"购物车" ;
    UINavigationController *nc3 = [[UINavigationController alloc]initWithRootViewController:vc3];
    
    MineVC *vc4 = [[MineVC alloc]init];
    vc4.title = @"个人中心" ;
    UINavigationController *nc4 = [[UINavigationController alloc]initWithRootViewController:vc4];
    
    self.viewControllers = @[nc1,nc2,nc3,nc4] ;
    
}
#pragma mark - createTabBarItems
- (void)createTabBarItems{
    //创建三个数组
    NSArray *titleArray = @[@"首页",@"分类",@"购物车",@"我的"] ;
    NSArray *selectArray = @[@"首页@（选中）",@"分类@（选中）",@"购物车@（选中）",@"我的@（选中）"];
    NSArray *unSelectArray = @[@"首页",@"分类",@"购物车",@"我的"];
    for (int i = 0 ; i < titleArray.count; i++) {
        //获取item
        UITabBarItem *item = self.tabBar.items[i];
        //对图片进行处理
        UIImage *selectedImage = [UIImage imageNamed:selectArray[i]];
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *unSelectImage = [UIImage imageNamed:unSelectArray[i]];
        unSelectImage = [unSelectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        item = [item initWithTitle:titleArray[i] image:unSelectImage selectedImage:selectedImage];
    }
    //设置item的字体颜色
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.69 green:0.69 blue:0.69 alpha:1]} forState:UIControlStateNormal];
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.98 green:0.44 blue:0.02 alpha:1]} forState:UIControlStateSelected];
    //设置tabBar阴影为隐藏
    [self.tabBar setShadowImage:[[UIImage alloc]init]];
    //设置背景色
    [self.tabBar setBackgroundImage:[UIImage imageNamed:@""]];
    
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

@end
