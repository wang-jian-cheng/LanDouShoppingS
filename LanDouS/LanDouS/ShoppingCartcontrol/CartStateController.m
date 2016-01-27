//
//  CartStateController.m
//  LanDouS
//
//  Created by Mao-MacPro on 15/1/14.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import "CartStateController.h"
#import "AppDelegate.h"
#import "DataProvider.h"
@interface CartStateController ()

@end

@implementation CartStateController
@synthesize strState,imgState,strName,strNum,strPrice,lblName,lblNum,lblPrice;
- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.textColor=[UIColor whiteColor];
    _topView.backgroundColor=navi_bar_bg_color;
    [self addLeftButton:@"whiteback@2x.png"];
    if ([strState isEqualToString:@"success"]) {
        imgState.image=img(@"paysuccess.png");
        [self setBarTitle:@"支付成功"];
        [self payOrder:strNum];
    }
    else{
        imgState.image=img(@"payfailed.png");
        [self setBarTitle:@"支付失败"];
    }
    lblPrice.text=[NSString stringWithFormat:@"商品金额：￥%@",strPrice];
    lblNum.text=[NSString stringWithFormat:@"订单号：%@",strNum];
    lblName.text=[NSString stringWithFormat:@"商品名：%@",strName];
    // Do any additional setup after loading the view from its nib.
}

-(void)payOrder:(NSString *)paySn
{
    [SVProgressHUD showWithStatus:@"正在加载"];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        NSLog(@"^^^^%@", resultDict );
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            
            
            
            
            
            
        }
        
        else{
            
        }
        
        
        
    }];
    
    [dataProvider setFailedBlock:^(NSString *strError){
        [SVProgressHUD dismiss];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"检查网络！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        
    }];
    [dataProvider payorder:paySn];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden=YES;
}
-(void)clickLeftButton:(UIButton *)sender
{
    CustomTabBarViewController * tabbar=[(AppDelegate *)[[UIApplication sharedApplication] delegate] getTabBar];
    [tabbar selectTableBarIndex:0];
    [self.navigationController popToRootViewControllerAnimated:YES];
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
