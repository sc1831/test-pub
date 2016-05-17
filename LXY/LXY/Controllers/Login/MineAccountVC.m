//
//  MineAccountVC.m
//  LXY
//
//  Created by guohui on 16/3/16.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "MineAccountVC.h"
#import "ChangePhoneNumVC.h"
#import "ChangePasswordVC.h"
#import "RequestCenter.h"
#import "Common.h"
#import "SaveInfo.h"
@interface MineAccountVC ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
//头像图片
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
//账户名
@property (weak, nonatomic) IBOutlet UILabel *accountName;
//超市名称
@property (weak, nonatomic) IBOutlet UILabel *shopName;
//绑定手机号
@property (weak, nonatomic) IBOutlet UILabel *bindPhoneNum;
- (IBAction)loginPasswordClick:(id)sender;

- (IBAction)bindPhoneClick:(id)sender;
- (IBAction)change_user_icon:(id)sender;

@property (nonatomic ,strong)UIBarButtonItem *leftBarButton;
@end

@implementation MineAccountVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([[SaveInfo shareSaveInfo]userImageUrl]) {
        
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:[[SaveInfo shareSaveInfo]userImageUrl]] placeholderImage:[UIImage imageNamed:@"商品默认图"]] ;
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的账户" ;
    _accountName.text = _accountNameStr;
    _shopName.text = _shopNameStr;
    _bindPhoneNum.text =_bindPhoneNumStr;
    
    
//    [_userIcon sd_setImageWithURL:[NSURL URLWithString:[user objectForKey:CUSTOMERPHOTO]] placeholderImage:[UIImage imageNamed:@"userIcon.png"]];
    
    
    _headImageView.layer.cornerRadius = _headImageView.frame.size.width*0.5f ;
    _headImageView.layer.masksToBounds = YES ;
    _headImageView.image = _image;

    
    
}
-(void)leftNavBtnClick:(UIButton *)sender{
    [super leftNavBtnClick:sender];
}



//登录密码
- (IBAction)loginPasswordClick:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    ChangePasswordVC *changePasswordVC = [[ChangePasswordVC alloc]init];
    [self.navigationController pushViewController:changePasswordVC animated:YES];

}

- (IBAction)bindPhoneClick:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    ChangePhoneNumVC *changPhoneVC = [[ChangePhoneNumVC alloc]init];
    changPhoneVC.phoneNumStr = [_bindPhoneNumStr substringFromIndex:_bindPhoneNumStr.length-4];
    changPhoneVC.accountNameStr = _phoneNum;
    [self.navigationController pushViewController:changPhoneVC animated:YES];
    
}

- (IBAction)change_user_icon:(id)sender {
    UIActionSheet *iconImageActionsheet = [[UIActionSheet alloc]initWithTitle:@"选择方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"相册", nil];
    [iconImageActionsheet showInView:self.view];
    
}

#pragma mark - UIAlertViewDelegate -
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    // 0 相机 1相册 2取消
    if (buttonIndex == 2 ) {
        return ;
    }
    //实例化controller
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    //设置代理
    
    picker.delegate = self ;

    if (buttonIndex == 0) {
        //开启相机模式之前判断相机是否可用
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera ;
        }
    }
    [self presentViewController:picker animated:YES completion:nil];
}
#pragma mark - imagepickerDelegate -
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    NSLog(@"info～～～～%@",info);
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSLog(@"\n\nimage%@",image);
    [self dismissViewControllerAnimated:YES completion:nil];
    [[RequestCenter shareRequestCenter]sendRequestImageUrl:UPLOAD_AVATAR andImage:image setSuccessBlock:^(NSDictionary *resultDic) {
        if ([resultDic[@"code"] intValue] != 1) {
            BG_LOGIN ;
            return ;
        }
        HUDNormal(@"头像上传成功");
        
        [[SaveInfo shareSaveInfo]setUserImageUrl:resultDic[@"data"][@"img_path"]];
        _headImageView.image = image ;

        
    } setFailBlock:^(NSString *errorStr) {
        
        HUDNormal(@"头像上传失败");
    }];
    
    
    
}




//点击取消
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"点击取消");
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
