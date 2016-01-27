//
//  APPIntroductionController.m
//  LanDouS
//
//  Created by 张留扣 on 15/1/24.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import "APPIntroductionController.h"

@interface APPIntroductionController ()
@property (weak, nonatomic) IBOutlet UILabel *introLab;

@end

@implementation APPIntroductionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setBarTitle:@"应用说明"];
    [self addLeftButton:@"whiteback@2x.png"];
    _lblTitle.textColor=[UIColor whiteColor];
    _topView.backgroundColor=navi_bar_bg_color;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.Scrollview.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    self.introLab.frame = CGRectMake(0,NavigationBar_HEIGHT+StatusBar_HEIGHT , SCREEN_WIDTH, 320);
    self.introLab.numberOfLines = 0;
}


@end
