//
//  CompositeCell.m
//  LXY
//
//  Created by guohui on 16/3/15.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "CompositeCell.h"
#import "Common.h"
@implementation CompositeCell

- (void)awakeFromNib {
    // Initialization code

    
}

- (void)configWithGoodsModel:(GoodsModel *)model{
    [self.goods_image sd_setImageWithURL:[NSURL URLWithString:model.goods_image] placeholderImage:[UIImage imageNamed:@""]];
    self.goods_name.text = model.goods_name ;
    self.goods_price.text = [NSString stringWithFormat:@"¥%@",model.goods_price];
    self.goods_salenum.text = STR_A_B(@"销量", model.goods_salenum);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
