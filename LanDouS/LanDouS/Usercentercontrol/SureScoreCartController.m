//
//  SureScoreCartController.m
//  LanDouS
//
//  Created by Mao-MacPro on 15/1/23.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import "SureScoreCartController.h"
#import "MyAdressMagController.h"
#import "UIImageView+WebCache.h"
#import "DataProvider.h"
#import <AlipaySDK/AlipaySDK.h>
//#import "Order.h"
//#import "APAuthV2Info.h"
#import "DataSigner.h"

@interface SureScoreCartController ()

@end

@implementation SureScoreCartController
@synthesize lblAddressDetail,lblGoodsName,lblGoodsScore,lblNum,lblPhone,lblUsername,btnSurecart,dicScoreInfo,num,imgGoods;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarTitle:@"确认订单"];
//    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
//    image.image=[UIImage imageNamed:@"navgreen.png"];
//    [_topView addSubview:image];
//    _topView.backgroundColor=[UIColor colorWithRed:0.51 green:0.57 blue:0.29 alpha:1];
    _lblTitle.textColor=[UIColor whiteColor];
    [self addLeftButton:@"whiteback@2x.png"];
    dicPost=[[NSMutableDictionary alloc]init];
    
    [btnSurecart.layer setMasksToBounds:YES];
    [btnSurecart.layer setCornerRadius:2.0];
    
    lblGoodsName.text=[dicScoreInfo objectForKey:@"pgoods_name"];
    lblGoodsScore.text=[NSString stringWithFormat:@"积分：%@",[dicScoreInfo objectForKey:@"pgoods_points"]];
    lblNum.text=[NSString stringWithFormat:@"x%d",num];
    
    [imgGoods setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SCORE_GOODS_URL,[dicScoreInfo objectForKey:@"pgoods_image"]]] placeholderImage:img(@"landou_square_default.png")];
    [dicPost setObject:[dicScoreInfo objectForKey:@"pgoods_id"] forKey:@"pgoods_id"];
    [dicPost setObject:[NSString stringWithFormat:@"%d",num] forKey:@"count"];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden=YES;
    
    if (get_Dsp(@"address")) {
        lblUsername.text=[NSString stringWithFormat:@"收货人：%@",[get_Dsp(@"address") objectForKey:@"true_name"]];
        lblPhone.text=[get_Dsp(@"address") objectForKey:@"mob_phone"];
        lblAddressDetail.text=[NSString stringWithFormat:@"%@%@",[get_Dsp(@"address") objectForKey:@"area_info"],[get_Dsp(@"address") objectForKey:@"address"]];
        [dicPost setObject:[get_Dsp(@"address") objectForKey:@"address_id"] forKey:@"address_id"];
    }
    else{
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)addresschooseclick:(id)sender {
    MyAdressMagController *MyAdressMag=[[MyAdressMagController alloc]init];
    [self.navigationController pushViewController:MyAdressMag animated:YES];
}
- (IBAction)sureCartclick:(id)sender {
    if ([[dicPost objectForKey:@"address_id"]length]>0) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"确认提交订单？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        
    }
    else{
        [Dialog simpleToast:@"请选择收货地址"];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [self postinfo];
    }
}


-(void)postinfo
{
    
    [SVProgressHUD showWithStatus:@"正在加载"];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        NSLog(@"^^^^%@", resultDict );
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            point_orderid=[[resultDict objectForKey:@"data"] objectForKey:@"point_orderid"];
            point_orderSn= [[resultDict objectForKey:@"data"] objectForKey:@"point_ordersn"];
            [self gotoAlipay];
//            NSString *appScheme = @"LanDouS";
//            NSString* orderInfo = [self getOrderInfo];
//            NSString* signedStr = [self doRsa:orderInfo];
//            
//            NSLog(@"%@",signedStr);
//            
//            NSString *orderStrings = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",orderInfo, signedStr, @"RSA"];
//            
//            [AlixLibService payOrder:orderStrings AndScheme:appScheme seletor:@selector(paymentResult:) target:self];
            
        }
        else{
            [Dialog simpleToast:[resultDict objectForKey:@"message"]];
        }
        
        
        
    }];
    
    [dataProvider setFailedBlock:^(NSString *strError){
        [SVProgressHUD dismiss];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"检查网络！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        
    }];
    [dataProvider addPointsOrder:[dicPost objectForKey:@"pgoods_id"] andCount:num andAddress:[dicPost objectForKey:@"address_id"]];
    
    
}
-(void)payPointsOrder
{
    
    [SVProgressHUD showWithStatus:@"正在加载"];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        NSLog(@"^^^^%@", resultDict );
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            [Dialog simpleToast:@"支付成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            
        }
        
        
        
    }];
    
    [dataProvider setFailedBlock:^(NSString *strError){
        [SVProgressHUD dismiss];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"检查网络！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        
    }];
    [dataProvider payPointsOrder:point_orderid];
    
    
}




