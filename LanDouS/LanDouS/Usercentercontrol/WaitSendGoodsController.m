//
//  WaitSendGoodsController.m
//  LanDouS
//
//  Created by Mao-MacPro on 15/1/16.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import "WaitSendGoodsController.h"

#import "DataProvider.h"
#import "AppDelegate.h"
#import "ShopCartCell.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "WaitPayCell.h"
#import "CellView.h"
#import "GoodDetailController.h"
@interface WaitSendGoodsController ()

@end

@implementation WaitSendGoodsController
@synthesize imgNoData;
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
     [self setBarTitle:@"待发货"];
    arrayWaitpay=[[NSMutableArray alloc]init];
    tableWaitpay = [[UITableView alloc] initWithFrame:CGRectMake(0,NavigationBar_HEIGHT+20, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    [tableWaitpay addHeaderWithTarget:self action:@selector(headerRereshing)];
    
    //[table_appointment headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [tableWaitpay addFooterWithTarget:self action:@selector(footerRereshing)];
    tableWaitpay.dataSource = self;
    tableWaitpay.delegate = self;
    
    [self.view addSubview:tableWaitpay];
    
    [self getWaitSendList];
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
    
    [self getWaitSendList];
    
}

- (void)footerRereshing
{
    page=page+1;
    
    [self getmoreWaitSendList];
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
            
            
            [tableWaitpay reloadData];
            
            
            
        }
        else{
            
        }
    }];
    
    [dataProvider setFailedBlock:^(NSString *strError){
        
        
        
    }];
    
    [dataProvider getDiscountSetting];
}
-(void)getWaitSendList
{
    [SVProgressHUD showWithStatus:@"正在加载"];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        NSLog(@"^^^^%@", resultDict );
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
                [Dialog simpleToast:@"暂无信息"];
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
    [dataProvider getOrderList:@"20" andpage:page andPerPage:perpage];
    //[dataProvider getStoreList:@"nothing" andPage:shopPage andPerpage:shopPerpage];
}
-(void)getmoreWaitSendList
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
    [dataProvider getOrderList:@"20" andpage:page andPerPage:perpage];
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
    static NSString *CellIdentifier = @"WaitsendCellIdentifier";
    WaitPayCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"WaitPayCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        //cell.backgroundColor=[UIColor colorWithRed:0.94 green:0.95 blue:0.95 alpha:1];
    }
    cell.lblDingdan.text=[NSString stringWithFormat:@"订单号：%@",[[[[arrayWaitpay objectAtIndex:indexPath.section] objectForKey:@"order_list"] objectAtIndex:indexPath.row] objectForKey:@"order_sn"]];
    if ([[[[[arrayWaitpay objectAtIndex:indexPath.section] objectForKey:@"order_list"] objectAtIndex:indexPath.row] objectForKey:@"lock_state"] intValue]==1) {
        cell.lblReminder.hidden=NO;
        cell.btnCancel.hidden=YES;
    }
    else{
        cell.lblReminder.hidden=YES;
        cell.btnCancel.hidden=NO;
    }
    
    
    for (int i=0; i<[[[[[arrayWaitpay objectAtIndex:indexPath.section] objectForKey:@"order_list"] objectAtIndex:indexPath.row] objectForKey:@"order_goods"] count]; i++) {
        CellView *view=[[CellView alloc]initWithFrame:CGRectMake(0,118*i+10, SCREEN_WIDTH, 118)];
        view.lblgoodsName.text=[[[[[[arrayWaitpay objectAtIndex:indexPath.section] objectForKey:@"order_list"] objectAtIndex:indexPath.row] objectForKey:@"order_goods"] objectAtIndex:i] objectForKey:@"goods_name"];
        view.lblPrice.text=[NSString stringWithFormat:@"￥%@",[[[[[[arrayWaitpay objectAtIndex:indexPath.section] objectForKey:@"order_list"] objectAtIndex:indexPath.row] objectForKey:@"order_goods"] objectAtIndex:i] objectForKey:@"goods_price"]];
        view.lblNum.text=[NSString stringWithFormat:@"x%@",[[[[[[arrayWaitpay objectAtIndex:indexPath.section] objectForKey:@"order_list"] objectAtIndex:indexPath.row] objectForKey:@"order_goods"] objectAtIndex:i] objectForKey:@"goods_num"]];
        
        NSString *shopid=[[[[arrayWaitpay objectAtIndex:indexPath.section] objectForKey:@"order_list"] objectAtIndex:indexPath.row] objectForKey:@"store_id"];
        
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",GOODS_IMG_URL,shopid,[[[[[[arrayWaitpay objectAtIndex:indexPath.section] objectForKey:@"order_list"] objectAtIndex:indexPath.row] objectForKey:@"order_goods"] objectAtIndex:i] objectForKey:@"goods_image"]]];
        
        [view.imgGoods setImageWithURL:url placeholderImage:img(@"landou_square_default.png")];
        
        view.btnGoodsDetail.tag=i+751;
        [view.btnGoodsDetail addTarget:self action:@selector(gotoGoodsDetail:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.contentView addSubview:view];
        
    }
    //cell.btnCancel.layer.borderWidth=0.6;
    
    //cell.btnCancel.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    [cell.btnCancel.layer setMasksToBounds:YES];
    [cell.btnCancel.layer setCornerRadius:6.0];
    [cell.btnCancel setBackgroundColor:[UIColor colorWithRed:0.92 green:0.62 blue:0.25 alpha:1]];
    [cell.btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cell.btnCancel addTarget:self action:@selector(cancellist:) forControlEvents:UIControlEventTouchUpInside];
     // Configure the cell...
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *viewsectionHeader=[[UIView alloc]init];
    viewsectionHeader.backgroundColor=[UIColor whiteColor];
    
    UILabel *lbltitle = [[UILabel alloc] initWithFrame:CGRectMake(10,5,SCREEN_WIDTH,30)];
//    if ([[[arrayWaitpay objectAtIndex:section]objectForKey:@"order_list"]count]>1) {
        lbltitle.text =[NSString stringWithFormat:@"付款单号：%@",[[arrayWaitpay objectAtIndex:section]objectForKey:@"pay_sn"]];
//    }
//    else{
//        lbltitle.text =[[[[arrayWaitpay objectAtIndex:section]objectForKey:@"order_list"] objectAtIndex:0]objectForKey:@"store_name"];
//    }
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
            lblDiscount.text =[NSString stringWithFormat:@"运费￥%.2f",yunFei];
        }
        else
        {
            lblDiscount.text =[NSString stringWithFormat:@"免运费"];
        }
        
    }
    
    
    
    
    
    
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
    NSString* online_discount=    [[arrayWaitpay objectAtIndex:section] objectForKey:@"discount"];
    float discount=[online_discount isEqual:@""]?0.00:[online_discount floatValue];

    if ((totalprice+yunFei)>minTotalPrice) {
        lblPrice.text=[NSString stringWithFormat:@"共%d件商品  合计：￥%.2f",count,totalprice+yunFei-discount];
        
    }
    else{
        lblPrice.text=[NSString stringWithFormat:@"共%d件商品  合计：￥%.2f",count,totalprice+yunFei];
        //lblYunFei.text=[NSString stringWithFormat:@"运费(￥%@)，在线支付满%.2f元立减%.2f",self.strFreightPrice,minTotalPrice,onLinePayDiscount];
        
        
        //lblYunFei.text=[NSString stringWithFormat:@"(运费:￥5.00，在线支付减免:￥2.00)"];
    }
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
//    btncancel.layer.borderColor=[[UIColor lightGrayColor]CGColor];
//    [btncancel.layer setMasksToBounds:YES];
//    [btncancel.layer setCornerRadius:6.0];
//    
//    [btncancel setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    btncancel.tag=2000+section;
//    [btncancel addTarget:self action:@selector(cancelclick:) forControlEvents:UIControlEventTouchUpInside];
//    btncancel.backgroundColor=[UIColor whiteColor];
//    [viewFooter addSubview:btncancel];
    
