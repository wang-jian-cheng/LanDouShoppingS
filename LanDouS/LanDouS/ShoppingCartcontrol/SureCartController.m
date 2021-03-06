//
//  SureCartController.m
//  LanDouS
//
//  Created by Mao-MacPro on 15/1/12.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import "SureCartController.h"
#import "DataProvider.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "ShopCartCell.h"
#import "SureCartController.h"
#import "AppDelegate.h"
#import "CartStateController.h"
#import "MyAdressMagController.h"
#import <AlipaySDK/AlipaySDK.h>
//#import "Order.h"
//#import "APAuthV2Info.h"
#import "DataSigner.h"
#import "payRequsestHandler.h"
#import "WXApi.h"
@interface SureCartController ()
{
    NSString *relpayChannel;
}
@end

@implementation SureCartController
int pay_method=0;
typedef enum {
    weixin_pay,
    ali_pay,
    offline_pay
}paymethod;//枚举名称
@synthesize viewHeader,arrayCartList,lblallPrice,lblYunFei,btnsure,lblAddress,lblName,lblPhone,totalPrice,btnPeisong,strType;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarTitle:@"确认订单"];
    _lblTitle.textColor=[UIColor whiteColor];
    _topView.backgroundColor=navi_bar_bg_color;
    [self addLeftButton:@"whiteback@2x.png"];
    [btnsure.layer setMasksToBounds:YES];
    [btnsure.layer setCornerRadius:3.0];
    [btnPeisong.layer setMasksToBounds:YES];
    [btnPeisong.layer setCornerRadius:3.0];
    
    minTotalPrice=0.00;
    onLinePayDiscount=0.00;
    
    dicPost=[[NSMutableDictionary alloc]init];
    dicAddress=[[NSMutableDictionary alloc]init];
    tableCart = [[UITableView alloc] initWithFrame:CGRectMake(0,NavigationBar_HEIGHT+20, SCREEN_WIDTH, SCREEN_HEIGHT-64-45)];
    tableCart.dataSource = self;
    tableCart.delegate = self;
    
    [self.view addSubview:tableCart];
    tableCart.tableHeaderView=viewHeader;
    [dicPost setObject:@"delivery" forKey:@"ship_method"];
    [dicPost setObject:@"online" forKey:@"pay_method"];
    
    
    if ([strType isEqualToString:@"buynow"]) {
        [dicPost setObject:[[arrayCartList objectAtIndex:0] objectForKey:@"goods_num"] forKey:@"goods_num"];
        [dicPost setObject:[[arrayCartList objectAtIndex:0] objectForKey:@"goods_id"] forKey:@"goods_id"];
        
        
        NSString *str = [self getGoodPrice:0];
        if (str != nil) {
            totalPrice = totalPrice + ([str floatValue] * [[[arrayCartList objectAtIndex:0] objectForKey:@"goods_num"] intValue]);
        }
        else
        {
            totalPrice=totalPrice+[[[arrayCartList objectAtIndex:0] objectForKey:@"goods_price"] floatValue]*[[[arrayCartList objectAtIndex:0] objectForKey:@"goods_num"] intValue];
        }
    }
    else{
        for (int i=0; i<arrayCartList.count; i++) {
            
            NSString *str = [self getGoodPrice:i];
            if (str != nil) {
                totalPrice = totalPrice + ([str floatValue] * [[[arrayCartList objectAtIndex:i] objectForKey:@"goods_num"] intValue]);
            }
            else
            {
                totalPrice=totalPrice+[[[arrayCartList objectAtIndex:i] objectForKey:@"goods_price"] floatValue]*[[[arrayCartList objectAtIndex:i] objectForKey:@"goods_num"] intValue];
            }
//            
//            totalPrice=totalPrice+[[[arrayCartList objectAtIndex:i] objectForKey:@"goods_price"] floatValue]*[[[arrayCartList objectAtIndex:i] objectForKey:@"goods_num"] intValue];
        }
    }
    if(totalPrice>29.0){
        _strFreightPrice=@"0";
    }else{
                _strFreightPrice=@"5";
    }
//    lblallPrice.text=[NSString stringWithFormat:@"总金额￥%.2f",totalPrice];
//    
//    if ( totalPrice>5) {
//        lblYunFei.text=[NSString stringWithFormat:@"免运费，在线支付减免：￥2.00"];
//    }
//    else{
//        lblYunFei.text=[NSString stringWithFormat:@"(运费:￥5.00，在线支付减免:￥2.00)"];
//    }
    
    [self getDiscountSetting];
    if (get_Dsp(@"address")) {
        lblName.text=[NSString stringWithFormat:@"收货人：%@",[get_Dsp(@"address") objectForKey:@"true_name"]];
        lblPhone.text=[get_Dsp(@"address") objectForKey:@"mob_phone"];
        lblAddress.text=[get_Dsp(@"address") objectForKey:@"area_info"];
        [dicPost setObject:[get_Dsp(@"address") objectForKey:@"address_id"] forKey:@"address_id"];
    }
    else{
        
    }
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ensureaddress:) name:@"surecartaddress" object:nil];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    
    self.tabBarController.tabBar.hidden=YES;
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
    if (get_Dsp(@"address")) {
        lblName.text=[NSString stringWithFormat:@"收货人：%@",[get_Dsp(@"address") objectForKey:@"true_name"]];
        lblPhone.text=[get_Dsp(@"address") objectForKey:@"mob_phone"];
        lblAddress.text=[NSString stringWithFormat:@"%@%@",[get_Dsp(@"address") objectForKey:@"area_info"],[get_Dsp(@"address") objectForKey:@"address"]];
        [dicPost setObject:[get_Dsp(@"address") objectForKey:@"address_id"] forKey:@"address_id"];
    }
    else{
        lblName.text=@"暂无收货地址";
        lblPhone.text=@"";
        lblAddress.text=@"";
    }
}

