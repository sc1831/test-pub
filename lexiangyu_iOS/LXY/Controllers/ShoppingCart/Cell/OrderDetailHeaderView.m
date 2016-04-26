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
-(void)configWithOrderModel:(AddressModel *)model{
    ;
    self.storeNameAndPhoneLab.text = STR_A_B_C(model.member_name, @"    ", model.mob_phone);
    self.area_infoTextView.text = STR_A_B_C(model.area_info, @"    ",model.address);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
