//
//  ConfirmTableViewCell.h
//  LXY
//
//  Created by guohui on 16/4/13.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *shopMoney;
@property (weak, nonatomic) IBOutlet UILabel *shopNum;
@property (weak, nonatomic) IBOutlet UIImageView *shopImage;
@property (weak, nonatomic) IBOutlet UILabel *shopKilogramp;
@end
