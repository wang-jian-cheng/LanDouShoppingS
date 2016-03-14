//
//  ShoppingCartController.m
//  LanDouS
//
//  Created by Mao-MacPro on 14/12/23.
//  Copyright (c) 2014年 Mao-MacPro. All rights reserved.
//

#import "ShoppingCartController.h"
#import "DataProvider.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "ShopCartCell.h"
#import "SureCartController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
@interface ShoppingCartController ()

@end

@implementation ShoppingCartController
@synthesize viewDown,viewNothing,btnSure,lblAllPrice,strType,btnAllSelect;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarTitle:@"购物车"];
    _lblTitle.textColor=[UIColor whiteColor];
    _topView.backgroundColor=navi_bar_bg_color;
    arrayCartList=[[NSMutableArray alloc]init];
    arrayAddCart=[[NSMutableArray alloc]init];
    [btnAllSelect setImage:img(@"uncheck.png") forState:UIControlStateNormal];
    [btnAllSelect setImage:img(@"check.png") forState:UIControlStateSelected];
    
    
    
    tableCart = [[UITableView alloc] initWithFrame:CGRectMake(0,NavigationBar_HEIGHT+20, SCREEN_WIDTH, SCREEN_HEIGHT-113-45)];
    tableCart.dataSource = self;
    tableCart.delegate = self;
    [tableCart addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.view addSubview:tableCart];
    [btnSure.layer setMasksToBounds:YES];
    [btnSure.layer setCornerRadius:3.0];
    UIView*view =[ [UIView alloc]init];
    view.backgroundColor= [UIColor clearColor];
    [tableCart setTableFooterView:view];
    
    
    [self.view bringSubviewToFront:viewDown];
    tableCart.hidden=YES;
    viewDown.hidden=YES;
    viewNothing.hidden=YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cleanarray) name:@"dingdantijiaowancheng" object:nil];
    //[self headerRereshing];
    // Do any additional setup after loading the view from its nib.
}
-(void)cleanarray
{
    btnAllSelect.selected=NO;
    lblAllPrice.text=@"总金额￥0.00";
    [arrayAddCart removeAllObjects];
}
-(void)viewWillAppear:(BOOL)animated{
    
    if (get_Dsp(@"userinfo")) {
        if ([strType isEqualToString:@"allscreen"]) {
            [self addLeftButton:@"whiteback@2x.png"];
            tableCart.frame=CGRectMake(0, NavigationBar_HEIGHT+20, SCREEN_WIDTH, SCREEN_HEIGHT-113);
            viewDown.frame=CGRectMake(0, SCREEN_HEIGHT-45, SCREEN_WIDTH, 45);
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
            
        }
        else
        {
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] showTabBar];
        }
        [self getCartList];
        
    }
    else{
        LoginViewController *LoginView=[[LoginViewController alloc]init];
        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:LoginView];
        nav.navigationBar.hidden=YES;
        if ([strType isEqualToString:@"allscreen"]) {
            LoginView.strType=@"nav";
        }
        [self presentViewController:nav animated:YES completion:nil];
    }
    viewDown.backgroundColor=[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.2];
    
}
-(void)headerRereshing
{
    [self getCartList];
}

