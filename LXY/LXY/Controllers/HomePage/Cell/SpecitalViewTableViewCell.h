//
//  SpecitalViewTableViewCell.h
//  LXY
//
//  Created by guohui on 16/3/25.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"
@interface SpecitalViewTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *describeLabel; //描述label
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *goods_imageView;
- (void)configWithHomeModel:(HomeModel *)homemodel ;
@end
