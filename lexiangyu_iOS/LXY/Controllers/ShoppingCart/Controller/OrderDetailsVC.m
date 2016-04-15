//
//  OrderDetailsVC.m
//  LXY
//
//  Created by guohui on 16/4/14.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "OrderDetailsVC.h"
#import "OrderDetailHeaderView.h"
#import "OrderTabViewFootView.h"
#import "OrderDetailCell.h"
#import "Common.h"
#import "RequestCenter.h"
@interface OrderDetailsVC ()<UITableViewDelegate,UITableViewDataSource>
{
    OrderModel *orderModel ;
    NSMutableArray *goods_Mutlist ;
}
@property (weak, nonatomic) IBOutlet UITableView *orderDetalsTableView;

@end

@implementation OrderDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"订单详情" ;
    orderModel = [[OrderModel alloc]init];
    goods_Mutlist = [NSMutableArray arrayWithCapacity:0];
    [self loadOrderData];
}
- (void)loadOrderData{
    RequestCenter *requsetCenter = [RequestCenter shareRequestCenter];
    [requsetCenter sendRequestPostUrl:ORDER_DETAILS andDic:@{@"order_id":self.order_id} setSuccessBlock:^(NSDictionary *resultDic) {
        if ([[resultDic[@"code"] stringValue] isEqualToString:@"1"]) {
            NSDictionary *dataDic = resultDic[@"data"];
            [orderModel setValuesForKeysWithDictionary:dataDic];
            NSArray *goods_list = dataDic[@"goods_list"];
            for (NSDictionary *dic in goods_list) {
                GoodsModel *goodsModel = [[GoodsModel alloc]init];
                [goodsModel setValuesForKeysWithDictionary:dic];
                [goods_Mutlist addObject:goodsModel];
            }
            [self.orderDetalsTableView reloadData];
        }
        
    } setFailBlock:^(NSString *errorStr) {
        
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return goods_Mutlist.count ;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"OrderDetailCell";
    OrderDetailCell *cell = (OrderDetailCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellId owner:self options:nil] firstObject];
    }
    GoodsModel *goodsModel = goods_Mutlist[indexPath.row];
    [cell configViewGoodsModel:goodsModel];
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    OrderDetailHeaderView *headerView = [[[NSBundle mainBundle]loadNibNamed:@"OrderDetailHeaderView" owner:self options:nil]firstObject];
    [headerView configWithOrderModel:orderModel];
    return headerView ;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    OrderTabViewFootView *footView =[[[NSBundle mainBundle]loadNibNamed:@"OrderTabViewFootView" owner:self options:nil]firstObject];
    [footView configWithOrderModel:orderModel];
    return footView ;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
