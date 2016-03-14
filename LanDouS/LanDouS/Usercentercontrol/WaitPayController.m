//
//  WaitPayController.m
//  LanDouS
//
//  Created by Mao-MacPro on 15/1/16.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import "WaitPayController.h"
#import "DataProvider.h"
#import "AppDelegate.h"
#import "ShopCartCell.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "WaitPayCell.h"
#import "CellView.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "APAuthV2Info.h"
#import "DataSigner.h"
#import "GoodDetailController.h"
#import "payRequsestHandler.h"
#import "WXApi.h"
#import "CartStateController.h"
@interface WaitPayController ()

@end

@implementation WaitPayController
@synthesize imgNoData;
- (void)viewDidLoad {
    [super viewDidLoad];
    page=1;
    perpage=20;
    _lblTitle.textColor=[UIColor whiteColor];
//    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
////    image.image=[UIImage imageNamed:@"navgreen.png"];
//    [_topView addSubview:image];
//    _topView.backgroundColor=[UIColor colorWithRed:0.51 green:0.57 blue:0.29 alpha:1];
    [self addLeftButton:@"whiteback@2x.png"];
    [self setBarTitle:@"待付款"];
    arrayWaitpay=[[NSMutableArray alloc]init];
    tableWaitpay = [[UITableView alloc] initWithFrame:CGRectMake(0,NavigationBar_HEIGHT+20, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    [tableWaitpay addHeaderWithTarget:self action:@selector(headerRereshing)];
    
    //[table_appointment headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [tableWaitpay addFooterWithTarget:self action:@selector(footerRereshing)];
    tableWaitpay.dataSource = self;
    tableWaitpay.delegate = self;
    
    [self.view addSubview:tableWaitpay];
    
    [self getWaitPayList];
    [self getDiscountSetting];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}
- (void)headerRereshing
{
    page=1;
    
    [self getWaitPayList];
    
}

- (void)footerRereshing
{
    page=page+1;
    
    [self getmoreWaitPayList];
}
-(void)getDiscountSetting
{
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        
        NSLog(@"getdiscount^^^^%@", resultDict );
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            if ([[resultDict objectForKey:@"list"]isKindOfClass:[NSArray class]]) {
                if ([[resultDict objectForKey:@"list"] count]>0) {
                    minTotalPrice=[[[[resultDict objectForKey:@"list"]objectAtIndex:0] objectForKey:@"min_total_price"] floatValue];
                    onLinePayDiscount=[[[[resultDict objectForKey:@"list"]objectAtIndex:0] objectForKey:@"online_pay_discount"] floatValue];
                    
                }
            }
            
            
            [tableWaitpay reloadData];
            
            
            
        }
        else{
            
        }
    }];
    
    [dataProvider setFailedBlock:^(NSString *strError){
        
        
        
    }];
    
    [dataProvider getDiscountSetting];
}
-(void)getWaitPayList
{
    [SVProgressHUD showWithStatus:@"正在加载"];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        DLog(@"getwaitpaylist^^^^%@", resultDict );
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            [arrayWaitpay removeAllObjects];
            if ([[resultDict objectForKey:@"list"]isKindOfClass:[NSArray class]]) {
                imgNoData.hidden=YES;
                tableWaitpay.hidden=NO;
                if ([[resultDict objectForKey:@"list"]count]>0) {
                    for (int i=0; i<[[resultDict objectForKey:@"list"]count]; i++) {
                        [arrayWaitpay addObject: [[resultDict objectForKey:@"list"]objectAtIndex:i ]];
                    }
                }
            }
            
            else{
                imgNoData.hidden=NO;
                tableWaitpay.hidden=YES;
//                [Dialog simpleToast:@"暂无信息"];
            }
            
          [tableWaitpay reloadData];
        }
        else{
            
        }
         [tableWaitpay headerEndRefreshing];
        
        
    }];
    
    [dataProvider setFailedBlock:^(NSString *strError){
        [SVProgressHUD dismiss];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"检查网络！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [tableWaitpay headerEndRefreshing];
    }];
    [dataProvider getOrderList:@"10" andpage:page andPerPage:perpage];
    //[dataProvider getStoreList:@"nothing" andPage:shopPage andPerpage:shopPerpage];
}
-(void)getmoreWaitPayList
{
    [SVProgressHUD showWithStatus:@"正在加载"];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        NSLog(@"morelist^^^^%@", resultDict );
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            if ([[resultDict objectForKey:@"list"]isKindOfClass:[NSArray class]]) {
                if ([[resultDict objectForKey:@"list"]count]>0) {
                    
                    for (int i=0; i<[[resultDict objectForKey:@"list"]count]; i++) {
                        [arrayWaitpay addObject: [[resultDict objectForKey:@"list"]objectAtIndex:i ]];
                    }
                    
                }
                [tableWaitpay reloadData];
                
            }
        }
        else{
            
        }
        [tableWaitpay footerEndRefreshing];
        
        
    }];
    
    [dataProvider setFailedBlock:^(NSString *strError){
        [SVProgressHUD dismiss];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"检查网络！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [tableWaitpay footerEndRefreshing];
    }];
    [dataProvider getOrderList:@"10" andpage:page andPerPage:perpage];
    //[dataProvider getStoreList:@"nothing" andPage:shopPage andPerpage:shopPerpage];
}
#pragma mark tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return arrayWaitpay.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
//    int count=0;
//    for (int i=0; i<[[[arrayWaitpay objectAtIndex:section] objectForKey:@"order_list"]count]; i++) {
//        for (int j=0; j<[[[[[arrayWaitpay objectAtIndex:section] objectForKey:@"order_list"] objectAtIndex:i] objectForKey:@"order_goods"] count]; j++) {
//            count=count+1;
//        }
//    }
    
    return [[[arrayWaitpay objectAtIndex:section] objectForKey:@"order_list"]count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    UITableViewCell *cell = [tableView
    //                             dequeueReusableCellWithIdentifier:@"Cell"];
    static NSString *CellIdentifier = @"WaitPayCellIdentifier";
    WaitPayCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"WaitPayCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        //cell.backgroundColor=[UIColor colorWithRed:0.94 green:0.95 blue:0.95 alpha:1];
    }
    cell.lblReminder.hidden=YES;
//    cell.lblDingdan.text=[NSString stringWithFormat:@"订单号：%@",[[[[arrayWaitpay objectAtIndex:indexPath.section] objectForKey:@"order_list"] objectAtIndex:indexPath.row] objectForKey:@"order_sn"]];
    
    for (int i=0; i<[[[[[arrayWaitpay objectAtIndex:indexPath.section] objectForKey:@"order_list"] objectAtIndex:indexPath.row] objectForKey:@"order_goods"] count]; i++) {
        CellView *view=[[CellView alloc]initWithFrame:CGRectMake(0,118*i+10, SCREEN_WIDTH, 118)];
        view.lblgoodsName.text=[[[[[[arrayWaitpay objectAtIndex:indexPath.section] objectForKey:@"order_list"] objectAtIndex:indexPath.row] objectForKey:@"order_goods"] objectAtIndex:i] objectForKey:@"goods_name"];
        view.lblPrice.text=[NSString stringWithFormat:@"￥%@",[[[[[[arrayWaitpay objectAtIndex:indexPath.section] objectForKey:@"order_list"] objectAtIndex:indexPath.row] objectForKey:@"order_goods"] objectAtIndex:i] objectForKey:@"goods_price"]];
        view.lblNum.text=[NSString stringWithFormat:@"x%@",[[[[[[arrayWaitpay objectAtIndex:indexPath.section] objectForKey:@"order_list"] objectAtIndex:indexPath.row] objectForKey:@"order_goods"] objectAtIndex:i] objectForKey:@"goods_num"]];
        
        NSString *shopid=[[[[arrayWaitpay objectAtIndex:indexPath.section] objectForKey:@"order_list"] objectAtIndex:indexPath.row] objectForKey:@"store_id"];
        
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",GOODS_IMG_URL,shopid,[[[[[[arrayWaitpay objectAtIndex:indexPath.section] objectForKey:@"order_list"] objectAtIndex:indexPath.row] objectForKey:@"order_goods"] objectAtIndex:i] objectForKey:@"goods_image"]]];
        
        [view.imgGoods setImageWithURL:url placeholderImage:img(@"landou_square_default.png")];
        view.btnGoodsDetail.tag=i+750;
        [view.btnGoodsDetail addTarget:self action:@selector(gotoGoodsDetail:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:view];
        
    }
    cell.btnCancel.layer.borderWidth=0.6;
    
    cell.btnCancel.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    [cell.btnCancel.layer setMasksToBounds:YES];
    [cell.btnCancel.layer setCornerRadius:6.0];

    [cell.btnCancel setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [cell.btnCancel addTarget:self action:@selector(cancellist:) forControlEvents:UIControlEventTouchUpInside];

    
    
 
    
    
    
    
    // Configure the cell...
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *viewsectionHeader=[[UIView alloc]init];
    viewsectionHeader.backgroundColor=[UIColor whiteColor];
    
    UILabel *lbltitle = [[UILabel alloc] initWithFrame:CGRectMake(10,5,SCREEN_WIDTH,30)];
    if ([[[arrayWaitpay objectAtIndex:section]objectForKey:@"order_list"]count]>1) {
        lbltitle.text =[NSString stringWithFormat:@"付款单号：%@",[[arrayWaitpay objectAtIndex:section]objectForKey:@"pay_sn"]];
    }
    else{
        lbltitle.text =[[[[arrayWaitpay objectAtIndex:section]objectForKey:@"order_list"] objectAtIndex:0]objectForKey:@"store_name"];
    }
    
    lbltitle.text=[NSString stringWithFormat:@"订单号：%@",[[[[arrayWaitpay objectAtIndex:section] objectForKey:@"order_list"] objectAtIndex:0] objectForKey:@"order_sn"]];
    lbltitle.numberOfLines = 0;
    //lbltitle.textAlignment=NSTextAlignmentRight;
    lbltitle.font = [UIFont systemFontOfSize:14.0];
    lbltitle.textColor = [UIColor blackColor];
    lbltitle.backgroundColor = [UIColor whiteColor];
    [viewsectionHeader addSubview:lbltitle];
    UIImageView *imageline1=[[UIImageView alloc]initWithFrame:CGRectMake(0,36, SCREEN_WIDTH, 1)];
    imageline1.backgroundColor=[UIColor colorWithRed:0.97 green:0.96 blue:0.96 alpha:1];
    [viewsectionHeader addSubview:imageline1];
    UIImageView *imagecolor=[[UIImageView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 3)];
    imagecolor.image=[UIImage imageNamed:@"colorline.png"];
    [viewsectionHeader addSubview:imagecolor];
    return viewsectionHeader;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *viewFooter=[[UIView alloc]initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,20)];
    viewFooter.backgroundColor=[UIColor whiteColor];
    //viewFooter.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    
    UILabel *lblDiscount = [[UILabel alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH-20, 30)];
    
    lblDiscount.numberOfLines = 0;
    lblDiscount.textAlignment=NSTextAlignmentRight;
    lblDiscount.font = [UIFont systemFontOfSize:13];
    lblDiscount.textColor = [UIColor blackColor];
    lblDiscount.backgroundColor = [UIColor clearColor];
    [viewFooter addSubview:lblDiscount];
    float yunFei=[[[[[arrayWaitpay objectAtIndex:section]objectForKey:@"order_list"]objectAtIndex:0] objectForKey:@"shipping_fee"] floatValue];
    if (minTotalPrice>0) {
        
        if (yunFei>0) {
            lblDiscount.text =[NSString stringWithFormat:@"在线支付满%.2f元优惠%.2f元      运费￥%.2f",minTotalPrice,onLinePayDiscount,yunFei];
        }
        else
        {
            lblDiscount.text =[NSString stringWithFormat:@"在线支付满%.2f元优惠%.2f元      免运费",minTotalPrice,onLinePayDiscount];
        }
        
    }
    //lblDiscount.text =@"QQ";
    
    
    UILabel *lblPrice = [[UILabel alloc] initWithFrame:CGRectMake(0,30,SCREEN_WIDTH-20,30)];
    
    
    int count=0;
    for (int i=0; i<[[[arrayWaitpay objectAtIndex:section] objectForKey:@"order_list"]count]; i++) {
        for (int j=0; j<[[[[[arrayWaitpay objectAtIndex:section] objectForKey:@"order_list"] objectAtIndex:i] objectForKey:@"order_goods"] count]; j++) {
            count=count+1;
        }
    }
    float totalprice=0;
    for (int i=0; i<[[[arrayWaitpay objectAtIndex:section] objectForKey:@"order_list"]count]; i++) {
            totalprice=totalprice+[[[[[arrayWaitpay objectAtIndex:section] objectForKey:@"order_list"] objectAtIndex:i]objectForKey:@"goods_amount"] floatValue];
        
    }
    if ((totalprice+yunFei)>minTotalPrice) {
        lblPrice.text=[NSString stringWithFormat:@"共%d件商品  合计：￥%.2f",count,totalprice+yunFei-onLinePayDiscount];
        
    }
    else{
        lblPrice.text=[NSString stringWithFormat:@"共%d件商品  合计：￥%.2f",count,totalprice+yunFei];
        //lblYunFei.text=[NSString stringWithFormat:@"运费(￥%@)，在线支付满%.2f元立减%.2f",self.strFreightPrice,minTotalPrice,onLinePayDiscount];
        
        
        //lblYunFei.text=[NSString stringWithFormat:@"(运费:￥5.00，在线支付减免:￥2.00)"];
    }
    //lblPrice.text =[NSString stringWithFormat:@"共%d件商品  合计：￥%.2f",count,totalprice];
    lblPrice.numberOfLines = 0;
    lblPrice.textAlignment=NSTextAlignmentRight;
    lblPrice.font = [UIFont boldSystemFontOfSize:13.0];
    lblPrice.textColor =[UIColor colorWithRed:0.91 green:0.62 blue:0.25 alpha:1];
    lblPrice.backgroundColor = [UIColor whiteColor];
    [viewFooter addSubview:lblPrice];
    UIImageView *imageline1=[[UIImageView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 1)];
    imageline1.backgroundColor=[UIColor colorWithRed:0.97 green:0.96 blue:0.96 alpha:1];
    [viewFooter addSubview:imageline1];
    UIImageView *imageline2=[[UIImageView alloc]initWithFrame:CGRectMake(0,60, SCREEN_WIDTH, 1)];
    imageline2.backgroundColor=[UIColor colorWithRed:0.97 green:0.96 blue:0.96 alpha:1];
    [viewFooter addSubview:imageline2];
    
    
    
//    UIButton *btncancel=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-200, 35,80, 30)];
//    [btncancel setTitle:@"取消订单" forState:UIControlStateNormal];
//    btncancel.titleLabel.font=[UIFont systemFontOfSize:13.0] ;
//    btncancel.layer.borderWidth=0.6;
//    
//    btncancel.layer.borderColor=[[UIColor lightGrayColor]CGColor];
//    [btncancel.layer setMasksToBounds:YES];
//    [btncancel.layer setCornerRadius:6.0];
//    
//    [btncancel setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    btncancel.tag=2000+section;
//    [btncancel addTarget:self action:@selector(cancelclick:) forControlEvents:UIControlEventTouchUpInside];
//    btncancel.backgroundColor=[UIColor whiteColor];
//    [viewFooter addSubview:btncancel];
    
    UIButton *btnpay=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-90, 62,80, 30)];
    [btnpay setTitle:@"去付款" forState:UIControlStateNormal];
    btnpay.titleLabel.font=[UIFont systemFontOfSize:13.0] ;
    btnpay.tag=2001+section;
