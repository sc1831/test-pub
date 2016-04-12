//
//  ClassifyCollectionCell.h
//  LXY
//
//  Created by guohui on 16/3/18.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsModel.h"
@interface ClassifyCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLab;
- (void)configWithGoodsModel:(GoodsModel *)model ;
@end
