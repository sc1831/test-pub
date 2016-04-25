//
//  CompositeVC.m
//  LXY
//
//  Created by guohui on 16/3/15.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "CompositeVC.h"
#import "RequestCenter.h"
#import "CompositeCell.h"
#import "UITableView+MJRefresh.h"
#import "GoodsModel.h"
#import "Common.h"
#import "ShopingDetailsVC.h"
#import "GHControl.h"

@interface CompositeVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    int _page  ;//当前页码
    int _pageSize ;
    NSMutableArray *goods_Mtlist ;
    RequestCenter *requestCenter;
    int orderByNum ; // 0 综合 1 销量 2 价格
    BOOL orderByPriceFlag ;// yes 从高到低

    NSMutableDictionary *postDic ;
}
//价格图片
@property (weak, nonatomic) IBOutlet UIImageView *priceImageView;
//销量
@property (weak, nonatomic) IBOutlet UILabel *salesLabel;

@property (weak, nonatomic) IBOutlet UILabel *allLabel;
@property (nonatomic ,strong)UIView *tipView;
@property (nonatomic ,strong)NSTimer *disappear;

- (IBAction)leftNavBarClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
- (IBAction)searchClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *compositeTab;
- (IBAction)orderByZonghe:(id)sender;
- (IBAction)orderByxiaoliang:(id)sender;
- (IBAction)orderByPrice:(id)sender;

@end

@implementation CompositeVC
- (void)viewWillDisappear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = NO ;
}
- (void)viewWillAppear:(BOOL)animated{
  self.navigationController.navigationBarHidden= YES ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.navigationController.navigationBarHidden= YES ;
    _page = 1 ;
    _pageSize = 20 ;
    orderByPriceFlag = YES ;
    
    [self createTipView];
    _tipView.hidden = YES;

    if (self.goods_name.length > 0) {
        self.searchTextField.text = self.goods_name ;
    }
    postDic = [NSMutableDictionary dictionaryWithCapacity:0];
    goods_Mtlist = [NSMutableArray arrayWithCapacity:0];
    requestCenter = [RequestCenter shareRequestCenter];
    [postDic setValue:VALUETOSTR(_page) forKey:@"page"];
    [postDic setValue:VALUETOSTR(_pageSize) forKey:@"page_num"];
    if (self.goods_name.length > 0) {
        [postDic setValue:self.goods_name forKey:@"goods_name"];
        
    }
    if (self.gc_id.length > 0) {
        [postDic setValue:self.gc_id forKey:@"gc_id"];
    }
    
    [self addMjHeaderAndFooter];
    [self.compositeTab headerBeginRefresh];
    [GHControl setExtraCellLineHidden:_compositeTab];


//    self.compositeTab.estimatedRowHeight = 100 ; //预估tableView的高度
//    self.compositeTab.rowHeight = UITableViewAutomaticDimension ; //动态计算table的高度
}

