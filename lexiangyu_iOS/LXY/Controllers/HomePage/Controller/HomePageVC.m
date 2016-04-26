

//
//  HomePageVC.m
//  LXY
//
//  Created by guohui on 16/3/14.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "HomePageVC.h"
#import "Common.h"
#import "HomeClassifyVC.h"
#import "HomeCollectionViewCell.h"
#import "ShopingDetailsVC.h"
#import "BestGoodsCell.h"
#import "SpecitalViewTableViewCell.h"
#import "RequestCenter.h"
#import "CompositeVC.h"
#import "GoodsModel.h"
#import "HomeModel.h"
#import "SaveInfo.h"
#import "GHControl.h"
static NSString *const homeCollectionCellID = @"HOMECOLLECTIONVIEWCELL" ;
@interface HomePageVC ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    __weak IBOutlet UICollectionView *_collectionView; //可能感兴趣
    __weak IBOutlet UITableView *bestGoodsTab; //优品推荐
    //特价view
    __weak IBOutlet UIView *specialView;
    //优品推荐view
    __weak IBOutlet UIView *bestGoodsView;
    //优品推荐view的高度
    __weak IBOutlet NSLayoutConstraint *bestGoodsViewHeight;
    //可能感兴趣商品view的高度
    __weak IBOutlet NSLayoutConstraint *collectionViewHeight;
    
}

@property (nonatomic ,strong)UITableView *specialTableView; //超值特价
//@property (nonatomic,strong)AFNetworkReachabilityManager *manager;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIView *goods_classView;

- (IBAction)gotoController:(UIControl *)sender;
- (IBAction)gotoGoodsDetails:(UIControl *)sender;
- (IBAction)searchButClick:(UIControl *)sender;


@end

@implementation HomePageVC
{
//        //无网络界面
//      UIView *noNetView ;
    //  记录当前第几页
    int _currentIndex;
    
    //装载所有的image
    NSMutableArray *_imageArray;
    NSTimer *_moveTimer;
    BOOL _isTimerUp;//判断手动还是自动滚动
    
    
    
    //记录当前第几页
    int _middleIndex;
    //装载所有的image
    NSMutableArray *_middleImageArray;
    NSTimer *_middleMoveTimer;
    BOOL _middleIsTimerUp;//判断手动还是自动滚动
    
    NSMutableArray *adv ; //广告图
    NSMutableArray *discount ; //促销商品
    NSMutableArray *goods_class ; //商品顶级分类
    NSMutableArray *recommend_adv_goods ;//第二个推荐广告商品
//    NSMutableArray *def ; //第一个顶级下的默认数据
//    NSMutableArray *goods ; //分类下的商品
    NSMutableArray *special ; //超值特价
    NSMutableArray *superior ; //优品推荐商品
    NSMutableArray *recommend_goods ;//可能感兴趣的商品
    
    
}

-(void)viewDidDisappear:(BOOL)animated{
    
    //关闭定时器
    [_middleMoveTimer setFireDate:[NSDate distantFuture]];
    [_moveTimer setFireDate:[NSDate distantFuture]];
}
-(void)viewWillAppear:(BOOL)animated{
     self.navigationController.navigationBarHidden = YES ;
    if (goods_class.count <= 0) {
        [self loadHomeData];
    }
    if (recommend_goods.count <= 0) {
        [self loadRecommend_goods];
    }
    //开启定时器
    [_moveTimer setFireDate:[NSDate distantPast]];
    [_middleMoveTimer setFireDate:[NSDate distantPast]];
}

- (void)viewDidAppear:(BOOL)animated{
        self.TopView.contentSize = CGSizeMake(self.view.frame.size.width, 1438);
}

