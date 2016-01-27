//
//  CompanyIntroductionController.m
//  LanDouS
//
//  Created by 张留扣 on 15/1/24.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import "CompanyIntroductionController.h"

@interface CompanyIntroductionController ()
@property (weak, nonatomic) IBOutlet UILabel *introLab;

@end

@implementation CompanyIntroductionController
    
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setBarTitle:@"公司介绍"];
    [self addLeftButton:@"whiteback@2x.png"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.ScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    _lblTitle.textColor=[UIColor whiteColor];
    _topView.backgroundColor=navi_bar_bg_color;
    self.introLab.frame = CGRectMake(0,NavigationBar_HEIGHT+StatusBar_HEIGHT , SCREEN_WIDTH, 320);
    self.introLab.numberOfLines = 0;
}




@end
