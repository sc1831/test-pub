//
//  AllWaitePayVC.m
//  LXY
//
//  Created by guohui on 16/3/24.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "AllWaitePayVC.h"
#import "Common.h"
#import "GHControl.h"
#import "ConfirmorderVC.h"
#import "WaiteSendCell.h"
#import "RequestCenter.h"
#import "SaveInfo.h"

@interface AllWaitePayVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UIView *headView;
@property (nonatomic ,strong)UIView *footView;
@property (nonatomic)int page;
@end

@implementation AllWaitePayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"待付款";
    [self createTableView];
    [self sendRequestData];
}
-(void)sendRequestData{
    /**
     *  order_state	否	int	订单状态0已取消，10未付款，20已付款，30已发货，40已收货
     */
    RequestCenter * request = [RequestCenter shareRequestCenter];
    NSDictionary *postDic = @{@"user_id":[[SaveInfo shareSaveInfo]user_id],
                              @"order_state":@"10"
                              };
    
    [request sendRequestPostUrl:MY_REGISTER andDic:postDic setSuccessBlock:^(NSDictionary *resultDic) {
        if (resultDic[@"code"]==0) {
            HUDNormal(@"获取数据失败，请稍后再试");
            return ;
        }
        HUDNormal(@"获取数据成功");
        
        NSDictionary *dict = resultDic[@"data"];
        _page = [dict[@"page"] intValue];
        NSArray *array = dict[@"list"];
        //        for (NSDictionary *subDic in array) {
        //            MyFooterModel *model = [MyFooterModel modelWithDic:subDic];
        //
        //
        //
        //            [_dataArray addObject:model];
        //
        //            
        //            
        //        }
        
        [_waitPayTableView reloadData];
    } setFailBlock:^(NSString *errorStr) {
        NSLog(@"");
        
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
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}




-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    [self createHeadView];
    
    UILabel *label = [GHControl createLabelWithFrame:CGRectMake(45,11, M_WIDTH-25-40, 30) Font:14 Text:[NSString stringWithFormat:@"订单号：%ld",140112212155]];
    label.textColor = RGBCOLOR(99, 100, 101);
    [_headView addSubview:label];
    
    UILabel *waitLabel = [GHControl createLabelWithFrame:CGRectMake(M_WIDTH-70,11,70, 30) Font:13 Text:@"等待付款"];
    waitLabel.textColor = RGBCOLOR(249, 147, 73);
    [_headView addSubview:waitLabel];
    
    
    return _headView;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    [self createFootView];
    UILabel *label = [GHControl createLabelWithFrame:CGRectMake(18,5,60, 30) Font:14 Text:@"已付款:"];
    label.textColor = RGBCOLOR(99, 100, 101);
    [_footView addSubview:label];
    
    UILabel *moneyLabel = [GHControl createLabelWithFrame:CGRectMake(78, 5,M_WIDTH-150, 30) Font:14 Text:@"￥3000"];
    moneyLabel.font = [UIFont boldSystemFontOfSize:14];
    moneyLabel.textColor = RGBCOLOR(249, 147, 73);
    [_footView addSubview:moneyLabel];
    
    
    
    
    UIButton *payBtn = [GHControl createButtonWithFrame:CGRectMake(M_WIDTH-90,5,75, 30) ImageName:@"redBtnBg" Target:self Action:@selector(payBtnClick:) Title:@"去支付"];
    payBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [payBtn setTitleColor:RGBCOLOR(249, 147, 73) forState:UIControlStateNormal];
    [_footView addSubview:payBtn];
    
    
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
    
    static NSString *cellName = @"WaiteSendCell";
    
    WaiteSendCell *cell =
    (WaiteSendCell *)[tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellName owner:self options:nil] firstObject];
        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    if (indexPath.section == 0) {
    //        return 50;
    //    }
    return 77;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.waitPayTableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(void)payBtnClick:(UIButton *)btn{
    NSLog(@"去支付");
    ConfirmorderVC *confirmVC = [[ConfirmorderVC alloc]init];
    [self.navigationController pushViewController:confirmVC animated:YES];
    
}



-(UIView *)createHeadView{
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, M_WIDTH,45)];
    _headView.backgroundColor = [UIColor whiteColor];
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, M_WIDTH,5)];
    topView.backgroundColor = RGBCOLOR(219, 223, 224);
    [_headView addSubview:topView];
    
    UIImage *headImage = [UIImage imageNamed:@"个人中心店铺icon"];
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
