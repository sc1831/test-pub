
//
//  OrderTabViewFootView.m
//  LXY
//
//  Created by guohui on 16/4/14.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "OrderTabViewFootView.h"

@implementation OrderTabViewFootView
- (void)configWithOrderModel:(OrderModel *)model{
    self.order_amountLab.text = model.order_amount ;
    self.order_amount2Lab.text = model.order_amount ;
    self.orderLab.text = model.order_sn ;
    self.addTimeLab.text = model.add_time ;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
