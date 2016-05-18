//
//  WaitGetVC.m
//  LXY
//
//  Created by guohui on 16/3/15.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "WaitGetVC.h"
#import "Common.h"
#import "GHControl.h"
//#import "WaiteGetCell.h"
#import "RequestCenter.h"
#import "SaveInfo.h"
#import "AllGoodsOrders.h"
#import "MenyGoodsCell.h"
#import "WaiteSendCell.h"
#import "UITableView+MJRefresh.h"

#import "OrderDetailsVC.h"
#import "ShopingDetailsVC.h"
@interface WaitGetVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,strong)UITableView *waitGetTableView;
@property (nonatomic ,strong)UIControl *headView;
@property (nonatomic ,strong)UIView *footView;
@property (nonatomic ,strong)NSMutableArray *dataArray;
@property (nonatomic ,strong)NSMutableArray *subMutArray;
@property (nonatomic ,strong)UILabel *label;
@end

@implementation WaitGetVC
{
    
    int _page  ;//当前页码
    int _pageSize ;
    RequestCenter *requestCenter;
    NSMutableDictionary *postDic ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"待收货";
    _dataArray = [NSMutableArray array];
    _subMutArray = [NSMutableArray array];
    
    [self createTableView];
    
    _label = [GHControl createLabelWithFrame:CGRectMake(30, M_HEIGHT/2-20, M_WIDTH-60, 40) Font:15 Text:@"暂时还没有要收货的订单哦"];
    _label.textColor = RGBCOLOR(99, 100, 101);
    _label.textAlignment = NSTextAlignmentCenter;
    _label.hidden = YES;
    [self.view addSubview:_label];
    
    postDic = [NSMutableDictionary dictionaryWithCapacity:0];
    requestCenter = [RequestCenter shareRequestCenter];
    [postDic setValue:VALUETOSTR(_page) forKey:@"page"];
    //    [postDic setValue:VALUETOSTR(_pageSize) forKey:@"pageamount"];
    [postDic setValue:[[SaveInfo shareSaveInfo]user_id] forKey:@"user_id"];
    [postDic setValue:@"30" forKey:@"order_state"];
    
    
    [self addMjHeaderAndFooter];
    [self.waitGetTableView headerBeginRefresh];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refishViewFour) name:@"refishViewFour" object:nil];
    
    [self.view addSubview:self.noNetworkView];
    
    
}
-(void)refishViewFour{
    
    [self addMjHeaderAndFooter];
    [self.waitGetTableView headerBeginRefresh];
    
}
//重新加载数据
-(void)NoNetworkClickDelegate{
    if (![GHControl isExistNetwork]) {
        self.noNetworkView.hidden = NO;
        return;
    }
    self.noNetworkView.hidden = YES;
    [self addMjHeaderAndFooter];
    [self.waitGetTableView headerBeginRefresh];
}