-(void)getCartList
{
    
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        DLog(@"^^^^%@", resultDict );
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            if ([[resultDict objectForKey:@"list"]isKindOfClass:[NSArray class]]) {
                tableCart.hidden=NO;
                viewDown.hidden=NO;
                viewNothing.hidden=YES;
                arrayCartList=[NSMutableArray arrayWithArray:[resultDict objectForKey:@"list"]];
                
//                float allPrice;
//                for (int i=0; i<arrayCartList.count; i++) {
//                    allPrice=allPrice+[[[arrayCartList objectAtIndex:i] objectForKey:@"purchase_price"]floatValue];
//                }
                //lblAllPrice.text=[NSString stringWithFormat:@"总金额￥%.2f",allPrice];
                
                
                
                
                
            }
            else{
                viewNothing.hidden=NO;
                tableCart.hidden=YES;
                viewDown.hidden=YES;
            }
            
            
            
        }
        else{
            [Dialog simpleToast:@"亲，加载购物车失败"];
        }
        
        [tableCart reloadData];
        [tableCart headerEndRefreshing];
    }];
    
    [dataProvider setFailedBlock:^(NSString *strError){
        [SVProgressHUD dismiss];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"检查网络！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [tableCart headerEndRefreshing];
    }];
    
    [dataProvider getCartList];
}
-(void)updatecart:(NSString *)cardid andcount:(int)count
{
    
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        NSLog(@"cart-good-num^^^^%@", resultDict );
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            int goodsid=[[[resultDict objectForKey:@"data"] objectForKey:@"goods_id"] intValue];
            for (int i=0; i<[arrayAddCart count]; i++) {
                if ([[[arrayAddCart objectAtIndex:i] objectForKey:@"goods_id"] intValue]==goodsid) {
                    [arrayAddCart replaceObjectAtIndex:i withObject:[resultDict objectForKey:@"data"]];
                }
            }
            
             totalprice=0;
            for (int i=0; i<arrayAddCart.count; i++) {
                totalprice=totalprice+[[[arrayAddCart objectAtIndex:i] objectForKey:@"goods_price"] floatValue]*[[[arrayAddCart objectAtIndex:i] objectForKey:@"goods_num"] intValue];
            }
            lblAllPrice.text=[NSString stringWithFormat:@"总金额￥%.2f",totalprice];
            
            
            
            
            
            [self getCartList];
//            if ([[resultDict objectForKey:@"list"]isKindOfClass:[NSArray class]]) {
//                arrayCartList=[NSMutableArray arrayWithArray:[resultDict objectForKey:@"list"]];
//                
//            }
            
            
            
        }
        else{
            [Dialog simpleToast:[resultDict objectForKey:@"message"]];
        }
        
        [tableCart reloadData];
        
    }];
    
    [dataProvider setFailedBlock:^(NSString *strError){
        [SVProgressHUD dismiss];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"检查网络！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        
    }];
    
    [dataProvider updateCart:cardid andCount:count];
}
-(void)addclick:(UIButton *)sender
{
    ShopCartCell * cell;
    if ([Toolkit isSystemIOS8]) {
        cell=  (ShopCartCell *)[[sender  superview]superview] ;
    }else{
        cell=  (ShopCartCell *)[[[sender superview] superview]superview];
    }
    NSIndexPath * path = [tableCart indexPathForCell:cell];
    NSLog(@"******%ld",(long)path.section);
    NSLog(@"******%ld",(long)path.row);
    int count=[[[[[arrayCartList objectAtIndex:path.section] objectForKey:@"cart_list"] objectAtIndex:path.row] objectForKey:@"goods_num"]intValue];
    count=count+1;
    NSString *cartId=[[[[arrayCartList objectAtIndex:path.section] objectForKey:@"cart_list"] objectAtIndex:path.row] objectForKey:@"cart_id"];
    [self updatecart:cartId andcount:count];
    
    
}
-(void)cutclick:(UIButton *)sender
{
    ShopCartCell * cell;
    if ([Toolkit isSystemIOS8]) {
        cell=  (ShopCartCell *)[[sender  superview]superview] ;
    }else{
        cell=  (ShopCartCell *)[[[sender superview] superview]superview];
    }
    NSIndexPath * path = [tableCart indexPathForCell:cell];
    NSLog(@"******%ld",(long)path.section);
    NSLog(@"******%ld",(long)path.row);
    int count=[[[[[arrayCartList objectAtIndex:path.section] objectForKey:@"cart_list"] objectAtIndex:path.row] objectForKey:@"goods_num"]intValue];
    if (count==1) {
        return;
    }
    else{
        count=count-1;
    }
    NSString *cartId=[[[[arrayCartList objectAtIndex:path.section] objectForKey:@"cart_list"] objectAtIndex:path.row] objectForKey:@"cart_id"];
    [self updatecart:cartId andcount:count];
}
-(void)choosegoods:(UIButton *)sender
{
    ShopCartCell * cell;
    if ([Toolkit isSystemIOS8]) {
        cell=  (ShopCartCell *)[[sender  superview]superview] ;
    }else{
        cell=  (ShopCartCell *)[[[sender superview] superview]superview];
    }
    NSIndexPath * path = [tableCart indexPathForCell:cell];
    NSLog(@"******%ld",(long)path.section);
    NSLog(@"******%ld",(long)path.row);
    if (cell.btncheck.selected) {
        [cell.btncheck setSelected:NO];
        int goodsid=[[[[[arrayCartList objectAtIndex:path.section]objectForKey:@"cart_list"] objectAtIndex:path.row] objectForKey:@"goods_id"] intValue];
        
        for (int i=0; i<arrayAddCart.count; i++) {
            if (goodsid==[[[arrayAddCart objectAtIndex:i] objectForKey:@"goods_id"] intValue]) {
                [arrayAddCart removeObjectAtIndex:i];
            }
        }
        
        
         totalprice=0;
        for (int i=0; i<arrayAddCart.count; i++) {
            totalprice=totalprice+[[[arrayAddCart objectAtIndex:i] objectForKey:@"goods_price"] floatValue]*[[[arrayAddCart objectAtIndex:i] objectForKey:@"goods_num"] intValue];
        }
        lblAllPrice.text=[NSString stringWithFormat:@"总金额￥%.2f",totalprice];
        btnAllSelect.selected=NO;
        
        
        
        
        
        
    }
    else{
        [cell.btncheck setSelected:YES];
        [arrayAddCart addObject:[[[arrayCartList objectAtIndex:path.section]objectForKey:@"cart_list"] objectAtIndex:path.row]];
         totalprice=0;
        for (int i=0; i<arrayAddCart.count; i++) {
            totalprice=totalprice+[[[arrayAddCart objectAtIndex:i] objectForKey:@"goods_price"] floatValue]*[[[arrayAddCart objectAtIndex:i] objectForKey:@"goods_num"] intValue];
        }
        lblAllPrice.text=[NSString stringWithFormat:@"总金额￥%.2f",totalprice];
        
    }
    
}


