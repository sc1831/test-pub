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

#import "UIButton+Block.h"
#import "PayWebView.h"

#import "ShopingDetailsVC.h"
@interface AllShopVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UIControl *headView;
@property (nonatomic ,strong)UIView *footView;
@property (nonatomic ,strong)NSMutableArray *dataArray;
@property (nonatomic ,strong)NSMutableArray *subMutArray;
@property (nonatomic)int page;

@property (nonatomic ,strong)NSString *orderIds;
@property (nonatomic ,strong)UILabel *label;
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
    
    _label = [GHControl createLabelWithFrame:CGRectMake(30, M_HEIGHT/2-20, M_WIDTH-60, 40) Font:15 Text:@"暂时还没有订单哦"];
    _label.textColor = RGBCOLOR(99, 100, 101);
    _label.textAlignment = NSTextAlignmentCenter;
    _label.hidden = YES;
    [self.view addSubview:_label];
    
    postDic = [NSMutableDictionary dictionaryWithCapacity:0];
    requestCenter = [RequestCenter shareRequestCenter];
    [postDic setValue:VALUETOSTR(_page) forKey:@"page"];
    //    [postDic setValue:VALUETOSTR(_pageSize) forKey:@"pageamount"];
    [postDic setValue:[[SaveInfo shareSaveInfo]user_id] forKey:@"user_id"];
    [postDic setValue:@"" forKey:@"order_state"];
    
    
    [self addMjHeaderAndFooter];
    [self.waitPayTableView headerBeginRefresh];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refishViewOne) name:@"refishViewOne" object:nil];
    
    [self.view addSubview:self.noNetworkView];
    
    
}
-(void)refishViewOne{
    [self addMjHeaderAndFooter];
    [self.waitPayTableView headerBeginRefresh];
    
}
//重新加载数据
-(void)NoNetworkClickDelegate{
    if (![GHControl isExistNetwork]) {
        self.noNetworkView.hidden = NO;
        return;
    }
    self.noNetworkView.hidden = YES;
    [self addMjHeaderAndFooter];
    [self.waitPayTableView headerBeginRefresh];
}

#pragma mark MJRefresh
- (void)addMjHeaderAndFooter{
    if (![GHControl isExistNetwork]) {
        
        if (_dataArray.count>0) {
            self.noNetworkView.hidden = YES;
            HUDNormal(@"服务器无响应，请稍后再试");
        }else{
            self.noNetworkView.hidden = NO;
        }
        
        [self.waitPayTableView headerEndRefresh];
        return;
    }else{
        
        self.noNetworkView.hidden = YES;
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
            if (_dataArray.count==0) {
                _label.hidden = NO;
                return;
            }else{
                
                _label.hidden = YES;
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
            
            if (_page>[resultDic[@"data"][@"pageamount"] intValue]) {
                
                return ;
            }
            
            if ([resultDic[@"code"] intValue] != 1) {
                BG_LOGIN ;
                return ;
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
    
    UILabel *label = [GHControl createLabelWithFrame:CGRectMake(35,11, 60, 30) Font:14 Text:@"订单号："];
    label.textColor = RGBCOLOR(99, 100, 101);
    [_headView addSubview:label];
    UILabel *labelNum = [GHControl createLabelWithFrame:CGRectMake(85,11, M_WIDTH-90, 30) Font:14 Text:model.pay_sn];
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
        
    }else if ([model.order_state intValue] == 20){
    
        waitLabel.text = @"等待发货";
    }else if ([model.order_state intValue] == 30){
    
       waitLabel.text = @"等待收货";
    }
    
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
    
    //商品价格
    UILabel *moneyLabel = [GHControl createLabelWithFrame:CGRectMake(70, 5,M_WIDTH-150, 30) Font:14 Text:[NSString stringWithFormat:@"￥%@",model.order_amount]];
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
        UIButton *btn = [GHControl createButtonWithFrame:CGRectMake(M_WIDTH-90-80,5,75, 30) ImageName:@"评价商品_默认" Target:self Action:@selector(cancelBtnClick:) Title:@"取消订单"];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.tag = section;
        [btn setTitleColor:RGBCOLOR(249, 147, 73) forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[UIImage imageNamed:@"保存修改_点击"] forState:UIControlStateHighlighted];
        [_footView addSubview:btn];
    }else if ([model.order_state intValue] == 20){
        //等待发货
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 77;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [UIView animateWithDuration:0.3f
                     animations:^{
                         [tableView deselectRowAtIndexPath:indexPath animated:YES];
                     }];
    
    
    
    AllGoodsOrders *model =  _subMutArray[indexPath.section][indexPath.row];
    ShopingDetailsVC *shoppingDetailsVC = [[ShopingDetailsVC alloc] init];
    shoppingDetailsVC.goods_commonid = model.goods_id ;
    [self.navigationController pushViewController:shoppingDetailsVC animated:YES];
    
}

-(void)payBtnClick:(UIButton *)btn{
    AllGoodsOrders *model = _dataArray[btn.tag];
    [self gotoPayWebView:model];
    
}
- (void)gotoPayWebView:(AllGoodsOrders *)model{
    if (![GHControl isExistNetwork]) {
        HUDNormal(@"服务器无响应，请稍后重试");
        return;
    }
    
    [requestCenter sendRequestPostUrl:APP_PAY andDic:@{@"t":@"3",@"pay_sn":model.pay_sn} setSuccessBlock:^(NSDictionary *resultDic) {
        if ([resultDic[@"code"] intValue] != 1) {
            HUDNormal(resultDic[@"msg"]);
            BG_LOGIN ;
            return ;
        }
        
        PayWebView *payWebView = [[PayWebView alloc]init];
        payWebView.urlStr = resultDic[@"data"][@"url"];
        [self.navigationController pushViewController:payWebView animated:YES];
        
    } setFailBlock:^(NSString *errorStr) {
        
    }];
    
}

-(void)againPayBtnClick:(UIButton *)againPayBtn{
    
    NSLog(@"再次购买:%ld",(long)againPayBtn.tag);
    [self pushConfirmVC:againPayBtn];
    
}
-(void)cancelBtnClick:(UIButton *)cancelBtn{
    
    NSLog(@"取消订单:%ld",cancelBtn.tag);
    
    
    AllGoodsOrders *model = _dataArray[cancelBtn.tag];
    _orderIds = model.pay_sn;
    [self createFeedBackView];
    
    
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
                               @"pay_sn":orderId
                               };
    
    [request sendRequestPostUrl:MY_CANCEL_REGISTER andDic:postDict setSuccessBlock:^(NSDictionary *resultDic) {
        if ([resultDic[@"code"] intValue] != 1) {
            BG_LOGIN ;
            HUDNormal(resultDic[@"msg"]);
            return ;
        }
        
        
        HUDNormal(resultDic[@"msg"]);
        [self.waitPayTableView headerBeginRefresh];
        
    } setFailBlock:^(NSString *errorStr) {
        NSLog(@"");
        
    }];
}
-(void)pushConfirmVC:(UIButton *)btn{
    
    AllGoodsOrders *model = _dataArray[btn.tag];
    ConfirmorderVC *confirmVC = [[ConfirmorderVC alloc]init];
    confirmVC.orderIds = @"";
    confirmVC.cartIds = @"";
    confirmVC.goodsIds = @"";
    confirmVC.goodsNum = @"";
    confirmVC.pay_sn = model.pay_sn ;
    [self.navigationController pushViewController:confirmVC animated:YES];
}

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
