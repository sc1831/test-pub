//
//  HeadTableView.h
//  LXY
//
//  Created by guohui on 16/4/13.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeadTableView : UIView

//修改收货地址
@property (weak, nonatomic) IBOutlet UIButton *changeAddressBtn;
//手机号
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
//收货地址
@property (weak, nonatomic) IBOutlet UITextView *addressTextView;
@end