-(void)getDiscountSetting
{
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        
        NSLog(@"^^^^%@", resultDict );
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            if ([[resultDict objectForKey:@"list"]isKindOfClass:[NSArray class]]) {
                if ([[resultDict objectForKey:@"list"] count]>0) {
                    minTotalPrice=[[[[resultDict objectForKey:@"list"]objectAtIndex:0] objectForKey:@"min_total_price"] floatValue];
                    onLinePayDiscount=[[[[resultDict objectForKey:@"list"]objectAtIndex:0] objectForKey:@"online_pay_discount"] floatValue];
          
                }
            }
            if (onLinePayDiscount>=0) {
               // lblallPrice.text=[NSString stringWithFormat:@"总金额￥%.2f",totalPrice];
                
                if ((totalPrice+[self.strFreightPrice floatValue])>minTotalPrice) {
                    lblallPrice.text=[NSString stringWithFormat:@"总金额:￥%.2f",totalPrice+[self.strFreightPrice floatValue]-onLinePayDiscount];
                    lblYunFei.text=[NSString stringWithFormat:@"运费:￥%@，在线支付满%.2f减%.2f",self.strFreightPrice,minTotalPrice,onLinePayDiscount];
                }
                else{
                    lblallPrice.text=[NSString stringWithFormat:@"总金额:￥%.2f",totalPrice+[self.strFreightPrice floatValue]];
                    lblYunFei.hidden=NO;
lblYunFei.text=[NSString stringWithFormat:@"运费:￥%@",self.strFreightPrice];
                    
                    
                    //lblYunFei.text=[NSString stringWithFormat:@"(运费:￥5.00，在线支付减免:￥2.00)"];
                }
            }
            
            
            
            
            
            
        }
        else{
            
        }
    }];
    
    [dataProvider setFailedBlock:^(NSString *strError){
        
        
        
    }];
    
    [dataProvider getDiscountSetting];
}
//-(void)ensureaddress:(NSNotification *)notification
//{
//    [dicAddress removeAllObjects];
//    dicAddress=[NSMutableDictionary dictionaryWithDictionary:[notification object]];
//    lblName.text=[NSString stringWithFormat:@"收货人：%@",[dicAddress objectForKey:@"true_name"]];
//    lblPhone.text=[dicAddress objectForKey:@"mob_phone"];
//    lblAddress.text=[dicAddress objectForKey:@"area_info"];
//    [dicPost setObject:[dicAddress objectForKey:@"address_id"] forKey:@"address_id"];
//}

#pragma mark tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [arrayCartList count];
}