- (void)viewWillDisappear:(BOOL)animated{
  self.navigationController.navigationBarHidden = NO ;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    adv = [NSMutableArray arrayWithCapacity:0];
    discount = [NSMutableArray arrayWithCapacity:0];
    goods_class = [NSMutableArray arrayWithCapacity:0];
    recommend_adv_goods = [NSMutableArray arrayWithCapacity:0];
//    def = [NSMutableArray arrayWithCapacity:0];
//    goods = [NSMutableArray arrayWithCapacity:0];
    special = [NSMutableArray arrayWithCapacity:0];
    superior = [NSMutableArray arrayWithCapacity:0];
    recommend_goods = [NSMutableArray arrayWithCapacity:0];

    
//    [self loadHomeData];
//    [self loadRecommend_goods];
    
    self.view.backgroundColor = RGBCOLOR(241, 245, 246);
    
    
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:homeCollectionCellID];

    //创建滚动视图
    [self createScrollView];
    [self loadPage];
    [_TopView bringSubviewToFront:_searchView];
    
    
    //创建中间滚动视图
    [self createMiddleScrollView];
    
    [self middleLoadPage];
    
    //超级特价tableView
    [self createSpecialTableView];
    
    [GHControl setExtraCellLineHidden:bestGoodsTab];
    
}
- (void)loadHomeData{
    if (![GHControl isExistNetwork]) {
        HUDNormal(@"服务器无响应，请稍后重试");
        return;
    }
    RequestCenter *request = [RequestCenter shareRequestCenter];
    [request sendRequestPostUrl:HOME_INDEX andDic:nil setSuccessBlock:^(NSDictionary *resultDic) {
        if ([resultDic[@"code"] intValue] != 1) {
            BG_LOGIN ;
            return ;
        }
        if ([[resultDic objectForKey:@"code"] intValue] == 1) {
            // 成功获取数据
            NSDictionary *dataDic = [resultDic objectForKey:@"data"];
            
            
            for (NSDictionary *dic in [dataDic objectForKey:@"adv"]) {
                HomeModel *model = [[HomeModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [adv addObject:model];
            }
            for (NSDictionary *dic in [dataDic objectForKey:@"discount"]) {
                HomeModel *model = [[HomeModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [discount addObject:model];
            }
            for (NSDictionary *dic in [dataDic objectForKey:@"goods_class"]) {
                HomeModel *model = [[HomeModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [goods_class addObject:model];
            }
            for (NSDictionary *dic in [dataDic objectForKey:@"recommend_adv_goods"]) {
                HomeModel *model = [[HomeModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [recommend_adv_goods addObject:model];
            }
            for (NSDictionary *dic in [dataDic objectForKey:@"special"]) {
                HomeModel *model = [[HomeModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [special addObject:model];
            }
            for (NSDictionary *dic in [dataDic objectForKey:@"superior"]) {
                HomeModel *model = [[HomeModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [superior addObject:model];
            }
            [self refreshView];
            
        }else{
            //获取数据失败
        }
    } setFailBlock:^(NSString *errorStr) {
        
    }];
    
    if (superior.count==0) {
        bestGoodsView.hidden = YES;
    }
    
    bestGoodsView.frame = CGRectMake(0, 959, M_WIDTH, superior.count*96); //  superior.count*96;
    bestGoodsTab.frame = CGRectMake(0, 959, M_WIDTH, superior.count*96);
    
    bestGoodsViewHeight.constant = superior.count*96;
    
    
    
    
}
#pragma mark 刷新
- (void)refreshView{

    //TODO: 滚动视图1    
    if (adv.count>0) {
        [_imageArray removeAllObjects];
    }

    
    for (HomeModel *model in adv) {
        int i = 0 ;
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, M_WIDTH, _TopScrollView.frame.size.height)];
        
//        [imageView sd_setImageWithURL:[NSURL URLWithString:model.adv_image] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"火影%d",i+1]]];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.adv_image] placeholderImage:[UIImage imageNamed:@"乐县域logo-2"]];
        i ++ ;
        [_imageArray addObject:imageView];
    }
     //TODO: 滚动视图2
    if (recommend_adv_goods.count>0) {
        [_middleImageArray removeAllObjects];
    }
    for (HomeModel *model in recommend_adv_goods) {
        int i = 0 ;
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, M_WIDTH, _middleScrollView.frame.size.height)];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.goods_image] placeholderImage:[UIImage imageNamed:@"乐县域logo-2"]];
        i ++ ;
        [_middleImageArray addObject:imageView];
    }
    //分类
    for (int i = 1100 ; i < 1108 ; i ++) {
        UILabel *label = [self.goods_classView viewWithTag:i];
        UIImageView *imageView = [self.goods_classView viewWithTag:i+100];
        if (goods_class.count + 1100 > i) {
            HomeModel *model = goods_class[i - 1100];
            label.text = model.gc_name ;
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.gc_image] placeholderImage:[UIImage imageNamed:@"1.png"]];
        }
    }
    //超值特价 special
    [_specialTableView reloadData];
    //促销商品 discount
    for (int i = 0 ; i < 4; i++) {
        if (i >= discount.count) {
            break ;
        }
        HomeModel *model = discount[i];
        if (i == 0) {
            UILabel *jingle = [self.view viewWithTag:3500 + i];
            jingle.text = model.goods_jingle ;
        }
        UIImageView *imageView = [self.view viewWithTag:3100+i];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.goods_image] placeholderImage:[UIImage imageNamed:@""]];
        
        UILabel *name_label = [self.view viewWithTag:3200 +i];
        name_label.text = model.goods_name ;
        
        UILabel *price_label = [self.view viewWithTag:3300 +i];
        price_label.text = model.goods_price ;
        
    }
    //优品推荐 superior
    [bestGoodsTab reloadData];
   
    //可能感兴趣商品  _collectionView (走接口)
    
    
    
}
#pragma mark - 可能感兴趣的商品
- (void)loadRecommend_goods{
    if (![GHControl isExistNetwork]) {
        HUDNormal(@"服务器无响应，请稍后重试");
        return;
    }
    RequestCenter *requestCenter = [RequestCenter shareRequestCenter];
    NSDictionary *postDic = @{@"buyer_id":[[SaveInfo shareSaveInfo] user_id],@"page":@"1",@"page_num":@"10"};
    [requestCenter sendRequestPostUrl:RECOMMEND_GOODS andDic:postDic setSuccessBlock:^(NSDictionary *resultDic) {

        if ([resultDic[@"code"] intValue] != 1) {
            BG_LOGIN ;
            return ;
        }
        NSDictionary *data = resultDic[@"data"];
        NSArray *recommendgoods = data[@"recommend_goods"];
        for (NSDictionary *dic in recommendgoods) {
            HomeModel *model = [[HomeModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [recommend_goods addObject:model];
        }
        [_collectionView reloadData];
        
        
    } setFailBlock:^(NSString *errorStr) {
        
    }];
}

//创建specialTableView
-(void)createSpecialTableView{
    /**
     specialView
     */
    _specialTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,107,M_WIDTH) style:UITableViewStylePlain];
    _specialTableView.delegate = self;
    _specialTableView.dataSource = self;
    _specialTableView.tag = 30000;
    _specialTableView.center = CGPointMake(M_WIDTH/ 2, specialView.frame.size.height / 2);
    //逆时针旋转90°
    _specialTableView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
    _specialTableView.showsVerticalScrollIndicator = NO;

    [GHControl setExtraCellLineHidden:_specialTableView];
    [specialView addSubview:_specialTableView];
}

-(void)createScrollView{
    _TopScrollView.contentSize = CGSizeMake(M_WIDTH*3,_TopScrollView.frame.size.height);
    //一页的大小应该是frame的大小
    _TopScrollView.pagingEnabled = YES;
    _TopScrollView.delegate = self;
    _TopScrollView.showsHorizontalScrollIndicator = NO;
    _TopScrollView.showsVerticalScrollIndicator = NO;
    
    _TopScrollView.tag = 10001;
    [_TopScrollView setContentOffset:CGPointMake(M_WIDTH, 0)];
    
    _currentIndex = 0;
    _imageArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    
    for (int i =0; i<5; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, M_WIDTH, _TopScrollView.frame.size.height)];
        imageView.image = [UIImage imageNamed:@"乐县域logo-2"];
        
//        UIImagev *image = [UIImage imageNamed:[NSString stringWithFormat:@"火影%d",i+1]];
        
        [_imageArray addObject:imageView];
        
    }
    /******************************时间自动滚动******************************/
    _moveTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(animalMoveImage) userInfo:nil repeats:YES];
    _isTimerUp = NO;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [_TopScrollView addGestureRecognizer:tap];
    
}
-(void)createMiddleScrollView{

    _middleScrollView.contentSize = CGSizeMake(M_WIDTH*3,_middleScrollView.frame.size.height);
    //一页的大小应该是frame的大小
    _middleScrollView.pagingEnabled = YES;
    _middleScrollView.delegate = self;
    _middleScrollView.showsHorizontalScrollIndicator = NO;
    _middleScrollView.showsVerticalScrollIndicator = NO;
    
    _middleScrollView.tag = 10002;
    [_middleScrollView setContentOffset:CGPointMake(M_WIDTH, 0)];
    
    _middleIndex = 0;
    _middleImageArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    
    for (int i =0; i<5; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, M_WIDTH, _TopScrollView.frame.size.height)];
        imageView.image = [UIImage imageNamed:@"乐县域logo-2"];
        
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"火影%d",i+1]];
        
        [_middleImageArray addObject:imageView];
        
    }
    /******************************时间自动滚动******************************/
    _middleMoveTimer = [NSTimer scheduledTimerWithTimeInterval:3.5 target:self selector:@selector(middleScrollViewAnimalMoveImage) userInfo:nil repeats:YES];
    _middleIsTimerUp = NO;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(middleTapClick:)];
    [_middleScrollView addGestureRecognizer:tap];
    
}
#pragma mark----UIScrollView
-(void)loadPage{
    
    //清空当前已有的imageView
    
    for (UIView *view in [self.view viewWithTag:10001].subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    UIImageView *currentImageView= [[UIImageView alloc]init];
    UIImageView *nextImageView= [[UIImageView alloc]init];
    UIImageView *preImageView= [[UIImageView alloc]init];
    //当前页
    currentImageView = [_imageArray objectAtIndex:_currentIndex];
    currentImageView.frame = CGRectMake(M_WIDTH, 0, M_WIDTH, _TopScrollView.frame.size.height);
    
    [[self.view viewWithTag:10001]addSubview:currentImageView];
    //右侧
    
    nextImageView = [_imageArray objectAtIndex:_currentIndex+1<_imageArray.count?_currentIndex+1:0];
    nextImageView.frame = CGRectMake(M_WIDTH*2, 0, M_WIDTH, _TopScrollView.frame.size.height);
    
    [[self.view viewWithTag:10001]addSubview:nextImageView];
    
    //左侧页
    preImageView = [_imageArray objectAtIndex:_currentIndex-1<0?_imageArray.count-1:_currentIndex-1];
    preImageView.frame = CGRectMake(0, 0, M_WIDTH, _TopScrollView.frame.size.height);
    
    [[self.view viewWithTag:10001]addSubview:preImageView];
    
}
-(void)middleLoadPage{

    //清空当前已有的imageView
    
    for (UIView *view in [self.view viewWithTag:10002].subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    UIImageView *currentImageView= [[UIImageView alloc]init];
    UIImageView *nextImageView= [[UIImageView alloc]init];
    UIImageView *preImageView= [[UIImageView alloc]init];
    //当前页
    currentImageView = [_middleImageArray objectAtIndex:_middleIndex];
  
    currentImageView.frame = CGRectMake(M_WIDTH, 0, M_WIDTH, _middleScrollView.frame.size.height);
    
    [[self.view viewWithTag:10002]addSubview:currentImageView];
    //右侧
    
    nextImageView = [_middleImageArray objectAtIndex:_middleIndex+1<_middleImageArray.count?_middleIndex+1:0];
    nextImageView.frame = CGRectMake(M_WIDTH*2, 0, M_WIDTH, _middleScrollView.frame.size.height);
    
    [[self.view viewWithTag:10002]addSubview:nextImageView];
    
    
    //左侧页
    preImageView = [_middleImageArray objectAtIndex:_middleIndex-1<0?_middleImageArray.count-1:_middleIndex-1];
    preImageView.frame = CGRectMake(0, 0, M_WIDTH, _middleScrollView.frame.size.height);
    
    [[self.view viewWithTag:10002]addSubview:preImageView];
    
}


//减速结束时调用
#pragma mark scrollViewDelegate
//上拉加载更多
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (recommend_goods.count > 0) {
        return ;
    }
    float offset=scrollView.contentOffset.y;
    float contentHeight=scrollView.contentSize.height;
    float sub=contentHeight-offset;

    if ((scrollView.frame.size.height-sub)>20) {//如果上拉距离超过20p，则加载更多数据
        [self loadRecommend_goods];
        if (recommend_goods.count <= 0) {
//            HUDNormal(@"暂时没有信息...");
            return ;
        }
        //[self loadMoreData];//此处在view底部加载更多数据
    }
}


- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (recommend_goods.count <= 0) {
         scrollView.contentSize = CGSizeMake(M_WIDTH, 1438-471+superior.count*96);
        return ;
    }
    
    
    CGFloat num = (float)recommend_goods.count/2;
    int allNum= (int)recommend_goods.count/2;
    if (num > recommend_goods.count/2) {
        ++allNum;
    }
    NSLog(@"scrollView.contentSize.height:%f",scrollView.contentSize.height);
    if (scrollView.contentSize.height > 1400) {

    scrollView.contentSize = CGSizeMake(M_WIDTH, 1460+allNum*(M_WIDTH/2+15)-471+superior.count*96);
    
    }
        
}

