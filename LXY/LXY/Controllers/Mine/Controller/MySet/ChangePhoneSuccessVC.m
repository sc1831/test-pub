//
//  ChangePhoneSuccessVC.m
//  LXY
//
//  Created by guohui on 16/3/15.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "ChangePhoneSuccessVC.h"
#import "HomePageVC.h"
#import "UIButton+Block.h"
@interface ChangePhoneSuccessVC ()
@property (weak, nonatomic) IBOutlet UIButton *firstViewButton;

@end

@implementation ChangePhoneSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改绑定手机";
    
    __weak ChangePhoneSuccessVC *weakAuthSelf = self;
    [_firstViewButton setOnButtonPressedHandler:^{
        ChangePhoneSuccessVC *strongSelf = weakAuthSelf;
        if (strongSelf) {
            [strongSelf firstViewButtonClick];
        }
    }];
}
//首页按钮点击
-(void)firstViewButtonClick{

    [self.navigationController popToRootViewControllerAnimated:YES];

}

@end