-(NSString *)getGoodPrice:(NSInteger)index
{
    NSDictionary *tempDict = self.goosStandardIDStrArr[index];
    NSString *str = self.standardIDStrArr[index];
    
    NSDictionary *specInfo = tempDict[str];
    if(!([specInfo isEqual:[NSNull null]] || specInfo == nil))
    {
        DLog(@"price:%@",specInfo[@"goods_price"]);
        DLog(@"storage:%@",specInfo[@"goods_storage"]);
        
        
        return specInfo[@"goods_price"];

    }

    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    UITableViewCell *cell = [tableView
    //                             dequeueReusableCellWithIdentifier:@"Cell"];
    static NSString *CellIdentifier = @"ShopCartCellIdentifier";
    ShopCartCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"ShopCartCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        //cell.backgroundColor=[UIColor colorWithRed:0.94 green:0.95 blue:0.95 alpha:1];
    }
//    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",[[arrayCartList   objectAtIndex:indexPath.row] objectForKey:@"store_id"],[[arrayCartList   objectAtIndex:indexPath.row] objectForKey:@"goods_image"]]];
    
    NSURL *url=[NSURL URLWithString:[[arrayCartList objectAtIndex:indexPath.row] objectForKey:@"goods_image"]];
    
    [cell.ImgGoods setImageWithURL:url placeholderImage:img(@"landou_square_default.png")];
    
    
    cell.lblGoodsName.text= [[arrayCartList   objectAtIndex:indexPath.row] objectForKey:@"goods_name"];
//    cell.lblGoodsPrice.text=[NSString stringWithFormat:@"￥%@",[[arrayCartList   objectAtIndex:indexPath.row] objectForKey:@"goods_price"]];
    
    NSString *str = [self getGoodPrice:indexPath.row];
    
    if (str!=nil) {
        cell.lblGoodsPrice.text = str;
    }
    else
    {
        cell.lblGoodsPrice.text=[NSString stringWithFormat:@"￥%@",[[arrayCartList   objectAtIndex:indexPath.row] objectForKey:@"goods_price"]];
    }
    
    cell.textBuyNum.text=[NSString stringWithFormat:@"%@", [[arrayCartList   objectAtIndex:indexPath.row] objectForKey:@"goods_num"]];
    cell.lblBuyNum.text=[NSString stringWithFormat:@"x%@", [[arrayCartList   objectAtIndex:indexPath.row] objectForKey:@"goods_num"]];

    cell.btnAdd.hidden=YES;
    cell.btnCut.hidden=YES;
    cell.textBuyNum.hidden=YES;
    cell.imgbuyNumBG.hidden=YES;
    cell.btncheck.hidden=YES;
    
    
    // Configure the cell...
    return cell;
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *viewsectionHeader=[[UIView alloc]init];
//    viewsectionHeader.backgroundColor=[UIColor whiteColor];
//    
//    UILabel *lbltitle = [[UILabel alloc] initWithFrame:CGRectMake(10,0,SCREEN_WIDTH,30)];
//    
//    lbltitle.text =[[arrayCartList objectAtIndex:section]objectForKey:@"store_name"];
//    lbltitle.numberOfLines = 0;
//    //lbltitle.textAlignment=NSTextAlignmentRight;
//    lbltitle.font = [UIFont systemFontOfSize:14.0];
//    lbltitle.textColor = [UIColor blackColor];
//    lbltitle.backgroundColor = [UIColor whiteColor];
//    [viewsectionHeader addSubview:lbltitle];
//    UIImageView *imageline1=[[UIImageView alloc]initWithFrame:CGRectMake(0,31, SCREEN_WIDTH, 1)];
//    imageline1.backgroundColor=[UIColor colorWithRed:0.97 green:0.96 blue:0.96 alpha:1];
//    [viewsectionHeader addSubview:imageline1];
//    
//    return viewsectionHeader;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *viewFooter=[[UIView alloc]initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,20)];
//    viewFooter.backgroundColor=[UIColor whiteColor];
//    //viewFooter.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
//    UILabel *lblPrice = [[UILabel alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH-20,30)];
//    
//    lblPrice.text =[NSString stringWithFormat:@"共%lu件商品  合计：￥%@",(unsigned long)[[[arrayCartList objectAtIndex:section]objectForKey:@"cart_list"] count],[[arrayCartList objectAtIndex:section]objectForKey:@"purchase_price"]];
//    lblPrice.numberOfLines = 0;
//    lblPrice.textAlignment=NSTextAlignmentRight;
//    lblPrice.font = [UIFont boldSystemFontOfSize:13.0];
//    lblPrice.textColor =[UIColor colorWithRed:0.91 green:0.62 blue:0.25 alpha:1];
//    lblPrice.backgroundColor = [UIColor whiteColor];
//    [viewFooter addSubview:lblPrice];
//    UIImageView *imageline1=[[UIImageView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 1)];
//    imageline1.backgroundColor=[UIColor colorWithRed:0.97 green:0.96 blue:0.96 alpha:1];
//    [viewFooter addSubview:imageline1];
//    UIImageView *imageBG=[[UIImageView alloc]initWithFrame:CGRectMake(0, 30,SCREEN_WIDTH,10)];
//    imageBG.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
//    //imageBG.image=[UIImage imageNamed:@"line_01.png"];
//    [viewFooter addSubview:imageBG];
//    
//    return viewFooter;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 30;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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

- (IBAction)shipMethod:(id)sender {
    if ([sender selectedSegmentIndex]==0) {
        [dicPost setObject:@"delivery" forKey:@"ship_method"];
        if ([[dicPost objectForKey:@"pay_method"]isEqualToString:@"online"]) {
            lblallPrice.text=[NSString stringWithFormat:@"总金额￥%.2f",totalPrice];
            if (totalPrice>29) {
                lblYunFei.text=[NSString stringWithFormat:@"免运费，在线支付减免：￥2.00"];
            }
            else{
                lblYunFei.text=[NSString stringWithFormat:@"(运费:￥5.00，在线支付减免:￥2.00)"];
            }
        }
        else{
            lblallPrice.text=[NSString stringWithFormat:@"总金额￥%.2f",totalPrice];
            if (totalPrice>29) {
                lblYunFei.text=[NSString stringWithFormat:@"免运费"];
            }
            else{
                lblYunFei.text=[NSString stringWithFormat:@"(运费:￥5.00)"];
            }
        }
        
        
        
    }
    else{
        [dicPost setObject:@"self_take" forKey:@"ship_method"];
        
        
        
        
    }
    
    
}

- (IBAction)payMethod:(id)sender {
    if ([sender selectedSegmentIndex]==2) {
        pay_method=offline_pay;
        lblallPrice.text=[NSString stringWithFormat:@"总金额￥%.2f",totalPrice+[self.strFreightPrice floatValue]];
        lblYunFei.hidden=NO;
        lblYunFei.text=[NSString stringWithFormat:@"运费:￥%@，在线支付满%.2f减%.2f",self.strFreightPrice,minTotalPrice,onLinePayDiscount];
        [dicPost setObject:@"offline" forKey:@"pay_method"];
        
        
    }
    else{
        if ([sender selectedSegmentIndex]==0) {
            pay_method=weixin_pay;
        }else{
            pay_method=ali_pay;
        }
        [dicPost setObject:@"online" forKey:@"pay_method"];
        if (onLinePayDiscount>=0) {
            lblYunFei.hidden=NO;
            if ((totalPrice+[self.strFreightPrice floatValue])>minTotalPrice) {
                lblallPrice.text=[NSString stringWithFormat:@"总金额￥%.2f",totalPrice+[self.strFreightPrice floatValue]-onLinePayDiscount];
                lblYunFei.text=[NSString stringWithFormat:@"运费:￥%@，在线支付满%.2f减%.2f",self.strFreightPrice,minTotalPrice,onLinePayDiscount];
            }
            else{
                lblallPrice.text=[NSString stringWithFormat:@"总金额￥%.2f",totalPrice+[self.strFreightPrice floatValue]];
                lblYunFei.hidden=NO;
                lblYunFei.text=[NSString stringWithFormat:@"运费:￥%@，在线支付满%.2f减%.2f",self.strFreightPrice,minTotalPrice,onLinePayDiscount];
            }
        }
        
    }
}

- (IBAction)sureclick:(id)sender {
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"确认提交订单？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    [alert setTag:1007];
    
    
    
    
    
    
    
}

- (IBAction)chooseaddress:(id)sender {
    
    MyAdressMagController *MyAdressMag=[[MyAdressMagController alloc]init];
    MyAdressMag.strType=@"surecart";
    [self.navigationController pushViewController:MyAdressMag animated:YES];
    
}

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
//    order.tradeNO =dingDanNum; //订单ID（由商家自行制定）
//    order.productName = @"懒豆商城订单"; //商品标题
//    order.productDescription = @"懒豆商城订单"; //商品描述
//    
//    if ((totalPrice+[self.strFreightPrice floatValue])>minTotalPrice) {
//        order.amount = [NSString stringWithFormat:@"%.2f",totalPrice+[self.strFreightPrice floatValue]-onLinePayDiscount];
//        
//    }
//    else{
//        order.amount = [NSString stringWithFormat:@"%.2f",totalPrice+[self.strFreightPrice floatValue]];
//    }
//    
//     //商品价格
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
////
//    //将签名成功字符串格式化为订单字符串,请严格按照该格式
//    NSString *orderString = nil;
//    if (signedString != nil) {
//        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
//                       orderSpec, signedString, @"RSA"];
//        CartStateController *CartState=[[CartStateController alloc]init];
//        CartState.strPrice=[NSString stringWithFormat:@"%.2f",totalPrice];
//        CartState.strNum=dingDanNum;
//        CartState.strName=goodsName;
//        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//            NSLog(@"***************&&&&&&&&reslut = %@",resultDic);
//            if([[resultDic objectForKey:@"resultStatus"] intValue]==9000){
//                DataProvider *dataProvider = [[DataProvider alloc] init];
//                [dataProvider setFinishBlock:^(NSDictionary *resultDict){
//                    
//                }];
//                
//                [dataProvider setFailedBlock:^(NSString *strError){
//                    
//                }];
//                
//                [dataProvider payorder:dingDanNum];
//
//                
//                        CartState.strState=@"success";
//                
//            }
//            else{
//                
//                CartState.strState=@"failed";
//            }
//            
//            [self.navigationController pushViewController:CartState animated:YES];
//        }];
//        
//        
//    }
    
    [self realPay:@"alipay"];
    
}

