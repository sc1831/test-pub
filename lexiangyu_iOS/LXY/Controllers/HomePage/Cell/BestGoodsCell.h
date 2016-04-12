//
//  BestGoodsCell.h
//  LXY
//
//  Created by guohui on 16/3/23.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"
@interface BestGoodsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goods_image;
@property (weak, nonatomic) IBOutlet UILabel *goods_name;
@property (weak, nonatomic) IBOutlet UILabel *goods_price;

@property (weak, nonatomic) IBOutlet UILabel *goods_salenum;

//evaluation_good_star 评星
@property (weak, nonatomic) IBOutlet UIView *startView;
- (void)configWithHomemodel:(HomeModel *)model ;
@end
