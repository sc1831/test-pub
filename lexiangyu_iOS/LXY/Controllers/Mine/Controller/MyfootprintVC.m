//
//  MyfootprintVC.m
//  LXY
//
//  Created by guohui on 16/3/16.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "MyfootprintVC.h"
#import "FootPointCell.h"
#import "GHControl.h"
#import "RequestCenter.h"
#import "MyFooterModel.h"
#import "SaveInfo.h"
#import "ShopingDetailsVC.h"

@interface MyfootprintVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myFooterTableView;
@property (nonatomic ,strong) NSMutableArray *dataArray;
@property (nonatomic ,strong)NSString *goodIds;
@property (nonatomic ,assign)int page;
@property (nonatomic) int pageCount;
@end

@implementation MyfootprintVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的足迹" ;
    _dataArray = [NSMutableArray array];
    [self sendRequestData];
    
    
    
    [GHControl setExtraCellLineHidden:_myFooterTableView];

}
-(void)sendRequestData{
    
    RequestCenter * request = [RequestCenter shareRequestCenter];
    NSDictionary *postDic = @{@"page":@"0",
                              @"user_id":[[SaveInfo shareSaveInfo]user_id]
                              };
    
    [request sendRequestPostUrl:MY_FOOTER andDic:postDic setSuccessBlock:^(NSDictionary *resultDic) {
        
        if (resultDic[@"code"]==0) {
            HUDNormal(@"获取数据失败，请稍后再试");
            return ;
        }
        
        
        NSDictionary *dict = resultDic[@"data"];
        _page = [dict[@"page"] intValue];
        _pageCount = [dict[@"pageamount"] intValue];
        NSArray *array = dict[@"list"];
        NSString *str;
        for (NSDictionary *subDic in array) {
            MyFooterModel *model = [MyFooterModel modelWithDic:subDic];
            if (_dataArray.count<1) {
                str = [NSString stringWithFormat:@"%@,",model.goods_id];
                _goodIds = str;
            }else{
                 str = [NSString stringWithFormat:@"%@,",model.goods_id];
                _goodIds = [NSString stringWithFormat:@"%@%@",_goodIds,str];
                
            }
           
            [_dataArray addObject:model];
        }
        
        [self isHiddenEmptyButton];
        if (_dataArray.count==0) {
            HUDNormal(@"暂时无数据");
            return;
        }
//        HUDNormal(@"获取数据成功");
        [_myFooterTableView reloadData];
    } setFailBlock:^(NSString *errorStr) {
        NSLog(@"");
        
    }];
}
-(void)isHiddenEmptyButton{

    if (_dataArray.count>0) {
        UIButton *rightNarBtn = [GHControl createButtonWithFrame:CGRectMake(0, 0,50,30) ImageName:nil Target:self Action:@selector(rightNavBtnClick) Title:@"清空"];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightNarBtn];
    }
}
-(void)rightNavBtnClick{

    NSLog(@"清空点击");
    
    [self sendDelleteRequestData];
    
}
-(void)sendDelleteRequestData{
    
    RequestCenter * request = [RequestCenter shareRequestCenter];
    NSDictionary *postDic = @{
                              @"user_id":[[SaveInfo shareSaveInfo]user_id]
                              };
    
    [request sendRequestPostUrl:MY_DELLECT_FOOTER andDic:postDic setSuccessBlock:^(NSDictionary *resultDic) {
        HUDNormal(@"清空数据成功");
        [_dataArray removeAllObjects];
        [self isHiddenEmptyButton];
        [_myFooterTableView reloadData];
    } setFailBlock:^(NSString *errorStr) {
        NSLog(@"");
        
    }];
}

#pragma mark-----UItableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 10;
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"FootPointCell";
    FootPointCell *cell =
    (FootPointCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellId owner:self options:nil] firstObject];
        
    }
    MyFooterModel *model = _dataArray[indexPath.row];
    cell.contentsLabel.text = model.goods_name;
    cell.moneyLabel.text = model.goods_price;
    [cell.productImageView sd_setImageWithURL:[NSURL URLWithString:model.goods_image] placeholderImage:[UIImage imageNamed:@"火影1"]];
    cell.productImageView.layer.masksToBounds = YES;
    cell.productImageView.layer.cornerRadius = 3;
    
    
    return cell;
}
-(void)addButtonClick:(UIButton *)btn{
    NSLog(@"%ld",(long)btn.tag);
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    NSLog(@"%@",_dataArray[indexPath.row]);
    [UIView animateWithDuration:0.3f
                     animations:^{
                         [tableView deselectRowAtIndexPath:indexPath animated:YES];
                     }];
    ShopingDetailsVC *shoppingDetailsVC = [[ShopingDetailsVC alloc]init];
     MyFooterModel *model = _dataArray[indexPath.row];
    shoppingDetailsVC.goods_commonid = model.goods_id ;
    shoppingDetailsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shoppingDetailsVC animated:YES];
    
    
}


@end
