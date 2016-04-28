//
//  OrderDetailCell.m
//  LXY
//
//  Created by guohui on 16/4/14.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "OrderDetailCell.h"
#import "Common.h"
@implementation OrderDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)configViewGoodsModel:(GoodsModel *)model{
    [self.goodsIcon sd_setImageWithURL:[NSURL URLWithString:model.goods_image] placeholderImage:[UIImage imageNamed:@""]];
    self.goodsName.text = model.goods_name ;
    self.goodsNum.text = STR_A_B(@"数量", model.goods_num);
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
