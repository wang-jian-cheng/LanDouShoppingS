//
//  TypeViewController.m
//  LanDouS
//
//  Created by Mao-MacPro on 14/12/23.
//  Copyright (c) 2014年 Mao-MacPro. All rights reserved.
//

#import "TypeViewController.h"
#import "TypeCell.h"
#import "DataProvider.h"
#import "GoodsListController.h"
#import "AppDelegate.h"
#import "MJRefresh.h"
@interface TypeViewController ()

@end

@implementation TypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarTitle:@"分类"];
    _lblTitle.textColor=[UIColor whiteColor];
    _topView.backgroundColor=navi_bar_bg_color;
    newRow=100;
    lastIndexPath=[NSIndexPath indexPathForRow:101 inSection:0];
    secondNewRow=100;
    secondLastIndexPath=[NSIndexPath indexPathForRow:101 inSection:0];
    arrayFirstClass=[[NSMutableArray alloc]init];
    arraySecondClass=[[NSMutableArray alloc]init];
    arrayThirdClass=[[NSMutableArray alloc]init];
    tableFirst=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-113)];
    tableFirst.delegate=self;
    tableFirst.dataSource=self;
    
//    [tableFirst addHeaderWithTarget:self action:@selector(headrefresh)];
//    tableFirst.headerPullToRefreshText = @"";
//    tableFirst.headerReleaseToRefreshText = @" ";
//    tableFirst.headerRefreshingText = @" ";
    tableFirst.showsHorizontalScrollIndicator=NO;
    tableFirst.showsVerticalScrollIndicator=NO;
    [self.view addSubview:tableFirst];
    
    tableSecond=[[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3, 64, SCREEN_WIDTH/3*2, SCREEN_HEIGHT-113)];
    tableSecond.delegate=self;
    tableSecond.dataSource=self;
    tableSecond.showsVerticalScrollIndicator=NO;
    tableSecond.backgroundColor=[UIColor colorWithRed:0.95 green:0.82 blue:0.58 alpha:1];
    [self.view addSubview:tableSecond];
    
    tableThird=[[UITableView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH/3)*2, 64, SCREEN_WIDTH/3, SCREEN_HEIGHT-113)];
    tableThird.delegate=self;
    tableThird.dataSource=self;
    tableThird.showsVerticalScrollIndicator=NO;
    tableThird.backgroundColor=[UIColor colorWithRed:0.93 green:0.62 blue:0.2 alpha:1];

    [self.view addSubview:tableThird];
    tableSecond.hidden=YES;
    tableThird.hidden=YES;
    [self getFirstClass];
    // Do any additional setup after loading the view from its nib.
}
-(void)headrefresh
{
    [self getFirstClass];
}
-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] showTabBar];
}



