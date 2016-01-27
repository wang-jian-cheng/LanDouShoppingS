//
//  ZhuanTiController.m
//  LanDouS
//
//  Created by Mao-MacPro on 15/1/24.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import "ZhuanTiController.h"
#import "DataProvider.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "MJRefresh.h"
#import "GoodListCell.h"
#import "LoginViewController.h"
#import "ShoppingCartController.h"
#import "GoodDetailController.h"
@interface ZhuanTiController ()

@end

@implementation ZhuanTiController
@synthesize specialId;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarTitle:@"专题详情"];
//    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
//    image.image=[UIImage imageNamed:@"navgreen.png"];
//    [_topView addSubview:image];
    arrayList=[[NSMutableArray alloc]init];
//    _topView.backgroundColor=[UIColor colorWithRed:0.51 green:0.57 blue:0.29 alpha:1];
    _lblTitle.textColor=[UIColor whiteColor];
    [self addLeftButton:@"whiteback@2x.png"];
    
    tableZhuanTi = [[UITableView alloc] initWithFrame:CGRectMake(0,NavigationBar_HEIGHT+20, SCREEN_WIDTH, SCREEN_HEIGHT-102)];
    tableZhuanTi.dataSource = self;
    tableZhuanTi.delegate = self;
    //[tableZhuanTi addHeaderWithTarget:self action:@selector(headerRereshing)];
    
    //[table_appointment headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    //[tableGood addFooterWithTarget:self action:@selector(footerRereshing)];
    [self.view addSubview:tableZhuanTi];

    btnShopCart=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-50,SCREEN_HEIGHT-50,40,40)];
    [btnShopCart setImage:[UIImage imageNamed:@"shoppingCartIcon@2x.png"] forState:UIControlStateNormal];
    [btnShopCart.layer setMasksToBounds:YES];
    btnShopCart.layer.cornerRadius=20.0;
    [btnShopCart addTarget:self action:@selector(gotocart) forControlEvents:UIControlEventTouchUpInside];
    [btnShopCart setBackgroundColor:[UIColor colorWithRed:0.86 green:0.56 blue:0.15 alpha:1]];
    [self.view addSubview:btnShopCart];
    
    
    
    [self getScreeninfo];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}


-(void)getScreeninfo
{
    
    
    
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        NSLog(@"^^^^%@", resultDict );
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            if ([[[resultDict objectForKey:@"data"] objectForKey:@"special_product_list"]isKindOfClass:[NSArray class]]) {
                if ([[[resultDict objectForKey:@"data"] objectForKey:@"special_product_list"]count]>0) {
                    arrayList=[NSMutableArray arrayWithArray:[[resultDict objectForKey:@"data"] objectForKey:@"special_product_list"]];
                }
            }
            
            
            [self initHeadView:[[resultDict objectForKey:@"data"] objectForKey:@"special_image"]];
            
            [tableZhuanTi reloadData];
        }
        else{
            
        }
        
        
        
    }];
    
    [dataProvider setFailedBlock:^(NSString *strError){
        [SVProgressHUD dismiss];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"检查网络！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        
    }];
    
    [dataProvider getSpecial:specialId];
}
-(void)initHeadView:(NSString *)imgStr
{
    UIView *viewHead=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/2.5)];
    UIImageView *imgZhuanTi=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/2.5)];
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",LUNBO_IMAGE_URL,imgStr]];
    [imgZhuanTi setImageWithURL:url placeholderImage:img(@"landou_rectangle_default.png")];
    [viewHead addSubview:imgZhuanTi];
    
    tableZhuanTi.tableHeaderView=viewHead;
    
    
}
-(void)addCart:(UIButton *)sender
{
    if (get_Dsp(@"userinfo")) {
        GoodListCell * cell;
        if ([Toolkit isSystemIOS8]) {
            cell=  (GoodListCell *)[[sender  superview]superview] ;
        }else{
            cell=  (GoodListCell *)[[[sender superview] superview]superview];
        }
        NSIndexPath * path = [tableZhuanTi indexPathForCell:cell];
        NSLog(@"******%ld",(long)path.row);
        
        [self addCart:[[arrayList objectAtIndex:path.row] objectForKey:@"goods_id"] andCount:1];
    }
    else{
        LoginViewController *LoginView=[[LoginViewController alloc]init];
        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:LoginView];
        nav.navigationBar.hidden=YES;
        LoginView.strType=@"nav";
        [self presentViewController:nav animated:YES completion:nil];
    }
    
    
    
    
}
-(void)addCart:(NSString *)goods_id andCount:(int)count
{
    
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        NSLog(@"^^^^%@", resultDict );
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            
            [Dialog simpleToast:@"添加购物车成功"];
            
            
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
    
    [dataProvider addCart:goods_id andCount:count];
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
    return arrayList.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    UITableViewCell *cell = [tableView
    //                             dequeueReusableCellWithIdentifier:@"Cell"];
    static NSString *identifier = @"GoodListCellzhuantiIdentifier";
    GoodListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[GoodListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
    }
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",GOODS_IMG_URL,[[arrayList objectAtIndex:indexPath.row] objectForKey:@"store_id"],[[arrayList objectAtIndex:indexPath.row] objectForKey:@"goods_image"]]];
    [cell.imageGood setImageWithURL:url placeholderImage:img(@"landou_square_default.png")];
    
    
    cell.lblDisc.text=[[arrayList objectAtIndex:indexPath.row] objectForKey:@"goods_name"];
    cell.lblNowPrice.text=[NSString stringWithFormat:@"￥%@",[[arrayList objectAtIndex:indexPath.row]objectForKey:@"goods_price"]];
    cell.lblOldPrice.text=[NSString stringWithFormat:@"￥%@",[[arrayList objectAtIndex:indexPath.row]objectForKey:@"goods_marketprice"]];
    cell.lblTitle.hidden=YES;
    [cell.btnBuy addTarget:self action:@selector(addCart:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    // Configure the cell...
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodDetailController *GoodDetail=[[GoodDetailController alloc]init];
    GoodDetail.goodsId=[[arrayList objectAtIndex:indexPath.row] objectForKey:@"goods_id"];
    [self.navigationController pushViewController:GoodDetail animated:YES];
}

-(void)gotocart
{
    if (get_Dsp(@"userinfo")) {
        ShoppingCartController *ShoppingCart=[[ShoppingCartController alloc]init];
        ShoppingCart.strType=@"allscreen";
        [self.navigationController pushViewController:ShoppingCart animated:YES];
        //        [dicPost setObject:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
        //        [dicPost setObject:[NSString stringWithFormat:@"%d",perpage] forKey:@"perpage"];
        
        //[self getproduct:dicPost];
    }
    else{
        LoginViewController *LoginView=[[LoginViewController alloc]init];
        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:LoginView];
        nav.navigationBar.hidden=YES;
        LoginView.strType=@"nav";
        [self presentViewController:nav animated:YES completion:nil];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
