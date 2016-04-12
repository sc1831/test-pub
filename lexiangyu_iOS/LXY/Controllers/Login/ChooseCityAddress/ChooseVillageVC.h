//
//  ChooseVillageVC.h
//  LXY
//
//  Created by guohui on 16/3/29.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "ChooseCityVC.h"

@interface ChooseVillageVC : ChooseCityVC
@property (nonatomic,strong) NSString *villageStr;
@property (nonatomic,strong) NSString *villageId;
@property (nonatomic)BOOL receiveAddressClick;
@end