//    btnpay.layer.borderWidth=0.6;
//    btnpay.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    [btnpay.layer setMasksToBounds:YES];
    [btnpay.layer setCornerRadius:6.0];
    [btnpay addTarget:self action:@selector(payclick:) forControlEvents:UIControlEventTouchUpInside];
    btnpay.backgroundColor=[UIColor orangeColor];
    [viewFooter addSubview:btnpay];
    
    
    UIImageView *imageBG=[[UIImageView alloc]initWithFrame:CGRectMake(0, 92,SCREEN_WIDTH,10)];
    imageBG.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    //imageBG.image=[UIImage imageNamed:@"line_01.png"];
    [viewFooter addSubview:imageBG];
    
    return viewFooter;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 36;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 102;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120*[[[[[arrayWaitpay objectAtIndex:indexPath.section] objectForKey:@"order_list"]objectAtIndex:indexPath.row] objectForKey:@"order_goods"] count]+30;
}
//-(void)cancelclick:(UIButton *)sender
//{
//    NSLog(@"***%d",sender.tag-2000);
//}
-(void)gotoGoodsDetail:(UIButton *)sender
{
    WaitPayCell * cell;
    if ([Toolkit isSystemIOS8]) {
        cell=  (WaitPayCell *)[[[sender  superview]superview]superview] ;
    }else{
        cell=  (WaitPayCell *)[[[[sender superview] superview]superview]superview];
    }
    NSIndexPath * path = [tableWaitpay indexPathForCell:cell];
//    NSLog(@"***%ld***%ld****%d",(long)path.section,(long)path.row,sender.tag-700);
    
    
    
    
    
    GoodDetailController *GoodDetail=[[GoodDetailController alloc]init];
    GoodDetail.goodsId=[[[[[[arrayWaitpay objectAtIndex:path.section] objectForKey:@"order_list"] objectAtIndex:path.row] objectForKey:@"order_goods"] objectAtIndex:sender.tag-750] objectForKey:@"goods_id"];
    [self.navigationController pushViewController:GoodDetail animated:YES];
    
}





