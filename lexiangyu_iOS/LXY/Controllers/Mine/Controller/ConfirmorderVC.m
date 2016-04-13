//
//  ConfirmorderVC.m
//  LXY
//
//  Created by guohui on 16/3/15.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "ConfirmorderVC.h"
#import "CashierDesk.h"
#import "Common.h"

//微信
#import "WXApiRequestHandler.h"
//支付宝
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
//银联
#import "UPPaymentControl.h"
#define kURL_TN_Normal                @"http://101.231.204.84:8091/sim/getacptn"
#define kWaiting          @"正在获取TN,请稍后..."
#define kNote             @"提示"
#define kConfirm          @"确定"
#define kErrorNet         @"网络错误"
#define kResult           @"支付结果：%@"
@interface ConfirmorderVC ()
{
    UIAlertView* _alertView;
    NSMutableData* _responseData;
}
//手机号
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
//收货地址
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
//商品地址
@property (weak, nonatomic) IBOutlet UILabel *shopAddress;
//商品图片
@property (weak, nonatomic) IBOutlet UIImageView *shopImage;
//商品名称
@property (weak, nonatomic) IBOutlet UILabel *shopName;
//价位
@property (weak, nonatomic) IBOutlet UILabel *weightMoney;
//总价位
@property (weak, nonatomic) IBOutlet UILabel *allMoney;
//购买数量
@property (weak, nonatomic) IBOutlet UILabel *number;
//合计
@property (weak, nonatomic) IBOutlet UILabel *combinedMoney;
//商品共计数量
@property (weak, nonatomic) IBOutlet UILabel *allNumber;
//底部商品共计件数
@property (weak, nonatomic) IBOutlet UILabel *bootmAllNum;
//底部商品合计
@property (weak, nonatomic) IBOutlet UILabel *bootmMoney;




//支付方式
- (IBAction)paryMoneyClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIControl *subMitBtn;

- (IBAction)subMitClick:(id)sender;
@end

@implementation ConfirmorderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认订单" ;
    
}


- (IBAction)paryMoneyClick:(id)sender {
    NSLog(@"银联支付");
}
- (IBAction)subMitClick:(id)sender {
    //TODO:微信支付
//    [self bizPay];
//    TODO:支付宝支付
//    [self zhifubao];
    //TODO:银联支付
    [self startNetWithURL:[NSURL URLWithString:kURL_TN_Normal]];
    
    
    
//    CashierDesk *cashVC = [[CashierDesk alloc]init];
//    cashVC.allMoneyStr = _bootmMoney.text;
//    [self.navigationController pushViewController:cashVC animated:YES];
}

//银联
- (void)startNetWithURL:(NSURL *)url
{

    [self showAlertWait];
    
    NSURLRequest * urlRequest=[NSURLRequest requestWithURL:url];
    NSURLConnection* urlConn = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    [urlConn start];
}

#pragma mark - Alert

- (void)showAlertWait
{
    [self hideAlert];
    _alertView = [[UIAlertView alloc] initWithTitle:kWaiting message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [_alertView show];
    UIActivityIndicatorView* aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    aiv.center = CGPointMake(_alertView.frame.size.width / 2.0f - 15, _alertView.frame.size.height / 2.0f + 10 );
    [aiv startAnimating];
    [_alertView addSubview:aiv];
    
}

- (void)showAlertMessage:(NSString*)msg
{
    [self hideAlert];
    _alertView = [[UIAlertView alloc] initWithTitle:kNote message:msg delegate:self cancelButtonTitle:kConfirm otherButtonTitles:nil, nil];
    
}

- (void)hideAlert
{
    if (_alertView != nil)
    {
        [_alertView dismissWithClickedButtonIndex:0 animated:NO];
        _alertView = nil;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    _alertView = nil;
}

#pragma mark - connection

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse*)response
{
    NSHTTPURLResponse* rsp = (NSHTTPURLResponse*)response;
    NSInteger code = [rsp statusCode];
    if (code != 200)
    {
        
        [self showAlertMessage:kErrorNet];
        [connection cancel];
    }
    else
    {
        
        _responseData = [[NSMutableData alloc] init];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self hideAlert];
    NSString* tn = [[NSMutableString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    if (tn != nil && tn.length > 0)
    {
        
        NSLog(@"tn=%@",tn);
        [[UPPaymentControl defaultControl] startPay:tn fromScheme:@"UPPayDemo" mode:@"01" viewController:self];
        
    }
    
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self showAlertMessage:kErrorNet];
}


#pragma mark UPPayPluginResult
- (void)UPPayPluginResult:(NSString *)result
{
    NSString* msg = [NSString stringWithFormat:kResult, result];
    [self showAlertMessage:msg];
}




//微信
- (void)bizPay {
    NSString *res = [WXApiRequestHandler jumpToBizPay];
    if( ![@"" isEqual:res] ){
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"支付失败" message:res delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alter show];
        
    }
    
}
- (void)zhifubao{
    
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"2088611124318021";
    NSString *seller = @"847797605@qq.com";
    NSString *privateKey = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBANm2mCnzymkIV/0WBlSOO/TjAsfQ7FFQgJrZ5k+bSnbo48sXPem6708LusvqtGQnIhKF/8Lag/ezQuOK2eBWRx8zfFb1WTccXmeJTgown2rBcVhUPQKl/8779j937JE2aNSvDA7Ye9FP6/78epLLycMrIfxLY5ox2amvFkypVA4BAgMBAAECgYEAzPkyjdzvZq/qV2dTEmzPWiIYzhOPSodmbWRViAGGvClLvjvlmJbdFCjQ94fDyr9lPtdWExg0QxNNGHnz41iXn7XltRZPLVdTjk+gLNhri9eHtmP3V10+GZvt2lVDqOhiRdg8Pnq8b75a+ru6HQahYkYRB2KOAkmCTJaOp2OuEZkCQQDyCqv2hgu7GWkf+EJ/TP0q5GCsSOKbAnN2coLsXbKNoW7jE25wPTuUSsafRQ+OpXMSkEVqRqykqqsIbLDbXhJHAkEA5kTBX/nlvdIzlG6/Io/9TdiLonyDVXDrZCi5OKlfaPq4MXrJBYc9X4Lg2/tIZz5ymeMnGB9jkSGG2Zk2S1p5dwJAFga6l3ijYKdzVaF2C7ep4lleIs+PL6QNdd395ByyvwjN2oROLJCl91zGrn/OZqDP1ASlDILZ+zI81ktt3Mi2yQJBALF9xeCI60GJySBczQ+DFajvhZJVj5ZIV+j4Su0WAOkWeOwKzPBp8jCw3UozQvfx9rwPj47UgxbXVO5dXrBuqLkCQBhwgsy9e0N7kqPieZSvUdcxzDQM1YZq92gtCbYCRXZowaDo7q/xdlaZSmNTLMOb59gy6pk4wsNXD0nllSkyKkU=";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/

    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.productName = @"商品标题"; //商品标题
    order.productDescription = @"商品描述"; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",0.02]; //商品价格
    order.notifyURL =  @"http://www.xxx.com"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"alisdkdemo";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
    }
}

#pragma mark -
#pragma mark   ==============产生随机订单号==============


- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}


@end
