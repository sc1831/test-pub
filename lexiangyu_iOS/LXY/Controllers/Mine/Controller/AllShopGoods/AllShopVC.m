//
//  AllShopVC.m
//  LXY
//
//  Created by guohui on 16/3/24.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "AllShopVC.h"
#import "Common.h"
#import "GHControl.h"
#import "ConfirmorderVC.h"
#import "WaiteSendCell.h"
#import "OrderDetailsVC.h"
#import "RequestCenter.h"
#import "SaveInfo.h"
#import "AllGoodsOrders.h"
#import "MenyGoodsCell.h"
#import "UITableView+MJRefresh.h"

@interface AllShopVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UIView *headView;
@property (nonatomic ,strong)UIView *footView;
@property (nonatomic ,strong)NSMutableArray *dataArray;
@property (nonatomic ,strong)NSMutableArray *subMutArray;
@property (nonatomic)int page;
@end

@implementation AllShopVC
{
    int _page  ;//当前页码
    int _pageSize ;
    RequestCenter *requestCenter;
    NSMutableDictionary *postDic ;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"全部";
    _dataArray = [NSMutableArray array];
    _subMutArray = [NSMutableArray array];
    
    [self createTableView];
//    [self sendRequestData];
    
    postDic = [NSMutableDictionary dictionaryWithCapacity:0];
    requestCenter = [RequestCenter shareRequestCenter];
    [postDic setValue:VALUETOSTR(_page) forKey:@"page"];
    //    [postDic setValue:VALUETOSTR(_pageSize) forKey:@"pageamount"];
    [postDic setValue:[[SaveInfo shareSaveInfo]user_id] forKey:@"user_id"];
    [postDic setValue:@"" forKey:@"order_state"];

    
    [self addMjHeaderAndFooter];
    [self.waitPayTableView headerBeginRefresh];
    /**
     NSDictionary *postDic = @{@"order_state":@"",
     @"user_id":[[SaveInfo shareSaveInfo]user_id],
     @"page":@"7"
     };
     */
    
}
#pragma mark MJRefresh
- (void)addMjHeaderAndFooter{
    [self.waitPayTableView headerAddMJRefresh:^{//添加顶部刷新功能
        [self.waitPayTableView footerResetNoMoreData];//重置无数据状态
        [postDic setValue:@"1" forKey:@"page"];
        [requestCenter sendRequestPostUrl:MY_REGISTER andDic:postDic setSuccessBlock:^(NSDictionary *resultDic) {
            [self.waitPayTableView headerEndRefresh];
            if ([resultDic[@"code"] intValue] != 1) {
                BG_LOGIN ;
            }
//            if (resultDic[@"code"]==0) {
//                HUDNormal(@"获取数据失败，请稍后再试");
//                return ;
//            }
//            HUDNormal(@"获取数据成功");
            
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
            [_waitPayTableView reloadData];
            
        } setFailBlock:^(NSString *errorStr) {
            [self.waitPayTableView headerEndRefresh];
        }];
        

    }];
    
    [self.waitPayTableView footerAddMJRefresh:^{
        [postDic setValue:VALUETOSTR(_page) forKey:@"page"];
        [requestCenter sendRequestPostUrl:MY_REGISTER andDic:postDic setSuccessBlock:^(NSDictionary *resultDic) {
            
            if ([resultDic[@"code"] intValue] != 1) {
                BG_LOGIN ;
            }
            
            if ([[resultDic[@"code"] stringValue] isEqualToString:@"1"]) {
                NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:0];
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
                    MY_REFRESH_TWO;

                }
                if (indexPaths.count <= 0) {
                    [self.waitPayTableView footerEndRefreshNoMoreData];
                }else{
                    _page ++ ;
                    [self.waitPayTableView footerEndRefresh];
                    
                    [self.waitPayTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }else{
                [self.waitPayTableView footerEndRefresh ];

            }
            
        } setFailBlock:^(NSString *errorStr) {
        }];
        
    }];
    
}