- (BOOL)prefersStatusBarHidden
{
    return YES; //返回NO表示要显示，返回YES将hiden
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.tag == 10001) {
        int index = (float)scrollView.contentOffset.x/M_WIDTH;
//        NSLog(@"scrollView.tag == 100");
        if (index==0) {
            //向左翻页
            _currentIndex = _currentIndex - 1<0?(int)_imageArray.count - 1:_currentIndex - 1;
            [self loadPage];
            [scrollView setContentOffset:CGPointMake(M_WIDTH, 0)];
            
        }else if (index==2){
            
            //向右翻页
            
            _currentIndex = _currentIndex+1==_imageArray.count?0:_currentIndex+1;
            
            [self loadPage];
            [scrollView setContentOffset:CGPointMake(M_WIDTH, 0)];
            
            
        }else{
            
            NSLog(@"没有翻页不做任何改变");
            if (!_isTimerUp) {
                [_moveTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:3]];
            }
            
            _isTimerUp = NO;
            
        }

    }
    if (scrollView.tag == 10002) {
//        NSLog(@"scrollView.tag == 10002");
        int index = (float)scrollView.contentOffset.x/M_WIDTH;
        if (index==0) {
            //向左翻页
            _middleIndex = _middleIndex - 1<0?(int)_middleImageArray.count - 1:_middleIndex - 1;
            [self middleLoadPage];
            [scrollView setContentOffset:CGPointMake(M_WIDTH, 0)];
            
        }else if (index==2){
            
            //向右翻页
            _middleIndex = _middleIndex+1==_middleImageArray.count?0:_middleIndex+1;
            
            [self middleLoadPage];
            [scrollView setContentOffset:CGPointMake(M_WIDTH, 0)];
            
        }else{
            NSLog(@"没有翻页不做任何改变");
            if (!_middleIsTimerUp) {
                [_middleMoveTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:3]];
            }
            
            _middleIsTimerUp = NO;
        }

    }
    
    
    
    
    
}


