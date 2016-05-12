//
//  NoNetwork.h
//  LXY
//
//  Created by guohui on 16/5/12.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol NoNetworkDelegate <NSObject>
@optional
//无网络重新加载
- (void)NoNetworkClickDelegate;//1.1定义协议与方法


@end

@interface NoNetwork : UIView
/**代理*/
@property (retain,nonatomic) id <NoNetworkDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *againInternetButton;
- (IBAction)NoNetworkClick:(id)sender;

@end
