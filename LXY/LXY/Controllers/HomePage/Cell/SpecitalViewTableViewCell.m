//
//  SpecitalViewTableViewCell.m
//  LXY
//
//  Created by guohui on 16/3/25.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "SpecitalViewTableViewCell.h"

#import "SDWebImage/UIImageView+WebCache.h"
@implementation SpecitalViewTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    
}

- (void)configWithHomeModel:(HomeModel *)homemodel{
    self.describeLabel.text = homemodel.goods_name ;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",homemodel.goods_price];
    [self.goods_imageView sd_setImageWithURL:[NSURL URLWithString:homemodel.goods_image] placeholderImage:[UIImage imageNamed:@""]];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