#pragma mark - 自动滚动的方法
- (void)animalMoveImage{
        
        _isTimerUp = YES;
    
    [UIView animateWithDuration:0.5 animations:^{
        _TopScrollView.contentOffset = CGPointMake(2 *M_WIDTH, 0);//调用右侧页
        
    }];
    [self scrollViewDidEndDecelerating:_TopScrollView];
        
}

-(void)middleScrollViewAnimalMoveImage{

    _middleIsTimerUp = YES;
    
    [UIView animateWithDuration:0.7 animations:^{
        _middleScrollView.contentOffset = CGPointMake(2 *M_WIDTH, 0);//调用右侧页
        
    }];
    [self scrollViewDidEndDecelerating:_middleScrollView];
    
}

#pragma mark - 手势方法
- (void)tapClick:(UITapGestureRecognizer *)tap{
    //_currentIndex记录点击的是第几个
    NSLog(@"Top :%d",_currentIndex);
    
}
-(void)middleTapClick:(UITapGestureRecognizer *)tap{
   // _middleIndex  记录点击的是第几个
    NSLog(@"milld :%d",_middleIndex);
}

#pragma mark - tab delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [UIView animateWithDuration:0.3f
                     animations:^{
                         [tableView deselectRowAtIndexPath:indexPath animated:YES];
                     }];
    ShopingDetailsVC *shoppingDetailsVC = [[ShopingDetailsVC alloc]init];
    HomeModel *model ;
    if (tableView.tag==30000) {
        //超值特价
     model = special[indexPath.row];
  
    }else{
        // 4000 优品推荐
        model = superior[indexPath.row];
    }
    shoppingDetailsVC.goods_commonid = model.goods_id ;
    shoppingDetailsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shoppingDetailsVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==4000) {
        return 96;
    }
    if (tableView.tag==30000) {
        return M_WIDTH/2;
    }
    return 150;
}

