//
//  ReturnMoneyDetailController.m
//  LanDouS
//
//  Created by Mao-MacPro on 15/1/26.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import "ReturnMoneyDetailController.h"
#import "DataProvider.h"
@interface ReturnMoneyDetailController ()

@end

@implementation ReturnMoneyDetailController
@synthesize dicinfo,lblBuyNum,lblCanReturnMoney,lblDingDanMoney,lblGoodsName,lblGoodsPrice,textReturnMoney,textReturnNum,textReturnReson,btnMoneyAndGoods,btnOnlyReturnMoney;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarTitle:@"退款详情"];
    [self addLeftButton:@"whiteback@2x.png"];
    _lblTitle.textColor=[UIColor whiteColor];
    _topView.backgroundColor=navi_bar_bg_color;
    lblGoodsPrice.text=[NSString stringWithFormat:@"￥%@",[dicinfo objectForKey:@"goods_price"]];
    float price=[[dicinfo objectForKey:@"goods_price"] floatValue]*[[dicinfo objectForKey:@"goods_num"] intValue];
    lblDingDanMoney.text=[NSString stringWithFormat:@"￥%.2f",price];
    lblGoodsName.text=[dicinfo objectForKey:@"goods_name"];
    lblCanReturnMoney.text=[NSString stringWithFormat:@"￥%.2f",price];
    lblBuyNum.text=[dicinfo objectForKey:@"goods_num"];
    
    [btnOnlyReturnMoney setImage:img(@"uncheck.png") forState:UIControlStateNormal];
    [btnOnlyReturnMoney setImage:img(@"check.png") forState:UIControlStateSelected];
    [btnMoneyAndGoods setImage:img(@"uncheck.png") forState:UIControlStateNormal];
    [btnMoneyAndGoods setImage:img(@"check.png") forState:UIControlStateSelected];
    
    dicPost=[[NSMutableDictionary alloc]init];
    [dicPost setObject:[dicinfo objectForKey:@"order_id"] forKey:@"order_id"];
    [dicPost setObject:[dicinfo objectForKey:@"rec_id"] forKey:@"rec_id"];
    
    
    
    // Do any additional setup after loading the view from its nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getList
{
    [SVProgressHUD showWithStatus:@"正在加载"];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        NSLog(@"^^^^%@", resultDict );
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            [Dialog simpleToast:@"退款申请已提交，请耐心等待工作人员审核"];
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
    [dataProvider refund:dicPost];
    //[dataProvider getStoreList:@"nothing" andPage:shopPage andPerpage:shopPerpage];
}


- (IBAction)onlymoneyclick:(id)sender {
    [btnOnlyReturnMoney setSelected:YES];
    [btnMoneyAndGoods setSelected:NO];
    [dicPost setObject:@"1" forKey:@"refund_type"];
    
    
    
}
- (IBAction)moneyandgoodsclick:(id)sender {
    [btnOnlyReturnMoney setSelected:NO];
    [btnMoneyAndGoods setSelected:YES];
    [dicPost setObject:@"2" forKey:@"refund_type"];

}
- (IBAction)sureclick:(id)sender {
    if (textReturnMoney.text.length>0&&textReturnReson.text.length>0&&[[dicPost objectForKey:@"refund_type"]length]>0) {
        [dicPost setObject:textReturnMoney.text forKey:@"refund_amount"];
        if (textReturnNum.text.length>0) {
            [dicPost setObject:textReturnNum.text forKey:@"goods_num"];
            
        }
        [dicPost setObject:textReturnReson.text forKey:@"extend_msg"];
        
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"确认提交申请？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        alert.tag=123;
        
    }
    else{
        [Dialog simpleToast:@"请把相关信息填写完整"];
    }
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==123) {
        if (buttonIndex==1) {
            [self getList];
        }
    }
    
}

@end
