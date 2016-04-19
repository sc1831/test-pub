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
#import "GHControl.h"
@interface FeedBackVC ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *funationTextView;

@property (weak, nonatomic) IBOutlet UIButton *submitFeedbackBtn;

//功能意见
- (IBAction)functionOfOpinion:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLab;
@property (nonatomic ,strong)NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UILabel *classLab;
@property (weak, nonatomic) IBOutlet UILabel *textCountLab;
@property (nonatomic ,strong)NSString *feedBackStr; //反馈类型
//打电话
- (IBAction)makePhoneCall:(id)sender;
@end

@implementation FeedBackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"意见反馈" ;
    _dataArray = [NSMutableArray array];
    
    [_submitFeedbackBtn addTarget:self action:@selector(submitFeedbackBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_submitFeedbackBtn setBackgroundImage:[UIImage imageNamed:@"下一步_置灰"] forState:UIControlStateHighlighted];
}
//提交按钮
-(void)submitFeedbackBtnClick{
    
    [self leaveEditMode];
}

- (IBAction)functionOfOpinion:(id)sender {
    [self sendRequestData];

}
-(void)sendRequestData{
    if (_dataArray.count>0) {
        [_dataArray removeAllObjects];
    }
    RequestCenter * request = [RequestCenter shareRequestCenter];

    [request sendRequestPostUrl:MY_FEEDBACK_TYPE andDic:nil setSuccessBlock:^(NSDictionary *resultDic) {
        
        if ([resultDic[@"code"] intValue]==0) {
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
            _feedBackStr = [model.type_id stringValue];
            NSLog(@"_feedBackStr:%@",_feedBackStr);
            self.classLab.text = model.type_name ;
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
    if (self.funationTextView.text.length < 30) {
        HUDNormal(@"至少五个字");
        return ;
    }else if (self.funationTextView.text.length > 200){
        HUDNormal(@"之多200字评论,您已超限");
        return ;
    }
    RequestCenter * request = [RequestCenter shareRequestCenter];
        NSDictionary *postDic = @{@"user_id":[[SaveInfo shareSaveInfo]user_id],
                                  @"ftype":_feedBackStr,
                                  @"opinion":_funationTextView.text
                                  };
    
    [request sendRequestPostUrl:MY_FEEDBACK_TYPE andDic:postDic setSuccessBlock:^(NSDictionary *resultDic) {
        
        if ([resultDic[@"code"] intValue]==0) {
            HUDNormal(@"请求失败");
            return ;
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } setFailBlock:^(NSString *errorStr) {
        NSLog(@"");
    }];
}
#pragma mark - 代理方法
//通过代理实现文字隐藏
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0 ) {
        _placeholderLab.text = @"请留下您宝贵意见...";
    }else{
        _placeholderLab.text = @"";
        if (_funationTextView.text.length <= 200) {

        }else{
            HUDNormal(@"文字200字以内,您已抄限...");
        }
        NSString *strLength = [NSString stringWithFormat:@"%lu", self.funationTextView.text.length];
        self.textCountLab.text = STR_A_B(strLength, @"/200");
    }
}
//textView 键盘的隐藏 通过添加完成按钮实现
- (void)textViewDidBeginEditing:(UITextView *)textView {
    UIButton *rightNarBtn = [GHControl createButtonWithFrame:CGRectMake(0, 0, 80, 40) ImageName:@"rightBarBtnBg.png" Target:self Action:@selector(leaveEditMode) Title:nil];
    rightNarBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight ;
    [rightNarBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rightNarBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightNarBtn setTitle:@"提交" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightNarBtn];
    
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.navigationItem.rightBarButtonItem = nil;
    
}


//收回键盘
- (void)leaveEditMode {
    [_funationTextView resignFirstResponder];
    //    if (_opinionTextView.text.length > 0) {
    //        [self submitBtnClick:nil];
    //    }
    NSLog(@"确定");
    
    if (self.feedBackStr.length==0) {
        HUDNormal(@"请选择反馈类型");
        return ;
    }else if (_funationTextView.text.length==0){
        
        HUDNormal(@"请填写反馈信息");
        return ;
    }else{
        
        [self keepFeedBackInformation];
    }
}

//打电话
- (IBAction)makePhoneCall:(id)sender {
     [self.view addSubview:[GHControl makeTelPhoneNum]];
}
@end
