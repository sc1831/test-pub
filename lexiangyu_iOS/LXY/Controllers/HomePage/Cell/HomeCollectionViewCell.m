//
//  HomeCollectionViewCell.m
//  LXY
//
//  Created by guohui on 16/3/23.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "HomeCollectionViewCell.h"
#import "Common.h"
@implementation HomeCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)configWithHomemodel:(HomeModel *)model{
    self.goods_name.text = model.goods_name ;
    self.goods_price.text = [NSString stringWithFormat:@"¥%@",model.goods_price];
    [self.goods_imageView sd_setImageWithURL:[NSURL URLWithString:model.goods_image] placeholderImage:[UIImage imageNamed:@""]];

}
@end
