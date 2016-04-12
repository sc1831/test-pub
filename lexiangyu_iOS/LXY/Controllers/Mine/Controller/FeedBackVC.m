//
//  FeedBackVC.m
//  LXY
//
//  Created by guohui on 16/3/16.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "FeedBackVC.h"
#import "RequestCenter.h"
#import "UIButton+Block.h"
#import "SaveInfo.h"
#import "FeedBackModel.h"

@interface FeedBackVC ()<UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITextView *funationTextView;
//功能意见
- (IBAction)functionOfOpinion:(id)sender;
@property (nonatomic ,strong)NSMutableArray *dataArray;
@property (nonatomic ,strong)NSString *feedBackStr;
@property (weak, nonatomic) IBOutlet UIButton *keepFeedBackButton;
@end

@implementation FeedBackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈" ;
    _dataArray = [NSMutableArray array];
    
    __weak FeedBackVC *weakSelf = self;
    [_keepFeedBackButton setOnButtonPressedHandler:^{
        FeedBackVC *strongSelf = weakSelf;
        if (strongSelf) {
            if (strongSelf.feedBackStr.length==0) {
                HUDNormal(@"请选择反馈类型");
                return ;
            }else if (_funationTextView.text.length==0){
            
                HUDNormal(@"请填写反馈信息");
                return ;
            }else{
            [strongSelf keepFeedBackInformation];
            }
            
            
        }
    }];
    
}


- (IBAction)functionOfOpinion:(id)sender {
//    NSLog(@"功能意见点击");
    [self sendRequestData];

}
-(void)sendRequestData{
    if (_dataArray.count>0) {
        [_dataArray removeAllObjects];
    }
    RequestCenter * request = [RequestCenter shareRequestCenter];
//    NSDictionary *postDic = @{@"token":[[SaveInfo shareSaveInfo]token],
//                              @"user_id":[[SaveInfo shareSaveInfo]user_id]
//                              };
    
    [request sendRequestPostUrl:MY_FEEDBACK_TYPE andDic:nil setSuccessBlock:^(NSDictionary *resultDic) {
        
        if (resultDic[@"code"]==0) {
            HUDNormal(@"请求失败");
            return ;
        }
        
        NSArray *array = resultDic[@"data"];
        
        for (NSDictionary  *dict in array) {
             FeedBackModel *model = [FeedBackModel modelWithDic:dict];
            [_dataArray addObject:model];
        }
        [self createFeedBackView];
 
    
    } setFailBlock:^(NSString *errorStr) {
        NSLog(@"");
    }];
}

-(void)createFeedBackView{

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    for (int i =0; i<_dataArray.count; i++) {
         FeedBackModel *model = _dataArray[i];
        UIAlertAction *productProblem = [UIAlertAction actionWithTitle:model.type_name style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
            _feedBackStr = model.type_id;
            NSLog(@"_feedBackStr:%@",_feedBackStr);

        }];
       [alertController addAction:productProblem];
    }
    
        // 创建按钮
        // 注意取消按钮只能添加一个
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *action) {
            // 点击按钮后的方法直接在这里面写
            NSLog(@"取消");
        }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];

}

-(void)keepFeedBackInformation{

    RequestCenter * request = [RequestCenter shareRequestCenter];
        NSDictionary *postDic = @{@"user_id":[[SaveInfo shareSaveInfo]user_id],
                                  @"ftype":_feedBackStr,
                                  @"opinion":_funationTextView.text
                                  };
    
    [request sendRequestPostUrl:MY_FEEDBACK_TYPE andDic:postDic setSuccessBlock:^(NSDictionary *resultDic) {
        
        if (resultDic[@"code"]==0) {
            HUDNormal(@"请求失败");
            return ;
        }
        
        [self .navigationController popViewControllerAnimated:YES];
        
    } setFailBlock:^(NSString *errorStr) {
        NSLog(@"");
    }];
}









@end
