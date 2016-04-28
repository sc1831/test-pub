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
#import "UITableView+MJRefresh.h"

@interface MyfootprintVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myFooterTableView;
@property (nonatomic ,strong) NSMutableArray *dataArray;
@property (nonatomic ,strong)NSString *goodIds;
@property (nonatomic) int pageCount;
@end

@implementation MyfootprintVC
{

    int _page  ;//当前页码
    int _pageSize ;
    NSMutableArray *goods_Mtlist ;
    RequestCenter *requestCenter;
    NSMutableDictionary *postDic ;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的足迹" ;
    _dataArray = [NSMutableArray array];
    
    postDic = [NSMutableDictionary dictionaryWithCapacity:0];
    requestCenter = [RequestCenter shareRequestCenter];
    [postDic setValue:VALUETOSTR(_page) forKey:@"page"];
    //    [postDic setValue:VALUETOSTR(_pageSize) forKey:@"pageamount"];
    [postDic setValue:[[SaveInfo shareSaveInfo]user_id] forKey:@"user_id"];

    
    [self addMjHeaderAndFooter];
    [self.myFooterTableView headerBeginRefresh];
    
    [GHControl setExtraCellLineHidden:_myFooterTableView];

}
#pragma mark MJRefresh
- (void)addMjHeaderAndFooter{
   
    [self.myFooterTableView headerAddMJRefresh:^{//添加顶部刷新功能
        [self.myFooterTableView footerResetNoMoreData];//重置无数据状态
        [postDic setValue:@"1" forKey:@"page"];
        if (![GHControl isExistNetwork]) {
            HUDNormal(@"服务器无响应，请稍后重试");
            [self.myFooterTableView headerEndRefresh];
            return;
        }
        [requestCenter sendRequestPostUrl:MY_FOOTER andDic:postDic setSuccessBlock:^(NSDictionary *resultDic) {
            [self.myFooterTableView headerEndRefresh];
            
            if ([resultDic[@"code"] intValue] != 1) {
                BG_LOGIN ;
                return ;
            }
            [_dataArray removeAllObjects];
            
            NSDictionary *dict = resultDic[@"data"];
            _page = [dict[@"page"] intValue];
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

            [_myFooterTableView reloadData];
        
            
        } setFailBlock:^(NSString *errorStr) {
            [self.myFooterTableView headerEndRefresh];
        }];
        
    }];
    
    [self.myFooterTableView footerAddMJRefresh:^{
        [postDic setValue:VALUETOSTR(_page) forKey:@"page"];
        if (![GHControl isExistNetwork]) {
            HUDNormal(@"服务器无响应，请稍后重试");
            [self.myFooterTableView headerEndRefresh];
            return;
        }
        [requestCenter sendRequestPostUrl:MY_COLLECT andDic:postDic setSuccessBlock:^(NSDictionary *resultDic) {
            
            if (_page>[resultDic[@"data"][@"pageamount"] intValue]) {
                return ;
            }
            
            if ([resultDic[@"code"] intValue] != 1) {
                BG_LOGIN ;
                return ;
            }
            
            if ([[resultDic[@"code"] stringValue] isEqualToString:@"1"]) {
                NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:0];
                NSInteger count = _dataArray.count ;
                NSArray *goods_list = resultDic[@"data"] [@"list"];
                for (int i = 0 ; i <goods_list.count ; i++) {
                    NSDictionary *dic = goods_list[i] ;
                    MyFooterModel *model = [[MyFooterModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    [_dataArray addObject:model];
                    [indexPaths addObject:[NSIndexPath indexPathForRow:count + i inSection:0]];
                }
                if (indexPaths.count <= 0) {
                    [self.myFooterTableView footerEndRefreshNoMoreData];
                }else{
                    _page ++ ;
                    [self.myFooterTableView footerEndRefresh];
                    
                    [self.myFooterTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }else{
                [self.myFooterTableView footerEndRefresh ];
            }
            
        } setFailBlock:^(NSString *errorStr) {
        }];
        
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
    
    if (![GHControl isExistNetwork]) {
        HUDNormal(@"服务器无响应，请稍后重试");

        return;
    }
    
    RequestCenter * request = [RequestCenter shareRequestCenter];
    NSDictionary *postDics = @{
                              @"user_id":[[SaveInfo shareSaveInfo]user_id]
                              };
    
    [request sendRequestPostUrl:MY_DELLECT_FOOTER andDic:postDics setSuccessBlock:^(NSDictionary *resultDic) {
        if ([resultDic[@"code"] intValue]==0) {
            HUDNormal(@"数据清空失败，请稍后再试");
            return ;
        }
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
    cell.moneyLabel.text =[NSString stringWithFormat:@"￥%@",model.goods_price];
    [cell.productImageView sd_setImageWithURL:[NSURL URLWithString:model.goods_image] placeholderImage:[UIImage imageNamed:@"商品默认图"]];
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
