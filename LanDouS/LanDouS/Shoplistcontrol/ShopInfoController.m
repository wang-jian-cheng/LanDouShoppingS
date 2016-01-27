//
//  ShopInfoController.m
//  LanDouS
//
//  Created by Mao-MacPro on 14/12/25.
//  Copyright (c) 2014年 Mao-MacPro. All rights reserved.
//

#import "ShopInfoController.h"
#import "AppDelegate.h"
#import "shopinfoCell.h"
#import "MJRefresh.h"
#import "ShopInfoClassController.h"
#import "UIImageView+WebCache.h"
#import "DataProvider.h"
#import "GoodDetailController.h"
#define IMAGE_SHOP_URL @"http://112.53.78.18:8000/data/upload/shop/store/"
@interface ShopInfoController ()

@end

@implementation ShopInfoController
@synthesize topview,dicShopInfo,imgShop,lblShopDisc,lblShopName,btnCollect;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarTitle:@"店铺介绍"];
    [self addLeftButton:@"dackback@2x.png"];
    [self addRightButton:@"shopClass@2x.png"];
    topview.frame=CGRectMake(0, 64, SCREEN_WIDTH, 79);
    [self.view addSubview:topview];
    page=1;
    perpage=20;
    dicPost=[[NSMutableDictionary alloc]init];
    arrayShopGoods=[[NSMutableArray alloc]init];
    
    
    tableShopinfo=[[UITableView alloc]initWithFrame:CGRectMake(0,145, SCREEN_WIDTH, SCREEN_HEIGHT-143)];
    tableShopinfo.delegate=self;
    tableShopinfo.dataSource=self;
    [tableShopinfo addHeaderWithTarget:self action:@selector(headerRereshing)];
    
    //[table_appointment headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [tableShopinfo addFooterWithTarget:self action:@selector(footerRereshing)];
    [self.view addSubview:tableShopinfo];
    UIView *viewTableHeader=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 21)];
    viewTableHeader.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    UIImageView *imageline1=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    imageline1.image=[UIImage imageNamed:@"shopinfo_tableheader.png"];
    [viewTableHeader addSubview:imageline1];
    UILabel *lblReminder = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 80, 20)];
    lblReminder.text =@"热销产品";
    lblReminder.numberOfLines = 0;
    lblReminder.font = [UIFont systemFontOfSize:12];
    lblReminder.textColor = [UIColor blackColor];
    lblReminder.backgroundColor = [UIColor clearColor];
    [viewTableHeader addSubview:lblReminder];
    tableShopinfo.tableHeaderView=viewTableHeader;
    
    [self getTopViewInfo];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}
- (IBAction)collectclick:(id)sender {
    if (!btnCollect.selected) {
        
        [self addFavoriteStore:[dicShopInfo objectForKey:@"store_id"]];
        
    }
    else{
        [self delFavoriteStore :[dicShopInfo objectForKey:@"store_id"]];
    }
    
    
}
-(void)clickRightButton:(UIButton *)sender
{
    ShopInfoClassController *ShopInfoClass=[[ShopInfoClassController alloc]init];
    ShopInfoClass.storeID=[dicShopInfo objectForKey:@"store_id"];
    [self.navigationController pushViewController:ShopInfoClass animated:YES];
}
-(void)getTopViewInfo
{
    lblShopName.text=[dicShopInfo objectForKey:@"store_name"];
    lblShopDisc.text=[NSString stringWithFormat:@"主营项目：%@",[dicShopInfo objectForKey:@"store_zy"]];
    [imgShop setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SHOP_IMG_URL,[dicShopInfo objectForKey:@"store_label"]]] placeholderImage:nil];
    
    [btnCollect setImage:[UIImage imageNamed:@"shopuncollect.png"] forState:UIControlStateNormal];
    [btnCollect setImage:[UIImage imageNamed:@"shopcollected.png"] forState:UIControlStateSelected];
    if ([[dicShopInfo objectForKey:@"favorite"]intValue]==0) {
        [btnCollect setSelected:NO];
    }
    else{
        [btnCollect setSelected:YES];
    }
    [dicPost setObject:@"goods_salenum desc" forKey:@"orderby"];
    [dicPost setObject:[dicShopInfo objectForKey:@"store_id"] forKey:@"store_id"];
    [self headerRereshing];
    
}


- (void)headerRereshing
{
    page=1;
    
    [self refreshGoodList:dicPost];
    
}

