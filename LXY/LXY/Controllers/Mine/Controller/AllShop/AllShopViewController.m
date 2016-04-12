//
//  AllShopViewController.m
//  LXY
//
//  Created by guohui on 16/3/23.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "AllShopViewController.h"
#import "Common.h"
#import "GHControl.h"
#import "AllShopVC.h"


#import "WaitPayFirstViewController.h"
#import "WaitSendVC.h"
#import "WaitGetVC.h"

@interface AllShopViewController ()<UIScrollViewDelegate>
@property (nonatomic ,strong)NSMutableArray *dataArray;
@property (nonatomic ,strong)UIView *headView;
@property (nonatomic ,strong)UIView *lineView;
@property (nonatomic ,strong)UIScrollView *allShopScrollView;

@property (nonatomic ,strong)AllShopVC *allShopVC;
@property (nonatomic ,strong)WaitPayFirstViewController *allWaitePayVC;
@property (nonatomic ,strong)WaitGetVC *allWaiteGetVC;
@property (nonatomic ,strong)WaitSendVC *allWaiteEvaluationVC;

@end

@implementation AllShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"全部订单";
    self.view.backgroundColor = RGBCOLOR(219, 223, 224);;
    _dataArray = [NSMutableArray arrayWithObjects:@"全部",@"待付款",@"待发货",@"待收货",nil];

    [self createHeadView];
    [self createScrollView];
    [self addChildViewVC];
    

}
-(void)createScrollView{
    _allShopScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _headView.frame.origin.y+30, M_WIDTH, M_HEIGHT-_headView.frame.origin.y-30+10)];
    _allShopScrollView.delegate = self;
    _allShopScrollView.pagingEnabled = YES;
 
    _allShopScrollView.contentSize = CGSizeMake(M_WIDTH * _dataArray.count, _allShopScrollView.frame.size.height);
    [self.view addSubview:_allShopScrollView];
    
}
- (void)createHeadView {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0,64, M_WIDTH,30)];
        _headView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_headView];
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(18,28, (M_WIDTH - 120)/4,2)];
        _lineView.backgroundColor = RGBCOLOR(247, 92, 32);
        [_headView addSubview:_lineView];
        for (int i = 0; i < _dataArray.count; i++) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(i*(M_WIDTH/_dataArray.count),0, M_WIDTH/_dataArray.count,27);
            button.tag = 1000+i;
            [button setTitle:[NSString stringWithFormat:@"%@",_dataArray[i]] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor:RGBCOLOR(247, 92, 32) forState:UIControlStateSelected];
            button.titleLabel.font = [UIFont systemFontOfSize:13];;
            [button addTarget:self action:@selector(chooseLianZiType:) forControlEvents:UIControlEventTouchUpInside];
            [_headView addSubview:button];
            
            

            if (i==0) {
                button.selected = YES;
                _lineView.frame = CGRectMake(M_WIDTH/_dataArray.count*(button.tag-1000)+18, 28, (M_WIDTH - 120)/_dataArray.count, 2);
                
            }
            
        }
}
-(void)addChildViewVC{
    for (int i = 0; i<4; i++) {
        if (i==0) {
            _allShopVC = [[AllShopVC alloc]init];
            [self addChildViewController:_allShopVC];
            _allShopVC.view.frame = CGRectMake(i*M_WIDTH,0, M_WIDTH,_allShopScrollView.frame.size.height);
            [_allShopScrollView addSubview:self.allShopVC.view];
        }else if (i==1){
            _allWaitePayVC = [[WaitPayFirstViewController alloc]init];
            [self addChildViewController:_allWaitePayVC];
            _allWaitePayVC.view.frame = CGRectMake(i*M_WIDTH,0, M_WIDTH,_allShopScrollView.frame.size.height);
            [_allShopScrollView addSubview:self.allWaitePayVC.view];
        
        }else if(i==2){
            _allWaiteEvaluationVC = [[WaitSendVC alloc]init];
            [self addChildViewController:_allWaiteEvaluationVC];
            _allWaiteEvaluationVC.view.frame = CGRectMake(i*M_WIDTH,0, M_WIDTH,_allShopScrollView.frame.size.height);
            [_allShopScrollView addSubview:self.allWaiteEvaluationVC.view];
        
        }else{
            _allWaiteGetVC = [[WaitGetVC alloc]init];
            [self addChildViewController:_allWaiteGetVC];
            _allWaiteGetVC.view.frame = CGRectMake(i*M_WIDTH,0, M_WIDTH,_allShopScrollView.frame.size.height);
            [_allShopScrollView addSubview:self.allWaiteGetVC.view];
            
        }
    }
    
    
}
-(void)chooseLianZiType:(UIButton *)btn{
    
    
    int i =(int) btn.tag-1000;
    switch (btn.tag) {
        case 1000:
        {
            
            [_allShopScrollView setContentOffset:(CGPointMake)(i*M_WIDTH, 0) animated:YES];
        
        }
            break;
        case 1001:
        {
           
            [_allShopScrollView setContentOffset:(CGPointMake)(i*M_WIDTH, 0) animated:YES];

        }
            break;
        case 1002:
        {
            
            [_allShopScrollView setContentOffset:(CGPointMake)(i*M_WIDTH, 0) animated:YES];
            
        }
            break;
        case 1003:
        {
            
            [_allShopScrollView setContentOffset:(CGPointMake)(i*M_WIDTH, 0) animated:YES];
            
        }
            break;
            
        default:
            break;
    }
}
#pragma mark -- UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
        for(UIView *view in _headView.subviews)
        {
            if([view isKindOfClass:[UIButton class]])
            {
                if(((UIButton *)view).tag ==(int)(1000 +scrollView.contentOffset.x / M_WIDTH)){
                    ((UIButton *)view).selected = YES;
                    [((UIButton *)view) setTitleColor:UIColorFromRGB(0x008cff) forState:UIControlStateNormal];
                }else{
                    ((UIButton *)view).selected = NO;
                    [((UIButton *)view) setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                }
            }
        }
    _lineView.frame = CGRectMake(scrollView.contentOffset.x / _dataArray.count + 18,28,(M_WIDTH - 120)/_dataArray.count,2);
}

@end
