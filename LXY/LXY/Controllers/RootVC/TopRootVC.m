//
//  TopRootVC.m
//  LXY
//
//  Created by guohui on 16/3/14.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "TopRootVC.h"
#import "Common.h"
#import "GHControl.h"
@interface TopRootVC ()

@end

@implementation TopRootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNavController];
    //创建无网络view
    [self createNoNetworkView];
}
- (void)createNavController{
    UIButton *leftNarBtn = [GHControl createButtonWithFrame:CGRectMake(0, 0, 20, 20) ImageName:@"backBarIcon.png" Target:self Action:@selector(leftNavBtnClick:) Title:nil];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftNarBtn];

    UIButton *rightNarBtn = [GHControl createButtonWithFrame:CGRectMake(0, 0, 20, 20) ImageName:@"rightBarBtnBg.png" Target:self Action:@selector(rightNavBtnClick:) Title:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightNarBtn];
    
    //设置导航背景图片
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabBarBgImage.png"] forBarMetrics:UIBarMetricsDefault];
    //设置字体大小和颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14],NSForegroundColorAttributeName:[UIColor blackColor]}];
    
}
-(void)NoNetworkClickDelegate{
    
    NSLog(@"无网络重新加载数据");
}

-(void)createNoNetworkView{
    
    _noNetworkView =
    [[[NSBundle mainBundle] loadNibNamed:@"NoNetwork"
                                   owner:self
                                 options:nil] firstObject];
    _noNetworkView.frame = CGRectMake(0, 0, M_WIDTH, M_HEIGHT);
    _noNetworkView.delegate = self;
    [self.view addSubview:_noNetworkView];
    [self.noNetworkView bringSubviewToFront:self.view];
    _noNetworkView.hidden = YES;
    
    
}

- (void)leftNavBtnClick:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)rightNavBtnClick:(UIButton *)sender{

    
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
