//
//  GoodsListController.m
//  LanDouS
//
//  Created by Mao-MacPro on 15/1/4.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import "GoodsListController.h"
#import "AppDelegate.h"
#import "GoodListCell.h"
#import "DataProvider.h"
#import "MJRefresh.h"
#import "GoodDetailController.h"
#import "UIImageView+WebCache.h"
#import "ShoppingCartController.h"
#import "LoginViewController.h"
#import "CustomSearchBar.h"
enum{
    btnNormal,
    btnEmpty,
    btnNormalPrice,
    btnUP,
    btnDown,
};
@interface GoodsListController ()<CustomSearchBarDelegate>
{
    CustomSearchBar *_searchBar;
}

@end

@implementation GoodsListController
@synthesize btnGood,btnNew,btnPrice,btnSaleNum,gcId,storeID,searchID;
- (void)viewDidLoad {
    [super viewDidLoad];
    page=1;
    perpage=20;
     
    
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
//   image.image=[UIImage imageNamed:@"navgreen.png"];
//    [_topView addSubview:image];
    
//     searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(50, 30,SCREEN_WIDTH-100, 30)];
//    searchBar.delegate=self;
//    searchBar.placeholder=@"请输入搜索信息";
//    searchBar.searchBarStyle=UISearchBarStyleMinimal;
//    [_topView addSubview:searchBar];
    _searchBar = [[CustomSearchBar alloc] initWithFrame:CGRectMake(70, 20, SCREEN_WIDTH-130, NavigationBar_HEIGHT)];
    _searchBar.delegate = self;
    [_topView addSubview:_searchBar];
//    _topView.backgroundColor=[UIColor colorWithRed:0.51 green:0.57 blue:0.29 alpha:1];
    [self addLeftButton:@"whiteback@2x.png"];
    arrayList=[[NSMutableArray alloc]init];
    dicPost=[[NSMutableDictionary alloc]init];
    
    
    tableGood = [[UITableView alloc] initWithFrame:CGRectMake(0,NavigationBar_HEIGHT+58, SCREEN_WIDTH, SCREEN_HEIGHT-102)];
    tableGood.dataSource = self;
    tableGood.delegate = self;
    [tableGood addHeaderWithTarget:self action:@selector(headerRereshing)];
    
    //[table_appointment headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [tableGood addFooterWithTarget:self action:@selector(footerRereshing)];
    [self.view addSubview:tableGood];
    UIView *viewFooter=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    viewFooter.backgroundColor=[UIColor whiteColor];
    tableGood.tableFooterView=viewFooter;//为了让底部进购物车按钮不与tableview上最后一行的按钮重叠
    
    
    
    btnShopCart=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-50,SCREEN_HEIGHT-50,40,40)];
    [btnShopCart setImage:[UIImage imageNamed:@"shoppingCartIcon@2x.png"] forState:UIControlStateNormal];
    [btnShopCart.layer setMasksToBounds:YES];
    btnShopCart.layer.cornerRadius=20.0;
    [btnShopCart addTarget:self action:@selector(gotocart) forControlEvents:UIControlEventTouchUpInside];
    [btnShopCart setBackgroundColor:[UIColor colorWithRed:0.86 green:0.56 blue:0.15 alpha:1]];
    [self.view addSubview:btnShopCart];
    
    [btnSaleNum setBackgroundImage:[UIImage imageNamed:@"downgray@2x.png"] forState:UIControlStateNormal];
    [btnSaleNum setBackgroundImage:[UIImage imageNamed:@"downyello.png"] forState:UIControlStateSelected];
    btnSaleNum.selected=YES;
    btnPrice.tag=btnNormalPrice;
    [btnPrice setBackgroundImage:[UIImage imageNamed:@"allgray.png"] forState:UIControlStateNormal];
    
    [btnGood setBackgroundImage:[UIImage imageNamed:@"downgray.png"] forState:UIControlStateNormal];
    [btnGood setBackgroundImage:[UIImage imageNamed:@"downyello.png"] forState:UIControlStateSelected];
    
    [btnNew setBackgroundImage:[UIImage imageNamed:@"downgray.png"] forState:UIControlStateNormal];
    [btnNew setBackgroundImage:[UIImage imageNamed:@"downyello.png"] forState:UIControlStateSelected];
    if ([searchID isEqualToString:@"search"]) {
        [_searchBar becomeFirstResponder];
    }
    else{
        [dicPost setObject:gcId forKey:@"gc_id"];
        if (storeID.length>0) {
            [dicPost setObject:storeID forKey:@"store_id"];
        }
        [self headerRereshing];
    }
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [searchBar resignFirstResponder];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchbar
{
    [searchBar resignFirstResponder];
    if (searchbar.text.length>0) {
        [dicPost setObject:searchbar.text forKey:@"search_text"];
        [self headerRereshing];
        
        
        
    }
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length>0) {
        [dicPost setObject:searchText forKey:@"search_text"];
        [self headerRereshing];
    }
    else{
        [dicPost removeObjectForKey:@"search_text"];
        [self headerRereshing];
    }
}
#pragma mark - CustomSearchBarDelegate