#pragma mark MJRefresh
- (void)addMjHeaderAndFooter{
    
    if (![GHControl isExistNetwork]) {
        
        if (_dataArray.count>0) {
            self.noNetworkView.hidden = YES;
        }else{
            self.noNetworkView.hidden = NO;
        }
        
        [self.waitGetTableView headerEndRefresh];
        return;
    }else{
        
        self.noNetworkView.hidden = YES;
        
    }
    
    [self.waitGetTableView headerAddMJRefresh:^{//添加顶部刷新功能
        [self.waitGetTableView footerResetNoMoreData];//重置无数据状态
        [postDic setValue:@"1" forKey:@"page"];
        
        
        
        [requestCenter sendRequestPostUrl:MY_REGISTER andDic:postDic setSuccessBlock:^(NSDictionary *resultDic) {
            [self.waitGetTableView headerEndRefresh];
            if ([resultDic[@"code"] intValue] != 1) {
                BG_LOGIN ;
                return ;
            }
            
            [_subMutArray removeAllObjects];
            [_dataArray removeAllObjects];
            
            NSDictionary *dict = resultDic[@"data"];
            _page = [dict[@"page"] intValue];
            NSArray *array = dict[@"list"];
            for (NSDictionary *subDic in array) {
                AllGoodsOrders *model = [AllGoodsOrders modelWithDic:subDic];
                NSArray *subArray = subDic[@"order_goods"];
                NSMutableArray *mutArray = [NSMutableArray array];
                for (NSDictionary *smallDic in subArray) {
                    AllGoodsOrders *model = [AllGoodsOrders modelWithDic:smallDic];
                    [mutArray addObject:model];
                }
                [_subMutArray addObject:mutArray];
                
                [_dataArray addObject:model];
            }
            _page = 2;
            if (_dataArray.count ==0) {
                _label.hidden = NO;
                return;
            }else{
                
                _label.hidden = YES;
            }
            [_waitGetTableView reloadData];
            
        } setFailBlock:^(NSString *errorStr) {
            [self.waitGetTableView headerEndRefresh];
        }];
        
    }];
    
    [self.waitGetTableView footerAddMJRefresh:^{
        [postDic setValue:VALUETOSTR(_page) forKey:@"page"];
        
        
        
        [requestCenter sendRequestPostUrl:MY_REGISTER andDic:postDic setSuccessBlock:^(NSDictionary *resultDic) {
            
            if (_page>[resultDic[@"data"][@"pageamount"] intValue]) {
                
                return ;
            }
            if ([resultDic[@"code"] intValue] != 1) {
                BG_LOGIN ;
                return ;
            }
            
            if ([[resultDic[@"code"] stringValue] isEqualToString:@"1"]) {
                NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:0];
                //                NSInteger count = _dataArray.count ;
                NSArray *goods_list = resultDic[@"data"] [@"list"];
                
                
                for (int i = 0 ; i <goods_list.count ; i++) {
                    NSDictionary *dic = goods_list[i] ;
                    AllGoodsOrders *model = [AllGoodsOrders modelWithDic:dic];
                    [_dataArray addObject:model];
                    
                    
                    
                    
                    NSArray *subArray = dic[@"order_goods"];
                    NSMutableArray *mutArray = [NSMutableArray array];
                    for (NSDictionary *smallDic in subArray) {
                        AllGoodsOrders *model = [AllGoodsOrders modelWithDic:smallDic];
                        [mutArray addObject:model];
                    }
                    [_subMutArray addObject:mutArray];
                    
                    //                    MY_REFRESH(count);
                    [_waitGetTableView reloadData];
                    
                }
                if (indexPaths.count <= 0) {
                    [self.waitGetTableView footerEndRefreshNoMoreData];
                }else{
                    _page ++ ;
                    [self.waitGetTableView footerEndRefresh];
                    
                    [self.waitGetTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }else{
                [self.waitGetTableView footerEndRefresh ];
            }
            
        } setFailBlock:^(NSString *errorStr) {
        }];
        
    }];
    
}

-(void)createTableView{
    if (_isMineGetPush) {
        _isMineGetPush = NO;
        _waitGetTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, M_WIDTH, M_HEIGHT) style:UITableViewStyleGrouped];
    }else{
        
        _waitGetTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, M_WIDTH, M_HEIGHT-94) style:UITableViewStyleGrouped];
    }
    
    _waitGetTableView.delegate = self;
    _waitGetTableView.dataSource = self;
    _waitGetTableView.backgroundColor = RGBCOLOR(219, 223, 224);
    [self.view addSubview:_waitGetTableView];
    
}

