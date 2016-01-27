//
//  ResetNewPassController.m
//  LanDouS
//
//  Created by Mao-MacPro on 15/1/25.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import "ResetNewPassController.h"
#import "DataProvider.h"
#import "UserAgreementController.h"
@interface ResetNewPassController ()

@end

@implementation ResetNewPassController
@synthesize lblPhone,textPassword,textPasswordAgain,strPhone;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBarTitle:@"密码重置"];
    [self addLeftButton:@"whiteback@2x.png"];
    _lblTitle.textColor=[UIColor whiteColor];
    _topView.backgroundColor=navi_bar_bg_color;
    self.view.backgroundColor=[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    lblPhone.text=[NSString stringWithFormat:@"手机号：%@",strPhone];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)registerclick:(id)sender {
    if ( textPassword.text.length>0&&textPasswordAgain.text.length>0 ) {
        if ([textPassword.text isEqualToString:textPasswordAgain.text]) {
            [self getresetpassword];
        }
        else{
            [Dialog simpleToast:@"亲，两次密码输入不一致"];
        }
        
        
    }
    else{
        [Dialog simpleToast:@"亲，请把信息填写完整"];
    }
    
    
}
-(void)getresetpassword
{
    [SVProgressHUD show];
    
    
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        NSLog(@"^^^^%@", resultDict );
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            //set_sp(@"userinfo",[resultDict objectForKey:@"data"]);
            [Dialog simpleToast:@"YEAH，密码修改成功！"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else{
            [Dialog simpleToast:[resultDict objectForKey:@"message"]];
        }
        
        
        
    }];
    
    [dataProvider setFailedBlock:^(NSString *strError){
        [SVProgressHUD dismiss];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"检查网络！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        
    }];
    
    [dataProvider resetPassword:strPhone andPassword:textPassword.text];
    //[dataProvider userLogin:phone andpassword:password_md5];
}

- (IBAction)agreementclick:(id)sender {
    UserAgreementController *UserAgreement=[[UserAgreementController alloc]init];
    [self.navigationController pushViewController:UserAgreement animated:YES];
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
