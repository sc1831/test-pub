//
//  GuiteVC.m
//  LXY
//
//  Created by guohui on 16/3/14.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "GuiteVC.h"
#import "Common.h"
#import "MainTabBar.h"
#import "LoginVC.h"

#define num 2
#define YINDAOYE_COUNT 3
@interface GuiteVC ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIPageControl *pageControl;
@end

@implementation GuiteVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //1.创建一个滚动视图
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,M_WIDTH, M_HEIGHT)];
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    for (int i = 0; i<num; i++) {
        //背景图
//        UIImage *backImage = [UIImage imageNamed:@"guide_bg"];
//        
//        UIImageView *backImageView = [[UIImageView alloc]initWithImage:backImage];
//        
//        backImageView.frame = CGRectMake(M_WIDTH*i, 0, M_WIDTH, M_HEIGHT);
//        
//        [scrollView addSubview:backImageView];
        
        //前置图
        NSString *string = [NSString stringWithFormat:@"index%i",i+1];
        UIImage *forImage = [UIImage imageNamed:string];
        
        UIImageView *forImageView = [[UIImageView alloc]initWithImage:forImage];
        
        forImageView.frame = CGRectMake(M_WIDTH*i, 0, M_WIDTH, M_HEIGHT);
        
        [scrollView addSubview:forImageView];
        
    }
    
    //设置内容的大小
    scrollView.contentSize = CGSizeMake(M_WIDTH*num, 0);
    
    //滚动视图的分页设置
    //提示：每张图片的大小要与滚动视图的大小保持一致，才能使每张图片在每一页里面
    scrollView.pagingEnabled = YES;
    
    
//    //建立进入最后一个页面的按钮
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(M_WIDTH*(num-1) + 100,M_HEIGHT-140, 120, 50);
//    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    //添加到滚动视图
//    [scrollView addSubview:button];
    
    
    //分页控制
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((M_WIDTH-120)/2, M_HEIGHT-40, 120,0)];
    //分页的页数
    self.pageControl.numberOfPages = num;
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    //当前显示分页
    self.pageControl.currentPage = 0;
    //将分页控建加在本视图上面
    [self.view addSubview:self.pageControl];

}

//分页控制
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int gap = scrollView.contentOffset.x/M_WIDTH;
    self.pageControl.currentPage = gap;



}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.x > scrollView.frame.size.width+30) {
        [self buttonClicked];
    }
    
    
}
-(void)buttonClicked{
    NSLog(@"进来了");
    if (true) {
        LoginVC *login = [[LoginVC alloc]init];
        [self presentViewController:login animated:YES completion:nil];
    }else{
        MainTabBar *main = [[MainTabBar alloc]init];
        [self presentViewController:main animated:YES completion:nil];
    }
    
}

@end
