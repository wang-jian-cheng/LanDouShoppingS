//
//  ReturnMoneyController.m
//  LanDouS
//
//  Created by Mao-MacPro on 15/1/25.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import "ReturnMoneyController.h"
#import "DataProvider.h"
#import "UIImageView+WebCache.h"
#import "ReturnmoneyCell.h"
#import "ReturnMoneyDetailController.h"
@interface ReturnMoneyController ()

@end

@implementation ReturnMoneyController
@synthesize orderId;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarTitle:@"退款列表"];
    [self addLeftButton:@"whiteback@2x.png"];
    _lblTitle.textColor=[UIColor whiteColor];
    _topView.backgroundColor=navi_bar_bg_color;
    arrayList=[[NSMutableArray alloc]init];
    tableList = [[UITableView alloc] initWithFrame:CGRectMake(0,NavigationBar_HEIGHT+20, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    
    //[tableWaitpay addHeaderWithTarget:self action:@selector(headerRereshing)];
    
    //[table_appointment headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    //[tableWaitpay addFooterWithTarget:self action:@selector(footerRereshing)];
    tableList.dataSource = self;
    tableList.delegate = self;
    
    [self.view addSubview:tableList];
    [self getWaitPayList];
    // Do any additional setup after loading the view from its nib.
}
-(void)getWaitPayList
{
    [SVProgressHUD showWithStatus:@"正在加载"];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        NSLog(@"^^^^%@", resultDict );
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            if ([[[resultDict objectForKey:@"data"] objectForKey:@"order_goods"]isKindOfClass:[NSArray class]]) {
                arrayList=[NSMutableArray arrayWithArray:[[resultDict objectForKey:@"data"] objectForKey:@"order_goods"]];
                
                storeid=[[resultDict objectForKey:@"data"] objectForKey:@"store_id"];
                
                // arrayPost= [[NSMutableArray alloc]initWithCapacity:[[[resultDict objectForKey:@"data"] objectForKey:@"order_goods"] count] ];
                
                
                [tableList reloadData];
                
            }
            else{
                [Dialog simpleToast:@"暂无信息"];
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
    [dataProvider getOrderDetail:orderId];
    //[dataProvider getStoreList:@"nothing" andPage:shopPage andPerpage:shopPerpage];
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
    return  1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    UITableViewCell *cell = [tableView
    //                             dequeueReusableCellWithIdentifier:@"Cell"];
    static NSString *CellIdentifier = @"ReturnmoneyCellIdentifier";
    ReturnmoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"ReturnmoneyCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        //cell.backgroundColor=[UIColor colorWithRed:0.94 green:0.95 blue:0.95 alpha:1];
    }
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",GOODS_IMG_URL,storeid,[[arrayList objectAtIndex:indexPath.section] objectForKey:@"goods_image"]]];
    [cell.imgGoods setImageWithURL:url placeholderImage:img(@"landou_square_default.png")];
    
    cell.lblGoodsName.text=[[arrayList objectAtIndex:indexPath.section] objectForKey:@"goods_name"];
    cell.lblPrice.text=[NSString stringWithFormat:@"￥%@",[[arrayList objectAtIndex:indexPath.section] objectForKey:@"goods_price"]];
    
    cell.lblGoodsNum.text=[NSString stringWithFormat:@"x%@",[[arrayList objectAtIndex:indexPath.section] objectForKey:@"goods_num"]];
    [cell.btnReturnMoney addTarget:self action:@selector(gotoReturnMoneyDetail:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnReturnMoney.layer setMasksToBounds:YES];
    [cell.btnReturnMoney.layer setCornerRadius:3.0];
    [cell.btnReturnMoney.layer setBorderWidth:0.6];
    [cell.btnReturnMoney.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    
    // Configure the cell...
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 127;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(void)gotoReturnMoneyDetail:(UIButton *)sender
{
    ReturnmoneyCell * cell;
    if ([Toolkit isSystemIOS8]) {
        cell=  (ReturnmoneyCell *)[[sender  superview]superview] ;
    }else{
        cell=  (ReturnmoneyCell *)[[[sender superview] superview]superview];
    }
    NSIndexPath * path = [tableList indexPathForCell:cell];
    NSLog(@"******%ld",(long)path.row);
    ReturnMoneyDetailController *ReturnMoneyDetail=[[ReturnMoneyDetailController alloc]init];
    ReturnMoneyDetail.dicinfo=[[NSMutableDictionary alloc]initWithDictionary:[arrayList objectAtIndex:path.section]];
    
    
    [self.navigationController pushViewController:ReturnMoneyDetail animated:YES];
    
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
