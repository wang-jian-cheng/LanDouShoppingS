//
//  UserAgreementController.m
//  HuanHuan
//
//  Created by Mao-MacPro on 14/12/22.
//  Copyright (c) 2014年 Mao-MacPro. All rights reserved.
//

#import "UserAgreementController.h"

@interface UserAgreementController ()

@end

@implementation UserAgreementController
@synthesize webview;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarTitle:@"用户使用协议"];
    [self addLeftButton:@"whiteback@2x.png"];
    _lblTitle.textColor=[UIColor whiteColor];
    _topView.backgroundColor=navi_bar_bg_color;
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"index" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webview loadRequest:request];
    // Do any additional setup after loading the view from its nib.
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
