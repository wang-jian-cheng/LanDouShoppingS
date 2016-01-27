//
//  LoginViewController.m
//  LanDouS
//
//  Created by Mao-MacPro on 14/12/24.
//  Copyright (c) 2014年 Mao-MacPro. All rights reserved.
//

#import "LoginViewController.h"
#import "InputPhoneNumController.h"
#import "DataProvider.h"
#import "AppDelegate.h"
#import "ResetPasswordController.h"
@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize textPassword,textUsername,strType;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarTitle:@"登录"];
    [self addLeftButton:@"whiteback@2x.png"];
    _lblTitle.textColor=[UIColor whiteColor];
    _topView.backgroundColor=navi_bar_bg_color;
    [_btnRight setTitle:@"注册" forState:UIControlStateNormal];
    [_btnRight setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _btnRight.titleLabel.font=[UIFont systemFontOfSize:13.0];
    self.view.backgroundColor=[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    // Do any additional setup after loading the view from its nib.
}
-(void)clickLeftButton:(UIButton *)sender
{
    
    if ([strType isEqualToString:@"nav"]) {
        
    }
    else{
        CustomTabBarViewController * tabbar=[(AppDelegate *)[[UIApplication sharedApplication] delegate] getTabBar];
        [tabbar selectTableBarIndex:0];
    
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)clickRightButton:(UIButton *)sender
{
    InputPhoneNumController *InputPhoneNum=[[InputPhoneNumController alloc]init];
    [self.navigationController pushViewController:InputPhoneNum animated:YES];
    
}


-(void)getlogindata
{
    [SVProgressHUD showWithStatus:@"正在登录"];;
//    NSUserDefaults *userinfo=[NSUserDefaults standardUserDefaults];
    
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        NSLog(@"^^^^%@", resultDict );
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            [Dialog simpleToast:@"登录成功"];
            
            set_sp(@"userinfo",[resultDict objectForKey:@"data"]);
            [sp synchronize];
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"userinfoLogin" object:nil ];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else{
            [Dialog simpleToast:@"账户或密码错误"];
        }
        
        
        
    }];
    
    [dataProvider setFailedBlock:^(NSString *strError){
        [SVProgressHUD dismiss];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"检查网络！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        
    }];
    
    [dataProvider userlogin:textUsername.text andPassword:textPassword.text];
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 

- (IBAction)loginclick:(id)sender {
    if (textPassword.text.length>0&&textUsername.text.length>0) {
        [self getlogindata];
    }
    else
    {
        [Dialog simpleToast:@"亲，用户名或密码为空"];
    }
}

- (IBAction)forgetpassword:(id)sender {
    ResetPasswordController *ResetPassword=[[ResetPasswordController alloc]init];
    [self.navigationController pushViewController:ResetPassword animated:YES];
}
@end
