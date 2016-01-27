//
//  MyScoreLogController.m
//  LanDouS
//
//  Created by Mao-MacPro on 15/1/28.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import "MyScoreLogController.h"
#import "DataProvider.h"
#import "MyScoreLogCell.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
@interface MyScoreLogController ()

@end

@implementation MyScoreLogController

- (void)viewDidLoad {
    [super viewDidLoad];
    page=1;
    perpage=20;
    [self setBarTitle:@"我的积分"];
    [self addLeftButton:@"whiteback@2x.png"];
    _lblTitle.textColor=[UIColor whiteColor];
    _topView.backgroundColor=navi_bar_bg_color;
    
    
    arrayScore=[[NSMutableArray alloc]init];
    tableScore = [[UITableView alloc] initWithFrame:CGRectMake(0,NavigationBar_HEIGHT+20+36, SCREEN_WIDTH, SCREEN_HEIGHT-64-36)];
    tableScore.dataSource = self;
    tableScore.delegate = self;
    [tableScore addHeaderWithTarget:self action:@selector(headerRereshing)];
    [tableScore addFooterWithTarget:self action:@selector(footerRereshing)];
    [self.view addSubview:tableScore];
    [self headerRereshing];
    
    // Do any additional setup after loading the view from its nib.
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
    
    [dataProvider getPointsLog:page andperpage:perpage];
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
    
    [dataProvider getPointsLog:page andperpage:perpage];
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
    static NSString *CellIdentifier = @"MyScoreLogCellIdentifier";
    MyScoreLogCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"MyScoreLogCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        //cell.backgroundColor=[UIColor colorWithRed:0.94 green:0.95 blue:0.95 alpha:1];
    }
    NSString *str= [[arrayScore objectAtIndex:indexPath.row]objectForKey:@"pl_addtime"];//时间戳
    NSTimeInterval time=[str doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSLog(@"date:%@",[detaildate description]);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    cell.lblTime.text=[NSString stringWithFormat:@"%@",currentDateStr];
    if ([[[arrayScore objectAtIndex:indexPath.row] objectForKey:@"pl_points"] floatValue]>0) {
        cell.lblScore.text=[NSString stringWithFormat:@"+%@",[[arrayScore objectAtIndex:indexPath.row] objectForKey:@"pl_points"]];
    }
    else{
        cell.lblScore.text=[NSString stringWithFormat:@"%@",[[arrayScore objectAtIndex:indexPath.row] objectForKey:@"pl_points"]];
    }
    cell.lblCaozuo.text=[[arrayScore objectAtIndex:indexPath.row]objectForKey:@"pl_stage"];
    
    cell.lblDesc.text=[[arrayScore objectAtIndex:indexPath.row] objectForKey:@"pl_desc"];
    
    // Configure the cell...
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 59;
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
