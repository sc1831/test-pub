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
#import "GHControl.h"
#import "AddressModel.h"
@interface OrderDetailsVC ()<UITableViewDelegate,UITableViewDataSource>
{
    AddressModel *addressModel ;
    NSMutableArray *goods_Mutlist ; //cellarray
}
@property (weak, nonatomic) IBOutlet UITableView *orderDetalsTableView;

@end

@implementation OrderDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"订单详情" ;
    addressModel = [[AddressModel alloc]init];
    goods_Mutlist = [NSMutableArray arrayWithCapacity:0];
    [self loadOrderData];
}
- (void)loadOrderData{
    
    if (![GHControl isExistNetwork]) {
        HUDNormal(@"服务器无响应，请稍后重试");

        return;
    }
    
    RequestCenter *requsetCenter = [RequestCenter shareRequestCenter];
    [requsetCenter sendRequestPostUrl:ORDER_DETAILS andDic:@{@"pay_sn":self.order_id} setSuccessBlock:^(NSDictionary *resultDic) {
        if ([resultDic[@"code"] intValue] != 1) {
            BG_LOGIN ;
            return ;
        }
        HUDNormal(resultDic[@"msg"]);
        if ([[resultDic[@"code"] stringValue] isEqualToString:@"1"]) {
            NSDictionary *dataDic = resultDic[@"data"];
            [addressModel setValuesForKeysWithDictionary:dataDic[@"address_info"]];
            NSArray *order = dataDic[@"order"];
//            for (NSDictionary *orderDic in order) {
//                NSMutableArray *order_mtArray = [NSMutableArray arrayWithCapacity:0];
//                for (NSDictionary *goodsDic in orderDic[@"goods"]) {
//                    GoodsModel *model = [[GoodsModel alloc]init];
//                    [model setValuesForKeysWithDictionary:goodsDic];
//                    [order_mtArray addObject:model];
//                }
//                [goods_Mutlist addObject:order_mtArray];
//            }
            for (NSDictionary *orderDic in order) {
                for (NSDictionary *goodsDic in orderDic[@"goods"]) {
                    GoodsModel *model = [[GoodsModel alloc]init];
                    [model setValuesForKeysWithDictionary:goodsDic];
                    [goods_Mutlist addObject:model];
                }
            }
            
//            for (NSDictionary *dic in order) {
//                GoodsModel *goodsModel = [[GoodsModel alloc]init];
//                [goodsModel setValuesForKeysWithDictionary:dic];
//                [goods_Mutlist addObject:goodsModel];
//            }
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
    [headerView configWithOrderModel:addressModel];
    return headerView ;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    OrderTabViewFootView *footView =[[[NSBundle mainBundle]loadNibNamed:@"OrderTabViewFootView" owner:self options:nil]firstObject];
//    [footView configWithOrderModel:orderModel];
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