#pragma mark TableView Delegate
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 1 ;
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return goods_Mtlist.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"CompositeCell";
    CompositeCell *cell =
    (CompositeCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellId owner:self options:nil] firstObject];
        
    }
    GoodsModel *goodsModel = goods_Mtlist[indexPath.row];
    [cell configWithGoodsModel:goodsModel];
    cell.addShopingCar.tag = indexPath.row ;
    [cell.addShopingCar addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CELLSELECTANIMATE ;
    [self.compositeTab deselectRowAtIndexPath:indexPath animated:YES];
    ShopingDetailsVC *shoppingDetailsVC = [[ShopingDetailsVC alloc]init];
    GoodsModel *model = goods_Mtlist[indexPath.row];
    shoppingDetailsVC.goods_commonid = model.goods_id ;
    shoppingDetailsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shoppingDetailsVC animated:YES];
    
}
#pragma mark TestField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark MJRefresh
- (void)addMjHeaderAndFooter{
    
    
    [self.compositeTab headerAddMJRefresh:^{//添加顶部刷新功能
        [self.compositeTab footerResetNoMoreData];//重置无数据状态
        [postDic setValue:@"1" forKey:@"page"];
        
        if (![GHControl isExistNetwork]) {
            HUDNormal(@"服务器无响应，请稍后重试");
            [self.compositeTab headerEndRefresh];
            return;
        }
        
        [requestCenter sendRequestPostUrl:COMPOSITE andDic:postDic setSuccessBlock:^(NSDictionary *resultDic) {
            [self.compositeTab headerEndRefresh];
            if ([resultDic[@"code"] intValue] != 1) {
                BG_LOGIN ;
                return ;
            }
//            if ([resultDic[@"code"] intValue] != 1) {
//                return ;
//            }
            NSArray *goods_list = resultDic[@"data"] [@"goods_list"];
            [goods_Mtlist removeAllObjects];
            if (goods_list.count <= 0) {
                HUDNormal(@"搜索到0个相关商品")
            }
            for (NSDictionary *dic in goods_list) {
                GoodsModel *model = [[GoodsModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [goods_Mtlist addObject:model];
            }
            _page = 2 ;
            [self.compositeTab reloadData];
        } setFailBlock:^(NSString *errorStr) {
            [self.compositeTab headerEndRefresh];
        }];
        
    }];
    
    [self.compositeTab footerAddMJRefresh:^{
        [postDic setValue:VALUETOSTR(_page) forKey:@"page"];
        if (![GHControl isExistNetwork]) {
            HUDNormal(@"服务器无响应，请稍后重试");
            [self.compositeTab headerEndRefresh];
            return;
        }
        
        [requestCenter sendRequestPostUrl:COMPOSITE andDic:postDic setSuccessBlock:^(NSDictionary *resultDic) {
            if ([resultDic[@"code"] intValue] != 1) {
                BG_LOGIN ;
                return ;
            }
            if ([[resultDic[@"code"] stringValue] isEqualToString:@"1"]) {
                NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:0];
                NSInteger count = goods_Mtlist.count ;
                NSArray *goods_list = resultDic[@"data"] [@"goods_list"];
                if (goods_list.count <= 0) {
                    HUDNormal(@"没有更多商品");
                }
                
                for (int i = 0 ; i <goods_list.count ; i++) {
                    NSDictionary *dic = goods_list[i] ;
                    GoodsModel *model = [[GoodsModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    [goods_Mtlist addObject:model];
                    [indexPaths addObject:[NSIndexPath indexPathForRow:count + i inSection:0]];
                }
                if (indexPaths.count <= 0) {
                    [self.compositeTab footerEndRefreshNoMoreData];
                }else{
                    _page ++ ;
                    [self.compositeTab footerEndRefresh];
                    
                    [self.compositeTab insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }else{
                [self.compositeTab footerEndRefresh ];
            }
            
        } setFailBlock:^(NSString *errorStr) {
        }];
    }];
    
}



#pragma mark 点击事件
- (void)addBtnClick:(UIButton *)button{
    if (![GHControl isExistNetwork]) {
        HUDNormal(@"服务器无响应，请稍后重试");

        return;
    }
    
    GoodsModel *model = goods_Mtlist[button.tag];
    
    RequestCenter * request = [RequestCenter shareRequestCenter];
    NSDictionary *postDics = @{@"goods_id":model.goods_id,
                              @"goods_num":@"1"
                              };
    [request sendRequestPostUrl:ADD_SHOP_GOODS andDic:postDics setSuccessBlock:^(NSDictionary *resultDic) {
        if ([resultDic[@"code"] intValue] !=1) {
            HUDNormal(@"添加失败，请稍后再试");
            return ;
        }
        _tipView.hidden = NO;
        _disappear = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(animalMoveImage) userInfo:nil repeats:NO];
    } setFailBlock:^(NSString *errorStr) {
        NSLog(@"");
        
    }];
    
}
-(void)animalMoveImage{
    
    
    _tipView.hidden = YES;
}
//添加购物车成功提示
-(void)createTipView{
    
    _tipView = [[UIView alloc]initWithFrame:CGRectMake(90,M_HEIGHT/2-M_HEIGHT/8,M_WIDTH-180, M_HEIGHT/5)];
    _tipView.backgroundColor = [UIColor blackColor];
    _tipView.alpha = 0.8;
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


- (IBAction)leftNavBarClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)orderByZonghe:(id)sender {
    orderByNum = 0 ;
    [self changePostValue];
}

- (IBAction)orderByxiaoliang:(id)sender {
    orderByNum = 1 ;
    [self changePostValue];
}

- (IBAction)orderByPrice:(id)sender {
    orderByNum = 2 ;
    [self changePostValue];
}

- (void)changePostValue{
    
    if ([postDic[@"order_by_price"] intValue] > 0) {
        [postDic removeObjectForKey:@"order_by_price"];
    }
    
    switch (orderByNum) {
        case 0:
        {
            //综合
            _salesLabel.textColor = [UIColor blackColor];
            _allLabel.textColor = [UIColor orangeColor];
      
        }
            break;
        case 1:
        {
            
            //销量
            _salesLabel.textColor = [UIColor orangeColor];
            _allLabel.textColor = [UIColor blackColor];
            
        }
            break;
        case 2:
        {
            _allLabel.textColor = [UIColor blackColor];
            _salesLabel.textColor = [UIColor blackColor];
             orderByPriceFlag = !orderByPriceFlag ;
            //价格
            if (orderByPriceFlag == YES) {
                //价格由高到低
                [postDic setValue:@"1" forKey:@"order_by_price"];
                _priceImageView.image = [UIImage imageNamed:@"筛选.png"];
            }else{
                [postDic setValue:@"2" forKey:@"order_by_price"];
                _priceImageView.image = [UIImage imageNamed:@"筛选2.png"];
            }
           
            
        }
            break;
            
        default:
            break;
    }
    [self.compositeTab headerBeginRefresh];
}
#pragma mark search
- (IBAction)searchClick:(id)sender {
    if (_searchTextField.text.length <= 0) {
        HUDNormal(@"请您输入关键字");
        return ;
    }
    
    [postDic removeObjectForKey:@"gc_id"];
    if (self.searchTextField.text.length > 0) {
        [postDic setValue:self.searchTextField.text forKey:@"goods_name"];
    }else{
        [postDic removeObjectForKey:@"goods_name"];
    }
    [self.compositeTab headerBeginRefresh];
}
@end
