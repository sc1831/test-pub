//
//  ClassifyCollectionCell.m
//  LXY
//
//  Created by guohui on 16/3/18.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "ClassifyCollectionCell.h"
#import "common.h"
@implementation ClassifyCollectionCell
- (void)configWithGoodsModel:(GoodsModel *)model{
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.goods_image] placeholderImage:[UIImage imageNamed:@""]];
    self.goodsNameLab.text = model.goods_name ;
    

}
- (void)awakeFromNib {
    // Initialization code
}

@end
