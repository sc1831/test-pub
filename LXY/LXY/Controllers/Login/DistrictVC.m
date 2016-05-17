//
//  DistrictVC.m
//  LXY
//
//  Created by guohui on 16/3/15.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "DistrictVC.h"
#import "Common.h"
#import "ChooseCityTableViewCell.h"

@interface DistrictVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *provinceTableView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation DistrictVC
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"县" ;
    
    _dataArray = [NSMutableArray arrayWithObjects:@"北京",@"海南市",@"乌鲁木齐市",@"沈阳市",@"大连市",@"太原市",@"西安市",@"洛阳市",@"郑州市",@"深圳市",@"广州市",@"上海市", nil];
    [self createTableView];
}
-(void)createTableView{
    _provinceTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,M_WIDTH , M_HEIGHT) style:UITableViewStylePlain];
    _provinceTableView.delegate = self;
    _provinceTableView.dataSource = self;
    [self.view addSubview:_provinceTableView];
    
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
    cell.cityName.text =_dataArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     CELLSELECTANIMATE ;
    NSLog(@"%@",_dataArray[indexPath.row]);
    DistrictVC *districtVC = [[DistrictVC alloc]init];
    [self.navigationController pushViewController:districtVC animated:YES];
    
}


@end