#pragma mark tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return arrayCartList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [[[arrayCartList objectAtIndex:section] objectForKey:@"cart_list"]count];
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
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",GOODS_IMG_URL,[[[[arrayCartList objectAtIndex:indexPath.section] objectForKey:@"cart_list"] objectAtIndex:indexPath.row] objectForKey:@"store_id"],[[[[arrayCartList objectAtIndex:indexPath.section] objectForKey:@"cart_list"] objectAtIndex:indexPath.row] objectForKey:@"goods_image"]]];
    [cell.ImgGoods setImageWithURL:url placeholderImage:img(@"landou_square_default.png")];
    
    
    cell.lblGoodsName.text=[[[[arrayCartList objectAtIndex:indexPath.section] objectForKey:@"cart_list"] objectAtIndex:indexPath.row] objectForKey:@"goods_name"];
    cell.lblGoodsPrice.text=[NSString stringWithFormat:@"￥%@",[[[[arrayCartList objectAtIndex:indexPath.section] objectForKey:@"cart_list"] objectAtIndex:indexPath.row] objectForKey:@"goods_price"]];
    
    cell.textBuyNum.text=[NSString stringWithFormat:@"%@",[[[[arrayCartList objectAtIndex:indexPath.section] objectForKey:@"cart_list"] objectAtIndex:indexPath.row] objectForKey:@"goods_num"]];
    cell.lblBuyNum.text=[NSString stringWithFormat:@"x%@",[[[[arrayCartList objectAtIndex:indexPath.section] objectForKey:@"cart_list"] objectAtIndex:indexPath.row] objectForKey:@"goods_num"]];
    
    [cell.btnAdd addTarget:self action:@selector(addclick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnCut addTarget:self action:@selector(cutclick:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.btncheck setImage:img(@"uncheck.png") forState:UIControlStateNormal];
    [cell.btncheck setImage:img(@"check.png") forState:UIControlStateSelected];
    [cell.btncheck addTarget:self action:@selector(choosegoods:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
    
    
    if (btnAllSelect.selected) {
        cell.btncheck.selected=YES;
    }
    else{
        //cell.btncheck.selected=NO;
        int goodsid=[[[[[arrayCartList objectAtIndex:indexPath.section] objectForKey:@"cart_list"] objectAtIndex:indexPath.row] objectForKey:@"goods_id"] intValue];
        for (int i=0; i<arrayAddCart.count; i++) {
            if ([[[arrayAddCart objectAtIndex:i] objectForKey:@"goods_id"] intValue]==goodsid) {
                [cell.btncheck setSelected:YES];
                break;
            }
            else{
                [cell.btncheck setSelected:NO];
            }
        }
    }
 
    
    // Configure the cell...
    return cell;
}
/**
 添加头header，店铺名
 */
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *viewHeader=[[UIView alloc]init];
//    viewHeader.backgroundColor=[UIColor whiteColor];
//    
//    UILabel *lbltitle = [[UILabel alloc] initWithFrame:CGRectMake(10,0,SCREEN_WIDTH,30)];
//    
//     lbltitle.text =[[arrayCartList objectAtIndex:section]objectForKey:@"store_name"];
//    lbltitle.numberOfLines = 0;
//    //lbltitle.textAlignment=NSTextAlignmentRight;
//    lbltitle.font = [UIFont systemFontOfSize:14.0];
//    lbltitle.textColor = [UIColor blackColor];
//    lbltitle.backgroundColor = [UIColor whiteColor];
//    [viewHeader addSubview:lbltitle];
//    UIImageView *imageline1=[[UIImageView alloc]initWithFrame:CGRectMake(0,31, SCREEN_WIDTH, 1)];
//    imageline1.backgroundColor=[UIColor colorWithRed:0.97 green:0.96 blue:0.96 alpha:1];
//    [viewHeader addSubview:imageline1];
//    //改为viewHeader后显示店铺名
//    return nil;
//}
/**
 添加合计
 */
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *viewFooter=[[UIView alloc]initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,20)];
//    viewFooter.backgroundColor=[UIColor whiteColor];
//    //viewFooter.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
//    UILabel *lblPrice = [[UILabel alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH-20,30)];
//    
//    lblPrice.text =[NSString stringWithFormat:@"共%lu件商品  合计：￥%.2f",(unsigned long)[[[arrayCartList objectAtIndex:section]objectForKey:@"cart_list"] count],[[[arrayCartList objectAtIndex:section]objectForKey:@"purchase_price"] floatValue]];
//    lblPrice.numberOfLines = 0;
//     lblPrice.textAlignment=NSTextAlignmentRight;
//     lblPrice.font = [UIFont boldSystemFontOfSize:13.0];
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
//    //添加viewFooter后显示合计
//    return nil;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        NSLog(@"&&&&&%d%d",indexPath.section,indexPath.row);
        [self delcart:[[[[arrayCartList objectAtIndex:indexPath.section] objectForKey:@"cart_list"] objectAtIndex:indexPath.row] objectForKey:@"cart_id"]];
        
                 // Delete the row from the data source.
        
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(void)delcart:(NSString *)cartid
{
    
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        NSLog(@"^^^^%@", resultDict );
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            [btnAllSelect setSelected:NO];
            //[tableCart reloadData];
            [arrayAddCart removeAllObjects];
            lblAllPrice.text=[NSString stringWithFormat:@"总金额￥0.00"];
            [self headerRereshing];
            
            
        }
        else{
            [Dialog simpleToast:@"亲，删除失败了，请重试一下"];
        }
        
        [tableCart reloadData];
        [tableCart headerEndRefreshing];
    }];
    
    [dataProvider setFailedBlock:^(NSString *strError){
        [SVProgressHUD dismiss];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"检查网络！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [tableCart headerEndRefreshing];
    }];
    
    [dataProvider delCart:cartid];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getOrderConfirm:(NSDictionary *)infoDict
{
    [SVProgressHUD show];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        NSLog(@"^^^^%@", resultDict );
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            if ([[resultDict objectForKey:@"list"]isKindOfClass:[NSArray class]]) {
                
                //arrayCartList=[NSMutableArray arrayWithArray:[resultDict objectForKey:@"list"]];
                
                SureCartController *SureCart=[[SureCartController alloc]init];
                    //SureCart.totalPrice=[lblAllPrice.text floatValue];
                    SureCart.arrayCartList=[[NSMutableArray alloc]initWithArray:arrayAddCart];
                SureCart.strFreightPrice=@"5";
//                [[[resultDict objectForKey:@"list"] objectAtIndex:0] objectForKey:@"freight_price"];
                    [self.navigationController pushViewController:SureCart animated:YES];
                
                
                
            }
            
            
            
        }
        else{
            
        }
        
        
        
    }];
    
    [dataProvider setFailedBlock:^(NSString *strError){
        [SVProgressHUD dismiss];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"检查网络！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        
    }];
    
    [dataProvider getOrderComfirm:infoDict];
}

