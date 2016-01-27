//
//  RegisterController.m
//  LanDouS
//
//  Created by Mao-MacPro on 14/12/24.
//  Copyright (c) 2014年 Mao-MacPro. All rights reserved.
//

#import "RegisterController.h"
#import "DataProvider.h"
#import "UserAgreementController.h"
@interface RegisterController ()

@end

@implementation RegisterController
@synthesize lblPhone,textEmail,textUsername,textPassword,textPasswordAgain,strPhone;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarTitle:@"用户注册"];
    [self addLeftButton:@"whiteback@2x.png"];
    _lblTitle.textColor=[UIColor whiteColor];
    _topView.backgroundColor=navi_bar_bg_color;
    self.view.backgroundColor=[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    lblPhone.text=[NSString stringWithFormat:@"手机号：%@",strPhone];
    textEmail.hidden=YES;
NSString* email=[    NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] ];
    textEmail.text=email;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)registerclick:(id)sender {
    if (textUsername.text.length>0&&textPassword.text.length>0&&textPasswordAgain.text.length>0&&textEmail.text.length>0) {
        
        if ([textPassword.text isEqualToString:textPasswordAgain.text]) {
            
            if (textPassword.text.length<6) {
                [Dialog simpleToast:@"亲，密码长度不能小于六位"];
            }
            else{
                [self getRegisterData];
            }
            
            
        }
        else{
            [Dialog simpleToast:@"亲，两次密码输入不一致"];
        }
        
        
    }
    else{
        [Dialog simpleToast:@"亲，请将信息填写完整哦"];
    }
    
    
}

- (IBAction)useragrementclick:(id)sender {
    UserAgreementController *UserAgreement=[[UserAgreementController alloc]init];
    [self.navigationController pushViewController:UserAgreement animated:YES];
}
-(void)getRegisterData
{
    [SVProgressHUD show];
    
    
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        NSLog(@"^^^^%@", resultDict );
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            //set_sp(@"userinfo",[resultDict objectForKey:@"data"]);
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"注册成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            [alert setTag:1000];
        }
        else{
            [Dialog simpleToast:@"注册失败，请检查一下您的注册信息"];
        }
        
        
        
    }];
    
    [dataProvider setFailedBlock:^(NSString *strError){
        [SVProgressHUD dismiss];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"检查网络！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        
    }];
    
    [dataProvider userregister:strPhone andPassword:textPassword.text andName:textUsername.text andEmail:textEmail.text];
    //[dataProvider userLogin:phone andpassword:password_md5];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1000) {
        [self getlogindata];
    }
    
}
-(void)getlogindata
{
    [SVProgressHUD showWithStatus:@"正在登录"];;
    NSUserDefaults *userinfo=[NSUserDefaults standardUserDefaults];
    
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        NSLog(@"^^^^%@", resultDict );
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            [Dialog simpleToast:@"登录成功！"];
            
            set_sp(@"userinfo",[resultDict objectForKey:@"data"]);
            [sp synchronize];
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"userinfoLogin" object:nil ];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else{
            [Dialog simpleToast:@"登录失败！"];
        }
        
        
        
    }];
    
    [dataProvider setFailedBlock:^(NSString *strError){
        [SVProgressHUD dismiss];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"检查网络！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        
    }];
    
    [dataProvider userlogin:textUsername.text andPassword:textPassword.text];
}




@end