- (void)CustomSearchBarStartSearch:(CustomSearchBar *)searchBar andText:(NSString *)textSearch
{
    
    [_searchBar resignFirstResponder];
    if (textSearch.length>0) {
        [dicPost setObject:textSearch forKey:@"search_text"];
        [self headerRereshing];
    }
    else{
        [dicPost removeObjectForKey:@"search_text"];
        [self headerRereshing];
    }
        
        
     
    
}

- (void)CustomSearchBarStartInput:(CustomSearchBar *)searchBar
{
    //[self cleanPullDownList];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)salenumclick:(id)sender {
    
    if(btnSaleNum.tag!=btnNormal){
    [btnSaleNum setSelected:YES];
    
    [btnPrice setBackgroundImage:[UIImage imageNamed:@"allgray.png"] forState:UIControlStateNormal];
    [btnGood setSelected:NO];
    [btnNew setSelected:NO];
    [dicPost setObject:@"goods_salenum desc" forKey:@"orderby"];
    [self headerRereshing];
    }
    //重置按钮状态
    btnSaleNum.tag=btnNormal;
    btnPrice.tag=btnNormalPrice;
    btnNew.tag=btnEmpty;
    btnGood.tag=btnEmpty;
    
}

- (IBAction)priceclick:(id)sender {
    if (btnPrice.tag==btnNormalPrice) {
        btnPrice.tag=btnUP;
        [btnPrice setBackgroundImage:[UIImage imageNamed:@"upyello.png"] forState:UIControlStateNormal];
        
        [dicPost setObject:@"goods_price asc" forKey:@"orderby"];
        
    }
    else if (btnPrice.tag==btnUP)
    {
        btnPrice.tag=btnDown;
        [btnPrice setBackgroundImage:[UIImage imageNamed:@"downyello.png"] forState:UIControlStateNormal];
        [dicPost setObject:@"goods_price desc" forKey:@"orderby"];
        
        
    }
    else if (btnPrice.tag==btnDown)
    {
        btnPrice.tag=btnUP;
        [btnPrice setBackgroundImage:[UIImage imageNamed:@"upyello.png"] forState:UIControlStateNormal];
        [dicPost setObject:@"goods_price asc" forKey:@"orderby"];
    }
    [btnSaleNum setSelected:NO];
    
    [btnGood setSelected:NO];
    [btnNew setSelected:NO];
    [self headerRereshing];
    
    //重置按钮状态
    btnSaleNum.tag=btnEmpty;

    btnNew.tag=btnEmpty;
    btnGood.tag=btnEmpty;
    
}

