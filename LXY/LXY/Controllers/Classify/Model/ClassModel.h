//
//  ClassModel.h
//  LXY
//
//  Created by guohui on 16/4/6.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "RootModel.h"

@interface ClassModel : RootModel
@property (nonatomic,copy)NSString *gc_id ;
@property (nonatomic,copy)NSString *gc_name ;
@property (nonatomic,strong)NSArray *def ;
@end
