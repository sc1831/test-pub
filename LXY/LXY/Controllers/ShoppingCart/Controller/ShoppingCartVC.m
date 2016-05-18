//
//  ShoppingCartVC.m
//  LXY
//
//  Created by guohui on 16/3/14.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "ShoppingCartVC.h"
#import "GHControl.h"
#import "Common.h"
#import "ShoppingCartCell.h"
#import "ConfirmorderVC.h"
#import "RequestCenter.h"
#import "ShoppingCartModel.h"
#import "SaveInfo.h"
#import "ShopingDetailsVC.h"
#import "UITableView+MJRefresh.h"
#import "ShoppingCartBackView.h"



@implementation ShoppingCartSelectModel


@end

@interface ShoppingCartVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
//全选按钮
@property (weak, nonatomic) IBOutlet UIButton *allShopButton;
//合计多少钱
@property (weak, nonatomic) IBOutlet UILabel *allMoneyPay;
//全部结算底部view
@property (weak, nonatomic) IBOutlet UIView *AllView;
//删除底部view
@property (weak, nonatomic) IBOutlet UIView *bottmView;
//底部全选图片
@property (weak, nonatomic) IBOutlet UIImageView *bootmAllImageView;
//底部全选删除图片
@property (weak, nonatomic) IBOutlet UIImageView *bootmDeleteImageView;
//全选删除
@property (weak, nonatomic) IBOutlet UIButton *allDeleteButton;

@property (nonatomic, strong) NSMutableDictionary *mutableDictModel;

@property (nonatomic ,strong)UITableView *shoppingTableView;
@property (nonatomic, strong)UIControl *headView;
@property (nonatomic ,strong)UIView *footView;
@property (nonatomic,strong)UITabBarItem * tabBarItemOfMessage;
@property (nonatomic ,strong)UIButton *rightNarBtn;

@property (nonatomic ,strong)NSMutableArray *dataArray;
//用来存储每组的总数据
@property (nonatomic ,strong)NSMutableArray *totalPriceArray;

@property (nonatomic ,strong)NSString *cartStr;
@property (nonatomic ,strong)NSString *cartIds;
//选中全部删除
@property (nonatomic) BOOL allClick;
@property (nonatomic ,assign) int allGoods;
//选中全部结算
@property (nonatomic) BOOL allPayClick;
//选中物品价格
@property (nonatomic ,assign)CGFloat goodsMucth;


//存储每组数据的状态
@property (nonatomic ,strong) NSMutableArray *sectionStateArray;
//购物车每个商品的数量
@property (nonatomic ,assign) int shopNum;
//购物数量
@property (nonatomic ,assign) int shopAllNum;
//选择需要添加或减少的cart——id
@property (nonatomic ,strong) NSString *cart_ids;
//收货地址
@property (nonatomic ,strong)NSString *addressStr;
//记录是否是单个侧滑删除
@property (nonatomic ) BOOL isOnly;
@property (nonatomic ,strong)NSMutableArray *mutDataArray;
@property (nonatomic ,strong)ShoppingCartBackView *shopBackView;


//存储最内层goods_spec对应的数组
@property (nonatomic ,strong)NSMutableArray *goodsSpecArray;


//删除全部
- (IBAction)allDeleteClick:(id)sender;
//删除
- (IBAction)deleteClick:(id)sender;
//全选
- (IBAction)allFutureButton:(id)sender;
//去结算
- (IBAction)settlementButton:(id)sender;
@end

