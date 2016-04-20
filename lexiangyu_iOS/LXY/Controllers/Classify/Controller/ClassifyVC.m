//
//  ClassifyVC.m
//  LXY
//
//  Created by guohui on 16/3/14.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "ClassifyVC.h"
#import "ClassifyTabCell.h"
#import "ClassifyCollectionCell.h"
#import "Common.h"
#import "CompositeVC.h"
#import "ShopingDetailsVC.h"
#import "HeadCollectionReusableView.h"
#import "RequestCenter.h"
#import "ClassModel.h"
#import "GoodsModel.h"
#import "TitleModel.h"
static NSString *const cellID = @"CLASSIFYCOLLECTIONCELL";
static NSString *const headID = @"CLASSIFYCOLLECTIONHEAD";
@interface ClassifyVC ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UITextFieldDelegate>
{
    __weak IBOutlet UITableView *classifyTab;
    __weak IBOutlet UICollectionView *_collectionView;
//    NSIndexPath *changeIndexPath ;
    NSMutableArray *classMtArray ; //分类的数据 带model
    NSMutableArray *defMtArray ; //整个分类的大数组 包含goods 数组 存放goods model
    NSMutableArray *collectionMtTitleArray ;
    
}
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
- (IBAction)searchBtnClick:(UIButton *)sender;
@end

@implementation ClassifyVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"分类" ;
    self.navigationController.navigationBarHidden = YES ;
}
- (void)viewDidDisappear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = NO ;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    
    if (self.selectRow <= 0) {
        self.selectRow = 0 ;
    }
    self.automaticallyAdjustsScrollViewInsets = false ;
    classMtArray = [NSMutableArray arrayWithCapacity:0];
    defMtArray = [NSMutableArray arrayWithCapacity:0];
    collectionMtTitleArray = [NSMutableArray arrayWithCapacity:0];
    //注册复用的cell和head
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ClassifyCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:cellID];
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HeadCollectionReusableView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headID];
    [self loadClassData];
}

- (void)loadClassData{
    RequestCenter *requestCenter = [RequestCenter shareRequestCenter];
    [requestCenter sendRequestPostUrl:G_CLASS andDic:nil setSuccessBlock:^(NSDictionary *resultDic) {
        
        if ([resultDic[@"code"] intValue] != 1) {
            BG_LOGIN ;
        }
        NSArray *data = resultDic[@"data"];
        for (NSDictionary *dic in data) {
            ClassModel *classModel = [[ClassModel alloc]init];
            [classModel setValuesForKeysWithDictionary:dic];
            [classMtArray addObject:classModel];
        }
        [classifyTab reloadData];
        
        ClassModel *model = classMtArray[0];
        [self getGoodsDatabyClassid:model.gc_id];
    } setFailBlock:^(NSString *errorStr) {
        
    }];
    
}

#pragma mark - tab delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectRow != (int)indexPath.row) {
        ClassifyTabCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSIndexPath *selectIndexPath = [NSIndexPath indexPathForRow:self.selectRow inSection:0];
        ClassifyTabCell *cell2 = [tableView cellForRowAtIndexPath:selectIndexPath];
        [UIView animateWithDuration:0.3 animations:^{
            [cell2 changeFlageby:NO];
        } completion:^(BOOL finished) {
            [cell changeFlageby:YES];
            self.selectRow = (int)indexPath.row ;
        }];
//        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//        [tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
        ClassModel *model = classMtArray[indexPath.row];
        
        [self getGoodsDatabyClassid:model.gc_id];
    }
}

