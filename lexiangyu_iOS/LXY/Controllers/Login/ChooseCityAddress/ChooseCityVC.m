//
//  ChooseCityVC.m
//  LXY
//
//  Created by guohui on 16/3/15.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "ChooseCityVC.h"
#import "ChooseCityTableViewCell.h"
#import "ProvincialCityVC.h"
#import "RequestCenter.h"
#import "CityNameModel.h"
#import "GHControl.h"

@interface ChooseCityVC ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *chooseCitytableView;

@property (nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation ChooseCityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择城市" ;
    _chooseCitytableView.delegate = self;
    _chooseCitytableView.dataSource = self;
    [GHControl setExtraCellLineHidden:_chooseCitytableView];
    _dataArray = [NSMutableArray array];
    [self sendRequestData];

}
-(void)sendRequestData{
    if (![GHControl isExistNetwork]) {
        HUDNormal(@"服务器无响应，请稍后重试");
        return;
    }

  RequestCenter * request = [RequestCenter shareRequestCenter];
    NSDictionary *postDic = @{@"parent_id":@"0",
                              @"region":@"province",
                              
                              };
    
    [request sendRequestPostUrl:GET_CITY_ADDRESS andDic:postDic setSuccessBlock:^(NSDictionary *resultDic) {
//        HUDNormal(@"获取数据成功");

        if ([resultDic[@"code"] intValue] != 1) {
            BG_LOGIN ;
            return ;
        }

        NSArray *array = resultDic[@"data"];
        
        for (NSDictionary *subDic in array) {
            CityNameModel *model = [CityNameModel modelWithDic:subDic];

            [_dataArray addObject:model];
            
            
        }
        
        [_chooseCitytableView reloadData];
    } setFailBlock:^(NSString *errorStr) {

        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"ChooseCityTableViewCell";
    ChooseCityTableViewCell *cell =
    (ChooseCityTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellId owner:self options:nil] firstObject];
    }
    CityNameModel *model = _dataArray[indexPath.row];
    cell.cityName.text =model.province_name;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CityNameModel *model = _dataArray[indexPath.row];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:model.province_name forKey:@"province_name"];
    [defaults setObject:model.province_id forKey:@"province_id"];
    
    
    
    
    ProvincialCityVC *provinceVC = [[ProvincialCityVC alloc]init];
    provinceVC.provinceStr = model.province_name;
    provinceVC.provinceId = model.province_id;
    provinceVC.receiveAddressClick = _isReceiveAddressClick;
    [self.navigationController pushViewController:provinceVC animated:YES];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
