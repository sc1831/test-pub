//
//  ChooseVillageVC.m
//  LXY
//
//  Created by guohui on 16/3/29.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "ChooseVillageVC.h"
#import "RequestCenter.h"
#import "CityNameModel.h"
#import "ChooseCityTableViewCell.h"
#import "GHControl.h"

@interface ChooseVillageVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *provinceTableView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation ChooseVillageVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"村" ;
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
    NSDictionary *postDic = @{@"parent_id":_villageId,
                              @"region":@"village",
                              };
    
    [request sendRequestPostUrl:GET_CITY_ADDRESS andDic:postDic setSuccessBlock:^(NSDictionary *resultDic) {
        if ([resultDic[@"code"] intValue] != 1) {
            BG_LOGIN ;
            return ;
        }
//        HUDNormal(@"获取数据成功");
        if ([resultDic[@"code"] intValue]==0) {
            HUDNormal(@"数据请求失败，请稍后再试");
            return ;
        }
        GLOG(@"---------post:", resultDic);
        
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
    _provinceTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64,M_WIDTH , M_HEIGHT) style:UITableViewStylePlain];
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
    cell.cityName.text =model.village_name;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [UIView animateWithDuration:0.3f
                     animations:^{
                         [tableView deselectRowAtIndexPath:indexPath animated:YES];
                     }];
    NSLog(@"%@",_dataArray[indexPath.row]);
    CityNameModel *model = _dataArray[indexPath.row];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:model.village_name forKey:@"village_name"];
    [defaults setObject:model.village_id forKey:@"village_id"];
    
    
    NSString *allStr = [NSString stringWithFormat:@"%@  %@",_villageStr,model.village_name];
    
        if (_receiveAddressClick) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveAddressCityName" object:self userInfo:@{@"receiveAddressCityName":allStr}];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"cityName" object:self userInfo:@{@"cityName":allStr}];
        }

    NSUserDefaults *define = [NSUserDefaults standardUserDefaults];
   NSString *str =  [define objectForKey:@"isNewPhone"];
    if ([str isEqualToString:@"1"]||[str isEqualToString:@"2"]) {
        NSMutableArray *viewsArray = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
        [self.navigationController popToViewController:[viewsArray objectAtIndex:2] animated:YES];
    }else if ([str isEqualToString:@"3"]){
    
        NSMutableArray *viewsArray = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
        [self.navigationController popToViewController:[viewsArray objectAtIndex:3] animated:YES];
    }
    else {
    
        NSMutableArray *viewsArray = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
        [self.navigationController popToViewController:[viewsArray objectAtIndex:1] animated:YES];
        
    }
    
    
    
}
@end
