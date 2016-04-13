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
#import "AllGoodsOrders.h"
#import "GHControl.h"
#import "Common.h"
#import "ConfirmTableViewCell.h"
#import "HeadTableView.h"
#import "FooterTableView.h"
#import "SectionFooterView.h"

#import "RequestCenter.h"

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
@interface ConfirmorderVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UIAlertView* _alertView;
    NSMutableData* _responseData;
}

//底部商品共计件数
@property (weak, nonatomic) IBOutlet UILabel *bootmAllNum;
//底部商品合计
@property (weak, nonatomic) IBOutlet UILabel *bootmMoney;


@property (nonatomic ,strong)UITableView *confirmTableView;
@property (nonatomic ,strong)UIView *headView;






@property (weak, nonatomic) IBOutlet UIControl *subMitBtn;

- (IBAction)subMitClick:(id)sender;
@end

@implementation ConfirmorderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认订单" ;

    
    [self createTableView];
    
}
-(void)createTableView{
    
    _confirmTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64, M_WIDTH, M_HEIGHT-64-50) style:UITableViewStyleGrouped];
    _confirmTableView.delegate = self;
    _confirmTableView.dataSource = self;
    _confirmTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_confirmTableView];
    
    //添加表头
    HeadTableView *headTabView =
    [[[NSBundle mainBundle] loadNibNamed:@"HeadTableView"
                                   owner:self
                                 options:nil] firstObject];
    _confirmTableView.tableHeaderView = headTabView;
    
    

    //添加表尾
    FooterTableView *footerTabView =
    [[[NSBundle mainBundle] loadNibNamed:@"FooterTableView"
                                   owner:self
                                 options:nil] firstObject];
    _confirmTableView.tableFooterView = footerTabView;
    
//    AllGoodsOrders *dataModel = _dataArray[indexPath.section];
//    cell.shopMoney.text = [NSString stringWithFormat:@"￥%@",dataModel.order_amount];
    
   
    
    [footerTabView.payType addTarget:self action:@selector(paryMoneyClick) forControlEvents:UIControlEventTouchUpInside];
    
    
//    CGFloat allPrice;
//    CGFloat allNum;
//    for (int i ; i< _mutArray.count; i++) {
//        for (int j = 0; j<[_mutArray[i] count]; j++) {
//            AllGoodsOrders *model = _mutArray[i][j];
//            allPrice += [model.order_amount floatValue];
//            allNum += model.
//        }
//    }
    
    
    
    
    
    headTabView.phoneNumLabel.text = @"1234567890-098765";
    headTabView.addressLabel.text = @"北京市海淀区";
    
}

#pragma mark-----UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [_dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_mutArray[section] count];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    [self createHeadView];
    
    AllGoodsOrders *model = _dataArray[section];
    
    UILabel *label = [GHControl createLabelWithFrame:CGRectMake(45,11,60, 30) Font:14 Text:model.store_name];
    label.textColor = RGBCOLOR(99, 100, 101);
    [_headView addSubview:label];
    
    
    return _headView;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    SectionFooterView *sectionFooterView =
    [[[NSBundle mainBundle] loadNibNamed:@"SectionFooterView"
                                   owner:self
                                 options:nil] firstObject];
    
    NSLog(@"section:%ld",section);
    
    
    AllGoodsOrders *model = _dataArray[section];

    
        CGFloat allNum;
        for (int i = 0 ; i< (int)[_mutArray[section] count]; i++) {
                AllGoodsOrders *model = _mutArray[section][i];

                allNum += [model.goods_num floatValue];

        }
    
    
    sectionFooterView.shopMoeny.text = [NSString stringWithFormat:@"￥%.2lf",[model.order_amount floatValue]];
    sectionFooterView.shopNum.text = [NSString stringWithFormat:@"商品共%.lf件，合计：",allNum];
    return sectionFooterView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 70;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

        static NSString *cellName = @"ConfirmTableViewCell";
        
        ConfirmTableViewCell *cell =
        (ConfirmTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:cellName owner:self options:nil] firstObject];
            
        }
        AllGoodsOrders *model = _mutArray[indexPath.section][indexPath.row];
        cell.shopName.text = model.goods_name;
        cell.shopNum.text = [NSString stringWithFormat:@"X%@",model.goods_num];
        cell.shopMoney.text = [NSString stringWithFormat:@"￥%@",model.goods_price];
       [cell.shopImage sd_setImageWithURL:[NSURL URLWithString:model.goods_image] placeholderImage:[UIImage imageNamed:@"火影1"]];
    
    
        
        
        return cell;
        
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 77;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [_confirmTableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark------headView  footView
-(UIView *)createHeadView{
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, M_WIDTH,45)];
    _headView.backgroundColor = [UIColor whiteColor];
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, M_WIDTH,5)];
    topView.backgroundColor = RGBCOLOR(219, 223, 224);
    [_headView addSubview:topView];
    
    UIImage *headImage = [UIImage imageNamed:@"店铺"];
    UIImageView *headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(16,18, headImage.size.width, headImage.size.height)];
    headImageView.image = headImage;
    [_headView addSubview:headImageView];
    
    
    return _headView;
}