#pragma mark - actionsheet-delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%ld",buttonIndex);
    switch (buttonIndex) {
        case 0:
            //TODO: alipay
            [self gotoAlipay];
            break;
            case 1:
            //TODO: weixinpay
            [self gotoWxpay];
            break;
        default:
            break;
    }
}
-(void)payclick:(UIButton *)sender
{
    
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"请选择付款方式"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"支付宝", @"微信支付",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
//
    NSInteger section=sender.tag-2001;
    pay_sn=[[arrayWaitpay objectAtIndex:sender.tag-2001] objectForKey:@"pay_sn"];
    
    float totalprice=0;
    for (int i=0; i<[[[arrayWaitpay objectAtIndex:section] objectForKey:@"order_list"]count]; i++) {
        totalprice=totalprice+[[[[[arrayWaitpay objectAtIndex:section] objectForKey:@"order_list"] objectAtIndex:i]objectForKey:@"goods_amount"] floatValue];
        
    }
    
    float yunFei=[[[[[arrayWaitpay objectAtIndex:section]objectForKey:@"order_list"]objectAtIndex:0] objectForKey:@"shipping_fee"] floatValue];
    
    
    
    if ((totalprice+yunFei)>minTotalPrice) {
          realpaymoney=totalprice+yunFei-onLinePayDiscount;
        
    }
    else{
        realpaymoney=totalprice+yunFei;
        //lblYunFei.text=[NSString stringWithFormat:@"运费(￥%@)，在线支付满%.2f元立减%.2f",self.strFreightPrice,minTotalPrice,onLinePayDiscount];
        
        
        //lblYunFei.text=[NSString stringWithFormat:@"(运费:￥5.00，在线支付减免:￥2.00)"];
    }
    

//    
//    
}
-(void)cancellist:(UIButton *)sender
{
    WaitPayCell * cell;
    if ([Toolkit isSystemIOS8]) {
        cell=  (WaitPayCell *)[[sender  superview]superview] ;
    }else{
        cell=  (WaitPayCell *)[[[sender superview] superview]superview];
    }
    NSIndexPath * path = [tableWaitpay indexPathForCell:cell];
    NSLog(@"******%ld",(long)path.row);
    sectionID=path.section;
    rowID=path.row;
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"确认取消该订单？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    alert.tag=700;
    
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==700) {
        if (buttonIndex==1) {
            [self cancelorder:[[[[arrayWaitpay objectAtIndex:sectionID] objectForKey:@"order_list"] objectAtIndex:rowID] objectForKey:@"order_id"]];
        }
    }
}
-(void)cancelorder:(NSString *)orderId
{
    [SVProgressHUD showWithStatus:@"正在加载"];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        NSLog(@"取消订单^^^^%@", resultDict );
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
    [dataProvider cancelOrder:orderId];
    //[dataProvider getStoreList:@"nothing" andPage:shopPage andPerpage:shopPerpage];
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
//    order.tradeNO =pay_sn; //订单ID（由商家自行制定）
//    order.productName = @"懒豆商城订单"; //商品标题
//    order.productDescription = @"懒豆商城订单"; //商品描述
//    order.amount = [NSString stringWithFormat:@"%.2f",realpaymoney]; //商品价格
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
//                 //付款成功
//                [self payOrder:pay_sn];
//                
//            }
//            else{
//                //付款失败
//                [Dialog simpleToast:@"亲，订单支付失败"];
//            }
//            
//            
//            
//            
//        }];
//        
//        
//    }
    
    [self realPay:@"alipay"];
}


