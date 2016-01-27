//
//  CommentEditController.m
//  LanDouS
//
//  Created by Mao-MacPro on 15/1/25.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import "CommentEditController.h"
#import "DataProvider.h"
#import "UIImageView+WebCache.h"
#import "CommentEditCell.h"
@interface CommentEditController ()

@end

@implementation CommentEditController
@synthesize orderId,btnCheck;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarTitle:@"商品评价"];
    [self addLeftButton:@"whiteback@2x.png"];
    _lblTitle.textColor=[UIColor whiteColor];
    _topView.backgroundColor=navi_bar_bg_color;
    dicPost=[[NSMutableDictionary alloc]init];
    arrayComment=[[NSMutableArray alloc]init];
    arrayDesc=[[NSMutableArray alloc]init];
    arrayStar=[[NSMutableArray alloc]init];
    arrayPost=[[NSMutableArray alloc]init];
    tableComment = [[UITableView alloc] initWithFrame:CGRectMake(0,NavigationBar_HEIGHT+20, SCREEN_WIDTH, SCREEN_HEIGHT-64-80)];
    
    //[tableWaitpay addHeaderWithTarget:self action:@selector(headerRereshing)];
    
    //[table_appointment headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    //[tableWaitpay addFooterWithTarget:self action:@selector(footerRereshing)];
    tableComment.dataSource = self;
    tableComment.delegate = self;
    
    [self.view addSubview:tableComment];
    
    [btnCheck setImage:img(@"uncheck.png") forState:UIControlStateNormal];
    [btnCheck setImage:img(@"check.png") forState:UIControlStateSelected];
    
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
                arrayComment=[NSMutableArray arrayWithArray:[[resultDict objectForKey:@"data"] objectForKey:@"order_goods"]];
                
                storeid=[[resultDict objectForKey:@"data"] objectForKey:@"store_id"];
                
               // arrayPost= [[NSMutableArray alloc]initWithCapacity:[[[resultDict objectForKey:@"data"] objectForKey:@"order_goods"] count] ];
                
                for (int i=0; i<[[[resultDict objectForKey:@"data"] objectForKey:@"order_goods"] count]; i++) {
                    [arrayStar addObject:@""];
                    [arrayDesc addObject:@""];
                }
                
                
                [tableComment reloadData];
                
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
    return arrayComment.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    UITableViewCell *cell = [tableView
    //                             dequeueReusableCellWithIdentifier:@"Cell"];
    static NSString *CellIdentifier = @"CommentEditCellIdentifier";
    CommentEditCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"CommentEditCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        //cell.backgroundColor=[UIColor colorWithRed:0.94 green:0.95 blue:0.95 alpha:1];
    }
    
     NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",GOODS_IMG_URL,storeid,[[arrayComment objectAtIndex:indexPath.section] objectForKey:@"goods_image"]]];
    [cell.imgGoods setImageWithURL:url placeholderImage:img(@"landou_square_default.png")];
    
    cell.lblGoodsName.text=[[arrayComment objectAtIndex:indexPath.section] objectForKey:@"goods_name"];
    cell.lblPrice.text=[NSString stringWithFormat:@"￥%@",[[arrayComment objectAtIndex:indexPath.section] objectForKey:@"goods_price"]];
    
    [cell.btn1 setImage:img(@"starunsel") forState:UIControlStateNormal];
    [cell.btn1 setImage:img(@"starsel") forState:UIControlStateSelected];
    
    [cell.btn2 setImage:img(@"starunsel") forState:UIControlStateNormal];
    [cell.btn2 setImage:img(@"starsel") forState:UIControlStateSelected];
    
    [cell.btn3 setImage:img(@"starunsel") forState:UIControlStateNormal];
    [cell.btn3 setImage:img(@"starsel") forState:UIControlStateSelected];
    
    [cell.btn4 setImage:img(@"starunsel") forState:UIControlStateNormal];
    [cell.btn4 setImage:img(@"starsel") forState:UIControlStateSelected];
    
    [cell.btn5 setImage:img(@"starunsel") forState:UIControlStateNormal];
    [cell.btn5 setImage:img(@"starsel") forState:UIControlStateSelected];
    
    
    
    
    [cell.btn1 addTarget:self action:@selector(clickone:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btn2 addTarget:self action:@selector(clicktwo:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btn3 addTarget:self action:@selector(clickthree:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btn4 addTarget:self action:@selector(clickfour:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btn5 addTarget:self action:@selector(clickfive:) forControlEvents:UIControlEventTouchUpInside];
    cell.textview.delegate=self;
    
    
    
    
    
    if ([[arrayStar objectAtIndex:indexPath.section] intValue]==1) {
        [cell.btn1 setSelected:YES];
        [cell.btn2 setSelected:NO];
        [cell.btn3 setSelected:NO];
        [cell.btn4 setSelected:NO];
        [cell.btn5 setSelected:NO];
    }
    else if([[arrayStar objectAtIndex:indexPath.section] intValue]==2)
    {
        [cell.btn1 setSelected:YES];
        [cell.btn2 setSelected:YES];
        [cell.btn3 setSelected:NO];
        [cell.btn4 setSelected:NO];
        [cell.btn5 setSelected:NO];
    }
    else if([[arrayStar objectAtIndex:indexPath.section] intValue]==3)
    {
        [cell.btn1 setSelected:YES];
        [cell.btn2 setSelected:YES];
        [cell.btn3 setSelected:YES];
        [cell.btn4 setSelected:NO];
        [cell.btn5 setSelected:NO];
    }
    else if([[arrayStar objectAtIndex:indexPath.section] intValue]==4)
    {
        [cell.btn1 setSelected:YES];
        [cell.btn2 setSelected:YES];
        [cell.btn3 setSelected:YES];
        [cell.btn4 setSelected:YES];
        [cell.btn5 setSelected:NO];
    }
    else if([[arrayStar objectAtIndex:indexPath.section] intValue]==5)
    {
        [cell.btn1 setSelected:YES];
        [cell.btn2 setSelected:YES];
        [cell.btn3 setSelected:YES];
        [cell.btn4 setSelected:YES];
        [cell.btn5 setSelected:YES];
    }
    
    if ([[arrayDesc objectAtIndex:indexPath.section]length]>0) {
        cell.textview.text=[arrayDesc objectAtIndex:indexPath.section];
        cell.lblReminder.hidden=YES;
    }
    else{
        cell.lblReminder.hidden=NO;
    }
    
    
    
    
    // Configure the cell...
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 258;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(void)clickone:(UIButton *)sender
{
    CommentEditCell * cell;
    if ([Toolkit isSystemIOS8]) {
        cell=  (CommentEditCell *)[[sender  superview]superview] ;
    }else{
        cell=  (CommentEditCell *)[[[sender superview] superview]superview];
    }
    NSIndexPath * path = [tableComment indexPathForCell:cell];
    NSLog(@"******%ld",(long)path.row);
    [cell.btn1 setSelected:YES];
    [cell.btn2 setSelected:NO];
    [cell.btn3 setSelected:NO];
    [cell.btn4 setSelected:NO];
    [cell.btn5 setSelected:NO];
    
    
    
    [arrayStar replaceObjectAtIndex:path.section withObject:@"1"];
    
//    NSString *str=[NSString stringWithFormat:@"goods[%@][score]=",[[arrayComment objectAtIndex:path.section] objectForKey:@"goods_id"]];
//    //dicPost setObject:<#(id)#> forKey:<#(id<NSCopying>)#>
//    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
//    [dic setObject:@"1" forKey:str];
//    [dicPost setObject:dic forKey:[NSString stringWithFormat:@"%d", path.section]];
    
    
    
    
}
-(void)clicktwo:(UIButton *)sender
{
    CommentEditCell * cell;
    if ([Toolkit isSystemIOS8]) {
        cell=  (CommentEditCell *)[[sender  superview]superview] ;
    }else{
        cell=  (CommentEditCell *)[[[sender superview] superview]superview];
    }
    NSIndexPath * path = [tableComment indexPathForCell:cell];
    NSLog(@"******%ld",(long)path.row);
    [cell.btn1 setSelected:YES];
    [cell.btn2 setSelected:YES];
    [cell.btn3 setSelected:NO];
    [cell.btn4 setSelected:NO];
    [cell.btn5 setSelected:NO];
    [arrayStar replaceObjectAtIndex:path.section withObject:@"2"];
}
-(void)clickthree:(UIButton *)sender
{
    CommentEditCell * cell;
    if ([Toolkit isSystemIOS8]) {
        cell=  (CommentEditCell *)[[sender  superview]superview] ;
    }else{
        cell=  (CommentEditCell *)[[[sender superview] superview]superview];
    }
    NSIndexPath * path = [tableComment indexPathForCell:cell];
    NSLog(@"******%ld",(long)path.row);
    [cell.btn1 setSelected:YES];
    [cell.btn2 setSelected:YES];
    [cell.btn3 setSelected:YES];
    [cell.btn4 setSelected:NO];
    [cell.btn5 setSelected:NO];
    [arrayStar replaceObjectAtIndex:path.section withObject:@"3"];
}
-(void)clickfour:(UIButton *)sender
{
    CommentEditCell * cell;
    if ([Toolkit isSystemIOS8]) {
        cell=  (CommentEditCell *)[[sender  superview]superview] ;
    }else{
        cell=  (CommentEditCell *)[[[sender superview] superview]superview];
    }
    NSIndexPath * path = [tableComment indexPathForCell:cell];
    NSLog(@"******%ld",(long)path.row);
    [cell.btn1 setSelected:YES];
    [cell.btn2 setSelected:YES];
    [cell.btn3 setSelected:YES];
    [cell.btn4 setSelected:YES];
    [cell.btn5 setSelected:NO];
    [arrayStar replaceObjectAtIndex:path.section withObject:@"4"];
}
-(void)clickfive:(UIButton *)sender
{
    CommentEditCell * cell;
    if ([Toolkit isSystemIOS8]) {
        cell=  (CommentEditCell *)[[sender  superview]superview] ;
    }else{
        cell=  (CommentEditCell *)[[[sender superview] superview]superview];
    }
    NSIndexPath * path = [tableComment indexPathForCell:cell];
    NSLog(@"******%ld",(long)path.row);
    [cell.btn1 setSelected:YES];
    [cell.btn2 setSelected:YES];
    [cell.btn3 setSelected:YES];
    [cell.btn4 setSelected:YES];
    [cell.btn5 setSelected:YES];
    [arrayStar replaceObjectAtIndex:path.section withObject:@"5"];
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    CommentEditCell * cell;
    if ([Toolkit isSystemIOS8]) {
        cell=  (CommentEditCell *)[[textView  superview]superview] ;
    }else{
        cell=  (CommentEditCell *)[[[textView superview] superview]superview];
    }
    NSIndexPath * path = [tableComment indexPathForCell:cell];
    NSLog(@"******%ld",(long)path.section);
    [arrayDesc replaceObjectAtIndex:path.section withObject:cell.textview.text];
    
    
}
- (void)textViewDidChange:(UITextView *)textView
{
    CommentEditCell * cell;
    if ([Toolkit isSystemIOS8]) {
        cell=  (CommentEditCell *)[[textView  superview]superview] ;
    }else{
        cell=  (CommentEditCell *)[[[textView superview] superview]superview];
    }
    NSIndexPath * path = [tableComment indexPathForCell:cell];
    NSLog(@"******%ld",(long)path.section);
    if (cell.textview.text.length>0) {
        cell.lblReminder.hidden=YES;
    }
    else{
        cell.lblReminder.hidden=NO;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 

- (IBAction)postinfoclick:(id)sender {
    NSLog(@"%@",arrayStar);
    NSLog(@"%@",arrayDesc);
    
    NSString *strcenter;
    
    for (int i=0; i<arrayStar.count; i++) {
        NSString  *desc=[[arrayDesc objectAtIndex:i] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        strcenter=[NSString stringWithFormat:@"goods[%@][score]=%@&goods[%@][comment]=%@&",[[arrayComment objectAtIndex:i] objectForKey:@"goods_id"],[arrayStar objectAtIndex:i],[[arrayComment objectAtIndex:i] objectForKey:@"goods_id"],desc];
        
        [arrayPost addObject:strcenter];
    }
    NSString *strurl=[arrayPost componentsJoinedByString:@","];
    strurl = [strurl stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSString *lasturl;
    if (btnCheck.selected) {
        lasturl=[NSString stringWithFormat:@"%@anony=1",strurl];
    }
    else{
        lasturl=[NSString stringWithFormat:@"%@anony=0",strurl];
    }
    
    [self orderEvaluation:lasturl];
}

- (IBAction)checkclick:(id)sender {
    if (btnCheck.selected) {
        [btnCheck setSelected:NO];
    }
    else{
        [btnCheck setSelected:YES];
    }
    
}

-(void)orderEvaluation:(NSString *)stringurl 
{
    [SVProgressHUD showWithStatus:@"正在加载"];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        NSLog(@"^^^^%@", resultDict );
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            [Dialog simpleToast:@"评价成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"commentsuccess" object:nil ];
            
            [self.navigationController popViewControllerAnimated:YES];
            
            
        }
        else{
            
        }
        
        
        
    }];
    
    [dataProvider setFailedBlock:^(NSString *strError){
        [SVProgressHUD dismiss];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"检查网络！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        
    }];
    [dataProvider orderEvaluation:stringurl andOrderId:orderId];
    //[dataProvider getStoreList:@"nothing" andPage:shopPage andPerpage:shopPerpage];
}

@end
