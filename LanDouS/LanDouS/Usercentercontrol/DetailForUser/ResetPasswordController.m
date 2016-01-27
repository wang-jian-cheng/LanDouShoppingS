//
//  ResetPasswordController.m
//  LanDouS
//
//  Created by 张留扣 on 15/1/24.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import "ResetPasswordController.h"
#import <SMS_SDK/SMSSDK.h>
//#import <SMS_SDK/SMS_SRUtils.h>
//#import <SMS_SDK/CountryAndAreaCode.h>
#import "GetResetCodeController.h"
#import "UserAgreementController.h"
@interface ResetPasswordController ()

@end

@implementation ResetPasswordController
@synthesize myField;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setBarTitle:@"重置密码"];
    [self addLeftButton:@"whiteback@2x.png"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _lblTitle.textColor=[UIColor whiteColor];
    _topView.backgroundColor=navi_bar_bg_color;
//    self.myField.layer.masksToBounds = YES;
//    self.myField.layer.cornerRadius = 5;
//    self.myField.layer.borderWidth = 1;
//    self.myField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
}


- (IBAction)NextAction:(id)sender
{
    if (myField.text.length!=11) {
        [Dialog simpleToast:@"手机号码格式不对，请确认好之后重新输入！"];
    }
    else{
        NSString* str=[NSString stringWithFormat:@"我们将发送验证码短信到这个号码:+86 %@",myField.text];
        //_str=[NSString stringWithFormat:@"%@",self.telField.text];
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"确认手机号码" message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [myField resignFirstResponder];
    if (1==buttonIndex)
    {
        NSLog(@"点击了确定按钮");
        GetResetCodeController * verify=[[GetResetCodeController alloc] init];
        NSString* str2=@"86";
        verify.strPhone=myField.text;
        
       // [SMS_SDK getVerifyCodeByPhoneNumber:myField.text AndZone:str2 result:^(enum SMS_GetVerifyCodeResponseState state) {
            
        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:myField.text
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

    }
    if (0==buttonIndex) {
        NSLog(@"点击了取消按钮");
    }
}
- (IBAction)agreementclick:(id)sender {
    UserAgreementController *UserAgreement=[[UserAgreementController alloc]init];
    [self.navigationController pushViewController:UserAgreement animated:YES];
}
@end