-(void)getFirstClass
{
    [SVProgressHUD showWithStatus:@"正在加载"];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        DLog(@"^^^^%@", resultDict );
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            if ([[resultDict objectForKey:@"list"]isKindOfClass:[NSArray class]]) {
                if ([[resultDict objectForKey:@"list"]count]>0) {
                    NSMutableArray* array=[NSMutableArray new];
                    NSArray* list=[resultDict objectForKey:@"list"];
                    for (int i=0; i<8; i++) {
                        [array addObject:list[i]];
                    }
                    arrayFirstClass=[NSMutableArray arrayWithArray:array];
                    
                }
                [tableFirst reloadData];
                
            }
        }
        else{
            
        }
        [tableFirst headerEndRefreshing];
        
        
    }];
    
    [dataProvider setFailedBlock:^(NSString *strError){
        [SVProgressHUD dismiss];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"检查网络！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [tableFirst headerEndRefreshing];

    }];
    
    [dataProvider getGoodsClass:nil];
}
-(void)getSecondClass:(NSString *)parentId
{
    
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        DLog(@"^^^^%@", resultDict );
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            if ([[resultDict objectForKey:@"list"]isKindOfClass:[NSArray class]]) {
                [arraySecondClass removeAllObjects];
                [arrayThirdClass removeAllObjects];
                if ([[resultDict objectForKey:@"list"]count]>0) {
                     arraySecondClass=[NSMutableArray arrayWithArray:[resultDict objectForKey:@"list"]];
                    
                }
                [tableSecond reloadData];
                [tableThird reloadData];
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
    
    [dataProvider getGoodsClass:parentId];
}
-(void)getThirdClass:(NSString *)parentId
{
    
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        DLog(@"^^^^%@", resultDict );
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            if ([[resultDict objectForKey:@"list"]isKindOfClass:[NSArray class]]) {
                if ([[resultDict objectForKey:@"list"]count]>0) {
                    arrayThirdClass=[NSMutableArray arrayWithArray:[resultDict objectForKey:@"list"]];
                    
                }
                [tableThird reloadData];
                
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
    
    [dataProvider getGoodsClass:parentId];
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
    if (tableView==tableFirst) {
        return arrayFirstClass.count;
    }
    else if (tableView==tableSecond)
    {
        return arraySecondClass.count+1;
    }
    return  arrayThirdClass.count+1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==tableFirst) {
        static NSString *CellIdentifier = @"TypeCellIdentifier";
        TypeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"TypeCell" owner:self options:nil];
            cell=[nib objectAtIndex:0];
            cell.frame=CGRectMake(0, 0, SCREEN_WIDTH/3, 53);
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            //cell.backgroundColor=[UIColor colorWithRed:0.94 green:0.95 blue:0.95 alpha:1];
        }
        if (indexPath.row==newRow) {
            cell.imSelect.hidden=NO;
        }
        else{
            cell.imSelect.hidden=YES;
        }
        cell.frame=CGRectMake(0, 0, SCREEN_WIDTH/3, 53);
        cell.imSelect.frame=CGRectMake(cell.frame.size.width-18, 10, 18, 34);
        cell.lblTitle.text=[[arrayFirstClass objectAtIndex:indexPath.row] objectForKey:@"gc_name"];
        
        
         
         
        
        return cell;
    }
    
    else if (tableView==tableSecond)
    {
        static NSString *CellIdentifier = @"secondTypeCellIdentifier";
        TypeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"TypeCell" owner:self options:nil];
            cell=[nib objectAtIndex:0];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
             cell.backgroundColor=[UIColor colorWithRed:0.95 green:0.82 blue:0.58 alpha:1];
        }
        if (indexPath.row==secondNewRow) {
            if (indexPath.row==0) {
                cell.imSelect.hidden=YES;
            }
            else{
                cell.imSelect.hidden=NO;
            }
        }
        else{
            cell.imSelect.hidden=YES;
        }
        cell.frame=CGRectMake(0, 0, SCREEN_WIDTH/3, 53);
        cell.imSelect.frame=CGRectMake(cell.frame.size.width-18, 10, 18, 34);
        cell.lblTitle.numberOfLines=0;
        cell.lblTitle.font=[UIFont systemFontOfSize:13.0];
        cell.imSelect.image=[UIImage imageNamed:@"goodschoose.png"];
        
        if (indexPath.row==0) {
            cell.lblTitle.text=@"全部";
        }
        else{
            if(indexPath.row -1 > arraySecondClass.count - 1|| arraySecondClass.count == 0 || arraySecondClass == nil)
                return cell;
            
            cell.lblTitle.text=[[arraySecondClass objectAtIndex:indexPath.row-1] objectForKey:@"gc_name"];
        }
        
        
        
        return cell;
    }
    
    else
    {
        static NSString *identifier = @"Identifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.backgroundColor=[UIColor colorWithRed:0.93 green:0.62 blue:0.2 alpha:1];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.numberOfLines=0;
        if (indexPath.row==0) {
            cell.textLabel.text=@"全部";
        }
        else{
            if(indexPath.row -1 > arrayThirdClass.count - 1 || arrayThirdClass.count == 0 || arrayThirdClass == nil)
                return cell;
            cell.textLabel.text=[[arrayThirdClass objectAtIndex:indexPath.row-1]objectForKey:@"gc_name"];
        }
        
        cell.textLabel.textColor=[UIColor whiteColor];
        cell.textLabel.font=[UIFont systemFontOfSize:13.0];
        cell.textLabel.textAlignment=NSTextAlignmentCenter;
        
        
        
        
        return cell;
    }
    
    
    
    
    // Configure the cell...
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==tableFirst) {
        return 53;
    }
    else if (tableView==tableSecond)
    {
        return 53;
    }
    return 40;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView==tableFirst) {
        
        
        newRow = [indexPath row];
        NSInteger oldRow = [lastIndexPath row];
        
        if (newRow != oldRow)
        {
            TypeCell *newCell = [tableView cellForRowAtIndexPath:
                                        indexPath];
            newCell.imSelect.hidden=NO;
            
            TypeCell *oldCell = [tableView cellForRowAtIndexPath:
                                        lastIndexPath];
            oldCell.imSelect.hidden=YES;
            
            lastIndexPath = indexPath;
        }
        NSLog(@"--%i",newRow);
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        //[tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        tableSecond.hidden=NO;
        tableThird.hidden=YES;
        secondNewRow=100;
        secondLastIndexPath=[NSIndexPath indexPathForRow:101 inSection:0];
        
        
        if(arraySecondClass != nil&&arraySecondClass.count > 0)
            [arraySecondClass removeAllObjects] ;
        [tableSecond reloadData];
        
        firstClassID=[[[arrayFirstClass objectAtIndex:indexPath.row] objectForKey:@"gc_id"] intValue];
        [self getSecondClass:[[arrayFirstClass objectAtIndex:indexPath.row] objectForKey:@"gc_id"]];
        
        
    }
    
    
    
    if (tableView==tableSecond) {
        secondNewRow = [indexPath row];
        NSInteger oldRow = [secondLastIndexPath row];
        
        if (secondNewRow != oldRow)
        {
            TypeCell *newCell = [tableView cellForRowAtIndexPath:
                                 indexPath];
            if (secondNewRow==0) {
                newCell.imSelect.hidden=YES;
            }
            else{
                newCell.imSelect.hidden=NO;
            }
            TypeCell *oldCell = [tableView cellForRowAtIndexPath:
                                 secondLastIndexPath];
            oldCell.imSelect.hidden=YES;
            
            secondLastIndexPath = indexPath;
        }
        NSLog(@"--%i",newRow);
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if (indexPath.row==0) {
            tableThird.hidden=YES;
            GoodsListController *GoodsList=[[GoodsListController alloc]init];
            GoodsList.gcId=[NSString stringWithFormat:@"%d",firstClassID];
            [self.navigationController pushViewController:GoodsList animated:YES];
        }
        else{
            tableThird.hidden=NO;
            secondClassID=[[[arraySecondClass objectAtIndex:indexPath.row-1] objectForKey:@"gc_id"] intValue];

            
            
            
            [self getThirdClass:[[arraySecondClass objectAtIndex:indexPath.row-1] objectForKey:@"gc_id"]];
            if(arrayThirdClass != nil&&arrayThirdClass.count > 0)
                [arrayThirdClass removeAllObjects] ;
            [tableThird reloadData];
            
        }
    }
    
    
    if (tableView==tableThird) {
        GoodsListController *GoodsList=[[GoodsListController alloc]init];
        if (indexPath.row==0) {
            GoodsList.gcId=[NSString stringWithFormat:@"%d",secondClassID];
        }
        else{
            GoodsList.gcId=[[arrayThirdClass objectAtIndex:indexPath.row-1] objectForKey:@"gc_id"];
        }
        [self.navigationController pushViewController:GoodsList animated:YES];
    }
    
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
