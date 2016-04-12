//
//  MenyGoodsCell.h
//  LXY
//
//  Created by guohui on 16/4/11.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AllGoodsOrders;
@interface MenyGoodsCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (nonatomic ,strong)UITableView *specialTableView;
@property (nonatomic ,strong)NSMutableArray *dataMutArray;
-(void)modelWithArray:(NSMutableArray *)mutArray;
@end
