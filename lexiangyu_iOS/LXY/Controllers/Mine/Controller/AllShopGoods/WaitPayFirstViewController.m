//
//  WaitPayFirstViewController.m
//  LXY
//
//  Created by guohui on 16/3/18.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "WaitPayFirstViewController.h"
#import "Common.h"
#import "WaiteSendCell.h"
#import "GHControl.h"
#import "ConfirmorderVC.h"
#import "RequestCenter.h"
#import "SaveInfo.h"
#import "AllGoodsOrders.h"
#import "MenyGoodsCell.h"
#import "UITableView+MJRefresh.h"
#import "PayWebView.h"
#import "OrderDetailsVC.h"
@interface WaitPayFirstViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)UITableView *waitPayTableView;
@property (nonatomic,strong)UIView *headView;
@property (nonatomic ,strong)UIView *footView;
@property (nonatomic ,strong)NSMutableArray *dataArray;
@property (nonatomic ,strong)NSMutableArray *subMutArray;
@property (nonatomic ,strong)NSString *orderIds;

@property (nonatomic ,strong)UITableView *specialTableView;

@end

@implementation WaitPayFirstViewController
{

    int _page  ;//当前页码
    int _pageSize ;
    RequestCenter *requestCenter;
    NSMutableDictionary *postDic ;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"待付款";
    _dataArray = [NSMutableArray array];
    _subMutArray = [NSMutableArray array];
    [self createTableView];

    

    postDic = [NSMutableDictionary dictionaryWithCapacity:0];
    requestCenter = [RequestCenter shareRequestCenter];
    [postDic setValue:VALUETOSTR(_page) forKey:@"page"];
    [postDic setValue:[[SaveInfo shareSaveInfo]user_id] forKey:@"user_id"];
    [postDic setValue:@"10" forKey:@"order_state"];
    
    
    [self addMjHeaderAndFooter];
    [self.waitPayTableView headerBeginRefresh];
    
}
#pragma mark MJRefresh
- (void)addMjHeaderAndFooter{
    if (![GHControl isExistNetwork]) {
        HUDNormal(@"服务器无响应，请稍后重试");
        [self.waitPayTableView headerEndRefresh];
        return;
    }
    [self.waitPayTableView headerAddMJRefresh:^{//添加顶部刷新功能
        [self.waitPayTableView footerResetNoMoreData];//重置无数据状态
        [postDic setValue:@"1" forKey:@"page"];
        [requestCenter sendRequestPostUrl:MY_REGISTER andDic:postDic setSuccessBlock:^(NSDictionary *resultDic) {
            [self.waitPayTableView headerEndRefresh];
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
                    [_waitPayTableView reloadData];
                    
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
    if (_isMinePush) {
        _isMinePush = NO;
        _waitPayTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, M_WIDTH,M_HEIGHT) style:UITableViewStyleGrouped];
    }else{
    
         _waitPayTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, M_WIDTH,M_HEIGHT-94) style:UITableViewStyleGrouped];
    }
    
    _waitPayTableView.delegate = self;
    _waitPayTableView.dataSource = self;
    _waitPayTableView.tag = 10;
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
    
    UILabel *label = [GHControl createLabelWithFrame:CGRectMake(45,11,60, 30) Font:14 Text:@"订单号:"];
    label.textColor = RGBCOLOR(99, 100, 101);
    [_headView addSubview:label];
    UILabel *labelNum = [GHControl createLabelWithFrame:CGRectMake(93,11, M_WIDTH-110, 30) Font:14 Text:model.pay_sn];
    labelNum.textColor = RGBCOLOR(204,204,204);
    [_headView addSubview:labelNum];
    
    
    UILabel *waitLabel = [GHControl createLabelWithFrame:CGRectMake(M_WIDTH-70,11,70, 30) Font:13 Text:@"等待付款"];
    waitLabel.textColor = RGBCOLOR(249, 147, 73);
    [_headView addSubview:waitLabel];
    
    
    return _headView;

}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    [self createFootView];
    AllGoodsOrders *model = _dataArray[section];
    UILabel *label = [GHControl createLabelWithFrame:CGRectMake(18,5,40, 30) Font:14 Text:@"付款:"];
    label.textColor = RGBCOLOR(99, 100, 101);
    [_footView addSubview:label];
    
    UILabel *moneyLabel = [GHControl createLabelWithFrame:CGRectMake(58, 5,M_WIDTH-150, 30) Font:14 Text:model.order_amount];
    moneyLabel.font = [UIFont boldSystemFontOfSize:14];
    moneyLabel.textColor = RGBCOLOR(249, 147, 73);
    [_footView addSubview:moneyLabel];
    
    
    
    
    UIButton *payBtn = [GHControl createButtonWithFrame:CGRectMake(M_WIDTH-90,5,75, 30) ImageName:@"评价商品_默认" Target:self Action:@selector(payBtnClick:) Title:@"去支付"];
    [payBtn setBackgroundImage:[UIImage imageNamed:@"保存修改_点击"] forState:UIControlStateHighlighted];
    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    payBtn.tag = section;
    payBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [payBtn setTitleColor:RGBCOLOR(249, 147, 73) forState:UIControlStateNormal];
    [_footView addSubview:payBtn];
    
    
    UIButton *btn = [GHControl createButtonWithFrame:CGRectMake(M_WIDTH-90-80,5,75, 30) ImageName:@"评价商品_默认" Target:self Action:@selector(btnClick:) Title:@"取消订单"];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.tag = section;
    [btn setTitleColor:RGBCOLOR(249, 147, 73) forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[UIImage imageNamed:@"保存修改_点击"] forState:UIControlStateHighlighted];
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
        cell.shopTime.text = dataModel.add_time; //pay_sn
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
    detailVC.order_id = model.pay_sn ;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 77;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    [self.waitPayTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OrderDetailsVC *detailVC = [[OrderDetailsVC alloc]init];
    AllGoodsOrders *model = _dataArray[indexPath.row];
    detailVC.order_id = model.pay_sn ;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

-(void)payBtnClick:(UIButton *)btn{
    NSLog(@"去支付");
    if (![GHControl isExistNetwork]) {
        HUDNormal(@"服务器无响应，请稍后重试");

        return;
    }
    AllGoodsOrders *model = _dataArray[btn.tag];
    [requestCenter sendRequestPostUrl:APP_PAY andDic:@{@"t":@"3",@"pay_sn":model.pay_sn} setSuccessBlock:^(NSDictionary *resultDic) {
        if ([resultDic[@"code"] intValue] != 1) {
            HUDNormal(resultDic[@"msg"]);
            BG_LOGIN ;
            return ;
        }
        
        PayWebView *payWebView = [[PayWebView alloc]init];
        payWebView.urlStr = resultDic[@"url"];
        [self.navigationController pushViewController:payWebView animated:YES];
        
    } setFailBlock:^(NSString *errorStr) {
        
    }];
    
    
    
//    ConfirmorderVC *confirmVC = [[ConfirmorderVC alloc]init];
//    confirmVC.orderIds = model.order_id;
//    confirmVC.cartIds = @"";
//    confirmVC.goodsIds = @"";
//    confirmVC.goodsNum = @"";
//    [self.navigationController pushViewController:confirmVC animated:YES];
    
}

-(void)btnClick:(UIButton *)btn{
    NSLog(@"订单取消");
    [self createFeedBackView];
    AllGoodsOrders *model = _dataArray[btn.tag];
    _orderIds = model.pay_sn;

    
}
-(void)createFeedBackView{
    
    
    NSMutableArray *mutArray = [NSMutableArray arrayWithObjects:@"我不想买了",@"信息填写错误、重新拍",@"配送时差问题",@"其他", nil];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    for (int i =0; i<mutArray.count; i++) {
       
        UIAlertAction *productProblem = [UIAlertAction actionWithTitle:mutArray[i] style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {

            [self sendRequestDataCancelOrderId:_orderIds andReason:mutArray[i]];
        }];
        [alertController addAction:productProblem];
    }
    
    // 创建按钮
    // 注意取消按钮只能添加一个
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *action) {
        // 点击按钮后的方法直接在这里面写
        NSLog(@"取消");
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
-(void)sendRequestDataCancelOrderId:(NSString *)orderId andReason:(NSString *)reasonStr{
    
    if (![GHControl isExistNetwork]) {
        HUDNormal(@"服务器无响应，请稍后重试");

        return;
    }
    
    RequestCenter * request = [RequestCenter shareRequestCenter];
    NSDictionary *postDict = @{
                              @"reason":reasonStr,
                              @"user_id":[[SaveInfo shareSaveInfo]user_id],
                              @"order_id":orderId
                              };
    
    [request sendRequestPostUrl:MY_CANCEL_REGISTER andDic:postDict setSuccessBlock:^(NSDictionary *resultDic) {
        if ([resultDic[@"code"] intValue] != 1) {
            BG_LOGIN ;
            return ;
        }

        if ([resultDic[@"code"] intValue]==0) {
            HUDNormal(@"已付款的订单目前不支持取消订单");
            return ;
        }
        HUDNormal(@"取消订单成功");
        [self addMjHeaderAndFooter];
        

    } setFailBlock:^(NSString *errorStr) {
        NSLog(@"");
        
    }];
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
