//
//  InputPhoneNumController.m
//  LanDouS
//
//  Created by Mao-MacPro on 14/12/24.
//  Copyright (c) 2014年 Mao-MacPro. All rights reserved.
//

#import "InputPhoneNumController.h"
#import <SMS_SDK/SMSSDK.h>
//
//#import <SMS_SDK/CountryAndAreaCode.h>
#import "GetCodeController.h"
#import "UserAgreementController.h"
#import "DataProvider.h"
@interface InputPhoneNumController ()

@end

@implementation InputPhoneNumController
@synthesize textPhone,lblReminder;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarTitle:@"输入手机号"];
    _lblTitle.textColor=[UIColor whiteColor];
    _topView.backgroundColor=navi_bar_bg_color;
    isphoneUsed=YES;
    lblReminder.hidden=YES;
    [self addLeftButton:@"whiteback@2x.png"];
    self.view.backgroundColor=[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    [textPhone addTarget:self action:@selector(textChangeAction:) forControlEvents:UIControlEventEditingChanged];    // Do any additional setup after loading the view from its nib.
}
- (void) textChangeAction:(id) sender
{
    lblReminder.hidden=YES;
    if (textPhone.text.length==11) {
        [self isphoneUsed];
    }
    else if (textPhone.text.length>11||textPhone.text.length<11)
    {
        isphoneUsed=YES;
        
        
    }
}
-(void)isphoneUsed
{
    
    
    
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        NSLog(@"^^^^%@", resultDict );
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            if ([[resultDict objectForKey:@"find"]intValue]==0) {
                isphoneUsed=NO;
                
            }
            else{
                lblReminder.hidden=NO;
            }
            
        }
        else{
            lblReminder.hidden=NO;
        }
        
        
        
    }];
    
    [dataProvider setFailedBlock:^(NSString *strError){
        [SVProgressHUD dismiss];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"检查网络！" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert show];
        
    }];
    
    [dataProvider isPhoneRegged:textPhone.text];
    //[dataProvider userLogin:phone andpassword:password_md5];
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

- (IBAction)nextclick:(id)sender {
    if (isphoneUsed) {
        return;
    }
    if (textPhone.text.length!=11) {
        [Dialog simpleToast:@"亲，手机号码格式不对，请确认好之后重新输入！"];
    }
    else{
        NSString* str=[NSString stringWithFormat:@"我们将发送验证码短信到这个号码:+86 %@",textPhone.text];
        //_str=[NSString stringWithFormat:@"%@",self.telField.text];
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"确认手机号码" message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [textPhone resignFirstResponder];
    if (1==buttonIndex)
    {
        NSLog(@"点击了确定按钮");
        GetCodeController * verify=[[GetCodeController alloc] init];
        NSString* str2=@"86";
        verify.strPhone=textPhone.text;
        
        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:textPhone.text
                                       zone:@"86"
                           customIdentifier:nil
                                     result:^(NSError *error)
         {
             
             if (!error)
             {
                 [SVProgressHUD dismiss];
                 [self.navigationController pushViewController:verify animated:YES];
             }
             else
             {
                 [SVProgressHUD dismiss];
                 UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"codesenderrtitle", nil)
                                                                 message:[NSString stringWithFormat:@"错误描述：%@",[error.userInfo objectForKey:@"getVerificationCode"]]
                                                                delegate:self
                                                       cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                                       otherButtonTitles:nil, nil];
                 [alert show];
             }
             
         }];
        
        
//        [SMSSDK getVerifyCodeByPhoneNumber:textPhone.text AndZone:str2 result:^(enum SMS_GetVerifyCodeResponseState state) {
//            
//        }]
    }
    if (0==buttonIndex) {
        NSLog(@"点击了取消按钮");
    }
}

//if (1==state) {
//    NSLog(@"block 获取验证码成功");
//    [self.navigationController pushViewController:verify animated:YES];
//    
//}
//else if(0==state)
//{
//    NSLog(@"block 获取验证码失败");
//    NSString* str=[NSString stringWithFormat:@"验证码发送失败 请稍后重试"];
//    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"发送失败" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [alert show];
//}
//else if (SMS_ResponseStateMaxVerifyCode==state)
//{
//    NSString* str=[NSString stringWithFormat:@"请求验证码超上限 请稍后重试"];
//    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"超过上限" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [alert show];
//}
//else if(SMS_ResponseStateGetVerifyCodeTooOften==state)
//{
//    NSString* str=[NSString stringWithFormat:@"客户端请求发送短信验证过于频繁"];
//    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [alert show];
//}
//

- (IBAction)agreementclick:(id)sender {
    UserAgreementController *UserAgreement=[[UserAgreementController alloc]init];
    [self.navigationController pushViewController:UserAgreement animated:YES];
}
@end
