//
//  ShopListViewController.m
//  LanDouS
//
//  Created by Mao-MacPro on 14/12/23.
//  Copyright (c) 2014年 Mao-MacPro. All rights reserved.
//

#import "ShopListViewController.h"
#import "ShopListCell.h"
#import "ShopInfoController.h"
#import "AppDelegate.h"
#import "DataProvider.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#define IMAGE_SHOP_URL @"http://112.53.78.18:8000/data/upload/shop/store/"
@interface ShopListViewController ()

@end

@implementation ShopListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    page=1;
    perpage=20;
//    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
//    image.image=[UIImage imageNamed:@"nav.png"];
//    [_topView addSubview:image];
//    _topView.backgroundColor=[UIColor colorWithRed:0.51 green:0.57 blue:0.29 alpha:1];
    
    arrayShopList=[[NSMutableArray alloc]init];
    tableShopList = [[UITableView alloc] initWithFrame:CGRectMake(0,NavigationBar_HEIGHT+20, SCREEN_WIDTH, SCREEN_HEIGHT-113)];
    tableShopList.dataSource = self;
    tableShopList.delegate = self;
    [tableShopList addHeaderWithTarget:self action:@selector(headerRereshing)];
    
    //[table_appointment headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [tableShopList addFooterWithTarget:self action:@selector(footerRereshing)];
    [self.view addSubview:tableShopList];
    [self headerRereshing];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] showTabBar];
}
- (void)headerRereshing
{
    page=1;
    
    [self refreshShopList];
    
}

- (void)footerRereshing
{
    page=page+1;
    
    [self GetMoreShop];
}
-(void)refreshShopList
{
    [SVProgressHUD showWithStatus:@"正在加载"];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        NSLog(@"^^^^%@", resultDict );
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            if ([[resultDict objectForKey:@"list"]isKindOfClass:[NSArray class]]) {
                if ([[resultDict objectForKey:@"list"]count]>0) {
                    [arrayShopList removeAllObjects];
                    for (int i=0; i<[[resultDict objectForKey:@"list"]count]; i++) {
                        [arrayShopList addObject: [[resultDict objectForKey:@"list"]objectAtIndex:i ]];
                    }
                    
                }
                [tableShopList reloadData];
                
            }
        }
        else{
            
        }
        [tableShopList headerEndRefreshing];
        
        
    }];
    
    [dataProvider setFailedBlock:^(NSString *strError){
        [SVProgressHUD dismiss];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"检查网络！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [tableShopList headerEndRefreshing];
    }];
    
    [dataProvider getStoreList:@"nothing" andPage:page andPerpage:perpage];
}
-(void)GetMoreShop
{
    
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        NSLog(@"^^^^%@", resultDict );
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            if ([[resultDict objectForKey:@"list"]isKindOfClass:[NSArray class]]) {
                if ([[resultDict objectForKey:@"list"]count]>0) {
                    for (int i=0; i<[[resultDict objectForKey:@"list"]count]; i++) {
                        [arrayShopList addObject: [[resultDict objectForKey:@"list"]objectAtIndex:i ]];
                    }
                    
                }
                [tableShopList reloadData];
                
            }
        }
        else{
            
        }
        [tableShopList footerEndRefreshing];
        
        
    }];
    
    [dataProvider setFailedBlock:^(NSString *strError){
        [SVProgressHUD dismiss];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"检查网络！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [tableShopList footerEndRefreshing];
    }];
    
    [dataProvider getStoreList:@"nothing" andPage:page andPerpage:perpage];
}


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
    return arrayShopList.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ShopListCellIdentifier";
    ShopListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"ShopListCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        //cell.backgroundColor=[UIColor colorWithRed:0.94 green:0.95 blue:0.95 alpha:1];
    }
    cell.lblShopName.text=[[arrayShopList objectAtIndex:indexPath.row] objectForKey:@"store_name"];
    cell.lblShopDisc.text=[NSString stringWithFormat:@"主营项目：%@",[[arrayShopList objectAtIndex:indexPath.row] objectForKey:@"store_zy"]];
    [cell.imgShop setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SHOP_IMG_URL,[[arrayShopList objectAtIndex:indexPath.row] objectForKey:@"store_label"]]] placeholderImage:nil];
    
    
    
    // Configure the cell...
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopInfoController *ShopInfo=[[ShopInfoController alloc]init];
    ShopInfo.dicShopInfo=[[NSMutableDictionary alloc]initWithDictionary:[arrayShopList objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:ShopInfo animated:YES];
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
