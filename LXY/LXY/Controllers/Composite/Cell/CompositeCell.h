//
//  CompositeCell.h
//  LXY
//
//  Created by guohui on 16/3/15.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsModel.h"
@interface CompositeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goods_image;
@property (weak, nonatomic) IBOutlet UILabel *goods_name;
@property (weak, nonatomic) IBOutlet UILabel *goods_price;
@property (weak, nonatomic) IBOutlet UILabel *goods_salenum;
@property (weak, nonatomic) IBOutlet UIButton *addShopingCar;
- (void)configWithGoodsModel:(GoodsModel *)model ;


@end
