
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
    self.order_amountLab.text =[NSString stringWithFormat:@"￥%@",model.order_goods_price_total];
    self.order_amount2Lab.text = [NSString stringWithFormat:@"￥%@",model.order_goods_price_total];
    self.orderLab.text = model.pay_sn ;
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
