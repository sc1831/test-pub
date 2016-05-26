//
//  CountyVC.m
//  LXY
//
//  Created by guohui on 16/3/15.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "CountyVC.h"
#import "Common.h"
#import "ChooseCityTableViewCell.h"
#import "RequestCenter.h"
#import "CityNameModel.h"
#import "ChooseTownVC.h"
#import "GHControl.h"

@interface CountyVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *provinceTableView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation CountyVC
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"县/区" ;
    _dataArray = [NSMutableArray array];

    [self createTableView];
    [self sendRequestData];
}

-(void)sendRequestData{
    
    
    if (![GHControl isExistNetwork]) {
        HUDNormal(@"服务器无响应，请稍后重试");

        return;
    }
    
    RequestCenter * request = [RequestCenter shareRequestCenter];
    NSDictionary *postDic = @{@"parent_id":_cityId,
                              @"region":@"county",
                              };
    
    [request sendRequestPostUrl:GET_CITY_ADDRESS andDic:postDic setSuccessBlock:^(NSDictionary *resultDic) {

        if ([resultDic[@"code"] intValue] != 1) {
            BG_LOGIN ;
            return ;
        }
        
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
    _provinceTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64,M_WIDTH , M_HEIGHT-64) style:UITableViewStylePlain];
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
    
    
    cell.cityName.text =model.county_name;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     CELLSELECTANIMATE ;
    NSLog(@"%@",_dataArray[indexPath.row]);
    CityNameModel *model = _dataArray[indexPath.row];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:model.county_name forKey:@"county_name"];
    [defaults setObject:model.county_id forKey:@"county_id"];
    
    
    
    
    
    
    NSString *allStr = [NSString stringWithFormat:@"%@%@",_provinceStr,model.county_name];
    
    ChooseTownVC *chooseTownVC = [[ChooseTownVC alloc]init];
    chooseTownVC.townStr = allStr;
    chooseTownVC.townId = model.county_id;
    chooseTownVC.receiveAddressClick = _isReceiveAddressClick;
    [self.navigationController pushViewController:chooseTownVC animated:YES];
    
    if (_isReceiveAddressClick) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveAddressCityName" object:self userInfo:@{@"receiveAddressCityName":allStr}];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"cityName" object:self userInfo:@{@"cityName":allStr}];
    }
    

//    NSMutableArray *viewsArray = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
//    [self.navigationController popToViewController:[viewsArray objectAtIndex:1] animated:YES];
    
}

@end