- (void)showAlertWait
{
    mAlert = [[UIAlertView alloc] initWithTitle:kWaiting message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
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
    mAlert = [[UIAlertView alloc] initWithTitle:kNote message:msg delegate:nil cancelButtonTitle:kConfirm otherButtonTitles:nil, nil];
    [mAlert show];
}


- (void)realPay:(NSString *)channel
{
    
    if(!([channel isEqualToString:@"wx"] || [channel isEqualToString:@"alipay"]))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"支付方式错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if(realpaymoney ==0)
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
    
    
    
    [dataProvider getPingPPChargeChannel:channel andAmount:[NSString stringWithFormat:@"%ld",(long)(realpaymoney*100)] andOrdernum:pay_sn andSubject:@"suibian" andBody:@"test"];
//    [dataProvider setDelegateObject:self setBackFunctionName:@"realPayCallBack:"];
//    [dataProvider getPingppCharge:[Toolkit getUserID]
//                       andChannel:channel
//                        andAmount:[NSString stringWithFormat:@"%d",(int)realpaymoney*100]
//                   andDescription:@"1"
//                           andFlg:@"0"];
    
}



-(void)realPayCallBack:(id)dict
{
    DLog(@"%@",dict);
    //    if ([dict[@"code"] intValue]==200) {
    @try {
        
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
        NSString* charge = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"str_data:%@",charge);
        NSRange keyWordRange =  [charge rangeOfString:@"it_b_pay=" options:NSCaseInsensitiveSearch];
        NSMutableString *mutStr = [[NSMutableString alloc] initWithString:charge];
        [mutStr insertString:@" " atIndex:(keyWordRange.length+keyWordRange.location + 12)];
        DLog(@"%@",mutStr);
        charge = mutStr;
        
        
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
                               [self showAlertMessage:result];
                           }];
                       });
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}


