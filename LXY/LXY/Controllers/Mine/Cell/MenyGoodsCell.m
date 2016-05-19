//
//  MenyGoodsCell.m
//  LXY
//
//  Created by guohui on 16/4/11.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "MenyGoodsCell.h"
#import "GHControl.h"
#import "Common.h"
#import "AllGoodsOrders.h"
#import "ShopingDetailsVC.h"
@implementation MenyGoodsCell

- (void)awakeFromNib {
    // Initialization code
    _dataMutArray = [NSMutableArray array];
    _specialTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,70,_backView.frame.size.width+50) style:UITableViewStylePlain];
    _specialTableView.delegate = self;
    _specialTableView.dataSource = self;
    _specialTableView.tag = 20;
    _specialTableView.center = CGPointMake((_backView.frame.size.width+50) / 2, _backView.frame.size.height / 2);
    //逆时针旋转90°
    _specialTableView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
    _specialTableView.showsVerticalScrollIndicator = NO;
    _specialTableView.backgroundColor = [UIColor whiteColor];
    _specialTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_backView addSubview:_specialTableView];
    [GHControl setExtraCellLineHidden:_specialTableView];
}
-(void)modelWithArray:(NSMutableArray *)mutArray{

    _dataMutArray = [NSMutableArray arrayWithArray:mutArray];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellName = @"Indentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    // cell顺时针旋转90度
    cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    AllGoodsOrders *model = _dataMutArray[indexPath.row];
   
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(7,5, 60, 60)];

    [imageView sd_setImageWithURL:[NSURL URLWithString:model.goods_image] placeholderImage:[UIImage imageNamed:@"商品默认图"]];
    [cell.contentView addSubview:imageView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    return cell;
}
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataMutArray.count;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 77;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [UIView animateWithDuration:0.3f
                     animations:^{
                         [tableView deselectRowAtIndexPath:indexPath animated:YES];
                     }];
    // 获取导航控制器
    AllGoodsOrders *model = _dataMutArray[indexPath.row];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"MenyCellgotoVC" object:model.goods_id];

}

@end
