//
//  SettingController.m
//  LanDouS
//
//  Created by Mao-MacPro on 15/1/7.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import "SettingController.h"
#import "AppDelegate.h"

#import "CompanyIntroductionController.h"
#import "CompanyAddressController.h"
#import "CompanyPhoneViewController.h"
#import "WriteCommentsController.h"
#import "APPIntroductionController.h"
#import "ResetPasswordController.h"
#import "DataProvider.h"
#import "SVProgressHUD.h"
@interface SettingController ()
{
    NSString *urlString;
}
@end

@implementation SettingController
@synthesize scrollBG;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarTitle:@"更多设置"];
    _lblTitle.textColor=[UIColor whiteColor];
    _topView.backgroundColor=navi_bar_bg_color;
    [self addLeftButton:@"whiteback@2x.png"];
    scrollBG.contentSize=CGSizeMake(SCREEN_WIDTH, 560);
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}


- (IBAction)logoutclick:(id)sender {
    remove_sp(@"userinfo");
    remove_sp(@"address");
    CustomTabBarViewController * tabbar=[(AppDelegate *)[[UIApplication sharedApplication] delegate] getTabBar];
    [tabbar selectTableBarIndex:0];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)btn1Action:(id)sender
{
    CompanyIntroductionController *introductionVC = [[CompanyIntroductionController alloc]init];
    [self.navigationController pushViewController:introductionVC animated:YES];
}

- (IBAction)btn2Action:(id)sender
{
    CompanyAddressController *commpanyAddressVC = [[CompanyAddressController alloc]init];
    [self.navigationController pushViewController:commpanyAddressVC animated:YES];
}

- (IBAction)btn3Action:(id)sender
{
    CompanyPhoneViewController *companyPhoneVC = [[CompanyPhoneViewController alloc]init];
    [self.navigationController pushViewController:companyPhoneVC animated:YES];
}

- (IBAction)btn4Action:(id)sender
{
    WriteCommentsController *writeCommentsVC = [[WriteCommentsController alloc]init];
    [self.navigationController pushViewController:writeCommentsVC animated:YES];
}

- (IBAction)btn5Action:(id)sender
{
    APPIntroductionController *APPIntroductionVC = [[APPIntroductionController alloc]init];
    [self.navigationController pushViewController:APPIntroductionVC animated:YES];
}

- (IBAction)btn6Action:(id)sender
{
    //版本更新
    //   code ***
    
    [SVProgressHUD show];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        if ([[resultDict objectForKey:@"result"] intValue] == 1)
        {
            
            
            urlString=[[resultDict objectForKey:@"data"]objectForKey:@"download_link"];
            float newVersion=[[[resultDict objectForKey:@"data"] objectForKey:@"version_name"] floatValue];
            
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            float app_Version = [[infoDictionary objectForKey:@"CFBundleShortVersionString"] floatValue];
            
            if (app_Version<newVersion) {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"检测到新版本，是否去升级？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
            }
            else{
                [Dialog simpleToast:@"已经是最新版"];
            }
            
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"获取版本号失败!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
            [alert show];
            alert.tag=9111;
            
        }
    }];
    
    [dataProvider setFailedBlock:^(NSString *strError){
        [SVProgressHUD dismiss];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"检查网络！" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert show];
    }];
    [dataProvider getAPPVersionWithPlatform];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==9111) {
        if (buttonIndex==1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }
    }
    
}
- (IBAction)btn7Action:(id)sender
{
    ResetPasswordController *ResetVC = [[ResetPasswordController alloc]init];
    [self.navigationController pushViewController:ResetVC animated:YES];
}



@end
