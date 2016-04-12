//
//  FootPointCell.h
//  LXY
//
//  Created by guohui on 16/3/16.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FootPointCell : UITableViewCell
//购买的商品名称
@property (weak, nonatomic) IBOutlet UILabel *contentsLabel;
//购买价位
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
//产品图片
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;

@end
