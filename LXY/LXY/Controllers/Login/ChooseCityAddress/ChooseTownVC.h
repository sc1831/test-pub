//
//  ChooseTownVC.h
//  LXY
//
//  Created by guohui on 16/3/29.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "ChooseCityVC.h"

@interface ChooseTownVC : ChooseCityVC
@property (nonatomic,strong) NSString *townStr;
@property (nonatomic,strong) NSString *townId;
@property (nonatomic)BOOL receiveAddressClick;
@property (nonatomic) BOOL isAddressClick;
@end
