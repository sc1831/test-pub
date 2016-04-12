//
//  CountyVC.h
//  LXY
//
//  Created by guohui on 16/3/15.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "ChooseCityVC.h"

@interface CountyVC : RootVC
@property (nonatomic,strong) NSString *provinceStr;
@property (nonatomic,strong) NSString *cityId;
@property (nonatomic)BOOL isReceiveAddressClick;
@end