#pragma mark tab dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag==4000) {
      return superior.count;
    }
    if (tableView.tag==30000) {
        return special.count;
    }
    return 0 ;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==30000) {
        //超值特价
        static NSString *cellName = @"SpecitalViewTableViewCell";
        SpecitalViewTableViewCell *cell =
        (SpecitalViewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:cellName owner:self options:nil] firstObject];
            
        }
        // cell顺时针旋转90度
        cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
        HomeModel *model = special[indexPath.row];
        [cell configWithHomeModel:model];
        return cell;
    }
    // 4000 优品推荐
    NSString *idertifier = @"BESTGOODSCELL" ;
    BestGoodsCell *testCell = [tableView dequeueReusableCellWithIdentifier:idertifier];
    if (testCell == nil) {
        UINib *nib = [UINib nibWithNibName:@"BestGoodsCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:idertifier];
        testCell = [tableView dequeueReusableCellWithIdentifier:idertifier];
    }
    HomeModel *model = superior[indexPath.row];
    [testCell configWithHomemodel:model];
    testCell.selectionStyle = UITableViewCellSelectionStyleNone ;
    return testCell ;
   
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 ;
}

#pragma mark - Collection Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [UIView animateWithDuration:0.3f
                     animations:^{
                         [collectionView deselectItemAtIndexPath:indexPath animated:YES];
                     }];
    ShopingDetailsVC *shoppingDetailsVC = [[ShopingDetailsVC alloc]init];
    HomeModel *model = recommend_goods[indexPath.row];
    shoppingDetailsVC.goods_commonid = model.goods_id ;
    shoppingDetailsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shoppingDetailsVC animated:YES];
}
//这个collectionview 是否可选择
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES ;
}
#pragma mark - Collection DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return recommend_goods.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeCollectionViewCell *homeCollectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:homeCollectionCellID forIndexPath:indexPath];
    HomeModel *moel = recommend_goods[indexPath.row];
    [homeCollectionViewCell configWithHomemodel:moel];
    return homeCollectionViewCell ;
}
//定义section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
#pragma mark - Collection DelegateFlowLayout
//定义每个UICollectionview的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(M_WIDTH*0.5 - 10, M_WIDTH*0.5);
}

