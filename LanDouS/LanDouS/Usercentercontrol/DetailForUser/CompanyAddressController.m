//
//  CompanyAddressController.m
//  LanDouS
//
//  Created by 张留扣 on 15/1/24.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import "CompanyAddressController.h"

@interface CompanyAddressController ()

@end

@implementation CompanyAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setBarTitle:@"公司地址"];
    [self addLeftButton:@"dackback@2x.png"];
    _lblTitle.textColor=[UIColor whiteColor];
    _topView.backgroundColor=navi_bar_bg_color;
}

- (IBAction)kefulclick:(id)sender {
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:4008827090"]];
    UIWebView *phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    [self.view addSubview:phoneCallWebView];
    
}

- (IBAction)shouhouclick:(id)sender {
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:05393126699"]];
    UIWebView *phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    [self.view addSubview:phoneCallWebView];
}

@end