- (void)realPay:(NSString *)channel
{
    
    relpayChannel = channel;
    
    if(!([channel isEqualToString:@"wx"] || [channel isEqualToString:@"alipay"]))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"支付方式错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if(totalPrice ==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择套餐" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
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
    
    CGFloat amount;
    
    if ((totalPrice+[self.strFreightPrice floatValue])>minTotalPrice) {
        amount = totalPrice+[self.strFreightPrice floatValue]-onLinePayDiscount;

    }
    else{
        amount =totalPrice+[self.strFreightPrice floatValue];
    }

    [dataProvider getPingPPChargeChannel:channel andAmount:[NSString stringWithFormat:@"%ld",(long)(amount*100)] andOrdernum:dingDanNum andSubject:@"TaoXiaoQi" andBody:@"PayForGoods"];
    //    [dataProvider setDelegateObject:self setBackFunctionName:@"realPayCallBack:"];
    //    [dataProvider getPingppCharge:[Toolkit getUserID]
    //                       andChannel:channel
    //                        andAmount:[NSString stringWithFormat:@"%d",(int)realpaymoney*100]
    //                   andDescription:@"1"
    //                           andFlg:@"0"];
    
}


- (void)showAlertWait
{
    mAlert = [[UIAlertView alloc] initWithTitle:@"正在获取支付凭据,请稍后..." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [mAlert show];
    UIActivityIndicatorView* aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    aiv.center = CGPointMake(mAlert.frame.size.width / 2.0f - 15, mAlert.frame.size.height / 2.0f + 10 );
    [aiv startAnimating];
    [mAlert addSubview:aiv];
}

- (void)hideAlert
{
    if (mAlert != nil)
    {
        [mAlert dismissWithClickedButtonIndex:0 animated:YES];
        mAlert = nil;
    }
}

- (void)showAlertMessage:(NSString*)msg
{
    mAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [mAlert show];
}

-(void)realPayCallBack:(id)dict
{
    DLog(@"%@",dict);
    
    DLog(@"%@",dict[@"credential"][@"alipay"][@"orderInfo"]);
//    NSString *aliInfoStr = dict[@"credential"][@"alipay"][@"orderInfo"];
//    
//    NSRange keyWordRange =  [aliInfoStr rangeOfString:@"it_b_pay=" options:NSCaseInsensitiveSearch];
//    
//    DLog(@"%@",NSStringFromRange(keyWordRange));
    
  
    
    //    if ([dict[@"code"] intValue]==200) {
    @try {
        
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
        NSString* charge = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        
        if ([relpayChannel isEqualToString:@"alipay"]) {
            //在返回的charge中[@"credential"][@"alipay"][@"orderInfo"] 下 有个时间 日期和时间之间没有空格 在这里手动插入
            NSRange keyWordRange =  [charge rangeOfString:@"it_b_pay=" options:NSCaseInsensitiveSearch];
            NSMutableString *mutStr = [[NSMutableString alloc] initWithString:charge];
            [mutStr insertString:@" " atIndex:(keyWordRange.length+keyWordRange.location + 12)];
            DLog(@"%@",mutStr);
            charge = mutStr;
        }
        
        
//        charge = [charge stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
//        charge =@"{ \"id\" : \"ch_5SSKS04CWjvPfj58WTP0yLqD\",\"object\" : \"charge\", \"created\" : 1457686602,\"livemode\" : true, \"paid\" : false,\"refunded\" : false,\"app\" : \"app_aD0yT4DCSiH00qn9\", \"channel\" : \"alipay\",\"order_no\" : \"4ca0bc8028c3\", \"client_ip\" : \"113.122.238.6\",\"amount\" : 2700,\"amount_settle\" : 2700,  \"currency\" : \"cny\", \"subject\" : \"Your Subject\",\"body\" : \"Your Body\",\"extra\" : {  },\"time_paid\" : null,\"time_expire\" : 1457773002,\"time_settle\" : null,\"transaction_no\" : null,\"refunds\" : {       \"object\" : \"list\",       \"url\" : \"/v1/charges/ch_5SSKS04CWjvPfj58WTP0yLqD/refunds\", \"has_more\" : false,  \"data\" : [    ] },  \"amount_refunded\" : 0, \"failure_code\" : null, \"failure_msg\" : null, \"metadata\" : {  }, \"credential\" : {  \"object\" : \"credential\",   \"alipay\" : {      \"orderInfo\" : \"service=\\\"mobile.securitypay.pay\\\"&_input_charset=\\\"utf-8\\\"&notify_url=\\\"https%3A%2F%2Fapi.pingxx.com%2Fnotify%2Fcharges%2Fch_5SSKS04CWjvPfj58WTP0yLqD\\\"&partner=\\\"2088911456459895\\\"&out_trade_no=\\\"4ca0bc8028c3\\\"&subject=\\\"Your Subject\\\"&body=\\\"Your Body\\\"&total_fee=\\\"27.00\\\"&payment_type=\\\"1\\\"&seller_id=\\\"2088911456459895\\\"&it_b_pay=\\\"2016-03-12 16:56:42\\\"&sign=\\\"VYnUO16FS8Bw6%2FagZnI5b3yHdjBhQfDa8qPNpGwz2W3%2BazIds1KmWImPoC%2BTuAHpRSRZYCsOUhEmInTEuZRhlIwIIidhD8hM2dcM68QsO%2FrFJicdm087QQCWNIeQY4Xq9Dp7SPrxbHd1sShVA98hAmTaXFsgFM2w4RzUHEGRkPE%3D\\\"&sign_type=\\\"RSA\\\"\"    } },  \"description\" : null}";
        
//        charge = @"{\"id\":\"ch_W9Ci5Oe9y10S5iTGiPeDGG8O\",\"object\":\"charge\",\"created\":1457919127,\"livemode\":true,\"paid\":false,\"refunded\":false,\"app\":\"app_aD0yT4DCSiH00qn9\",\"channel\":\"alipay\",\"order_no\":\"2016031400000001\",\"client_ip\":\"127.0.0.1\",\"amount\":1,\"amount_settle\":1,\"currency\":\"cny\",\"subject\":\"2\",\"body\":\"核武者测试\",\"extra\":{},\"time_paid\":null,\"time_expire\":1458005527,\"time_settle\":null,\"transaction_no\":null,\"refunds\":{\"object\":\"list\",\"url\":\"1arges_W9Ci5Oe9y10S5iTGiPeDGG8O/refunds\",\"has_more\":false,\"data\":[]},\"amount_refunded\":0,\"failure_code\":null,\"failure_msg\":null,\"metadata\":{},\"credential\":{\"object\":\"credential\",\"alipay\":{\"orderInfo\":\"service=\\\"mobile.securitypay.pay\\\"&_input_charset=\\\"utf-8\\\"&notify_url=\\\"https%3A%2F%2Fapi.pingxx.com%2Fnotify%2Fcharges%2Fch_W9Ci5Oe9y10S5iTGiPeDGG8O\\\"&partner=\\\"2088911456459895\\\"&out_trade_no=\\\"2016031400000001\\\"&subject=\\\"2\\\"&body=\\\"核武者测试\\\"&total_fee=\\\"0.01\\\"&payment_type=\\\"1\\\"&seller_id=\\\"2088911456459895\\\"&it_b_pay=\\\"2016-03-15 09:32:07\\\"&sign=\\\"PMKtlJ%2Fu71YX%2FfAqL4kEahiMT28vFGEDd2wQRVFOgUF0dV31h0NdQ6lLGOHquEdpU%2FNptwKpHhfDRmRJvbWvFzIo7Djz9xI0g%2Flsn5nJ8vrWUbHu6sQyORc1DZN5wUY00%2FoaMVdvasGvp6yXgah3AU%2Fqx1R3FKRIHlz6ebFIaM4%3D\\\"&sign_type=\\\"RSA\\\"\"}},\"description\":null}";
        
        
//        @"{  \"time_settle\" : null,  \"description\" : null,  \"transaction_no\" : null,  \"time_paid\" : null,  \"extra\" : {  },  \"amount\" : 2700,  \"metadata\" : {  },  \"livemode\" : true,  \"order_no\" : \"4ca0bc8028c3\",  \"refunds\" : {    \"has_more\" : false,    \"object\" : \"list\",    \"data\" : [    ],    \"url\" : \"/v1/charges/ch_5SSKS04CWjvPfj58WTP0yLqD/refunds\"  },  \"object\" : \"charge\",  \"currency\" : \"cny\",  \"refunded\" : false,  \"channel\" : \"alipay\",  \"subject\" : \"YourSubject\",  \"amount_refunded\" : 0,  \"failure_code\" : null,  \"paid\" : false,  \"id\" : \"ch_5SSKS04CWjvPfj58WTP0yLqD\",  \"body\" : \"YourBody\",  \"amount_settle\" : 2700,  \"failure_msg\" : null,  \"time_expire\" : 1457773002,  \"client_ip\" : \"113.122.238.6\",  \"credential\" : {    \"alipay\" : {      \"orderInfo\" : \"service=\\\"mobile.securitypay.pay\\\"&_input_charset=\\\"utf-8\\\"&notify_url=\\\"https%3A%2F%2Fapi.pingxx.com%2Fnotify%2Fcharges%2Fch_5SSKS04CWjvPfj58WTP0yLqD\\\"&partner=\\\"2088911456459895\\\"&out_trade_no=\\\"4ca0bc8028c3\\\"&subject=\\\"YourSubject\\\"&body=\\\"YourBody\\\"&total_fee=\\\"27.00\\\"&payment_type=\\\"1\\\"&seller_id=\\\"2088911456459895\\\"&it_b_pay=\\\"2016-03-12 16:56:42\\\"&sign=\\\"VYnUO16FS8Bw6%2FagZnI5b3yHdjBhQfDa8qPNpGwz2W3%2BazIds1KmWImPoC%2BTuAHpRSRZYCsOUhEmInTEuZRhlIwIIidhD8hM2dcM68QsO%2FrFJicdm087QQCWNIeQY4Xq9Dp7SPrxbHd1sShVA98hAmTaXFsgFM2w4RzUHEGRkPE%3D\\\"&sign_type=\\\"RSA\\\"\"    },    \"object\" : \"credential\"  },  \"created\" : 1457686602,  \"app\" : \"app_aD0yT4DCSiH00qn9\"}";
        
//        charge = [charge stringByReplacingOccurrencesOfString:@" " withString:@""];
        DLog(@"%lld",0x4ca0bc8028c3);
        
//        //在返回的charge中[@"credential"][@"alipay"][@"orderInfo"] 下 有个时间 日期和时间之间没有空格 在这里手动插入
//        NSRange keyWordRange =  [charge rangeOfString:@"it_b_pay=" options:NSCaseInsensitiveSearch];
//        NSMutableString *mutStr = [[NSMutableString alloc] initWithString:charge];
//        [mutStr insertString:@" " atIndex:(keyWordRange.length+keyWordRange.location + 12)];
//        DLog(@"%@",mutStr);
//        
//        charge = mutStr;
//        charge2 =@"{ \"object\" : \"charge\",  \"created\":1457667801, \"livemode\": true, \"paid\" : false, \"refunded\" : false, \"app\": \"app_aD0yT4DCSiH00qn9\", \"channel\": \"alipay\", \"order_no\": \"930511011739138002\", \"client_ip\": \"113.122.238.6\", \"amount\": 290000, \"amount_settle\": 290000, \"currency\" : \"cny\", \"subject\" : \"TaoXiaoQi\", \"body\": \"PayForGoods\", \"extra\": {}, \"time_paid\": null, \"time_expire\": 1457754201, \"time_settle\": null, \"transaction_no\": null, \"refunds\": { \"object\": \"list\", \"url\": \"\/v1\/charges\/ch_nv9yH0rnHSiLXrzHC4rjT848\/refunds\", \"has_more\": false, \"data\": [] }, \"amount_refunded\": 0, \"failure_code\": null, \"failure_msg\": null, \"metadata\": {}, \"credential\": { \"object\": \"credential\", \"alipay\": { \"orderInfo\": \"service=\\\"mobile.securitypay.pay\\\"&_input_charset=\\\"utf-8\\\"&notify_url=\\\"https%3A%2F%2Fapi.pingxx.com%2Fnotify%2Fcharges%2Fch_nv9yH0rnHSiLXrzHC4rjT848\\\"&partner=\\\"2088911456459895\\\"&out_trade_no=\\\"930511011739138002\\\"&subject=\\\"TaoXiaoQi\\\"&body=\\\"PayForGoods\\\"&total_fee=\\\"2900.00\\\"&payment_type=\\\"1\\\"&seller_id=\\\"2088911456459895\\\"&it_b_pay=\\\"2016-03-12 11:43:21\\\"&sign=\\\"L1Q5NoSqD7LyGK5jXFq4U46WHpyrTyQT9rTnck1R2TEC6xKwH3RXdEqHuPtm5pMsfjQ7zaRTwbyYSRxZD812%2FusujxTAZO%2FKtahiJuod7oCSoEbyNkGW5M2%2Br3%2F%2FJsIN%2Bw3g1yIkuGBs%2F0JS82Sp6pkgEXA7GvXfuYpjXznsqDI%3D\\\"&sign_type=\\\"RSA\\\"\"}},\"id\": \"ch_nv9yH0rnHSiLXrzHC4rjT848\",\"description\": null}";

//  /*ok*/      charge1 = @"{ \"id\": \"ch_nv9yH0rnHSiLXrzHC4rjT848\", \"object\": \"charge\", \"created\": 1457667801, \"livemode\": true, \"paid\": false, \"refunded\": false, \"app\": \"app_aD0yT4DCSiH00qn9\", \"channel\": \"alipay\", \"order_no\": \"930511011739138002\", \"client_ip\": \"113.122.238.6\", \"amount\": 290000, \"amount_settle\": 290000, \"currency\": \"cny\", \"subject\": \"TaoXiaoQi\", \"body\": \"PayForGoods\", \"extra\": {}, \"time_paid\": null, \"time_expire\": 1457754201, \"time_settle\": null, \"transaction_no\": null, \"refunds\": { \"object\": \"list\", \"url\": \"/v1/charges/ch_nv9yH0rnHSiLXrzHC4rjT848/refunds\", \"has_more\": false, \"data\": [] }, \"amount_refunded\": 0, \"failure_code\": null, \"failure_msg\": null, \"metadata\": {}, \"credential\": { \"object\": \"credential\", \"alipay\": { \"orderInfo\": \"service=\\\"mobile.securitypay.pay\\\"&_input_charset=\\\"utf-8\\\"&notify_url=\\\"https%3A%2F%2Fapi.pingxx.com%2Fnotify%2Fcharges%2Fch_nv9yH0rnHSiLXrzHC4rjT848\\\"&partner=\\\"2088911456459895\\\"&out_trade_no=\\\"930511011739138002\\\"&subject=\\\"TaoXiaoQi\\\"&body=\\\"PayForGoods\\\"&total_fee=\\\"2900.00\\\"&payment_type=\\\"1\\\"&seller_id=\\\"2088911456459895\\\"&it_b_pay=\\\"2016-03-12 11:43:21\\\"&sign=\\\"L1Q5NoSqD7LyGK5jXFq4U46WHpyrTyQT9rTnck1R2TEC6xKwH3RXdEqHuPtm5pMsfjQ7zaRTwbyYSRxZD812%2FusujxTAZO%2FKtahiJuod7oCSoEbyNkGW5M2%2Br3%2F%2FJsIN%2Bw3g1yIkuGBs%2F0JS82Sp6pkgEXA7GvXfuYpjXznsqDI%3D\\\"&sign_type=\\\"RSA\\\"\" } }, \"description\": null }";

        
//        charge1 = @"{ \"id\": \"ch_LiDSaLP0ajL4jTC4CGjPKWvP\", \"object\": \"charge\", \"created\": 1457599194, \"livemode\": true, \"paid\": false, \"refunded\": false, \"app\": \"app_aD0yT4DCSiH00qn9\", \"channel\": \"alipay\", \"order_no\": \"280510938483769002\", \"client_ip\": \"113.122.238.6\", \"amount\": 440000, \"amount_settle\": 440000, \"currency\": \"cny\", \"subject\": \"suibian\", \"body\": \"test\", \"extra\": {}, \"time_paid\": null, \"time_expire\": 1457685594, \"time_settle\": null, \"transaction_no\": null, \"refunds\": { \"object\": \"list\", \"url\": \"/v1/charges/ch_LiDSaLP0ajL4jTC4CGjPKWvP/refunds\", \"has_more\": false, \"data\": [] }, \"amount_refunded\": 0, \"failure_code\": null, \"failure_msg\": null, \"metadata\": {}, \"credential\": { \"object\": \"credential\", \"alipay\": { \"orderInfo\": \"service=\\\"mobile.securitypay.pay\\\"&_input_charset=\\\"utf-8\\\"&notify_url=\\\"https%3A%2F%2Fapi.pingxx.com%2Fnotify%2Fcharges%2Fch_LiDSaLP0ajL4jTC4CGjPKWvP\\\"&partner=\\\"2088911456459895\\\"&out_trade_no=\\\"280510938483769002\\\"&subject=\\\"suibian\\\"&body=\\\"test\\\"&total_fee=\\\"4400.00\\\"&payment_type=\\\"1\\\"&seller_id=\\\"2088911456459895\\\"&it_b_pay=\\\"2016-03-11 16:39:54\\\"&sign=\\\"Xj06AJPPLQih1ZGTs3KN7X6kQByPkoHrJALN1PMa%2FqGEC8ev7PehCeGKR4smB93eOOdCDshuXWL%2F04wZadHAADeQt11iyk4rQyJAHOJvKZATmdjQEof5PVyOKAyUq5E7dhuhOPWlKrJjR2jg%2Bd4OJvh%2F030eYCKT1kGWvYfWWeI%3D\\\"&sign_type=\\\"RSA\\\"\" } }, \"description\": null }";
        
//        charge1 =  @"{ \"id\" : \"ch_00u9y9XHSirT4G8GqTCKy9a1\",  \"object\" : \"charge\", \"created\" : 1457659840, \"livemode\" : true,\"paid\" : false,\"refunded\" : false,\"app\" : \"app_aD0yT4DCSiH00qn9\",\"channel\" : \"alipay\",\"order_no\" : \"610511003777833002\",\"client_ip\" : \"113.122.238.6\",\"amount\" : 290000,\"amount_settle\" : 290000,\"currency\" : \"cny\",\"subject\" : \"TaoXiaoQi\", \"body\" : \"PayForGoods\", \"extra\" : {  },\"time_paid\" : null,\"time_expire\" : 1457746240, \"time_settle\" : null,\"transaction_no\" : null,   \"refunds\" : {\"object\" : \"list\", \"url\" : \"/v1/charges/ch_00u9y9XHSirT4G8GqTCKy9a1/refunds\" ,\"has_more\" : false,  \"data\" : [] },\"amount_refunded\" : 0, \"failure_code\" : null, \"failure_msg\" : null,\"metadata\" : {},    \"credential\" : { \"object\" : \"credential\" , \"alipay\" : {      \"orderInfo\" : \"service=\\\"mobile.securitypay.pay\\\"&_input_charset=\\\"utf-8\\\"&notify_url=\\\"https%3A%2F%2Fapi.pingxx.com%2Fnotify%2Fcharges%2Fch_00u9y9XHSirT4G8GqTCKy9a1\\\"&partner=\\\"2088911456459895\\\"&out_trade_no=\\\"610511003777833002\\\"&subject=\\\"TaoXiaoQi\\\"&body=\\\"PayForGoods\\\"&total_fee=\\\"2900.00\\\"&payment_type=\\\"1\\\"&seller_id=\\\"2088911456459895\\\"&it_b_pay=\\\"2016-03-12 09:30:40\\\"&sign=\\\"EJSwdCs5xm5OTXMFzRmCvRDJXO7bLyWDZuspI09doZfA0ElFuOV7gQUJsrOaHozmPEF5RQhK2ZI%2FQrUBrPNR39r%2FJbCadkzEhUi26ppXivRe8SX%2BpQyksqqX5mtiTg5pDwbFlDki4OFLwvqIedIddTuoILMinK9oZXGu6%2FvB2vs%3D\\\"&sign_type=\\\"RSA\\\"\"    }},\"description\" : null }";
        DLog(@"%@",charge);
//
//        NSString *charge = @"{ \"id\": \"ch_DOOOO8Ty5iHGebfDa110e5WH\", \"object\": \"charge\", \"created\": 1457591618, \"livemode\": true, \"paid\": false, \"refunded\": false, \"app\": \"app_aD0yT4DCSiH00qn9\", \"channel\": \"alipay\", \"order_no\": \"590510934126753002\", \"client_ip\": \"113.122.238.219\", \"amount\": 2370000, \"amount_settle\": 2370000, \"currency\": \"cny\", \"subject\": \"suibian\", \"body\": \"test\", \"extra\": {}, \"time_paid\": null, \"time_expire\": 1457678018, \"time_settle\": null, \"transaction_no\": null, \"refunds\": { \"object\": \"list\", \"url\": \"/v1/charges/ch_DOOOO8Ty5iHGebfDa110e5WH/refunds\", \"has_more\": false, \"data\": [] }, \"amount_refunded\": 0, \"failure_code\": null, \"failure_msg\": null, \"metadata\": {}, \"credential\": { \"object\": \"credential\", \"alipay\": { \"orderInfo\": \"service=\\\"mobile.securitypay.pay\\\"&_input_charset=\\\"utf-8\\\"&notify_url=\\\"https%3A%2F%2Fapi.pingxx.com%2Fnotify%2Fcharges%2Fch_DOOOO8Ty5iHGebfDa110e5WH\\\"&partner=\\\"2088911456459895\\\"&out_trade_no=\\\"590510934126753002\\\"&subject=\\\"suibian\\\"&body=\\\"test\\\"&total_fee=\\\"23700.00\\\"&payment_type=\\\"1\\\"&seller_id=\\\"2088911456459895\\\"&it_b_pay=\\\"2016-03-11 14:33:38\\\"&sign=\\\"R96%2BLc2%2Bk%2FsmJqvBAoeic5UG5f2XrpofC4iXiG4yFWBwIclXq6BL6I8KlzBmvb3XeW67bmOrVg%2Fobt5gzch9PZrXOdFYCeIATi47u9Seu1Ade%2F4%2FjDoXdqQJd6ixBdZMJ5%2BnE6G5gpUUZ6kLcY7cfKI2X8ekMNaZBmXJGCyWPRw%3D\\\"&sign_type=\\\"RSA\\\"\" } }, \"description\": null }";
//        DLog(@"str_data:%@",charge);

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
                           }];
                       });
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}



