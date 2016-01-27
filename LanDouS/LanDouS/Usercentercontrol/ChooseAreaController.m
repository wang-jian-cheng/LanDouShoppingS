//
//  ChooseAreaController.m
//  LanDouS
//
//  Created by Mao-MacPro on 15/1/15.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import "ChooseAreaController.h"
#import "DataProvider.h"
@interface ChooseAreaController ()

@end

@implementation ChooseAreaController
@synthesize tableArea,strType;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarTitle:@"选择区域"];
    [self addLeftButton:@"whiteback@2x.png"];
    _lblTitle.textColor=[UIColor whiteColor];
    _topView.backgroundColor=navi_bar_bg_color;
    array_city=[[NSMutableArray alloc]init];
    dic_data=[[NSMutableDictionary alloc]init];
    [self getProvinceList];
    // Do any additional setup after loading the view from its nib.
}
-(void)getProvinceList
{
     
    
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        if ([[resultDict objectForKey:@"result"] intValue] == 1)
        {
            if ([[resultDict objectForKey:@"list"]isKindOfClass:[NSArray class]]) {
                for (int i=0; i<[[resultDict objectForKey:@"list"] count]; i++) {
                    [array_city addObject:[[resultDict objectForKey:@"list"] objectAtIndex:i]];
                }
                NSDictionary *dic;
                for (int j=0; j<array_city.count; j++) {
                    if ([[[array_city objectAtIndex:j] objectForKey:@"area_name"]isEqualToString:@"兰山区"]) {
                        dic=[array_city objectAtIndex:j];
                        [array_city removeObjectAtIndex:j];
                        [array_city insertObject:dic atIndex:0];
                        
                        
                    }
                }
                NSDictionary *dic1;
                for (int j=0; j<array_city.count; j++) {
                    if ([[[array_city objectAtIndex:j] objectForKey:@"area_name"]isEqualToString:@"河东区"]) {
                        dic1=[array_city objectAtIndex:j];
                        [array_city removeObjectAtIndex:j];
                        [array_city insertObject:dic1 atIndex:1];
                        
                        
                    }
                }
                NSDictionary *dic2;
                for (int j=0; j<array_city.count; j++) {
                    if ([[[array_city objectAtIndex:j] objectForKey:@"area_name"]isEqualToString:@"罗庄区"]) {
                        dic2=[array_city objectAtIndex:j];
                        [array_city removeObjectAtIndex:j];
                        [array_city insertObject:dic2 atIndex:2];
                        
                        
                    }
                }
                
                
                
                
            }
            
            [tableArea  reloadData];
            
            
        }
        else
        {
            [Dialog simpleToast:@"对不起，查询失败！"];
        }
        
        
        
        
    }];
    
    [dataProvider setFailedBlock:^(NSString *strError){
        [SVProgressHUD dismiss];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"检查网络！" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert show];
        
    }];
    // NSString *password_md5=[MyMD5 md5:text_password.text];
    [dataProvider getArea:@"235"];
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
    return array_city.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    UITableViewCell *cell = [tableView
    //                             dequeueReusableCellWithIdentifier:@"Cell"];
    static NSString *identifier = @"Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        
    }
    
    cell.textLabel.text= [[array_city objectAtIndex:indexPath.row] objectForKey:@"area_name"] ;
    
    cell.textLabel.font=[UIFont systemFontOfSize:15.0];
    
    
    
    
    // Configure the cell...
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([strType isEqualToString:@"edit"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"editchoosearea" object:[array_city objectAtIndex:indexPath.row]];
    }
    else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"choosearea" object:[array_city objectAtIndex:indexPath.row] ];
    }
    [self.navigationController popViewControllerAnimated:YES];
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