//- (NSString *)generateTradeNO
//{
//    const int N = 15;
//    
//    NSString *sourceString = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
//    NSMutableString *result = [[NSMutableString alloc] init] ;
//    srand(time(0));
//    for (int i = 0; i < N; i++)
//    {
//        unsigned index = rand() % [sourceString length];
//        NSString *s = [sourceString substringWithRange:NSMakeRange(index, 1)];
//        [result appendString:s];
//    }
//    return result;
//}
-(void)gotoAlipay
{
//    /*============================================================================*/
//    /*=======================需要填写商户app申请的===================================*/
//    /*============================================================================*/
//    NSString *partner =PartnerID;
//    NSString *seller = SellerID;
//    NSString *privateKey =PartnerPrivKey;
//    /*============================================================================*/
//    /*============================================================================*/
//    /*============================================================================*/
//    
//    //partner和seller获取失败,提示
//    if ([partner length] == 0 ||
//        [seller length] == 0 ||
//        [privateKey length] == 0)
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                        message:@"缺少partner或者seller或者私钥。"
//                                                       delegate:self
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
//        [alert show];
//        return;
//    }
//    
//    /*
//     *生成订单信息及签名
//     */
//    //将商品信息赋予AlixPayOrder的成员变量
//    Order *order = [[Order alloc] init];
//    order.partner = partner;
//    order.seller = seller;
//    order.tradeNO =point_orderSn; //订单ID（由商家自行制定）
//    order.productName = @"淘小七订单"; //商品标题
//    order.productDescription = @"淘小七订单"; //商品描述
//    order.amount = [NSString stringWithFormat:@"5.0"]; //商品价格
//    order.notifyURL =  @"http://www.xxx.com"; //回调URL
//    
//    order.service = @"mobile.securitypay.pay";
//    order.paymentType = @"1";
//    order.inputCharset = @"utf-8";
//    order.itBPay = @"30m";
//    order.showUrl = @"m.alipay.com";
//    
//    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
//    NSString *appScheme = @"alisdkdemo";
//    
//    //将商品信息拼接成字符串
//    NSString *orderSpec = [order description];
//    NSLog(@"orderSpec = %@",orderSpec);
//    
//    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
//    id<DataSigner> signer = CreateRSADataSigner(privateKey);
//    NSString *signedString = [signer signString:orderSpec];
//    //
//    //将签名成功字符串格式化为订单字符串,请严格按照该格式
//    NSString *orderString = nil;
//    if (signedString != nil) {
//        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
//                       orderSpec, signedString, @"RSA"];
//        
//        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//            NSLog(@"***************&&&&&&&&reslut = %@",resultDic);
//            if ([[resultDic objectForKey:@"resultStatus"] intValue]==9000) {
//                //付款成功
//                [self payPointsOrder];
//            }
//            else{
//                //付款失败
//                [Dialog simpleToast:@"支付失败"];
//            }
//            
//            
//        }];
//        
//        
//    }

    [self realPay:@"alipay" andOrderId:point_orderSn];
}




- (void)realPay:(NSString *)channel andOrderId:(NSString *)pointorderid
{
    relpayChannel = channel;
    
    if(!([channel isEqualToString:@"wx"] || [channel isEqualToString:@"alipay"]))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"支付方式错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    //    if(realpaymoney ==0)
    //    {
    //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择套餐" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    //        [alert show];
    //        return;
    //    }
    
    [SVProgressHUD showWithStatus:@"正在加载"];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        DLog(@"%@", resultDict);
        //        if ([[resultDict objectForKey:@"result"]intValue]==1) {
        [self realPayCallBack:resultDict];
        
        
    }];
    
    [dataProvider setFailedBlock:^(NSString *strError){
        [SVProgressHUD dismiss];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"支付失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        
    }];
    
    //    if(realpaymoney <= 29.0){
    //
    //        realpaymoney += 5;
    //    }
    
    [dataProvider getPingPPChargeChannel:channel andAmount:[NSString stringWithFormat:@"%ld",(long)(0.01*100)] andOrdernum:pointorderid andSubject:@"suibian" andBody:@"test"];
    //    [dataProvider setDelegateObject:self setBackFunctionName:@"realPayCallBack:"];
    //    [dataProvider getPingppCharge:[Toolkit getUserID]
    //                       andChannel:channel
    //                        andAmount:[NSString stringWithFormat:@"%d",(int)realpaymoney*100]
    //                   andDescription:@"1"
    //                           andFlg:@"0"];
    
}
#define kUrlScheme      @"com.taoxiaoqi.app" // 这个是你定义的 URL Scheme，支付宝、微信支付和测试模式需要。