-(void)addorder:(NSDictionary *)infoDict
{
    
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        DLog(@"^^^^%@", resultDict );
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dingdantijiaowancheng" object:nil ];
            dingDanNum=[[resultDict objectForKey:@"data"]objectForKey:@"pay_sn"];
            goodsName=[[[[[[resultDict objectForKey:@"data"] objectForKey:@"order_list"] objectAtIndex:0]objectForKey:@"order_goods"] objectAtIndex:0] objectForKey:@"goods_name"];
            if ([[dicPost objectForKey:@"pay_method"]isEqualToString:@"online"]) {
                if (pay_method==ali_pay) {
                    [self gotoAlipay];
                }else if(pay_method==weixin_pay){
                    [self gotoWxpay];
                }

                DataProvider *dataProvider1 = [[DataProvider alloc] init];
                [dataProvider1 setFinishBlock:^(NSDictionary *resultDict){
                    NSLog(@"减免-----%@-----",resultDict);
                }];
                [dataProvider1 setFailedBlock:^(NSString* strError){
                    NSLog(@"减免fail-----%@-----",strError);
                }];
                [dataProvider1 updateMobileDiscout:dingDanNum pay_method:[NSString stringWithFormat:@"在线支付满%.2f减%.2f",minTotalPrice,onLinePayDiscount] discount:[NSString stringWithFormat:@"%.2f",onLinePayDiscount]];

            }
            else{
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"订单提交成功，请耐心等待～" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
                [alert setTag:1006];
            }
   
        }
        else{
            NSString* err=[resultDict objectForKey:@"message"];
            if ([[resultDict objectForKey:@"result"] intValue]==6834) {
                [Dialog simpleToast:@"亲，请选择收货地址"];
            }
            else if([[resultDict objectForKey:@"result"] intValue]==6833){
                [Dialog simpleToast:@"亲，请选择收货地址"];
            }else {
                [Dialog simpleToast:err];
            }
            
        }
        
        
        
    }];
    
    [dataProvider setFailedBlock:^(NSString *strError){
        [SVProgressHUD dismiss];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"检查网络！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        
    }];
    
    [dataProvider addOrder:infoDict];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1006) {
        if (buttonIndex==0) {
            CustomTabBarViewController * tabbar=[(AppDelegate *)[[UIApplication sharedApplication] delegate] getTabBar];
            [tabbar selectTableBarIndex:0];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    if (alertView.tag==1007) {
        if (buttonIndex==1) {
            if ([dicPost objectForKey:@"address_id"]==nil) {
                [Dialog simpleToast:@"亲，请选择收货地址"];
                return;
            }
            
            
            
            if ([strType isEqualToString:@"buynow"]) {
                
            }
            else{
                NSMutableArray *arrayCartId=[[NSMutableArray alloc]init];
                for (int i=0;i<arrayCartList.count; i++) {
                    
                    [arrayCartId addObject:[ [arrayCartList   objectAtIndex:i] objectForKey:@"cart_id"]];
                    
                }
                NSString *string2 = [arrayCartId componentsJoinedByString:@","];
                [dicPost setObject:string2 forKey:@"cart_id"];
            }
           
            
            if ([[dicPost objectForKey:@"ship_method"]isEqualToString:@"delivery"]&&[[dicPost objectForKey:@"pay_method"]isEqualToString:@"online"]) {//配送 支付宝
                
            }
            else if ([[dicPost objectForKey:@"ship_method"]isEqualToString:@"delivery"]&&[[dicPost objectForKey:@"pay_method"]isEqualToString:@"offline"])//配送 货到付款
            {
                
            }
            else if ([[dicPost objectForKey:@"ship_method"]isEqualToString:@"self_take"]&&[[dicPost objectForKey:@"pay_method"]isEqualToString:@"online"])//自提 支付宝
            {
                 
            }
            else if ([[dicPost objectForKey:@"ship_method"]isEqualToString:@"self_take"]&&[[dicPost objectForKey:@"pay_method"]isEqualToString:@"offline"])//自提 货到付款
            {
                
            }
            [self addorder:dicPost];
        }
    }
    
}

-(void)gotoWxpay{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxpaySuccess) name:@"wxpaySuccess" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxpayFail) name:@"wxpayFail" object:nil];
//    
//    NSString* orderPrice;
//    //{{{
//    //本实例只是演示签名过程， 请将该过程在商户服务器上实现
//    
//    //创建支付签名对象
//    payRequsestHandler *req = [[payRequsestHandler alloc] init];
//    //初始化支付签名对象
//    [req init:APP_ID mch_id:MCH_ID];
//    //设置密钥
//    [req setKey:PARTNER_ID];
//    
//    //}}}
//    if ((totalPrice+[self.strFreightPrice floatValue])>minTotalPrice) {
//        orderPrice = [NSString stringWithFormat:@"%.2f",totalPrice+[self.strFreightPrice floatValue]-onLinePayDiscount];
//        
//    }
//    else{
//        orderPrice= [NSString stringWithFormat:@"%.2f",totalPrice+[self.strFreightPrice floatValue]];
//    }
//    
//    orderPrice=[NSString stringWithFormat:@"%.0f"  ,  [orderPrice floatValue]*100];
//    //获取到实际调起微信支付的参数后，在app端调起支付
//    NSMutableDictionary *dict = [req sendPayWithOrderName:@"懒豆商城商品" orderPrice:orderPrice orderNo:dingDanNum];
//    
//    if(dict == nil){
//        //错误提示
//        NSString *debug = [req getDebugifo];
//        
//        [self alert:@"提示信息" msg:debug];
//        
//        NSLog(@"%@\n\n",debug);
//    }else{
//        NSLog(@"%@\n\n",[req getDebugifo]);
//        //[self alert:@"确认" msg:@"下单成功，点击OK后调起支付！"];
//        
//        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
//        
//        //调起微信支付
//        PayReq* req             = [[PayReq alloc] init];
//        req.openID              = [dict objectForKey:@"appid"];
//        req.partnerId           = [dict objectForKey:@"partnerid"];
//        req.prepayId            = [dict objectForKey:@"prepayid"];
//        req.nonceStr            = [dict objectForKey:@"noncestr"];
//        req.timeStamp           = stamp.intValue;
//        req.package             = [dict objectForKey:@"package"];
//        req.sign                = [dict objectForKey:@"sign"];
//        
//        //[WXApi safeSendReq:req];
//        [WXApi sendReq:req];
//    }

    [self realPay:@"wx"];
    
}
//客户端提示信息
- (void)alert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alter show];

}
/**
 *  微信支付完成的回调
 *
 *  @param resp 返回参数信息
 */