- (IBAction)sureclick:(id)sender {
    if (arrayAddCart.count==0) {
                [Dialog simpleToast:@"亲，您未选中任何商品"];
                return;
    }
    NSMutableArray *arrayCartId=[[NSMutableArray alloc]init];
    for (int i=0;i<arrayAddCart.count; i++) {
        
            [arrayCartId addObject:[[arrayAddCart objectAtIndex:i]   objectForKey:@"cart_id"]];
        
    }
     NSString *string2 = [arrayCartId componentsJoinedByString:@","];
    NSMutableDictionary *dicPost=[[NSMutableDictionary alloc]init];
    [dicPost setObject:string2 forKey:@"cart_id"];
    //TODO：使用接口27确认订单来获得邮费和相关商品信息
//    [self getOrderConfirm:dicPost];
    SureCartController *SureCart=[[SureCartController alloc]init];
    //SureCart.totalPrice=[lblAllPrice.text floatValue];
    SureCart.arrayCartList=[[NSMutableArray alloc]initWithArray:arrayAddCart];
    SureCart.strFreightPrice=@"5";
    [self.navigationController pushViewController:SureCart animated:YES];
    
    
}
- (IBAction)goHomeviewclick:(id)sender {
    CustomTabBarViewController * tabbar=[(AppDelegate *)[[UIApplication sharedApplication] delegate] getTabBar];
    [tabbar selectTableBarIndex:0];
    if ([strType isEqualToString:@"allscreen"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
- (IBAction)allselectedclick:(id)sender {
    if (btnAllSelect.selected) {
        [btnAllSelect setSelected:NO];
        [tableCart reloadData];
        [arrayAddCart removeAllObjects];
        lblAllPrice.text=[NSString stringWithFormat:@"总金额￥0.00"];
        
    }
    else{
        [btnAllSelect setSelected:YES];
        [tableCart reloadData];
        [arrayAddCart removeAllObjects];
        for (int i=0; i<arrayCartList.count; i++) {
            for (int j=0; j<[[[arrayCartList objectAtIndex:i] objectForKey:@"cart_list"] count]; j++) {
                [arrayAddCart addObject:[[[arrayCartList objectAtIndex:i] objectForKey:@"cart_list"] objectAtIndex:j]];
            }
            
        }
        
         totalprice=0;
        for (int i=0; i<arrayAddCart.count; i++) {
            totalprice=totalprice+[[[arrayAddCart objectAtIndex:i] objectForKey:@"goods_price"] floatValue]*[[[arrayAddCart objectAtIndex:i] objectForKey:@"goods_num"] intValue];
        }
        lblAllPrice.text=[NSString stringWithFormat:@"总金额￥%.2f",totalprice];
        
        
        
        
        
        
        
        
        
        
        
        
    }
}
@end