//    UIButton *btnpay=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-90, 35,80, 30)];
//    [btnpay setTitle:@"取消订单" forState:UIControlStateNormal];
//    btnpay.titleLabel.font=[UIFont systemFontOfSize:13.0] ;
//    btnpay.tag=2001+section;
//    btnpay.titleLabel.textColor=[UIColor whiteColor];
//    //    btnpay.layer.borderWidth=0.6;
//    //    btnpay.layer.borderColor=[[UIColor lightGrayColor]CGColor];
//    [btnpay.layer setMasksToBounds:YES];
//    [btnpay.layer setCornerRadius:6.0];
//    [btnpay addTarget:self action:@selector(payclick:) forControlEvents:UIControlEventTouchUpInside];
//    btnpay.backgroundColor=[UIColor orangeColor];
//    [viewFooter addSubview:btnpay];
//    
//    
    UIImageView *imageBG=[[UIImageView alloc]initWithFrame:CGRectMake(0, 61,SCREEN_WIDTH,10)];
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
    return 71;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120*[[[[[arrayWaitpay objectAtIndex:indexPath.section] objectForKey:@"order_list"]objectAtIndex:indexPath.row] objectForKey:@"order_goods"] count]+30;
}

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
    GoodDetail.goodsId=[[[[[[arrayWaitpay objectAtIndex:path.section] objectForKey:@"order_list"] objectAtIndex:path.row] objectForKey:@"order_goods"] objectAtIndex:sender.tag-751] objectForKey:@"goods_id"];
    [self.navigationController pushViewController:GoodDetail animated:YES];
    
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
    alert.tag=701;
    
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==701) {
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
        NSLog(@"^^^^%@", resultDict );
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            
            [Dialog simpleToast:@"取消订单成功"];
            [self headerRereshing];
            
            
            
        }
        
        else{
            
            [Dialog simpleToast:[NSString stringWithFormat:@"%@,请去网页查看订单详情",[resultDict objectForKey:@"message"]]];

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
