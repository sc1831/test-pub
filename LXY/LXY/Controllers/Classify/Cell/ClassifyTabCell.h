//
//  ClassifyTabCell.h
//  LXY
//
//  Created by guohui on 16/3/18.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassModel.h"
@interface ClassifyTabCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
- (void)changeFlageby:(BOOL)flag ;
- (void)configWithClassModel:(ClassModel *)model ;
@end
