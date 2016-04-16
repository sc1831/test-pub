//
//  ShoppingCartCell.h
//  LXY
//
//  Created by guohui on 16/3/15.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingCartModel.h"

@interface ShoppingCartCell : UITableViewCell
//商品名称
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
//商品
@property (weak, nonatomic) IBOutlet UILabel *shopDetailContent;

//商品价位
@property (weak, nonatomic) IBOutlet UILabel *shopMoney;
//按钮
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
//按钮图标
@property (weak, nonatomic) IBOutlet UIImageView *btnImage;
//增加按钮
@property (weak, nonatomic) IBOutlet UIButton *addButton;
//减少按钮
@property (weak, nonatomic) IBOutlet UIButton *reductionButton;
//数量
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodsImageViewHeight;
-(void)dataWithCell:(ShoppingCartModel *)model andAllGoods:(int)allGoods;


-(void)dataWithCell:(ShoppingCartModel *)model sectionIndexValue:(int)indexValue andAllGoods:(int)allGoods;
@end