@implementation ShoppingCartVC
-(void)viewWillAppear:(BOOL)animated{

    [self addMjHeaderAndFooter];
    [self.shoppingTableView headerBeginRefresh];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购物车";
    self.view.backgroundColor = RGBCOLOR(219, 223, 224);
    _dataArray = [[NSMutableArray alloc]init];
    _allClick = NO;
    _allPayClick = NO;
    _allGoods = 0;
    _shopNum = 0;
    _sectionStateArray = [NSMutableArray array];
    _goodsSpecArray = [NSMutableArray array];
    _totalPriceArray = [NSMutableArray array];
    
    [self createTableView];

    self.automaticallyAdjustsScrollViewInsets = false ;
    _rightNarBtn = [GHControl createButtonWithFrame:CGRectMake(0, 0,50,30) ImageName:nil Target:self Action:@selector(rightNavBtnClick) Title:@"编辑"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_rightNarBtn];
//    [self.view bringSubviewToFront:_AllView];
    _bottmView.hidden = YES;
//    self.tabBarItemOfMessage =[self.tabBarController.tabBar.items objectAtIndex:2];
//    self.tabBarItemOfMessage.badgeValue = @"99+";
    [self createBackView];
    
    [GHControl setExtraCellLineHidden:_shoppingTableView];
    
    

    [self.view addSubview:self.noNetworkView];
    
    
}
//重新加载数据
-(void)NoNetworkClickDelegate{
    if (![GHControl isExistNetwork]) {
        self.noNetworkView.hidden = NO;
        return;
    }
    self.noNetworkView.hidden = YES;
    [self addMjHeaderAndFooter];
    [self.shoppingTableView headerBeginRefresh];
}
-(void)createBackView{

    _shopBackView = [[[NSBundle mainBundle] loadNibNamed:@"ShoppingCartBackView"
                                                   owner:self
                                                 options:nil] firstObject];
    _shopBackView.frame = CGRectMake(0,64, M_WIDTH, M_HEIGHT-64-49 - 56);
    [self.view addSubview:_shopBackView];
    
    [_shopBackView.goLookButton addTarget:self action:@selector(goLookButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _shopBackView.hidden = YES;
}
-(void)goLookButtonClick{

    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"isReferred" object:self userInfo:nil];
    
}

#pragma mark MJRefresh
- (void)addMjHeaderAndFooter{
    [self.shoppingTableView headerAddMJRefresh:^{//添加顶部刷新功能
        [self.shoppingTableView footerResetNoMoreData];//重置无数据状态
        
        if (![GHControl isExistNetwork]) {
            if (_dataArray.count>0) {
                self.noNetworkView.hidden = YES;
            }else{
                self.noNetworkView.hidden = NO;
            }
            
            [self.shoppingTableView headerEndRefresh];
            return;
        }else{
        
          self.noNetworkView.hidden = YES;
        }
        [self sendRequestData];
    }];
    
    
}
-(void)sendRequestData{

    
    RequestCenter *request = [RequestCenter shareRequestCenter];

    NSDictionary *dict = @{@"buyer_id":[[SaveInfo shareSaveInfo] user_id]};

    NSMutableString *string = [NSMutableString stringWithString:SHOP_GOODS];
    
    [request sendRequestPostUrl:string andDic:dict setSuccessBlock:^(NSDictionary *resultDic) {
        
       
        
        if ([resultDic[@"code"] intValue] != 1) {
            [self.shoppingTableView headerEndRefresh];
            BG_LOGIN ;
            HUDNormal(resultDic[@"msg"])
             [self.shoppingTableView headerEndRefresh];
            return ;
        }
        
        [_sectionStateArray removeAllObjects];
        [_dataArray removeAllObjects];
        [_goodsSpecArray removeAllObjects];
        [_totalPriceArray removeAllObjects];
        

        NSDictionary *data = resultDic[@"data"];
        
        NSDictionary *cartDic = data[@"cart"];
        
        NSArray *keyArray =[cartDic allKeys];
        _shopBackView.hidden = YES;
        _rightNarBtn.hidden = NO;
        _AllView.hidden = NO;
        self.view.backgroundColor = RGBCOLOR(219, 223, 224);
        if (keyArray.count==0) {
            [_shoppingTableView reloadData];
            HUDNormal(@"暂时还没有购物");
            [self allMoneyPayStr];
            
            [_rightNarBtn setTitle:@"编辑" forState:UIControlStateNormal];
            _bottmView.hidden = YES;
            _AllView.hidden = NO;
             _shopBackView.hidden = NO;
            _rightNarBtn.hidden = YES;
            _AllView.hidden = YES;
            self.view.backgroundColor = [UIColor whiteColor];

            [self.shoppingTableView headerEndRefresh];
            return;
        }
        
        for (int i = 0; i<keyArray.count; i++)
        {
           
            NSDictionary *dic= [cartDic objectForKey:[[cartDic allKeys]objectAtIndex:i]];
            ShoppingCartModel *model = [ShoppingCartModel modelWithDic:dic];
            [_totalPriceArray addObject:model];
            
            NSArray *array = dic[@"goods"];
            
             NSMutableArray *smallArray = [NSMutableArray array];
            for (NSDictionary *dic in array) {
                ShoppingCartModel *model = [ShoppingCartModel modelWithDic:dic];
                [smallArray addObject:model];
                
                NSMutableArray *subGoodsSpecArray = [NSMutableArray array];
                NSArray *subGoodsSpec = dic[@"goods_spec"];
                for (NSDictionary *subGoodsSpecDict in subGoodsSpec) {
                    ShoppingCartModel *model = [ShoppingCartModel modelWithDic:subGoodsSpecDict];
                    [subGoodsSpecArray addObject:model];
                }
                if (subGoodsSpec.count== 0) {
                    [_goodsSpecArray addObject:subGoodsSpec];
                }
                [_goodsSpecArray addObject:subGoodsSpecArray];
                
            }
            
            [_dataArray addObject:smallArray];
            
            [_sectionStateArray addObject:@"1"];
            
        }
        

        [self updateAllButtonState];
        _allMoneyPay.text = [NSString stringWithFormat:@"合计:￥%.2lf",0.00];
        
        [self.shoppingTableView headerEndRefresh];
        [_shoppingTableView reloadData];
        
        
    } setFailBlock:^(NSString *errorStr) {
        if (![GHControl isExistNetwork]) {
            if (_dataArray.count>0) {
                self.noNetworkView.hidden = YES;
            }else{
                self.noNetworkView.hidden = NO;
            }
            
            [self.shoppingTableView headerEndRefresh];
            return;
        }else{
            
            self.noNetworkView.hidden = YES;
        }

         [self.shoppingTableView headerEndRefresh];
    }];
}
-(void)rightNavBtnClick{
    NSLog(@"编辑点击");
    if (_bottmView.hidden == YES) {
        [_rightNarBtn setTitle:@"完成" forState:UIControlStateNormal];
        _bottmView.hidden = NO;
        _AllView.hidden = YES;
        
        [self updateAllButtonState];
        
    }else{
    
        [_rightNarBtn setTitle:@"编辑" forState:UIControlStateNormal];
        _bottmView.hidden = YES;
        _AllView.hidden = NO;
        [self updateAllButtonState];
    }
    
}
-(void)updateAllButtonState{

    BOOL allShopClick=YES;
    for (int i = 0 ; i<_sectionStateArray.count; i++) {
        if ([_sectionStateArray[i] isEqualToString:@"1"]) {
            allShopClick = NO;
            _allPayClick = NO;
            [_allShopButton setTitle:@"全选" forState:UIControlStateNormal];
            _bootmAllImageView.image = [UIImage imageNamed:@"未选中"];
            
            _allClick = NO;
            [_allDeleteButton setTitle:@"全选" forState:UIControlStateNormal];
            _bootmDeleteImageView.image = [UIImage imageNamed:@"未选中"];
        }
    }
    if (_sectionStateArray.count==0) {
        allShopClick = NO;
        _allPayClick = NO;
        [_allShopButton setTitle:@"全选" forState:UIControlStateNormal];
        _bootmAllImageView.image = [UIImage imageNamed:@"未选中"];
        
        _allClick = NO;
        [_allDeleteButton setTitle:@"全选" forState:UIControlStateNormal];
        _bootmDeleteImageView.image = [UIImage imageNamed:@"未选中"];
    }
    if (allShopClick) {
        _allPayClick = YES;
        [_allShopButton setTitle:@"全选" forState:UIControlStateNormal];
        _bootmAllImageView.image = [UIImage imageNamed:@"选中"];
        _allClick = YES;
        [_allDeleteButton setTitle:@"全选" forState:UIControlStateNormal];
        _bootmDeleteImageView.image = [UIImage imageNamed:@"选中"];
        
    }
    
    
    
    
}
-(void)createTableView{
    
    _shoppingTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64, M_WIDTH, M_HEIGHT-64-49 - 56) style:UITableViewStyleGrouped];
    _shoppingTableView.delegate = self;
    _shoppingTableView.dataSource = self;
    _shoppingTableView.backgroundColor = RGBCOLOR(219, 223, 224);
    [self.view addSubview:_shoppingTableView];
    
}

