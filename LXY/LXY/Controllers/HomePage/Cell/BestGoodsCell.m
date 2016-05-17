//
//  BestGoodsCell.m
//  LXY
//
//  Created by guohui on 16/3/23.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "BestGoodsCell.h"
#import "Common.h"
@implementation BestGoodsCell

- (void)awakeFromNib {
    // Initialization code

}
- (void)configWithHomemodel:(HomeModel *)model{
    [self.goods_image sd_setImageWithURL:[NSURL URLWithString:model.goods_image] placeholderImage:[UIImage imageNamed:@""]];
    self.goods_name.text = model.goods_name ;
    self.goods_price.text = STR_A_B(@"¥", model.goods_price)  ;
    self.goods_salenum.text = model.goods_salenum ;
    
    UIImageView *bgStarImageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 84, 14 )];
    bgStarImageView.image = [UIImage imageNamed:@"星星灰.png"];
    bgStarImageView.contentMode=UIViewContentModeLeft;//这个居中是包括了，横向和纵向都是居中。图片不会拉伸或者压缩，就是按照imageView的frame和图片的大小来居中显示的。
    [self.startView addSubview:bgStarImageView];

    
    UIImageView *startImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 84, 14 )];
    startImageView.image = [UIImage imageNamed:@"星星.png"];
    startImageView.contentMode=UIViewContentModeLeft;
    //设置裁剪，超出部分裁剪
    startImageView.clipsToBounds=YES;
    [self.startView addSubview:startImageView] ;
    float x = startImageView.frame.size.width/5.0f*[model.evaluation_good_star floatValue];
    
    startImageView.frame = CGRectMake(0, 0, x, 14);
    
//    self.evaluation_starImageView.contentMode = UIViewContentModeLeft ;
//    self.evaluation_starImageView.clipsToBounds = YES ;
//
//    float x = self.evaluation_starImageView.frame.size.width/5.0f*[model.evaluation_good_star floatValue];
//    
//    self.evaluation_starImageView.frame = CGRectMake(0, 0, 30, self.evaluation_starImageView.frame.size.height);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
