//
//  ProvincialCityVC.m
//  LXY
//
//  Created by guohui on 16/3/15.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "ProvincialCityVC.h"
#import "Common.h"
#import "ChooseCityTableViewCell.h"
#import "CountyVC.h"
#import "RequestCenter.h"
#import "CityNameModel.h"
#import "GHControl.h"

@interface ProvincialCityVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *provinceTableView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation ProvincialCityVC
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"市" ;
    _dataArray = [NSMutableArray array];

    [self createTableView];
    [self sendRequestData];
}

-(void)sendRequestData{
   
    RequestCenter * request = [RequestCenter shareRequestCenter];
    NSDictionary *postDic = @{@"parent_id":_provinceId,
                              @"region":@"city",
                              };
    
    [request sendRequestPostUrl:GET_CITY_ADDRESS andDic:postDic setSuccessBlock:^(NSDictionary *resultDic) {
        if ([resultDic[@"code"] intValue] != 1) {
            BG_LOGIN ;
        }

        
        NSArray *array = resultDic[@"data"];
        NSLog(@"array:%@",array);
        if (_dataArray.count>0) {
            [_dataArray removeAllObjects];
        }
        for (NSDictionary *subDic in array) {
            CityNameModel *model = [CityNameModel modelWithDic:subDic];

            [_dataArray addObject:model];
        }
        
        [_provinceTableView reloadData];
    } setFailBlock:^(NSString *errorStr) {
        NSLog(@"");
        
    }];
}
-(void)createTableView{
    _provinceTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,M_WIDTH , M_HEIGHT) style:UITableViewStylePlain];
    _provinceTableView.delegate = self;
    _provinceTableView.dataSource = self;
    [self.view addSubview:_provinceTableView];
    [GHControl setExtraCellLineHidden:_provinceTableView];
    
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
    cell.cityName.text =model.city_name;
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",_dataArray[indexPath.row]);
    CityNameModel *model = _dataArray[indexPath.row];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:model.city_name forKey:@"city_name"];
    [defaults setObject:model.city_id forKey:@"city_id"];
    
    
    
    
    
    CountyVC *countyVC = [[CountyVC alloc]init];
    countyVC.provinceStr = [NSString stringWithFormat:@"%@%@",_provinceStr,model.city_name];
    countyVC.cityId = model.city_id;
    countyVC.isReceiveAddressClick = _receiveAddressClick;
    
    [self.navigationController pushViewController:countyVC animated:YES];
    
}

@end