- (void)footerRereshing
{
    page=page+1;
    
    [self GetMoreGood:dicPost];
}
-(void)refreshGoodList:(NSDictionary *)infoDict
{
    
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        NSLog(@"^^^^%@", resultDict );
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            if ([[resultDict objectForKey:@"list"]isKindOfClass:[NSArray class]]) {
                if ([[resultDict objectForKey:@"list"]count]>0) {
                    [arrayShopGoods removeAllObjects];
                    for (int i=0; i<[[resultDict objectForKey:@"list"]count]; i++) {
                        [arrayShopGoods addObject: [[resultDict objectForKey:@"list"]objectAtIndex:i ]];
                    }
                    
                }
                [tableShopinfo reloadData];
                
            }
        }
        else{
            
        }
        [tableShopinfo headerEndRefreshing];
        
        
    }];
    
    [dataProvider setFailedBlock:^(NSString *strError){
        [SVProgressHUD dismiss];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"检查网络！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [tableShopinfo headerEndRefreshing];
    }];
    
    [dataProvider getGoodsList:dicPost andPage:page andPerPage:perpage];
}
-(void)GetMoreGood:(NSDictionary *)infoDict
{
    
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        NSLog(@"^^^^%@", resultDict );
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            if ([[resultDict objectForKey:@"list"]isKindOfClass:[NSArray class]]) {
                if ([[resultDict objectForKey:@"list"]count]>0) {
                    for (int i=0; i<[[resultDict objectForKey:@"list"]count]; i++) {
                        [arrayShopGoods addObject: [[resultDict objectForKey:@"list"]objectAtIndex:i ]];
                    }
                    
                }
                [tableShopinfo reloadData];
                
            }
        }
        else{
            
        }
        [tableShopinfo footerEndRefreshing];
        
        
    }];
    
    [dataProvider setFailedBlock:^(NSString *strError){
        [SVProgressHUD dismiss];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"检查网络！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [tableShopinfo footerEndRefreshing];
    }];
    
    [dataProvider getGoodsList:dicPost andPage:page andPerPage:perpage];
}
-(void)addFavoriteStore:(NSString *)store_id
{
    
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        NSLog(@"^^^^%@", resultDict );
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            [btnCollect setSelected:YES];
            [Dialog simpleToast:@"收藏店铺成功"];
        }
        else{
            
        }
        
        
        
    }];
    
    [dataProvider setFailedBlock:^(NSString *strError){
        [SVProgressHUD dismiss];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"检查网络！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        
    }];
    
    [dataProvider addFavoriteStore:store_id];
}
-(void)delFavoriteStore:(NSString *)store_id
{
    
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        NSLog(@"^^^^%@", resultDict );
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            [btnCollect setSelected:NO];
            [Dialog simpleToast:@"取消成功"];
                
            
        }
        else{
            
        }
        
        
        
    }];
    
    [dataProvider setFailedBlock:^(NSString *strError){
        [SVProgressHUD dismiss];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"检查网络！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        
    }];
    
    [dataProvider delFavoriteStore:store_id];
}


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
    return arrayShopGoods.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    UITableViewCell *cell = [tableView
    //                             dequeueReusableCellWithIdentifier:@"Cell"];
    static NSString *identifier = @"shopinfoCellIdentifier";
    shopinfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[shopinfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.lblTitle.text=[[arrayShopGoods objectAtIndex:indexPath.row] objectForKey:@"goods_name"];
    
    cell.lblNowPrice.text=[NSString stringWithFormat:@"￥%@",[[arrayShopGoods objectAtIndex:indexPath.row] objectForKey:@"goods_price"]];
    cell.lblOldPrice.text=[NSString stringWithFormat:@"￥%@",[[arrayShopGoods objectAtIndex:indexPath.row] objectForKey:@"goods_marketprice"]];
    cell.lblBuyNum.text=[NSString stringWithFormat:@"%@人已付款",[[arrayShopGoods objectAtIndex:indexPath.row] objectForKey:@"goods_salenum"]];
    NSURL *URL=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",GOODS_IMG_URL,[[arrayShopGoods objectAtIndex:indexPath.row] objectForKey:@"store_id"],[[arrayShopGoods objectAtIndex:indexPath.row] objectForKey:@"goods_image"]]];
    [cell.imageGood setImageWithURL:URL placeholderImage:nil];
    
    
    // Configure the cell...
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 103;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodDetailController *GoodDetail=[[GoodDetailController alloc]init];
    GoodDetail.goodsId=[[arrayShopGoods objectAtIndex:indexPath.row] objectForKey:@"goods_id"];
    [self.navigationController pushViewController:GoodDetail animated:YES];
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