#pragma mark-----UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 12;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellName = @"ShoppingCartCell";
    
    ShoppingCartCell *cell =
    (ShoppingCartCell *)[tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellName owner:self options:nil] firstObject];
        
    }
 
    ShoppingCartModel *model = _dataArray[indexPath.section][indexPath.row];
    
//    [cell dataWithCell:model andAllGoods:_allGoods];
    NSLog(@"indexPath.section:%ld",indexPath.section);
    
    
    int indexValue = [_sectionStateArray[indexPath.section] intValue];
    [cell dataWithCell:model sectionIndexValue:indexValue andAllGoods:_allGoods];
    
    if ([_goodsSpecArray[indexPath.section] count]!=0) {
        
    
        NSMutableArray *contectArray = [NSMutableArray array];
        for (int i = 0;  i< [_goodsSpecArray[indexPath.section] count]; i++) {
            ShoppingCartModel *goodsSpecModel = _goodsSpecArray[indexPath.section][i];
            
            [contectArray addObject:[NSString stringWithFormat:@"%@:%@          ",goodsSpecModel.sp_name,goodsSpecModel.sp_value_name]];
          
        }
        cell.shopDetailContent.text = [contectArray componentsJoinedByString:@""];
        
    }
    
    
    [cell.rightButton addTarget:self action:@selector(rightImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.rightButton.tag = indexPath.section;
    
    
    //添加商品数量按钮
    [cell.addButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.addButton.tag = indexPath.section*1000 + indexPath.row;
    //减少商品数量按钮
    [cell.reductionButton addTarget:self action:@selector(reductionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.reductionButton.tag = indexPath.section*1000 + indexPath.row ;
//    cell.numberTextField.delegate = self;
    cell.numberBtn.tag = indexPath.section*10000 + indexPath.row ;
    [cell.numberBtn addTarget:self action:@selector(changeCellNumLab:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return 145;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    [self createHeadView];
    NSString *str = nil;
    str = @"选中";
    
    NSString *storName =nil;
    for (int i =0 ; i<[_dataArray[section] count]; i++) {
        ShoppingCartModel *model = _dataArray[section][i];
        storName = model.store_name;
        if (model.isSelected == NO) {
            str = @"未选中";
        }else{
            
        }
        if ([_sectionStateArray[section] intValue]==2) {
            str = @"选中";
        }
    }
    UIButton *rightButton = [GHControl createButtonWithFrame:CGRectMake(0,8,40,35) ImageName:nil Target:self Action:@selector(rightBtnClick:) Title:nil];
    [rightButton setImage:[UIImage imageNamed:str] forState:UIControlStateNormal];
        rightButton.tag = section;
    [_headView addSubview:rightButton];
    
    
    UILabel *label = [GHControl createLabelWithFrame:CGRectMake(63,11, M_WIDTH-25-60, 30) Font:14 Text:[NSString stringWithFormat:@"%@",storName]];
    label.textColor = RGBCOLOR(99, 100, 101);
    [_headView addSubview:label];
    
    
    return _headView;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    NSMutableArray *mutArray = _dataArray[section];
    ShoppingCartModel *sectionModel = _totalPriceArray[section];
    CGFloat goodsPrice ;
    for (int i = 0 ; i<mutArray.count; i++) {
        CGFloat value;
        ShoppingCartModel *model = mutArray[i];
        value = [model.goods_price floatValue];
        goodsPrice += value;
        
    }
    
    [self createFootView];
    
    UILabel *label = [GHControl createLabelWithFrame:CGRectMake(0,3,M_WIDTH-5,10) Font:10 Text:[NSString stringWithFormat:@"小计(共%@件):￥%.2lf",sectionModel.goods_num_total ,[sectionModel.goods_price_total floatValue]]];
    label.textColor = RGBCOLOR(249, 147, 73);
    label.textAlignment = NSTextAlignmentRight;
    [_footView addSubview:label];
    
    return _footView;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     CELLSELECTANIMATE ;
    [_shoppingTableView deselectRowAtIndexPath:indexPath animated:YES];
    ShopingDetailsVC *shoppingDetailsVC = [[ShopingDetailsVC alloc]init];
    ShoppingCartModel *model = _dataArray[indexPath.section][indexPath.row];
    shoppingDetailsVC.goods_commonid = model.goods_id ;
    shoppingDetailsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shoppingDetailsVC animated:YES];
    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
     ShoppingCartModel *model = _dataArray[indexPath.section][indexPath.row];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        _isOnly = YES;
        [_mutDataArray removeLastObject];
        //删除单个
        [self deleteShopDoods:indexPath cartIds:model.cart_id andIsAllDelete:NO];

    }else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }
}
#pragma mark-----点击添加或减少商品数量按钮
//点击加号
-(void)addButtonClick:(UIButton *)addButton{
    
    [self addButtonClickOrReductionButtonClick:YES andButton:addButton];
    
}
-(void)reductionButtonClick:(UIButton *)reductionButton{

    [self addButtonClickOrReductionButtonClick:NO andButton:reductionButton];
    
}
-(void)addButtonClickOrReductionButtonClick:(BOOL )isAddButtonClick  andButton:(UIButton *)addButton {
    
    _cart_ids = nil;
    ShoppingCartModel *model = _dataArray[addButton.tag/1000][addButton.tag%1000];
    _shopNum =  [model.goods_num intValue];
   
    if (isAddButtonClick) {
      _shopNum++;
    }else{
    
      _shopNum--;
    }
    if (_shopNum>[model.goods_storage intValue]) {
        HUDNormal(@"抱歉哦、没那么多库存");
        return;
    }
//    model.goods_num = [NSString stringWithFormat:@"%d",_shopNum];
    

    [self sendAddShopGoodsCartId:model.cart_id andGoodsNum:[NSString stringWithFormat:@"%d",_shopNum] isManual:NO];
    
}
#pragma mark------点击cell对勾按钮
//点击选中按钮
-(void)rightBtnClick:(UIButton *)rightButton{
    _allGoods = 0;

    if ([_sectionStateArray[rightButton.tag] intValue]==1) {
        [_sectionStateArray replaceObjectAtIndex:rightButton.tag withObject:@"2"];
    }else{
    
        [_sectionStateArray replaceObjectAtIndex:rightButton.tag withObject:@"1"];
    }
    
    
    UIImage *image = nil;
    for (int i = 0 ; i < [_dataArray[rightButton.tag] count]; i++) {
        ShoppingCartModel *model = _dataArray[rightButton.tag][i];
        if ([_sectionStateArray[rightButton.tag] intValue]==1){
        
            image = [UIImage imageNamed:@"未选中"];
            model.isSelected = NO;
        }else{
            image = [UIImage imageNamed:@"选中"];
            model.isSelected = YES;
            
        }
        
    }
//    [rightButton setBackgroundImage:image forState:UIControlStateNormal];
    [rightButton setImage:image forState:UIControlStateNormal];
    NSLog(@"点击圆点");
    [self.shoppingTableView reloadData];

    //显示总价
    [self allMoneyPayStr];
    
}
-(void)rightImageButtonClick:(id)sender {
    _allGoods = 0;
    
    UIButton *button = (UIButton *)sender;
    UITableViewCell * cell = (UITableViewCell *)[[button superview] superview];
    NSIndexPath * indexPath = [self.shoppingTableView indexPathForCell:cell];
    //返回按钮颜色
    ShoppingCartModel *model = _dataArray[indexPath.section][indexPath.row];
    model.isSelected = !model.isSelected;
    UIImage *image = nil;
    if(model.isSelected) {
        image = [UIImage imageNamed:@"选中"];
    }
    else {
        image = [UIImage imageNamed:@"未选中"];
    }
    
    int num = 0;
    for (int i =0 ; i<[_dataArray[indexPath.section] count]; i++) {
        ShoppingCartModel *model = _dataArray[indexPath.section][i];

        if (model.isSelected == NO) {
            image = [UIImage imageNamed:@"未选中"];
            num++;
            
        }else{
            image = [UIImage imageNamed:@"选中"];
            
        }
        
    }
    if (num==0) {
        [_sectionStateArray replaceObjectAtIndex:indexPath.section withObject:@"2"];
    }else{
    
        [_sectionStateArray replaceObjectAtIndex:indexPath.section withObject:@"1"];
    }
    
    
    ShoppingCartCell *shopCell = [self.shoppingTableView cellForRowAtIndexPath:indexPath];
    
    [shopCell.rightButton setBackgroundImage:image forState:UIControlStateNormal];
//    [shopCell.rightButton setImage:image forState:UIControlStateNormal];
    [shopCell.rightButton setImageEdgeInsets:UIEdgeInsetsMake(15, 15, 15,15)];
    [self.shoppingTableView reloadData];
    //显示总价
    [self allMoneyPayStr];
    
}

-(UIImage *)buttonBackgroundImage:(UIButton *)button{

    
    UIImage *image = nil;
    for (int i = 0 ; i < [_dataArray[button.tag] count]; i++) {
        ShoppingCartModel *model = _dataArray[button.tag][i];
        NSLog(@"model.goods_price:%@",model.goods_price);
        model.isSelected = !model.isSelected;
        if(model.isSelected) {
            image = [UIImage imageNamed:@"选中"];
        }
        else {
            image = [UIImage imageNamed:@"未选中"];
        }
        
    }

    return image;
}

//全选
- (IBAction)allFutureButton:(id)sender {
    NSLog(@"全选点击");
    
    UIButton *button = (UIButton *)sender;
    
    _allPayClick = !_allPayClick;
    if (_allPayClick) {
        for (int i = 0 ; i< _sectionStateArray.count; i++) {
            for (int j = 0 ; j < [_dataArray[i] count]; j++) {
                ShoppingCartModel *model = _dataArray[i][j];
                model.isSelected = YES;
            }
        }
        
        for (int i = 0 ; i<_sectionStateArray.count; i++) {
            [_sectionStateArray replaceObjectAtIndex:i withObject:@"2"];
        }
        [button setTitle:@"全选" forState:UIControlStateNormal];
        _bootmAllImageView.image = [UIImage imageNamed:@"选中"];
    }else{
        
        for (int i = 0 ; i< _sectionStateArray.count; i++) {
            for (int j = 0 ; j < [_dataArray[i] count]; j++) {
                ShoppingCartModel *model = _dataArray[i][j];
                model.isSelected = NO;
            }
        }
        for (int i = 0 ; i<_sectionStateArray.count; i++) {
            [_sectionStateArray replaceObjectAtIndex:i withObject:@"1"];
        }
        [button setTitle:@"全选" forState:UIControlStateNormal];
        _bootmAllImageView.image = [UIImage imageNamed:@"未选中"];
    }
    [self.shoppingTableView reloadData];
    //显示总价
    [self allMoneyPayStr];

}
-(void)allMoneyPayStr{
    _goodsMucth = 0;
    
    for (int i = 0 ; i< _sectionStateArray.count; i++) {
        for (int j = 0 ; j < [_dataArray[i] count]; j++) {
            ShoppingCartModel *model = _dataArray[i][j];
            CGFloat value;
            if (model.isSelected) {
                value = [model.goods_price floatValue]*[model.goods_num floatValue];
                _goodsMucth += value;
                
            }
        }
        
    }
    _allMoneyPay.text = [NSString stringWithFormat:@"合计:￥%.2lf元",_goodsMucth];
    if ([_allMoneyPay.text isEqualToString:@"0.00"]) {
        _bottmView.backgroundColor = [UIColor grayColor];
        
    }else{
    
        _bottmView.backgroundColor = RGBCOLOR(253, 80, 11);
    }
    //刷新全选按钮状态
    [self updateAllButtonState];
    
}
//去结算
- (IBAction)settlementButton:(id)sender {
    _cartIds = @"";
    for (int i = 0 ; i< _sectionStateArray.count; i++) {
        for (int j = 0 ; j < [_dataArray[i] count]; j++) {
            ShoppingCartModel *model = _dataArray[i][j];
            if (model.isSelected) {
                NSString *str = [NSString stringWithFormat:@"%@,",model.cart_id];
                _cartIds = [NSString stringWithFormat:@"%@%@",_cartIds,str];
            }
        }
    }
    if ([_cartIds isEqualToString:@""]) {
        HUDNormal(@"请选择商品");
        return;
    }
    
    
    ConfirmorderVC *confirmVC = [[ConfirmorderVC alloc]init];
    confirmVC.orderIds = @"";
    confirmVC.cartIds = _cartIds;
    confirmVC.goodsIds = @"";
    confirmVC.goodsNum = @"";
    confirmVC.pay_sn = @"" ;
    confirmVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:confirmVC animated:YES];
}
//选中全部删除按钮
- (IBAction)allDeleteClick:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    
    _allClick = !_allClick;
    if (_allClick) {
        for (int i = 0 ; i< _sectionStateArray.count; i++) {
            for (int j = 0 ; j < [_dataArray[i] count]; j++) {
                ShoppingCartModel *model = _dataArray[i][j];
                model.isSelected = YES;
                }
            }
        
        for (int i = 0 ; i<_sectionStateArray.count; i++) {
            [_sectionStateArray replaceObjectAtIndex:i withObject:@"2"];
        }
        [button setTitle:@"全选" forState:UIControlStateNormal];
        _bootmDeleteImageView.image = [UIImage imageNamed:@"选中"];
    }else{
        
        for (int i = 0 ; i< _sectionStateArray.count; i++) {
            for (int j = 0 ; j < [_dataArray[i] count]; j++) {
                ShoppingCartModel *model = _dataArray[i][j];
                model.isSelected = NO;
            }
        }
        for (int i = 0 ; i<_sectionStateArray.count; i++) {
            [_sectionStateArray replaceObjectAtIndex:i withObject:@"1"];
        }
        [button setTitle:@"全选" forState:UIControlStateNormal];
        _bootmDeleteImageView.image = [UIImage imageNamed:@"未选中"];
    }
    [self allMoneyPayStr];
    [self.shoppingTableView reloadData];
    
}
//删除全部
- (IBAction)deleteClick:(id)sender {
    _mutDataArray = [NSMutableArray array];
    _cartIds = @"";
    for (int i = 0 ; i< _sectionStateArray.count; i++) {
        for (int j = 0 ; j < [_dataArray[i] count]; j++) {
            ShoppingCartModel *model = _dataArray[i][j];
                    if (model.isSelected) {
                       NSString *str = [NSString stringWithFormat:@"%@,",model.cart_id];
                        _cartIds = [NSString stringWithFormat:@"%@%@",_cartIds,str];
                        [_mutDataArray addObject:str];
                }
            }

    }
    
        [self deleteShopDoods:nil cartIds:_cartIds andIsAllDelete:YES];

}
#pragma  mark------删除购物车物品
-(void)deleteShopDoods:(NSIndexPath *)indexPath cartIds:(NSString *)cartIds andIsAllDelete:(BOOL)isAllDelete{

    if ([cartIds isEqualToString:@""]) {
        HUDNormal(@"请选择要删除的商品");
        return;
    }
    if (![GHControl isExistNetwork]) {
        HUDNormal(@"服务器无响应，请稍后重试");

        return;
    }
    
    RequestCenter *request = [RequestCenter shareRequestCenter];
    
    NSDictionary *dict = @{@"cart_ids":cartIds};
    
    NSMutableString *string = [NSMutableString stringWithString:DELLECT_SHOP_GOODS];
    
    [request sendRequestPostUrl:string andDic:dict setSuccessBlock:^(NSDictionary *resultDic) {
        if ([resultDic[@"code"] intValue] != 1) {
            BG_LOGIN ;
            HUDNormal(@"数据删除失败，请稍后再试");
            return ;
        }

       

     
        
        if (_mutDataArray.count!=0) {
            [self sendRequestData];
            if (_dataArray.count==0) {
                _bootmDeleteImageView.image = [UIImage imageNamed:@"未选中"];
                [_allDeleteButton setTitle:@"全选" forState:UIControlStateNormal];
                
                
            }
        }
        
        //侧滑删除
        if (_isOnly) {
            _isOnly = NO;
            [_sectionStateArray removeLastObject];
            if ([_dataArray[indexPath.section] count]==1) {
                [_dataArray removeObjectAtIndex:indexPath.section];
            }else{
                
                [_dataArray[indexPath.section] removeObjectAtIndex:indexPath.row];
            }
            [self sendRequestData];
            

        }
       
        
        [_shoppingTableView reloadData];
    } setFailBlock:^(NSString *errorStr) {
        
    }];
    
}
#pragma mark----更改商品数量
-(void)sendAddShopGoodsCartId:(NSString *)cartId  andGoodsNum:(NSString *)goodsNum isManual:(BOOL)ismanual{
    
    if (![GHControl isExistNetwork]) {
        HUDNormal(@"服务器无响应，请稍后重试");

        return;
    }

    RequestCenter *request = [RequestCenter shareRequestCenter];
    
    NSDictionary *dict = @{@"cart_id":cartId,
                           @"goods_num":goodsNum
                           };
    
    
    
    [request sendRequestPostUrl:ADD_SHOP_GOODS_NUM andDic:dict setSuccessBlock:^(NSDictionary *resultDic) {
        if ([resultDic[@"code"] intValue] != 1) {
            BG_LOGIN ;
            HUDNormal(resultDic[@"msg"]);
            return ;
        }


//        if (ismanual) {
//            [self sendRequestData];
//        }else{
//        
//          [_shoppingTableView reloadData];
//        }
        [self sendRequestData];
        
    } setFailBlock:^(NSString *errorStr) {
        
    }];
    
   

}
- (void)changeCellNumLab:(UIButton *)button{
    ShoppingCartModel *model = _dataArray[button.tag/10000][button.tag%10000];

    _shopAllNum = [model.goods_storage intValue];
    
    
    _cart_ids = model.cart_id;
    [self showInputBidNum:model.goods_storage];
    
}
- (void)showInputBidNum:(NSString *)num{
    //文本框只能是alert风格
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:nil message:@"请输入要购买的数量" preferredStyle:UIAlertControllerStyleAlert];
    
    
    [alertControl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }]];
    [alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"确定");
       UITextField *codeTestField = alertControl.textFields.lastObject;
        
        if (_shopAllNum < [codeTestField.text intValue]) {
            HUDNormal(@"抱歉哦、没那么多库存");
            return;
        }

        [self sendAddShopGoodsCartId:_cart_ids andGoodsNum:codeTestField.text isManual:YES];
    }]];

    
    [alertControl addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = [NSString stringWithFormat:@"库存量为%@",num];
    }];
    [self presentViewController:alertControl animated:YES completion:nil];
}
- (void)alertTextFieldDidChange:(NSNotification *)notification{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;  // 不要错写为self.presentedViewController
    if (alertController) {
        //下标为2的是添加了坚挺的 也是最后一个alertcontroller.textfields.lastObject
        UITextField *listrn = alertController.textFields.lastObject;
        //限制,如果listen输入长度要限制5个字内,否则不允许点击默认defalut 键
        UIAlertAction *action = alertController.actions.lastObject ;
        action.enabled = listrn.text.length == 4 ;
    }
}
#pragma mark------headView  footView
-(UIView *)createHeadView{
    _headView = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, M_WIDTH,45)];
    _headView.backgroundColor = [UIColor whiteColor];
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, M_WIDTH,5)];
    topView.backgroundColor = RGBCOLOR(219, 223, 224);
    [_headView addSubview:topView];
    
    
    UIImage *headImage = [UIImage imageNamed:@"店铺"];
    UIImageView *headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(40,18, headImage.size.width, headImage.size.height)];
    headImageView.image = headImage;
    [_headView addSubview:headImageView];
    
    
    return _headView;
}
-(UIView *)createFootView{
    _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, M_WIDTH,12)];
    _footView.backgroundColor = RGBCOLOR(219, 223, 224);
    
    return _footView;
}
@end