-(void)realPayCallBack:(id)dict
{
    DLog(@"%@",dict);
    
    
    //    if ([dict[@"code"] intValue]==200) {
    @try {
        
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
        NSString* charge = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"str_data:%@",charge);
        if ([relpayChannel isEqualToString:@"alipay"]) {
            //在返回的charge中[@"credential"][@"alipay"][@"orderInfo"] 下 有个时间 日期和时间之间没有空格 在这里手动插入
            NSRange keyWordRange =  [charge rangeOfString:@"it_b_pay=" options:NSCaseInsensitiveSearch];
            NSMutableString *mutStr = [[NSMutableString alloc] initWithString:charge];
            [mutStr insertString:@" " atIndex:(keyWordRange.length+keyWordRange.location + 12)];
            DLog(@"%@",mutStr);
            charge = mutStr;
        }
        
        
        //            NSString* charge = [[NSString alloc] initWithData:    data encoding:NSUTF8StringEncoding];
        //            NSLog(@"charge = %@", charge);
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           [Pingpp createPayment:charge viewController:self appURLScheme:kUrlScheme withCompletion:^(NSString *result, PingppError *error) {
                               NSLog(@"completion block: %@", result);
                               if (error == nil) {
                                   NSLog(@"PingppError is nil");
                               } else {
                                   NSLog(@"PingppError: code=%lu msg=%@", (unsigned  long)error.code, [error getMsg]);
                               }
                               //                               [self showAlertMessage:result];
                               
                               [Dialog simpleToast:result];
                           }];
                       });
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}




//-(NSString*)getOrderInfo
//{
//    /*
//     *点击获取prodcut实例并初始化订单信息
//     */
//    
//    AlixPayOrder *order = [[AlixPayOrder alloc] init];
//    order.partner = PartnerID;
//    order.seller = SellerID;
//    
//    order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
//    order.productName = @"懒豆商城订单"; //商品标题
//    order.productDescription = @"懒豆商城积分运费"; //商品描述
//    
//    NSLog(@"个参数%@",dicPost);
//    
//    
//    
//    order.amount = [NSString stringWithFormat:@"0.1"]; //商品价格
//    order.notifyURL =  @"http://notify.msp.hk/notif y.htm"; //回调URL
//    NSLog(@"%@",[order description]);
//    return [order description];
//}
//
//- (NSString *)generateTradeNO
//{
//    const int N = 15;
//    
//    NSString *sourceString = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
//    NSMutableString *result = [[NSMutableString alloc] init] ;
//    srand(time(0));
//    for (int i = 0; i < N; i++)
//    {
//        unsigned index = rand() % [sourceString length];
//        NSString *s = [sourceString substringWithRange:NSMakeRange(index, 1)];
//        [result appendString:s];
//    }
//    return result;
//}
//
//-(NSString*)doRsa:(NSString*)orderInfo
//{
//    id<DataSigner> signer;
//    signer = CreateRSADataSigner(PartnerPrivKey);
//    NSString *signedString = [signer signString:orderInfo];
//    return signedString;
//}
//
////wap回调函数
//-(void)paymentResult:(NSString *)resultd
//{
//    //结果处理
//#if ! __has_feature(objc_arc)
//    AlixPayResult* result = [[[AlixPayResult alloc] initWithString:resultd] autorelease];
//#else
//    AlixPayResult* result = [[AlixPayResult alloc] initWithString:resultd];
//#endif
//    if (result)
//    {
//        
//        
//        if (result.statusCode == 9000)
//        {
//            /*
//             *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
//             */
//            //交易成功
//            NSString* key = AlipayPubKey;//签约帐户后获取到的支付宝公钥
//            id<DataVerifier> verifier;
//            verifier = CreateRSADataVerifier(key);
//            //提交订单
//             [self payPointsOrder];
//            if ([verifier verifyString:result.resultString withSign:result.signString])
//            {
//                
//                //验证签名成功，交易结果无篡改
//            }
//        }
//        else
//        {
//            
//            //交易失败
//        }
//        
//    }
//    else
//    {
//        //失败
//    }
//    
//}

@end
