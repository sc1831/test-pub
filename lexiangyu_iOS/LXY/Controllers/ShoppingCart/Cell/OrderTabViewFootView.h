//
//  OrderTabViewFootView.h
//  LXY
//
//  Created by guohui on 16/4/14.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
@interface OrderTabViewFootView : UIView
@property (weak, nonatomic) IBOutlet UILabel *order_amountLab;
@property (weak, nonatomic) IBOutlet UILabel *order_amount2Lab;
@property (weak, nonatomic) IBOutlet UILabel *orderLab;
@property (weak, nonatomic) IBOutlet UILabel *addTimeLab;
- (void)configWithOrderModel:(OrderModel *)model ;
@end
