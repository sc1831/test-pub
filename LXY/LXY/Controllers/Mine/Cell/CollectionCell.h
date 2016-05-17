//
//  CollectionCell.h
//  LXY
//
//  Created by guohui on 16/3/15.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionCell : UITableViewCell
//购买的商品名称
@property (weak, nonatomic) IBOutlet UILabel *contentsLabel;
//购买价位
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
//销售数量
@property (weak, nonatomic) IBOutlet UILabel *salesLabel;
//添加按钮
@property (weak, nonatomic) IBOutlet UIButton *addButton;
//产品图片
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *productImageViewWedth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loeadWedth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottmHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;

@end
