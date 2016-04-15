//
//  OrderDetailHeaderView.h
//  LXY
//
//  Created by guohui on 16/4/14.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
@interface OrderDetailHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *storeNameAndPhoneLab;
@property (weak, nonatomic) IBOutlet UILabel *area_info;

- (void)configWithOrderModel:(OrderModel *)model ;
@end