-(void) onResp:(BaseResp*)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，微信支付结果
        strTitle = [NSString stringWithFormat:@"支付结果"];
        NSLog(@"surecart status");
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
    }
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //    [alert show];
    
}
-(void)wxpaySuccess{
    CartStateController *CartState=[[CartStateController alloc]init];
    CartState.strPrice=[NSString stringWithFormat:@"%.2f",totalPrice];
    CartState.strNum=dingDanNum;
    CartState.strName=goodsName;
   

    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        DLog(@"sure-cart:%@",resultDict);
    }];
    
    [dataProvider setFailedBlock:^(NSString *strError){
        
    }];
    
    [dataProvider payorder:dingDanNum];

            
            
    CartState.strState=@"success";
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"wxpaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"wxpayFail" object:nil];
    
        [self.navigationController pushViewController:CartState animated:YES];
}
-(void)wxpayFail{
    CartStateController *CartState=[[CartStateController alloc]init];
    CartState.strPrice=[NSString stringWithFormat:@"%.2f",totalPrice];
    CartState.strNum=dingDanNum;
    CartState.strName=goodsName;
   
            
            CartState.strState=@"failed";
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"wxpaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"wxpayFail" object:nil];
        
        [self.navigationController pushViewController:CartState animated:YES];
}
@end
