//
//  OrderDetailCell.h
//  LXY
//
//  Created by guohui on 16/4/14.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllGoodsOrders.h"
@interface OrderDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsIcon;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsNum;
- (void)configViewGoodsModel:(AllGoodsOrders *)model ;
@end
