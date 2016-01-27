//
//  MyAdressMagController.m
//  LanDouS
//
//  Created by Mao-MacPro on 15/1/12.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import "MyAdressMagController.h"
#import "AppDelegate.h"
#import "DataProvider.h"
#import "AddAdressController.h"
#import "MyAddressCell.h"
#import "EditViewController.h"
@interface MyAdressMagController ()

@end

@implementation MyAdressMagController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarTitle:@"地址管理"];
    [self addLeftButton:@"whiteback@2x.png"];
    _lblTitle.textColor=[UIColor whiteColor];
    _topView.backgroundColor=navi_bar_bg_color;
    [self addRightButton:@"e2_address_add_btnbai@2x.png"];
    arrayAddress=[[NSMutableArray alloc]init];
    tableAddress = [[UITableView alloc] initWithFrame:CGRectMake(0,NavigationBar_HEIGHT+20, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    tableAddress.dataSource = self;
    tableAddress.delegate = self;
    tableAddress.backgroundColor=[UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1];
    tableAddress.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableAddress];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self getAdderssList];
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}
-(void)clickRightButton:(UIButton *)sender{
    AddAdressController *AddAdress=[[AddAdressController alloc]init];
    [self.navigationController pushViewController:AddAdress animated:YES];
}
-(void)getAdderssList
{
    [SVProgressHUD showWithStatus:@"正在加载"];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        NSLog(@"^^^^%@", resultDict );
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            [arrayAddress removeAllObjects];
            if ([[resultDict objectForKey:@"list"]isKindOfClass:[NSArray class]]) {
                if ([[resultDict objectForKey:@"list"]count]>0) {
                    arrayAddress=[NSMutableArray arrayWithArray:[resultDict objectForKey:@"list"]];
                    
                }
            }
            else{
                [Dialog simpleToast:@"亲，暂无地址，请去添加收货地址地址"];
                remove_sp(@"address");
            }
            [tableAddress reloadData];
        }
        else{
            
        }
        
        
        
    }];
    
    [dataProvider setFailedBlock:^(NSString *strError){
        [SVProgressHUD dismiss];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"检查网络！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        
    }];
    [dataProvider getAddress];
    //[dataProvider getStoreList:@"nothing" andPage:shopPage andPerpage:shopPerpage];
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
    return arrayAddress.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    UITableViewCell *cell = [tableView
    //                             dequeueReusableCellWithIdentifier:@"Cell"];
    static NSString *CellIdentifier = @"MyAddressCellIdentifier";
    MyAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"MyAddressCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        //cell.backgroundColor=[UIColor colorWithRed:0.95 green:0.82 blue:0.58 alpha:1];
    }
    cell.lblName.text=[[arrayAddress objectAtIndex:indexPath.row] objectForKey:@"true_name"];
    cell.lblPhone.text=[[arrayAddress objectAtIndex:indexPath.row] objectForKey:@"mob_phone"];
    cell.lblAddress.text=[NSString stringWithFormat:@"%@%@",[[arrayAddress objectAtIndex:indexPath.row] objectForKey:@"area_info"],[[arrayAddress objectAtIndex:indexPath.row] objectForKey:@"address"]];
    [cell.viewBG.layer setMasksToBounds:YES];
    [cell.viewBG.layer setCornerRadius:4.0];
    [cell.btnEdit addTarget:self action:@selector(editclick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnDel addTarget:self action:@selector(delclick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (SCREEN_WIDTH>320) {
        cell.viewBG.frame=CGRectMake(10, 8, SCREEN_WIDTH-20, SCREEN_WIDTH/3);
        cell.btnEdit.frame=CGRectMake(0, 83, (SCREEN_WIDTH-20)/2-10,(SCREEN_WIDTH-20)/8 );
        cell.btnDel.frame=CGRectMake(cell.btnEdit.frame.size.width+10, 83, (SCREEN_WIDTH-20)/2-10,(SCREEN_WIDTH-20)/8 );
    }
    
    
//    [cell.viewBG.layer setBorderWidth:0.6];
//    [cell.viewBG.layer setBorderColor:[[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1] CGColor]];
    
    
    // Configure the cell...
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if ([self.strType isEqualToString:@"surecart"]) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"surecartaddress" object:[arrayAddress objectAtIndex:indexPath.row] ];
//    }
    indexID=indexPath.row;
    addressId=[[arrayAddress objectAtIndex:indexPath.row] objectForKey:@"address_id"];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"确定设置该地址为默认收货地址？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert setTag:400];
    [alert show];
    
    
    
}
-(void)setDefaultAddress
{
    [SVProgressHUD showWithStatus:@"正在加载"];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        NSLog(@"^^^^%@", resultDict );
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            
            [Dialog simpleToast:@"设置默认地址成功"];
            set_sp(@"address", [arrayAddress objectAtIndex:indexID]);
        }
        else{
            
        }
        
        
        
    }];
    
    [dataProvider setFailedBlock:^(NSString *strError){
        [SVProgressHUD dismiss];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"检查网络！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        
    }];
    [dataProvider setDefaultAddress:addressId];
    
}







-(void)editclick:(UIButton *)sender
{
    MyAddressCell * cell;
    if ([Toolkit isSystemIOS8]) {
        cell=  (MyAddressCell *)[[[sender  superview]superview]superview ] ;
    }else{
        cell=  (MyAddressCell *)[[[[sender superview] superview]superview]superview];
    }
    NSIndexPath * path = [tableAddress indexPathForCell:cell];
    NSLog(@"******%ld",(long)path.row);
    EditViewController *EditView=[[EditViewController alloc]init];
    EditView.dicPost=[[NSMutableDictionary alloc]initWithDictionary:[arrayAddress objectAtIndex:path.row]];
    [self.navigationController pushViewController:EditView animated:YES];
    
}
-(void)delclick:(UIButton *)sender
{
    MyAddressCell * cell;
    if ([Toolkit isSystemIOS8]) {
        cell=  (MyAddressCell *)[[[sender  superview]superview]superview ] ;
    }else{
        cell=  (MyAddressCell *)[[[[sender superview] superview]superview]superview];
    }
    NSIndexPath * path = [tableAddress indexPathForCell:cell];
    NSLog(@"******%ld",(long)path.row);
    addressId=[[arrayAddress objectAtIndex:path.row] objectForKey:@"address_id"];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"确定删除该地址？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    [alert setTag:401];
     
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==401) {
        if (buttonIndex==1) {
            [self delAdderss:addressId];
        }
    }
    else if (alertView.tag==400)
    {
        if (buttonIndex==1) {
            [self setDefaultAddress];
        }
    }
}
-(void)delAdderss:(NSString *)addressID
{
    [SVProgressHUD showWithStatus:@"正在加载"];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        NSLog(@"^^^^%@", resultDict );
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            [Dialog simpleToast:@"成功删除该地址"];
            [self getAdderssList];
                
            
        }
        else{
            
        }
        
        
        
    }];
    
    [dataProvider setFailedBlock:^(NSString *strError){
        [SVProgressHUD dismiss];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"检查网络！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        
    }];
    [dataProvider delAddress:addressID];
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
