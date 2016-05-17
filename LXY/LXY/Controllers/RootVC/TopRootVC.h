//
//  TopRootVC.h
//  LXY
//
//  Created by guohui on 16/3/14.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoNetwork.h"
@interface TopRootVC : UIViewController<NoNetworkDelegate>
@property (nonatomic ,strong)NoNetwork *noNetworkView;
//无网络重新加载
-(void)NoNetworkClickDelegate;

@end