- (IBAction)goodclick:(id)sender {
    if(btnGood.tag!=btnNormal){
    [btnSaleNum setSelected:NO];

    [btnPrice setBackgroundImage:[UIImage imageNamed:@"allgray.png"] forState:UIControlStateNormal];
    [btnGood setSelected:YES];
    [btnNew setSelected:NO];
    [dicPost setObject:@"evaluation_good_star desc" forKey:@"orderby"];
    [self headerRereshing];
    }
    
    //重置按钮状态
    btnSaleNum.tag=btnEmpty;
    btnPrice.tag=btnNormalPrice;
    btnNew.tag=btnEmpty;
    btnGood.tag=btnNormal;
}

- (IBAction)newclick:(id)sender {
    if(btnNew.tag!=btnNormal){
    [btnSaleNum setSelected:NO];
    btnPrice.tag=btnNormal;
    [btnPrice setBackgroundImage:[UIImage imageNamed:@"allgray.png"] forState:UIControlStateNormal];
    [btnGood setSelected:NO];
    [btnNew setSelected:YES];
    [dicPost setObject:@"goods_edittime desc" forKey:@"orderby"];
    [self headerRereshing];
    }
    //重置按钮状态
    btnSaleNum.tag=btnEmpty;
    btnPrice.tag=btnNormalPrice;
    btnNew.tag=btnNormal;
    btnGood.tag=btnEmpty;
    
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
    [SVProgressHUD show];
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
                [tableGood reloadData];
                
            }
            else{
                [Dialog simpleToast:@"亲，暂无此类商品"];
            }
        }
        else{
            
        }
        [tableGood headerEndRefreshing];
        
        
    }];
    
    [dataProvider setFailedBlock:^(NSString *strError){
        [SVProgressHUD dismiss];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"检查网络！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [tableGood headerEndRefreshing];
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
                        [arrayList addObject: [[resultDict objectForKey:@"list"]objectAtIndex:i ]];
                    }
                    
                }
                [tableGood reloadData];
                
            }
        }
        else{
            
        }
        [tableGood footerEndRefreshing];
        
        
    }];
    
    [dataProvider setFailedBlock:^(NSString *strError){
        [SVProgressHUD dismiss];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"检查网络！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [tableGood footerEndRefreshing];
    }];
    
    [dataProvider getGoodsList:dicPost andPage:page andPerPage:perpage];
}

-(void)addCart:(NSString *)goods_id andCount:(int)count
{
     
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        NSLog(@"^^^^%@", resultDict );
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            
            [Dialog simpleToast:@"YEAH，添加购物车成功"];
            
        
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
    static NSString *identifier = @"GoodListCellIdentifier";
    GoodListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[GoodListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
    }
    
    NSString *strTitle=[NSString stringWithFormat:@"<h3>%@</h3>",[[arrayList objectAtIndex:indexPath.row] objectForKey:@"goods_name"]];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[strTitle dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    cell.lblDisc.attributedText=attributedString;
     //cell.lblDisc.text=[[arrayList objectAtIndex:indexPath.row] objectForKey:@"goods_name"];
    
    
    cell.lblNowPrice.text=[NSString stringWithFormat:@"￥%@",[[arrayList objectAtIndex:indexPath.row] objectForKey:@"goods_price"]];
    cell.lblOldPrice.text=[NSString stringWithFormat:@"￥%@",[[arrayList objectAtIndex:indexPath.row] objectForKey:@"goods_marketprice"]];
    cell.lblTitle.text=[[arrayList objectAtIndex:indexPath.row] objectForKey:@"store_name"];
    NSURL *URL=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",GOODS_IMG_URL,[[arrayList objectAtIndex:indexPath.row] objectForKey:@"store_id"],[[arrayList objectAtIndex:indexPath.row] objectForKey:@"goods_image"]]];
    [cell.imageGood setImageWithURL:URL placeholderImage:img(@"landou_square_default.png")];
    
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
-(void)addCart:(UIButton *)sender
{
    if (get_Dsp(@"userinfo")) {
        GoodListCell * cell;
        if ([Toolkit isSystemIOS8]) {
            cell=  (GoodListCell *)[[sender  superview]superview] ;
        }else{
            cell=  (GoodListCell *)[[[sender superview] superview]superview];
        }
        NSIndexPath * path = [tableGood indexPathForCell:cell];
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




@end
