//
//  ShoppingCartCell.m
//  LXY
//
//  Created by guohui on 16/3/15.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "ShoppingCartCell.h"
#import "GHControl.h"
#import "Common.h"
@implementation ShoppingCartCell

- (void)awakeFromNib {
    // Initialization code
    
    _goodsImageViewHeight.constant = 80;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)dataWithCell:(ShoppingCartModel *)model andAllGoods:(int)allGoods{

    _contentLabel.text = model.goods_name;
    _shopMoney.text = [NSString stringWithFormat:@"￥%@",model.goods_price];

    [_numberBtn setTitle:model.goods_num forState:UIControlStateNormal];
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.goods_image] placeholderImage:[UIImage imageNamed:@"商品默认图"]];
    _goodsImageView.layer.masksToBounds = YES;
    _goodsImageView.layer.cornerRadius = 3;
    
    if ([model.goods_num intValue]<2) {
        _reductionButton.userInteractionEnabled = NO;
        [_reductionButton setBackgroundImage:[UIImage imageNamed:@"数量选择_点击1.png"] forState:UIControlStateNormal];
    }
    if ([model.goods_num intValue]>1) {
        _reductionButton.userInteractionEnabled = YES;
        [_reductionButton setBackgroundImage:[UIImage imageNamed:@"数量选择1.png"] forState:UIControlStateNormal];
    }
    
    UIImage *image = nil;
    if(model.isSelected) {
        image = [UIImage imageNamed:@"选中"];
    }
    else {
        image = [UIImage imageNamed:@"未选中"];
    }
    
    if (allGoods == 1) {
        image = [UIImage imageNamed:@"选中"];
        model.isSelected = YES;
    }else if (allGoods == 2){
        image = [UIImage imageNamed:@"未选中"];
        model.isSelected = NO;
        
    }else{
        
    }
//    if (model.isHeadSelected) {
//        image = [UIImage imageNamed:@"选中"];
//        model.isSelected = YES;
//    }
    
    [_rightButton setBackgroundImage:image forState:UIControlStateNormal];

}

-(void)dataWithCell:(ShoppingCartModel *)model sectionIndexValue:(int)indexValue andAllGoods:(int)allGoods{

    _contentLabel.text = model.goods_name;
    _shopMoney.text = [NSString stringWithFormat:@"￥%@",model.goods_price];
    [_numberBtn setTitle:model.goods_num forState:UIControlStateNormal];
    
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.goods_image] placeholderImage:[UIImage imageNamed:@"商品默认图"]];
    _goodsImageView.layer.masksToBounds = YES;
    _goodsImageView.layer.cornerRadius = 3;
    
    if ([model.goods_num intValue]<2) {
        _reductionButton.userInteractionEnabled = NO;
        [_reductionButton setBackgroundImage:[UIImage imageNamed:@"数量选择_点击1.png"] forState:UIControlStateNormal];
    }
    if ([model.goods_num intValue]>1) {
        _reductionButton.userInteractionEnabled = YES;
        [_reductionButton setBackgroundImage:[UIImage imageNamed:@"数量选择1.png"] forState:UIControlStateNormal];
    }
    
    UIImage *image = nil;
    if(model.isSelected) {
        image = [UIImage imageNamed:@"选中"];
    }
    else {
        image = [UIImage imageNamed:@"未选中"];
    }
    
    if (allGoods == 1) {
        image = [UIImage imageNamed:@"选中"];
        model.isSelected = YES;
    }else if (allGoods == 2){
        image = [UIImage imageNamed:@"未选中"];
        model.isSelected = NO;
        
    }else{
        
    }
    if (indexValue==2) {
        image = [UIImage imageNamed:@"选中"];
        model.isSelected = YES;
    }
//    else if (indexValue == 1){
//        image = [UIImage imageNamed:@"未选中"];
//        model.isSelected = NO;
//        
//    }
    
        
    [_rightButton setBackgroundImage:image forState:UIControlStateNormal];
}
@end