- (void)normalPayAction
{
    self.channel = @"alipay";
    
    long long amount = realpaymoney;
    if (amount == 0) {
        return;
    }

    NSString *amountStr = [NSString stringWithFormat:@"%lld", amount];
    NSURL* url = [NSURL URLWithString:kUrl];
    NSMutableURLRequest * postRequest=[NSMutableURLRequest requestWithURL:url];
    
    NSDictionary* dict = @{
                           @"channel" : self.channel,
                           @"amount"  : amountStr
                           };
    NSData* data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *bodyData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    [postRequest setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])]];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    

    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [self showAlertWait];
    [NSURLConnection sendAsynchronousRequest:postRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        [self hideAlert];
        if (httpResponse.statusCode != 200) {
            [self showAlertMessage:kErrorNet];
            return;
        }
        if (connectionError != nil) {
            NSLog(@"error = %@", connectionError);
            [self showAlertMessage:kErrorNet];
            return;
        }
        NSString* charge = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"charge = %@", charge);
        dispatch_async(dispatch_get_main_queue(), ^{
            [Pingpp createPayment:charge viewController:self appURLScheme:kUrlScheme withCompletion:^(NSString *result, PingppError *error) {
                NSLog(@"completion block: %@", result);
                if (error == nil) {
                    NSLog(@"PingppError is nil");
                } else {
                    NSLog(@"PingppError: code=%lu msg=%@", (unsigned  long)error.code, [error getMsg]);
                }
                [self showAlertMessage:result];
            }];
        });
    }];
}


