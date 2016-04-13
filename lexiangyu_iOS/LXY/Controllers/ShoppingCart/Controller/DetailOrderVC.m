
//
//  DetailOrderVC.m
//  LXY
//
//  Created by guohui on 16/3/16.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "DetailOrderVC.h"

@interface DetailOrderVC ()
//详情背景视图
@property (weak, nonatomic) IBOutlet UIScrollView *detailScrollView;

@end

@implementation DetailOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"订单详情" ;
    
}


@end