//定义每个UICollectionView 的 margin //设置左右上下的边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}



#pragma mark - TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
//    [self gotoSearchVC];
    return YES;
}
- (void)gotoSearchVC{
    CompositeVC *compositeVC = [[CompositeVC alloc] init];
    compositeVC.hidesBottomBarWhenPushed = YES ;
    if (self.searchTextField.text.length > 0) {
        compositeVC.goods_name = self.searchTextField.text ;
    }
    [self.navigationController pushViewController:compositeVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (IBAction)gotoController:(UIControl *)sender {
    if (sender.tag - 1000 >= goods_class.count) {
        return ;
    }
    
    HomeModel *model = goods_class[sender.tag - 1000];

    CompositeVC *compositeVC = [[CompositeVC alloc] init];
    compositeVC.hidesBottomBarWhenPushed = YES ;
    compositeVC.gc_id = model.gc_id ;
    [self.navigationController pushViewController:compositeVC animated:YES];
    
}

- (IBAction)gotoGoodsDetails:(UIControl *)sender {
    if (sender.tag - 3000 >= discount.count) {
        return ;
    }
    //  3000 促销商品
    ShopingDetailsVC *shoppingDetailsVC = [[ShopingDetailsVC alloc]init];
    HomeModel *model = discount[sender.tag - 3000];
    shoppingDetailsVC.goods_commonid = model.goods_id ;
    shoppingDetailsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shoppingDetailsVC animated:YES];
}

- (IBAction)searchButClick:(UIControl *)sender {
    [self gotoSearchVC];
}


@end
