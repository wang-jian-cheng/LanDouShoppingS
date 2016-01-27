//
//  ShopInfoClassController.m
//  LanDouS
//
//  Created by Mao-MacPro on 14/12/25.
//  Copyright (c) 2014年 Mao-MacPro. All rights reserved.
//

#import "ShopInfoClassController.h"
#import "DataProvider.h"
#import "ShopInfoSecondClassController.h"
@interface ShopInfoClassController ()

@end

@implementation ShopInfoClassController
@synthesize storeID;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarTitle:@"商品分类"];
    [self addLeftButton:@"dackback@2x.png"];
    arrayKinds=[[NSMutableArray alloc]init];
    
    tableKinds=[[UITableView alloc]initWithFrame:CGRectMake(0,64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    tableKinds.delegate=self;
    tableKinds.dataSource=self;
    [self.view addSubview:tableKinds];
    [self getstoreGoodsClass:storeID];
    // Do any additional setup after loading the view from its nib.
}

-(void)getstoreGoodsClass:(NSString *)storeid
{
    
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        NSLog(@"^^^^%@", resultDict );
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            if ([[resultDict objectForKey:@"list"]isKindOfClass:[NSArray class]]) {
                if ([[resultDict objectForKey:@"list"]count]>0) {
                    
                    for (int i=0; i<[[resultDict objectForKey:@"list"]count]; i++) {
                        [arrayKinds addObject: [[resultDict objectForKey:@"list"]objectAtIndex:i ]];
                    }
                    
                }
                [tableKinds reloadData];
                
            }
            else{
                [Dialog simpleToast:@"亲，暂无此商品分类"];
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
    
    [dataProvider getStoreGoodsClass:storeid andParentID:@""];
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
    return arrayKinds.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    UITableViewCell *cell = [tableView
    //                             dequeueReusableCellWithIdentifier:@"Cell"];
    static NSString *identifier = @"Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    cell.textLabel.text=[[arrayKinds objectAtIndex:indexPath.row] objectForKey:@"stc_name"];
    cell.textLabel.font=[UIFont boldSystemFontOfSize:15.0];
    
    
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
    ShopInfoSecondClassController *ShopInfoSecondClass=[[ShopInfoSecondClassController alloc]init];
    ShopInfoSecondClass.storeID=storeID;
    ShopInfoSecondClass.parentID=[[arrayKinds objectAtIndex:indexPath.row] objectForKey:@"stc_id"];
    [self.navigationController pushViewController:ShopInfoSecondClass animated:YES];
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
