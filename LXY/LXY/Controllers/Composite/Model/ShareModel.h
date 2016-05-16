//
//  ShareModel.h
//  LXY
//
//  Created by guohui on 16/5/16.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "RootModel.h"

@interface ShareModel : RootModel
@property (nonatomic,copy) NSString *goods_id ;
@property (nonatomic,copy) NSString *goods_image ;
@property (nonatomic,copy) NSString *goods_name ;
@property (nonatomic,copy) NSString *goods_price ;
@property (nonatomic,copy) NSString *share_url ;
@end
