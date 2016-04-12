//
//  CollectVC.m
//  LXY
//
//  Created by guohui on 16/3/15.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "CollectVC.h"
#import "CollectionCell.h"
#import "Common.h"
#import "GHControl.h"
#import "RequestCenter.h"
#import "MyCollectModel.h"
#import "SaveInfo.h"
#import "ShopingDetailsVC.h"

@interface CollectVC ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *collectTableView;
//存储数据
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic ,strong)UIView *tipView;
@property (nonatomic ,strong)UILabel *label;
@property (nonatomic )int page;
@property (nonatomic ,strong)NSTimer *disappear;
@end

@implementation CollectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收藏" ;
    _dataArray = [NSMutableArray array];
    [GHControl setExtraCellLineHidden:_collectTableView];
    [self createTipView];
    _tipView.hidden = YES;
    
    [self sendRequestData];
    
    _label = [GHControl createLabelWithFrame:CGRectMake(30, M_HEIGHT/2-20, M_WIDTH-60, 40) Font:15 Text:@"暂时还没有收藏哦、赶紧去逛逛"];
    _label.textColor = RGBCOLOR(99, 100, 101);
    _label.textAlignment = NSTextAlignmentCenter;
    _label.hidden = YES;
    [self.view addSubview:_label];
   

}
-(void)sendRequestData{
    /**
     user_id	是	int	用户id
     fav_type	否	string	查看收藏类型 goods查看商品，store查看店铺

     */
    RequestCenter * request = [RequestCenter shareRequestCenter];
    NSDictionary *postDic = @{@"user_id":[[SaveInfo shareSaveInfo]user_id],
                              @"fav_type":@"goods",
                              };
    
    [request sendRequestPostUrl:MY_COLLECT andDic:postDic setSuccessBlock:^(NSDictionary *resultDic) {

        if ([resultDic[@"code"] intValue]==0) {
            HUDNormal(@"获取数据失败，请稍后再试");
            return ;
        }
        
        NSDictionary *dict = resultDic[@"data"];
        _page = [dict[@"page"] intValue];
        NSArray *array = dict[@"list"];
        for (NSDictionary *subDic in array) {
            MyCollectModel *model = [MyCollectModel modelWithDic:subDic];

            [_dataArray addObject:model];
            
        }
        if (_dataArray.count==0) {
            _label.hidden = NO;
            return;
        }
        HUDNormal(@"获取数据成功");
        [_collectTableView reloadData];
    } setFailBlock:^(NSString *errorStr) {
        NSLog(@"");
        
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"CollectionCell";
    CollectionCell *cell =
    (CollectionCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellId owner:self options:nil] firstObject];
        
    }
    
    MyCollectModel *model = _dataArray[indexPath.row];
    
    cell.contentsLabel.text = model.goods_name;
    cell.moneyLabel.text = [NSString stringWithFormat:@"￥%@",model.goods_price];
    cell.salesLabel.text = [NSString stringWithFormat:@"销售%@",model.goods_salenum];
    
    [cell.productImageView sd_setImageWithURL:[NSURL URLWithString:model.goods_image] placeholderImage:[UIImage imageNamed:@"火影1"]];
    cell.productImageView.layer.masksToBounds = YES;
    cell.productImageView.layer.cornerRadius = 3;
    
    [cell.addButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.addButton.tag = indexPath.row;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self sendDellectRequestData:indexPath];
        
    }else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }
}
-(void)sendDellectRequestData:(NSIndexPath *)indexPath{
    
    /**
     ids        是 	string	商品id，多一个请用,隔开
     user_id	是	int     用户id
     type       是	string	goods商品	store店铺

     */
    
    MyCollectModel *model = _dataArray[indexPath.row];
    
    RequestCenter * request = [RequestCenter shareRequestCenter];
    NSDictionary *postDic = @{@"ids":model.goods_id,
                              @"user_id":[[SaveInfo shareSaveInfo]user_id],
                              @"type":@"goods"
                              };
    
    [request sendRequestPostUrl:MY_DELLECT_COLLECT andDic:postDic setSuccessBlock:^(NSDictionary *resultDic) {
        if ([resultDic[@"code"] intValue]==0) {
            HUDNormal(@"删除数据失败，请稍后再试");
            return ;
        }
        HUDNormal(@"删除数据成功");
        GLOG(@"---------post:", resultDic);
        [_dataArray removeObjectAtIndex:indexPath.row];
        [_collectTableView reloadData];
    } setFailBlock:^(NSString *errorStr) {
        NSLog(@"");
        
    }];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    [UIView animateWithDuration:0.3f
                     animations:^{
                         [tableView deselectRowAtIndexPath:indexPath animated:YES];
                     }];
    ShopingDetailsVC *shoppingDetailsVC = [[ShopingDetailsVC alloc]init];
    MyCollectModel *model = _dataArray[indexPath.row];
    shoppingDetailsVC.goods_commonid = model.goods_commonid ;
    shoppingDetailsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shoppingDetailsVC animated:YES];

    
}

-(void)addButtonClick:(UIButton *)btn{
    NSLog(@"%ld",(long)btn.tag);
    
    [self addShopGoodsRequestData:(int)btn.tag];
    
}
-(void)addShopGoodsRequestData:(int )index{
    
    MyCollectModel *model = _dataArray[index];
    
    RequestCenter * request = [RequestCenter shareRequestCenter];
    NSDictionary *postDic = @{@"goods_id":model.goods_id,
                              @"goods_num":@"1"
                              };
    
    [request sendRequestPostUrl:ADD_SHOP_GOODS andDic:postDic setSuccessBlock:^(NSDictionary *resultDic) {
        if ([resultDic[@"code"] intValue] ==0) {
            HUDNormal(@"添加失败，请稍后再试");
            return ;
        }
         _tipView.hidden = NO;
         _disappear = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(animalMoveImage) userInfo:nil repeats:YES];
    } setFailBlock:^(NSString *errorStr) {
        NSLog(@"");
        
    }];
}
-(void)animalMoveImage{

     _tipView.hidden = YES;
    
}
//添加购物车成功提示
-(void)createTipView{
    
    _tipView = [[UIView alloc]initWithFrame:CGRectMake(30,M_HEIGHT/2-M_HEIGHT/8,M_WIDTH-60, M_HEIGHT/4)];
    _tipView.backgroundColor = RGBACOLOR(80, 81, 82, 0.8);
    _tipView.layer.masksToBounds = YES;
    _tipView.layer.cornerRadius = 5.0f;
    [self.view addSubview:_tipView];
    
    UILabel *label = [GHControl createLabelWithFrame:CGRectMake(0, _tipView.frame.size.height-60, _tipView.frame.size.width, 40) Font:16 Text:@"加入购物车成功"];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [_tipView addSubview:label];
    
    UIImageView *imageView = [GHControl createImageViewWithFrame:CGRectMake(_tipView.frame.size.width/2-30,10, 59, 59) ImageName:@"添加购物成功"];
    [_tipView addSubview:imageView];
}


@end
