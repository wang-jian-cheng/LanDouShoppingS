//
//  GetResetCodeController.m
//  LanDouS
//
//  Created by Mao-MacPro on 15/1/25.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import "GetResetCodeController.h"
#import <SMS_SDK/SMSSDK.h>
//#import <SMS_SDK/SMS_UserInfo.h>
//#import <SMS_SDK/SMS_SRUtils.h>
//#import <SMS_SDK/SMS_AddressBook.h>
#import <AddressBook/AddressBook.h>
#import "ResetNewPassController.h"
@interface GetResetCodeController ()

@end

@implementation GetResetCodeController
@synthesize strPhone,lblPhone,btnGetCode,textCode;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarTitle:@"输入验证码"];
    [self addLeftButton:@"whiteback@2x.png"];
    _lblTitle.textColor=[UIColor whiteColor];
    _topView.backgroundColor=navi_bar_bg_color;
    self.view.backgroundColor=[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    [btnGetCode setBackgroundColor:[UIColor colorWithRed:0.92 green:0.62 blue:0.25 alpha:1]];
    [btnGetCode.layer setMasksToBounds:YES];
    btnGetCode.layer.cornerRadius=2.0;
    seconds = 60;
    lblPhone.text=strPhone;
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    // Do any additional setup after loading the view from its nib.
}
-(void)getcode:(NSString *)phone
{
//    [Sm getVerifyCodeByPhoneNumber:phone AndZone:@"86" result:^(enum SMS_GetVerifyCodeResponseState state) {
        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:phone
                                       zone:@"86"
                           customIdentifier:nil
                                     result:^(NSError *error)
         {
             
             if (!error)
             {
                 [SVProgressHUD dismiss];
                
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

- (IBAction)getcodeclick:(id)sender {
    
    if (seconds==60) {
        [timer setFireDate:[NSDate date]];
        [self getcode:strPhone];
        NSLog(@"调接口");
    }
    else{
        NSLog(@"不调");
    }
    
    
}

-(void)timerFireMethod:(NSTimer *)theTimer {
    if (seconds == 1) {
        [timer setFireDate:[NSDate distantFuture]];
        seconds = 60;
        [btnGetCode setBackgroundColor:[UIColor colorWithRed:0.92 green:0.62 blue:0.25 alpha:1]];
        [btnGetCode setTitle:@"重新发送" forState: UIControlStateNormal];
        [btnGetCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnGetCode setEnabled:YES];
    }else{
        seconds--;
        [btnGetCode setBackgroundColor:[UIColor grayColor]];
        NSString *title = [NSString stringWithFormat:@"%d秒",seconds];
        //[btnGetcode setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        //[btnGetcode setEnabled:NO];
        [btnGetCode setTitle:title forState:UIControlStateNormal];
    }
}




- (IBAction)nextclick:(id)sender {
    [SMSSDK commitVerificationCode:textCode.text phoneNumber:strPhone zone:@"86" result:^(NSError *error) {
        if (!error) {
            NSLog(@"block 验证成功");
            ResetNewPassController *Register=[[ResetNewPassController alloc]init];
            Register.strPhone=strPhone;
            [self.navigationController pushViewController:Register animated:YES];

        }
        else
        {
            NSLog(@"block 验证失败");
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"codesenderrtitle", nil)
                                                            message:[NSString stringWithFormat:@"错误描述：%@",[error.userInfo objectForKey:@"getVerificationCode"]]
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }

    }];
    
//    [SMSSDK commitVerifyCode:textCode.text result:^(enum SMS_ResponseState state) {
//        if (1==state) {
//            NSLog(@"block 验证成功");
//            ResetNewPassController *Register=[[ResetNewPassController alloc]init];
//            Register.strPhone=strPhone;
//            [self.navigationController pushViewController:Register animated:YES];
//            
//        }
//        else if(0==state)
//        {
//            NSLog(@"block 验证失败");
//            [Dialog simpleToast:@"亲，验证码无效，请重新输入"];
//        }
//    }];
    
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
