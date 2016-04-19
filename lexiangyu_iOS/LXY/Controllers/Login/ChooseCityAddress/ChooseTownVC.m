//
//  ChooseTownVC.m
//  LXY
//
//  Created by guohui on 16/3/29.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "ChooseTownVC.h"
#import "RequestCenter.h"
#import "CityNameModel.h"
#import "ChooseCityTableViewCell.h"
#import "ChooseVillageVC.h"
#import "GHControl.h"
@interface ChooseTownVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *provinceTableView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation ChooseTownVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"乡/镇" ;
    _dataArray = [NSMutableArray array];
    [self createTableView];
    [self sendRequestData];
}

-(void)sendRequestData{
    
    RequestCenter * request = [RequestCenter shareRequestCenter];
    NSDictionary *postDic = @{@"parent_id":_townId,
                              @"region":@"town",
                              };
    
    [request sendRequestPostUrl:GET_CITY_ADDRESS andDic:postDic setSuccessBlock:^(NSDictionary *resultDic) {
//        HUDNormal(@"获取数据成功");
        GLOG(@"---------post:", resultDic);
        if ([resultDic[@"code"] intValue]==0) {
            HUDNormal(@"数据请求失败，请稍后再试");
            return ;
        }
        NSArray *array = resultDic[@"data"];
        
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
    _provinceTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,M_WIDTH , M_HEIGHT) style:UITableViewStylePlain];
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
    CityNameModel  *model = _dataArray[indexPath.row];
    cell.cityName.text =model.town_name;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",_dataArray[indexPath.row]);
    CityNameModel *model = _dataArray[indexPath.row];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:model.town_name forKey:@"town_name"];
    [defaults setObject:model.town_id forKey:@"town_id"];
    
    
    
    NSString *allStr = [NSString stringWithFormat:@"%@%@",_townStr,model.town_name];
    
    ChooseVillageVC *chooseVillageVC = [[ChooseVillageVC alloc]init];
    chooseVillageVC.villageStr = allStr;
    chooseVillageVC.villageId = model.town_id;
    chooseVillageVC.receiveAddressClick = _receiveAddressClick;
    [self.navigationController pushViewController:chooseVillageVC animated:YES];
    
    
//    if (_receiveAddressClick) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveAddressCityName" object:self userInfo:@{@"receiveAddressCityName":allStr}];
//    }else{
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"cityName" object:self userInfo:@{@"cityName":allStr}];
//    }
//    
//    NSMutableArray *viewsArray = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
//    [self.navigationController popToViewController:[viewsArray objectAtIndex:1] animated:YES];
    
}
@end