#pragma mark------去支付
- (void)paryMoneyClick {
    NSLog(@"银联支付");
}
- (IBAction)subMitClick:(id)sender {
    //TODO:微信支付
//    [self bizPay];
//    TODO:支付宝支付
    [self zhifubao];
    //TODO:银联支付
//    [self startNetWithURL:[NSURL URLWithString:kURL_TN_Normal]];
    
    
    
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
    
//    
//    /*
//     *商户的唯一的parnter和seller。
//     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
//     */
//    
//    /*============================================================================*/
//    /*=======================需要填写商户app申请的===================================*/
//    /*============================================================================*/
//    NSString *partner = @"2088611124318021";
//    NSString *seller = @"847797605@qq.com";
//    NSString *privateKey = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBANm2mCnzymkIV/0WBlSOO/TjAsfQ7FFQgJrZ5k+bSnbo48sXPem6708LusvqtGQnIhKF/8Lag/ezQuOK2eBWRx8zfFb1WTccXmeJTgown2rBcVhUPQKl/8779j937JE2aNSvDA7Ye9FP6/78epLLycMrIfxLY5ox2amvFkypVA4BAgMBAAECgYEAzPkyjdzvZq/qV2dTEmzPWiIYzhOPSodmbWRViAGGvClLvjvlmJbdFCjQ94fDyr9lPtdWExg0QxNNGHnz41iXn7XltRZPLVdTjk+gLNhri9eHtmP3V10+GZvt2lVDqOhiRdg8Pnq8b75a+ru6HQahYkYRB2KOAkmCTJaOp2OuEZkCQQDyCqv2hgu7GWkf+EJ/TP0q5GCsSOKbAnN2coLsXbKNoW7jE25wPTuUSsafRQ+OpXMSkEVqRqykqqsIbLDbXhJHAkEA5kTBX/nlvdIzlG6/Io/9TdiLonyDVXDrZCi5OKlfaPq4MXrJBYc9X4Lg2/tIZz5ymeMnGB9jkSGG2Zk2S1p5dwJAFga6l3ijYKdzVaF2C7ep4lleIs+PL6QNdd395ByyvwjN2oROLJCl91zGrn/OZqDP1ASlDILZ+zI81ktt3Mi2yQJBALF9xeCI60GJySBczQ+DFajvhZJVj5ZIV+j4Su0WAOkWeOwKzPBp8jCw3UozQvfx9rwPj47UgxbXVO5dXrBuqLkCQBhwgsy9e0N7kqPieZSvUdcxzDQM1YZq92gtCbYCRXZowaDo7q/xdlaZSmNTLMOb59gy6pk4wsNXD0nllSkyKkU=";
//    /*============================================================================*/
//    /*============================================================================*/
//    /*============================================================================*/
//
//    /*
//     *生成订单信息及签名
//     */
//    //将商品信息赋予AlixPayOrder的成员变量
//    Order *order = [[Order alloc] init];
//    order.partner = partner;
//    order.seller = seller;
//    order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
//    order.productName = @"商品标题"; //商品标题
//    order.productDescription = @"商品描述"; //商品描述
//    order.amount = [NSString stringWithFormat:@"%.2f",10.01]; //商品价格
//    order.notifyURL =  @"http://www.xxx.com"; //回调URL
//    order.service = @"mobile.securitypay.pay";
//    order.paymentType = @"1";
//    order.inputCharset = @"utf-8";
//    order.itBPay = @"30m";
//    order.showUrl = @"m.alipay.com";
//    
//    
//    
//    
//    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"alisdkdemo";
//
//    //将商品信息拼接成字符串
//    NSString *orderSpec = [order description];
//    NSLog(@"orderSpec = %@",orderSpec);
//    
//    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
//    id<DataSigner> signer = CreateRSADataSigner(privateKey);
//    NSString *signedString = [signer signString:orderSpec];
//    
//    //将签名成功字符串格式化为订单字符串,请严格按照该格式
//    NSString *orderString = nil;
//    if (signedString != nil) {
//        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
//                       orderSpec, signedString, @"RSA"];
//        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//            NSLog(@"reslut = %@",resultDic);
//        }];
//    }
    
    RequestCenter *requestCenter = [RequestCenter shareRequestCenter];
    [requestCenter sendRequestPostUrl:@"app/pay" andDic:nil setSuccessBlock:^(NSDictionary *resultDic) {
        
        [[AlipaySDK defaultService] payOrder:resultDic[@"req_url"] fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            NSLog(@"%@",resultDic[@"memo"]);
            NSLog(@"########################");
        }];
    } setFailBlock:^(NSString *errorStr) {

    }];
    

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