-(void)createTableView{
    
    _waitPayTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, M_WIDTH, M_HEIGHT-94) style:UITableViewStyleGrouped];
    _waitPayTableView.delegate = self;
    _waitPayTableView.dataSource = self;
    _waitPayTableView.backgroundColor = RGBCOLOR(219, 223, 224);
    [self.view addSubview:_waitPayTableView];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    [self createHeadView];
    AllGoodsOrders *model = _dataArray[section];
    
    UILabel *label = [GHControl createLabelWithFrame:CGRectMake(45,11, 60, 30) Font:14 Text:[NSString stringWithFormat:@"订单号：%ld",140112212155]];
    label.textColor = RGBCOLOR(99, 100, 101);
    [_headView addSubview:label];
    UILabel *labelNum = [GHControl createLabelWithFrame:CGRectMake(95,11, M_WIDTH-90, 30) Font:14 Text:model.order_sn];
    labelNum.textColor = RGBCOLOR(204,204,204);
    [_headView addSubview:labelNum];
    
    
    UILabel *waitLabel = [GHControl createLabelWithFrame:CGRectMake(M_WIDTH-90,11,75, 30) Font:13 Text:@""];
    waitLabel.textColor = RGBCOLOR(249, 147, 73);
    waitLabel.textAlignment = NSTextAlignmentRight;
    [_headView addSubview:waitLabel];
    
    if ([model.order_state intValue]==0) {
        waitLabel.text = @"已取消订单";
    }else if ([model.order_state intValue]== 10){
        
        waitLabel.text = @"等待付款";
        
    }else if ([model.order_state intValue] == 40){
        
        waitLabel.text = @"交易完成";
        waitLabel.textColor = RGBCOLOR(240,30,40);
    }
    
    
    
    return _headView;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    [self createFootView];
    
    AllGoodsOrders *model = _dataArray[section];
    
    UILabel *label = [GHControl createLabelWithFrame:CGRectMake(18,5,60, 30) Font:14 Text:@"已付款:"];
    label.textColor = RGBCOLOR(99, 100, 101);
    [_footView addSubview:label];
    
    //商品价格
    UILabel *moneyLabel = [GHControl createLabelWithFrame:CGRectMake(78, 5,M_WIDTH-150, 30) Font:14 Text:model.order_amount];
    moneyLabel.font = [UIFont boldSystemFontOfSize:14];
    moneyLabel.textColor = RGBCOLOR(249, 147, 73);
    [_footView addSubview:moneyLabel];

    
    
    if ([model.order_state intValue]==0) {
       // 取消订单
        label.text = @"付款:";
        //再次购买按钮
        UIButton *againPayBtn = [GHControl createButtonWithFrame:CGRectMake(M_WIDTH-90,5,75, 30) ImageName:@"评价商品_默认" Target:self Action:@selector(againPayBtnClick:) Title:@"再次购买"];
        againPayBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [againPayBtn setTitleColor:RGBCOLOR(249, 147, 73) forState:UIControlStateNormal];
        [againPayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [againPayBtn setBackgroundImage:[UIImage imageNamed:@"保存修改_点击"] forState:UIControlStateHighlighted];

        againPayBtn.tag = section;
        [_footView addSubview:againPayBtn];
        
    }else if ([model.order_state intValue]== 10){
        
      // 等待付款
        label.text = @"付款:";
        //去支付按钮
        UIButton *payBtn = [GHControl createButtonWithFrame:CGRectMake(M_WIDTH-90,5,75, 30) ImageName:@"评价商品_默认" Target:self Action:@selector(payBtnClick:) Title:@"去支付"];
        payBtn.tag = section;
        payBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [payBtn setTitleColor:RGBCOLOR(249, 147, 73) forState:UIControlStateNormal];
        [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [payBtn setBackgroundImage:[UIImage imageNamed:@"保存修改_点击"] forState:UIControlStateHighlighted];
        payBtn.tag = section;
        [_footView addSubview:payBtn];
        
        
    }else if ([model.order_state intValue] == 20){
    //等待发货
        UIButton *cancelBtn = [GHControl createButtonWithFrame:CGRectMake(M_WIDTH-90,5,75, 30) ImageName:@"评价商品_默认" Target:self Action:@selector(cancelBtnClick:) Title:@"取消订单"];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"保存修改_点击"] forState:UIControlStateHighlighted];
        cancelBtn.tag = section;
        [_footView addSubview:cancelBtn];
        
    }else if ([model.order_state intValue] == 40){
        
       // 交易完成
       label.text = @"共计付款:";
        
        //再次购买按钮
        UIButton *againPayBtn = [GHControl createButtonWithFrame:CGRectMake(M_WIDTH-90,5,75, 30) ImageName:@"评价商品_默认" Target:self Action:@selector(againPayBtnClick:) Title:@"再次购买"];
        againPayBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [againPayBtn setTitleColor:RGBCOLOR(249, 147, 73) forState:UIControlStateNormal];
        [againPayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [againPayBtn setBackgroundImage:[UIImage imageNamed:@"保存修改_点击"] forState:UIControlStateHighlighted];
        againPayBtn.tag = section;
        [_footView addSubview:againPayBtn];
    }
    
   
    
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
        [cell.shopImage sd_setImageWithURL:[NSURL URLWithString:model.goods_image] placeholderImage:[UIImage imageNamed:@"火影1"]];
        
        
        return cell;
        
    }else{
        static NSString *cellName = @"MenyGoodsCell";
        
        MenyGoodsCell *cell =
        (MenyGoodsCell *)[tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:cellName owner:self options:nil] firstObject];
        }
        
        UIControl *control = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
        control.tag = indexPath.section ;
        [control addTarget:self action:@selector(cellClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:control];
        
        [cell modelWithArray:_subMutArray[indexPath.section]];
        
        return cell;
    }
    
}
- (void)cellClick:(UIControl *)control {
    NSLog(@"control.tag : %ld",control.tag);
    OrderDetailsVC *detailVC = [[OrderDetailsVC alloc]init];
    AllGoodsOrders *model = _dataArray[control.tag];
    detailVC.order_id = model.order_id ;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return 77;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.waitPayTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    OrderDetailsVC *detailVC = [[OrderDetailsVC alloc]init];
    AllGoodsOrders *model = _dataArray[indexPath.section];
    detailVC.order_id = model.order_id ;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

-(void)payBtnClick:(UIButton *)btn{
    NSLog(@"去支付:%ld",btn.tag);
   
    [self pushConfirmVC:btn];
    
}
-(void)againPayBtnClick:(UIButton *)againPayBtn{

    NSLog(@"再次购买:%ld",(long)againPayBtn.tag);
    [self pushConfirmVC:againPayBtn];
    
}
-(void)cancelBtnClick:(UIButton *)cancelBtn{

    NSLog(@"取消订单:%ld",cancelBtn.tag);
    
    
}
-(void)pushConfirmVC:(UIButton *)btn{

    AllGoodsOrders *model = _dataArray[btn.tag];
    ConfirmorderVC *confirmVC = [[ConfirmorderVC alloc]init];
    confirmVC.orderIds = model.order_id;
    confirmVC.cartIds = @"";
    confirmVC.goodsIds = @"";
    confirmVC.goodsNum = @"";
    [self.navigationController pushViewController:confirmVC animated:YES];
}

-(UIView *)createHeadView{
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, M_WIDTH,45)];
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
