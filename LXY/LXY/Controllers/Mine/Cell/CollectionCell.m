//
//  CollectionCell.m
//  LXY
//
//  Created by guohui on 16/3/15.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "CollectionCell.h"

@implementation CollectionCell

- (void)awakeFromNib {
    // Initialization code
    _productImageViewWedth.constant = 72;
    _loeadWedth.constant = 0.5;
    _topHeight.constant = 5.5;
    _bottmHeight.constant = 5.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
