




//
//  WaitSendVC.m
//  LXY
//
//  Created by guohui on 16/3/15.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "WaitSendVC.h"
#import "Common.h"
#import "WaiteSendCell.h"
#import "GHControl.h"
#import "RequestCenter.h"
#import "SaveInfo.h"

@interface WaitSendVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,strong)UITableView *waitSendtableView;
@property (nonatomic ,strong)UIView *headView;
@property (nonatomic ,strong)UIView *footView;
@property (nonatomic)int page;
@end

@implementation WaitSendVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"待发货";
    [self createTableView];
    
    [self sendRequestData];
}
-(void)sendRequestData{
    /**
     *  order_state	否	int	订单状态0已取消，10未付款，20已付款，30已发货，40已收货
     */
    RequestCenter * request = [RequestCenter shareRequestCenter];
    NSDictionary *postDic = @{@"user_id":[[SaveInfo shareSaveInfo]user_id],
                              @"order_state":@"20"
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
        
        [_waitSendtableView reloadData];
    } setFailBlock:^(NSString *errorStr) {
        NSLog(@"");
        
    }];
}
-(void)createTableView{
    
    _waitSendtableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, M_WIDTH, M_HEIGHT) style:UITableViewStyleGrouped];
    _waitSendtableView.delegate = self;
    _waitSendtableView.dataSource = self;
    _waitSendtableView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_waitSendtableView];
    
}

#pragma mark-----UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    [self createHeadView];
    
    UILabel *label = [GHControl createLabelWithFrame:CGRectMake(45,11, M_WIDTH-25-40, 30) Font:14 Text:@"订单号"];
    label.textColor = RGBCOLOR(99, 100, 101);
    [_headView addSubview:label];
    
    UILabel *waitLabel = [GHControl createLabelWithFrame:CGRectMake(M_WIDTH-70,11,70, 30) Font:13 Text:@"等待发货"];
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
    
    UIButton *btn = [GHControl createButtonWithFrame:CGRectMake(M_WIDTH-90,5,75, 30) ImageName:@"redBtnBg" Target:self Action:@selector(btnClick:) Title:@"取消订单"];
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
    
    [_waitSendtableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


-(void)btnClick:(UIButton *)btn{

    NSLog(@"订单取消");
}


#pragma mark------headView  footView
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