- (void)getGoodsDatabyClassid:(NSString *)classID{
    RequestCenter *requestCenter = [RequestCenter shareRequestCenter];
    
    [requestCenter sendRequestPostUrl:SECOND_CLASS andDic:@{@"gc_id":classID} setSuccessBlock:^(NSDictionary *resultDic) {
 
        if ([resultDic[@"code"] intValue] != 1) {
            BG_LOGIN ;
        }
        if (defMtArray.count > 0) {
            [defMtArray removeAllObjects];
        }
        if (collectionMtTitleArray.count > 0) {
            [collectionMtTitleArray removeAllObjects];
        }
        //点击之后collection 需要刷新的部分
        NSArray *dataArray = resultDic[@"data"];
        // 加载分类的数据
        for (NSDictionary *dic in dataArray) {
            NSMutableArray *goodsMtArray = [NSMutableArray arrayWithCapacity:0];
            for (NSDictionary *goodsDic in dic[@"goods"]) {
                GoodsModel *model = [[GoodsModel alloc]init];
                [model setValuesForKeysWithDictionary:goodsDic];
                [goodsMtArray addObject:model];
            }
            [defMtArray addObject:goodsMtArray];
        }
        //加载分类的头数据
        for (NSDictionary *dic in dataArray) {
            TitleModel *model = [[TitleModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [collectionMtTitleArray addObject:model];
        }
        [_collectionView reloadData];
    } setFailBlock:^(NSString *errorStr) {
        
    }];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 36 ;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01 ;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01 ;
}
#pragma mark tab dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return classMtArray.count ;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *idertifier = @"CLASSIFYTABCELL" ;
    ClassifyTabCell *classifyTabCell = [tableView dequeueReusableCellWithIdentifier:idertifier];
    if (classifyTabCell == nil) {
        UINib *nib = [UINib nibWithNibName:@"ClassifyTabCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:idertifier];
        classifyTabCell = [tableView dequeueReusableCellWithIdentifier:idertifier];
    }
    ClassModel *model = classMtArray[indexPath.row];
    [classifyTabCell configWithClassModel:model];
    

    if ((int)indexPath.row == _selectRow && indexPath.section == 0) {
        [classifyTabCell changeFlageby:YES];
    }else{
        [classifyTabCell changeFlageby:NO];
    }
    return classifyTabCell ;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 ;
}



#pragma mark - Collection DataSource
//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [defMtArray[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    ClassifyCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    GoodsModel *model = defMtArray[indexPath.section][indexPath.row];
    [cell configWithGoodsModel:model];
    return cell;
    
}
//定义展示的Section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return defMtArray.count ;
}

#pragma mark - Collection Delegate
//UICollectionView被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ShopingDetailsVC *shoppingDetailsVC = [[ShopingDetailsVC alloc]init];
    
    GoodsModel *model = defMtArray[indexPath.section][indexPath.row];
    shoppingDetailsVC.goods_commonid = model.goods_id ;
    shoppingDetailsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shoppingDetailsVC animated:YES];
}
//返回这个UICollectionView是否可以被选择
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES ;
}
#pragma mark - Collection DelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(68, 90);
}
//定义每个UICollectionView 的 margin //设置左右上下的边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    int s = (int)(M_WIDTH - 78 - 68 * ((M_WIDTH - 78) / 68 - 1)) / ((M_WIDTH - 78) / 68) ;
    return UIEdgeInsetsMake(5, s, 5, s); //上左下右
}

// foot Size
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
//    return CGSizeMake(M_WIDTH, 44) ;
//}
// header Size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{

    return CGSizeMake(M_WIDTH, 24) ;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

    HeadCollectionReusableView *head = nil ;
    if (kind == UICollectionElementKindSectionHeader) {
        head = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headID forIndexPath:indexPath];
        TitleModel *model = collectionMtTitleArray[indexPath.section];
        head.headLab.text = model.gc_name ;
        head.control.tag = indexPath.section ;
        [head.control addTarget:self action:@selector(headclick:) forControlEvents:UIControlEventTouchUpInside];
    }

    
    return head ;
    
}

#pragma mark - testField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.searchTextField resignFirstResponder];
    return YES ;
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

- (IBAction)searchBtnClick:(UIButton *)sender {
    CompositeVC *compositeVC = [[CompositeVC alloc]init];
    compositeVC.hidesBottomBarWhenPushed = YES ;
    if (self.searchTextField.text.length > 0) {
        compositeVC.goods_name = self.searchTextField.text ;
    }
    [self.navigationController pushViewController:compositeVC animated:YES];
}
- (void)headclick:(UIControl *)control {
    CompositeVC *compositeVC = [[CompositeVC alloc]init];
    compositeVC.hidesBottomBarWhenPushed = YES ;
    TitleModel *model = collectionMtTitleArray[control.tag];
    compositeVC.goods_name = model.gc_name ;
    compositeVC.gc_id = model.gc_id ;
    [self.navigationController pushViewController:compositeVC animated:YES];
}

@end