-(void)payOrder:(NSString *)paySn
{
    DataProvider *dataProvider_=[[DataProvider alloc] init];
    [dataProvider_ setFinishBlock:^(NSDictionary *resultDict){
                NSLog(@"待付款^^^^%@", resultDict );
    }];
    [dataProvider_ setFailedBlock:^(NSString* error){
                NSLog(@"待付款fail^^^^%@", error );
    }];
   [ dataProvider_ updateMobileDiscout:pay_sn pay_method:[NSString stringWithFormat:@"在线支付满%.2f元减%.2f元",minTotalPrice,onLinePayDiscount] discount:[NSString stringWithFormat:@"%.2f",onLinePayDiscount]];
    [SVProgressHUD showWithStatus:@"正在加载"];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        NSLog(@"待付款订单支付^^^^desc:%@,------%@", [resultDict description],resultDict);
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            [Dialog simpleToast:@"YEAH，订单支付成功！"];
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
    [dataProvider payorder:paySn];
    
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
#pragma mark - weixinpay-delegate

-(void)gotoWxpay{
    
    /*
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxpaySuccess) name:@"wxpaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxpayFail) name:@"wxpayFail" object:nil];
    

    //{{{

    
    //创建支付签名对象
    payRequsestHandler *req = [[payRequsestHandler alloc] init];
    //初始化支付签名对象
    [req init:APP_ID mch_id:MCH_ID];
    //设置密钥
    [req setKey:PARTNER_ID];
    
   
    NSString* orderPrice=[NSString stringWithFormat:@"%.0f"  ,  realpaymoney*100];

    //获取到实际调起微信支付的参数后，在app端调起支付
    NSMutableDictionary *dict = [req sendPayWithOrderName:@"懒豆商城商品" orderPrice:orderPrice orderNo:pay_sn];
    
    if(dict == nil){
        //错误提示
        NSString *debug = [req getDebugifo];
        
        [self alert:@"提示信息" msg:debug];
        
        NSLog(@"%@\n\n",debug);
    }else{
        NSLog(@"%@\n\n",[req getDebugifo]);
        //[self alert:@"确认" msg:@"下单成功，点击OK后调起支付！"];
        
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = [dict objectForKey:@"appid"];
        req.partnerId           = [dict objectForKey:@"partnerid"];
        req.prepayId            = [dict objectForKey:@"prepayid"];
        req.nonceStr            = [dict objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [dict objectForKey:@"package"];
        req.sign                = [dict objectForKey:@"sign"];
        
        [WXApi sendReq:req];
    }
    */
    
    
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
        NSLog(@"surecart status，支付完成的回调：%@",resp.errStr);
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
    CartState.strPrice=[NSString stringWithFormat:@"%.2f",realpaymoney];
    CartState.strNum=pay_sn;
    CartState.strName=@"淘小七商品";
    
    
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
            [Dialog simpleToast:@"YEAH，订单支付成功！"];
        NSLog(@"pay-result-status:%@",resultDict);
    }];
    
    [dataProvider setFailedBlock:^(NSString *strError){
        
    }];
    
    [dataProvider payorder:pay_sn];
    
    
    
    CartState.strState=@"success";
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"wxpaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"wxpayFail" object:nil];
    [self.navigationController pushViewController:CartState animated:YES];
}
-(void)wxpayFail{
    [Dialog simpleToast:@"亲，订单支付失败"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"wxpaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"wxpayFail" object:nil];
}
@end
