//
//  CompanyPhoneViewController.m
//  LanDouS
//
//  Created by 张留扣 on 15/1/24.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import "CompanyPhoneViewController.h"

@interface CompanyPhoneViewController ()

@end

@implementation CompanyPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setBarTitle:@"联系电话"];
    [self addLeftButton:@"whiteback@2x.png"];
    _lblTitle.textColor=[UIColor whiteColor];
    _topView.backgroundColor=navi_bar_bg_color;
}


//- (IBAction)kefulclick:(id)sender {
//    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:4008827090"]];
//    UIWebView *phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
//    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
//    [self.view addSubview:phoneCallWebView];
//    
//}

- (IBAction)shouhouclick:(id)sender {
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:05397822170"]];
    UIWebView *phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    [self.view addSubview:phoneCallWebView];
}


@end
