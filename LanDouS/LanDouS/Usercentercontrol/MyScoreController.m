//
//  MyScoreController.m
//  LanDouS
//
//  Created by Mao-MacPro on 15/1/19.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import "MyScoreController.h"
#import "AppDelegate.h"
#import "DataProvider.h"
#import "UIImageView+WebCache.h"
#import "MyScoreCell.h"
#import "MJRefresh.h"
#import "SureScoreCartController.h"
#import "ScoreListController.h"
@interface MyScoreController ()

@end

@implementation MyScoreController

- (void)viewDidLoad {
    [super viewDidLoad];
    page=1;
    perpage=20;
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
//    image.image=[UIImage imageNamed:@"navgreen.png"];
//    [_topView addSubview:image];
    _lblTitle.textColor=[UIColor whiteColor];
//    _topView.backgroundColor=[UIColor colorWithRed:0.51 green:0.57 blue:0.29 alpha:1];
    [self addLeftButton:@"whiteback@2x.png"];
    [self addRightButton:@"scoreclass@2x.png"];
    [self setBarTitle:@"积分商城"];
    arrayScore=[[NSMutableArray alloc]init];
    tableScore = [[UITableView alloc] initWithFrame:CGRectMake(0,NavigationBar_HEIGHT+20, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    tableScore.dataSource = self;
    tableScore.delegate = self;
    [tableScore addHeaderWithTarget:self action:@selector(headerRereshing)];
    [tableScore addFooterWithTarget:self action:@selector(footerRereshing)];
    [self.view addSubview:tableScore];
    [self headerRereshing];
    // Do any additional setup after loading the view from its nib.
}
-(void)clickRightButton:(UIButton *)sender{
    ScoreListController *ScoreList=[[ScoreListController alloc]init];
    [self.navigationController pushViewController:ScoreList animated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
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
                    [arrayScore removeAllObjects];
                    for (int i=0; i<[[resultDict objectForKey:@"list"]count]; i++) {
                        [arrayScore addObject: [[resultDict objectForKey:@"list"]objectAtIndex:i ]];
                    }
                    
                }
                [tableScore reloadData];
                
            }
            else{
                [Dialog simpleToast:@"暂无积分商品"];
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
    
    [dataProvider getPointsGoods:page andperpage:perpage];
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
                        [arrayScore addObject: [[resultDict objectForKey:@"list"]objectAtIndex:i ]];
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
    
    [dataProvider getPointsGoods:page andperpage:perpage];
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
    return arrayScore.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MyScoreCellIdentifier";
    MyScoreCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"MyScoreCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        //cell.backgroundColor=[UIColor colorWithRed:0.94 green:0.95 blue:0.95 alpha:1];
    }
    cell.lblgoods.text=[[arrayScore objectAtIndex:indexPath.row] objectForKey:@"pgoods_name"];
    cell.lblscore.text=[NSString stringWithFormat:@"积分：%@",[[arrayScore objectAtIndex:indexPath.row] objectForKey:@"pgoods_points"]];
    cell.lbldesc.text=[NSString stringWithFormat:@"剩余数量：%@",[[arrayScore objectAtIndex:indexPath.row] objectForKey:@"pgoods_storage"]];
    [cell.btnExchange addTarget:self action:@selector(choosenum:) forControlEvents:UIControlEventTouchUpInside];
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SCORE_GOODS_URL,[[arrayScore objectAtIndex:indexPath.row] objectForKey:@"pgoods_image"]]];
    [cell.imgGoods setImageWithURL:url placeholderImage:img(@"landou_square_default.png")];
    
    
//    NSURL *URL=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",GOODS_IMG_URL,[[arrayList objectAtIndex:indexPath.row] objectForKey:@"store_id"],[[arrayList objectAtIndex:indexPath.row] objectForKey:@"goods_image"]]];
//    [cell.im setImageWithURL:URL placeholderImage:nil];
    
    
    // Configure the cell...
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 124;
}
-(void)choosenum:(UIButton *)sender
{
    MyScoreCell * cell;
    if ([Toolkit isSystemIOS8]) {
        cell=  (MyScoreCell *)[[sender  superview]superview] ;
    }else{
        cell=  (MyScoreCell *)[[[sender superview] superview]superview];
    }
    NSIndexPath * path = [tableScore indexPathForCell:cell];
    NSLog(@"******%ld",(long)path.row);
    indexId=path.row;
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入兑换数量" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle=UIAlertViewStylePlainTextInput;
    UITextField *tf = [alert textFieldAtIndex:0];
    tf.keyboardType = UIKeyboardTypeNumberPad;
    [alert show];
    
    
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UITextField *textNum=[alertView textFieldAtIndex:0];
    if ([textNum.text intValue]==0) {
        [Dialog simpleToast:@"数量为零"];
        return;
    }
    if (buttonIndex==1) {
        int totalscore=[textNum.text intValue]*[[[arrayScore objectAtIndex:indexId] objectForKey:@"pgoods_points"] intValue];
        if ([[get_Dsp(@"userinfo") objectForKey:@"member_points"]intValue]<totalscore) {
            [Dialog simpleToast:@"积分不足"];
        }
        else{
            SureScoreCartController *SureScoreCart=[[SureScoreCartController alloc]init];
            SureScoreCart.dicScoreInfo=[[NSMutableDictionary alloc]initWithDictionary:[arrayScore objectAtIndex:indexId]];
            SureScoreCart.num=[textNum.text intValue];
            [self.navigationController pushViewController:SureScoreCart animated:YES];
        }
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
