//
//  OrderDetailHeaderView.m
//  LXY
//
//  Created by guohui on 16/4/14.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "OrderDetailHeaderView.h"
#import "Common.h"
@implementation OrderDetailHeaderView
-(void)configWithOrderModel:(OrderModel *)model{
    ;
    self.storeNameAndPhoneLab.text = STR_A_B_C(model.store_name, @"    ", model.mob_phone);
    self.area_infoTextView.text = model.area_info ;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
