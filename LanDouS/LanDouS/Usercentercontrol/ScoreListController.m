//
//  ScoreListController.m
//  LanDouS
//
//  Created by Mao-MacPro on 15/1/25.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import "ScoreListController.h"
#import "MJRefresh.h"
#import "DataProvider.h"
#import "UIImageView+WebCache.h"
#import "ScoreListCell.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "APAuthV2Info.h"
#import "DataSigner.h"
@interface ScoreListController ()

@end

@implementation ScoreListController

- (void)viewDidLoad {
    [super viewDidLoad];
    page=1;
    perpage=20;
//    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
//    image.image=[UIImage imageNamed:@"navgreen.png"];
//    [_topView addSubview:image];
    _lblTitle.textColor=[UIColor whiteColor];
//    _topView.backgroundColor=[UIColor colorWithRed:0.51 green:0.57 blue:0.29 alpha:1];
    [self addLeftButton:@"whiteback@2x.png"];
    
    [self setBarTitle:@"已兑换商品"];
    arrayList=[[NSMutableArray alloc]init];
    tableScore = [[UITableView alloc] initWithFrame:CGRectMake(0,NavigationBar_HEIGHT+20, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    tableScore.dataSource = self;
    tableScore.delegate = self;
    [tableScore addHeaderWithTarget:self action:@selector(headerRereshing)];
    [tableScore addFooterWithTarget:self action:@selector(footerRereshing)];
    [self.view addSubview:tableScore];
    [self headerRereshing];
    // Do any additional setup after loading the view from its nib.
}
- (void)headerRereshing
{
    page=1;
    
    [self refreshScoreList];
    
}

- (void)footerRereshing
{
    page=page+1;
    
    [self GetMoreScore];
}
-(void)refreshScoreList
{
    [SVProgressHUD showWithStatus:@"正在加载"];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        NSLog(@"^^^^%@", resultDict );
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            if ([[resultDict objectForKey:@"list"]isKindOfClass:[NSArray class]]) {
                if ([[resultDict objectForKey:@"list"]count]>0) {
                    [arrayList removeAllObjects];
                    for (int i=0; i<[[resultDict objectForKey:@"list"]count]; i++) {
                        [arrayList addObject: [[resultDict objectForKey:@"list"]objectAtIndex:i ]];
                    }
                    
                }
                [tableScore reloadData];
                
            }
            else
            {
                [Dialog simpleToast:@"暂无积分订单"];
            }
        }
        else{
            [Dialog simpleToast:@"暂无信息"];
            
        }
        [tableScore headerEndRefreshing];
        
        
    }];
    
    [dataProvider setFailedBlock:^(NSString *strError){
        [SVProgressHUD dismiss];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"检查网络！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [tableScore headerEndRefreshing];
    }];
    
    [dataProvider getPointsOrder:page andperpage:perpage];
}
-(void)GetMoreScore
{
    [SVProgressHUD showWithStatus:@"正在加载"];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        NSLog(@"^^^^%@", resultDict );
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            if ([[resultDict objectForKey:@"list"]isKindOfClass:[NSArray class]]) {
                if ([[resultDict objectForKey:@"list"]count]>0) {
                    
                    for (int i=0; i<[[resultDict objectForKey:@"list"]count]; i++) {
                        [arrayList addObject: [[resultDict objectForKey:@"list"]objectAtIndex:i ]];
                    }
                    
                }
                [tableScore reloadData];
                
            }
        }
        else{
            [Dialog simpleToast:@"暂无信息"];
        }
        [tableScore footerEndRefreshing];
        
        
    }];
    
    [dataProvider setFailedBlock:^(NSString *strError){
        [SVProgressHUD dismiss];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"检查网络！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [tableScore footerEndRefreshing];
    }];
    
    [dataProvider getPointsOrder:page andperpage:perpage];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return arrayList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    UITableViewCell *cell = [tableView
    //                             dequeueReusableCellWithIdentifier:@"Cell"];
    static NSString *CellIdentifier = @"ScoreListCellIdentifier";
    ScoreListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"ScoreListCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        //cell.backgroundColor=[UIColor colorWithRed:0.94 green:0.95 blue:0.95 alpha:1];
    }
    cell.lblGoodsName.text=[[[[arrayList objectAtIndex:indexPath.section] objectForKey:@"goods_list"] objectAtIndex:0] objectForKey:@"point_goodsname"];
    cell.lblScore.text=[NSString stringWithFormat:@"%@积分",[[[[arrayList objectAtIndex:indexPath.section] objectForKey:@"goods_list"] objectAtIndex:0] objectForKey:@"point_goodspoints"]] ;
    cell.lblGoodsNum.text=[NSString stringWithFormat:@"x%@",[[[[arrayList objectAtIndex:indexPath.section] objectForKey:@"goods_list"] objectAtIndex:0] objectForKey:@"point_goodsnum"]] ;
    float i=[[[[[arrayList objectAtIndex:indexPath.section] objectForKey:@"goods_list"] objectAtIndex:0] objectForKey:@"point_goodsnum"] floatValue]*[[[[[arrayList objectAtIndex:indexPath.section] objectForKey:@"goods_list"] objectAtIndex:0] objectForKey:@"point_goodspoints"] floatValue];
    cell.lblTotalScore.text=[NSString stringWithFormat:@"合计：%.f积分",i];
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SCORE_GOODS_URL,[[[[arrayList objectAtIndex:indexPath.section] objectForKey:@"goods_list"] objectAtIndex:0] objectForKey:@"point_goodsimage"]]];
    [cell.imgGoods setImageWithURL:url placeholderImage:img(@"landou_square_default.png")];
    
    if ([[[arrayList objectAtIndex:indexPath.section] objectForKey:@"point_orderstate"] intValue]==10) {
        [cell.btnState setTitle:@"待付款" forState:UIControlStateNormal];
    }
    else if ([[[arrayList objectAtIndex:indexPath.section] objectForKey:@"point_orderstate"] intValue]==20)
    {
         [cell.btnState setTitle:@"待发货" forState:UIControlStateNormal];
    }
    else if ([[[arrayList objectAtIndex:indexPath.section] objectForKey:@"point_orderstate"] intValue]==30)
    {
         [cell.btnState setTitle:@"待收货" forState:UIControlStateNormal];
    }
    else if ([[[arrayList objectAtIndex:indexPath.section] objectForKey:@"point_orderstate"] intValue]==40)
    {
         [cell.btnState setTitle:@"已收货" forState:UIControlStateNormal];
    }
    else if ([[[arrayList objectAtIndex:indexPath.section] objectForKey:@"point_orderstate"] intValue]==2)
    {
        [cell.btnState setTitle:@"已取消" forState:UIControlStateNormal];
    }
    
    [cell.btnState addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnCancel.layer.borderWidth=0.6;
    
    cell.btnCancel.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    [cell.btnCancel.layer setMasksToBounds:YES];
    [cell.btnCancel.layer setCornerRadius:6.0];
    
    [cell.btnCancel setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [cell.btnCancel addTarget:self action:@selector(cancelclick:) forControlEvents:UIControlEventTouchUpInside];
    if ([[[arrayList objectAtIndex:indexPath.section] objectForKey:@"point_orderstate"] intValue]==10) {
        cell.btnCancel.hidden=NO;
    }
    else if ([[[arrayList objectAtIndex:indexPath.section] objectForKey:@"point_orderstate"] intValue]==20)
    {
        cell.btnCancel.hidden=NO;
    }
    else if ([[[arrayList objectAtIndex:indexPath.section] objectForKey:@"point_orderstate"] intValue]==30)
    {
        cell.btnCancel.hidden=YES;
    }
    else if ([[[arrayList objectAtIndex:indexPath.section] objectForKey:@"point_orderstate"] intValue]==40)
    {
        cell.btnCancel.hidden=YES;
    }
    else if ([[[arrayList objectAtIndex:indexPath.section] objectForKey:@"point_orderstate"] intValue]==2)
    {
        cell.btnCancel.hidden=YES;
    }
    
    
    // Configure the cell...
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 182;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(void)btnclick:(UIButton *)sender
{
    ScoreListCell * cell;
    if ([Toolkit isSystemIOS8]) {
        cell=  (ScoreListCell *)[[sender  superview]superview] ;
    }else{
        cell=  (ScoreListCell *)[[[sender superview] superview]superview];
    }
    NSIndexPath * path = [tableScore indexPathForCell:cell];
    NSLog(@"******%ld",(long)path.row);
    indexId=path.row;
    if ([[[arrayList objectAtIndex:path.section] objectForKey:@"point_orderstate"] intValue]==10) {
        [self gotoAlipay:[[arrayList objectAtIndex:path.section] objectForKey:@"point_orderid"]];
    }
    else if ([[[arrayList objectAtIndex:path.section] objectForKey:@"point_orderstate"] intValue]==20)
    {
        
    }
    else if ([[[arrayList objectAtIndex:path.section] objectForKey:@"point_orderstate"] intValue]==30)
    {
        
    }
    else if ([[[arrayList objectAtIndex:path.section] objectForKey:@"point_orderstate"] intValue]==40)
    {
        
    }
}
-(void)cancelclick:(UIButton *)sender
{
    ScoreListCell * cell;
    if ([Toolkit isSystemIOS8]) {
        cell=  (ScoreListCell *)[[sender  superview]superview] ;
    }else{
        cell=  (ScoreListCell *)[[[sender superview] superview]superview];
    }
    NSIndexPath * path = [tableScore indexPathForCell:cell];
    NSLog(@"******%ld",(long)path.row);
    indexId=path.row;
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"确定取消该订单？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
    
//    if ([[[arrayList objectAtIndex:path.section] objectForKey:@"point_orderstate"] intValue]==10) {
//         [self cancelOrder:[[arrayList objectAtIndex:path.section] objectForKey:@"point_orderid"]];
//    }
//    else if ([[[arrayList objectAtIndex:path.section] objectForKey:@"point_orderstate"] intValue]==20)
//    {
//        
//    }
//    else if ([[[arrayList objectAtIndex:path.section] objectForKey:@"point_orderstate"] intValue]==30)
//    {
//        
//    }
//    else if ([[[arrayList objectAtIndex:path.section] objectForKey:@"point_orderstate"] intValue]==40)
//    {
//        
//    }
    
    
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
         [self cancelOrder:[[arrayList objectAtIndex:indexId] objectForKey:@"point_orderid"]];
    }
    
}


-(void)cancelOrder:(NSString *)point_orderid
{
    
    [SVProgressHUD showWithStatus:@"正在加载"];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        NSLog(@"^^^^%@", resultDict );
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            [Dialog simpleToast:@"取消订单成功"];
             [self headerRereshing];
        }
        else{
            
        }
        
        
        
    }];
    
    [dataProvider setFailedBlock:^(NSString *strError){
        [SVProgressHUD dismiss];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"检查网络！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        
    }];
    [dataProvider cancelPointsOrder:point_orderid];
    
    
}
-(void)payPointsOrder:(NSString *)point_orderid
{
    
    [SVProgressHUD showWithStatus:@"正在加载"];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        NSLog(@"^^^^%@", resultDict );
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            [Dialog simpleToast:@"支付成功"];
            [self headerRereshing];
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
- (NSString *)generateTradeNO
{
    const int N = 15;
    
    NSString *sourceString = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *result = [[NSMutableString alloc] init] ;
    srand(time(0));
    for (int i = 0; i < N; i++)
    {
        unsigned index = rand() % [sourceString length];
        NSString *s = [sourceString substringWithRange:NSMakeRange(index, 1)];
        [result appendString:s];
    }
    return result;
}
-(void)gotoAlipay:(NSString *)point_orderid
{
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"2088111293014620";
    NSString *seller = @"gazecloud@qq.com";
    NSString *privateKey = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAM4bYoENrB7PwBGNGUjEcgHk3cTZg6Pee1D5dV0iyVQHcxGsSVzBtm/wd8YeW7z6i+tON31U+SzLhfhz3HNyMZrXWNYq2fZw7wq+pzHeSIa5b3cKINv6NvTg1kUFW8JW5FLlJZqnC55+VSZx8xSNEedZ4PnZs/EETxfvK1dJzicTAgMBAAECgYA3Yn5+5XiqMvOPA9aWikuEnMbHXhgU0fVbVh2msHFfhjzys9Rm+5sVy420DHZkewNccQFSSaJH2k0e7auAzl/rm1JcWgv3jVcjqadOaLLz5i+MCJOSSNBgG9AgJ5NvXVgQEo5XsfPA99P1cGKjKgkEKt6gUkM43pszn1GbveDvcQJBAPYHBsTm/QGOkUiyXvIQNufhhBySlFn5w1XrnRCHt2zwE5UtIkSvmSBAbfEwrx4TcDuS2hm+nG/IyfBhIbJp/3sCQQDWdhy5zgdbP5uQ6/hpdccDySNJ5YO6bIojmm4qAh+wh3rqwylnYeyEMkTvD2qc/73W59B0n3oHQlgEjrYKzNdJAkEA0NM3+KuDdu3W/ViBZH9Ey19Mrp/wEcsA9Q3vHBfGJk5EoOtVWe2eUJS/fOhwy1t+eOJ2A0IaMHvChCk9291CvwJBAL3ysxKmtsFNHz5GoijWFkT2G3lR/VBa3icWmsg+RU8XT/kqjjtw8glMdN3AK8+Oe9giTfFdZrmTO14eAIKkV3ECQHivG93bIxrIkXCUXuLj/PymBtgSbQj3vXJ2pfZnxmzwJvwPSNFwNhZlaaqa248+RxPVD60nGuWD6uqxzcPIE0c=";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.productName = @"懒豆商城订单"; //商品标题
    order.productDescription = @"懒豆商城订单"; //商品描述
    order.amount = [NSString stringWithFormat:@"0.01"]; //商品价格
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
    //
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"***************&&&&&&&&reslut = %@",resultDic);
            if ([[resultDic objectForKey:@"resultStatus"] intValue]==9000) {
                //付款成功
                [self payPointsOrder:point_orderid];
            }
            else{
                //付款失败
                [Dialog simpleToast:@"支付失败"];
            }
            
            
        }];
        
        
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

@end
