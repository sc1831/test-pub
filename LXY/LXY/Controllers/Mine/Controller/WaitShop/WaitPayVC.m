//
//  WaitPayVC.m
//  LXY
//
//  Created by guohui on 16/3/15.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "WaitPayVC.h"
#import "UIButton+Block.h"

@interface WaitPayVC ()
@property (weak, nonatomic) IBOutlet UIButton *lookButton;

@end

@implementation WaitPayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"待付款" ;
    __weak WaitPayVC *weakSelf = self;
    [_lookButton setOnButtonPressedHandler:^{
        WaitPayVC *strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf casuallyLook];
        }
        
    }];
    
    
}
-(void)casuallyLook{
    NSLog(@"随便逛逛");
}
@end