#pragma mark-----UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    [self createHeadView];
    
    AllGoodsOrders *model = _dataArray[section];
    
    UILabel *label = [GHControl createLabelWithFrame:CGRectMake(35,11,60, 30) Font:14 Text:@"订单号:"];
    label.textColor = RGBCOLOR(99, 100, 101);
    [_headView addSubview:label];
    UILabel *labelNum = [GHControl createLabelWithFrame:CGRectMake(83,11, M_WIDTH-110, 30) Font:14 Text:model.pay_sn];
    labelNum.textColor = RGBCOLOR(204,204,204);
    [_headView addSubview:labelNum];
    
    UILabel *waitLabel = [GHControl createLabelWithFrame:CGRectMake(M_WIDTH-70,11,70, 30) Font:13 Text:@"等待收货"];
    waitLabel.textColor = RGBCOLOR(249, 147, 73);
    [_headView addSubview:waitLabel];
    
    
    _headView.tag = section ;
    [_headView addTarget:self action:@selector(headerClick:) forControlEvents:UIControlEventTouchUpInside];
    return _headView;
    
}
- (void)headerClick:(UIControl *)control{
    AllGoodsOrders *model = _dataArray[control.tag];
    OrderDetailsVC *detailVC = [[OrderDetailsVC alloc]init];
    detailVC.order_id = model.pay_sn ;
    [self.navigationController pushViewController:detailVC animated:YES];
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    [self createFootView];
    
    AllGoodsOrders *model = _dataArray[section];
    
    UILabel *label = [GHControl createLabelWithFrame:CGRectMake(18,5,60, 30) Font:14 Text:@"已付款:"];
    label.textColor = RGBCOLOR(99, 100, 101);
    [_footView addSubview:label];
    
    UILabel *moneyLabel = [GHControl createLabelWithFrame:CGRectMake(78, 5,M_WIDTH-150, 30) Font:14 Text:model.order_amount];
    moneyLabel.font = [UIFont boldSystemFontOfSize:14];
    moneyLabel.textColor = RGBCOLOR(249, 147, 73);
    [_footView addSubview:moneyLabel];
    
    UIButton *btn = [GHControl createButtonWithFrame:CGRectMake(M_WIDTH-90,5,75, 30) ImageName:@"评价商品_默认" Target:self Action:@selector(btnClick:) Title:@"确认收货"];
    btn.tag = section ;
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:RGBCOLOR(249, 147, 73) forState:UIControlStateNormal];
    [_footView addSubview:btn];
    
    return _footView;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 45;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([_subMutArray[indexPath.section] count]==1) {
        static NSString *cellName = @"WaiteSendCell";
        
        WaiteSendCell *cell =
        (WaiteSendCell *)[tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:cellName owner:self options:nil] firstObject];
            
        }
        AllGoodsOrders *model = _subMutArray[indexPath.section][indexPath.row];
        cell.shopName.text = model.goods_name;
        cell.shopNum.text = [NSString stringWithFormat:@"X%@",model.goods_num];
        AllGoodsOrders *dataModel = _dataArray[indexPath.section];
        cell.shopTime.text = dataModel.add_time;
        [cell.shopImage sd_setImageWithURL:[NSURL URLWithString:model.goods_image] placeholderImage:[UIImage imageNamed:@"商品默认图"]];
        
        
        return cell;
        
    }else{
        static NSString *cellName = @"MenyGoodsCell";
        
        MenyGoodsCell *cell =
        (MenyGoodsCell *)[tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:cellName owner:self options:nil] firstObject];
        }
        
        
        [cell modelWithArray:_subMutArray[indexPath.section]];
        
        return cell;
    }
    
    
}

//- (void)cellClick:(UIControl *)control {
//    NSLog(@"control.tag : %ld",control.tag);
//    OrderDetailsVC *detailVC = [[OrderDetailsVC alloc]init];
//    AllGoodsOrders *model = _dataArray[control.tag];
//    detailVC.order_id = model.pay_sn ;
//    [self.navigationController pushViewController:detailVC animated:YES];
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    if (indexPath.section == 0) {
    //        return 50;
    //    }
    return 77;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CELLSELECTANIMATE ;
    AllGoodsOrders *model =  _subMutArray[indexPath.section][indexPath.row];
    ShopingDetailsVC *shoppingDetailsVC = [[ShopingDetailsVC alloc] init];
    shoppingDetailsVC.goods_commonid = model.goods_id ;
    [self.navigationController pushViewController:shoppingDetailsVC animated:YES];
    
}



-(void)btnClick:(UIButton *)btn{
    AllGoodsOrders *model = _dataArray[btn.tag];
    [requestCenter sendRequestPostUrl:CONFIRM_RECEIPT andDic:@{@"pay_sn":model.pay_sn} setSuccessBlock:^(NSDictionary *resultDic) {
        if ([resultDic[@"code"] intValue] != 1) {
            BG_LOGIN ;
            return ;
        }
        HUDNormal(resultDic[@"msg"]);
        [self.waitGetTableView headerBeginRefresh];
    } setFailBlock:^(NSString *errorStr) {
    }];
    NSLog(@"确认收货");
}


#pragma mark------headView  footView
-(UIView *)createHeadView{
    _headView = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, M_WIDTH,45)];
    _headView.backgroundColor = [UIColor whiteColor];
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, M_WIDTH,5)];
    topView.backgroundColor = RGBCOLOR(219, 223, 224);
    [_headView addSubview:topView];
    
    UIImage *headImage = [UIImage imageNamed:@"店铺"];
    UIImageView *headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(16,18, headImage.size.width, headImage.size.height)];
    headImageView.image = headImage;
    [_headView addSubview:headImageView];
    
    
    return _headView;
}
-(UIView *)createFootView{
    _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, M_WIDTH,45)];
    _footView.backgroundColor = [UIColor whiteColor];
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0,40, M_WIDTH,5)];
    topView.backgroundColor = RGBCOLOR(219, 223, 224);
    [_footView addSubview:topView];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0,0, M_WIDTH, 0.5)];
    lineView.backgroundColor = RGBCOLOR(226, 227, 228);
    [_footView addSubview:lineView];
    return _footView;
}

@end
