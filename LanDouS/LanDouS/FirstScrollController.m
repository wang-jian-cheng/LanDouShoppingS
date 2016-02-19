//
//  FirstScrollController.m
//  LanDouS
//
//  Created by Mao-MacPro on 15/1/20.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import "FirstScrollController.h"

#define NUMBER_OF_PAGES     5
#define PAGECTL_ON_IMG      1

@interface FirstScrollController ()
{
    UIButton *nextBtn;
}
@end

@implementation FirstScrollController
@synthesize scrollBG,pageCol;
- (void)viewDidLoad {
    [super viewDidLoad];
    scrollBG=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    scrollBG.delegate=self;
    scrollBG.showsHorizontalScrollIndicator=NO;
    scrollBG.contentSize=CGSizeMake(SCREEN_WIDTH*NUMBER_OF_PAGES, SCREEN_HEIGHT);
    scrollBG.pagingEnabled=YES;
    [self.view addSubview:scrollBG];
    
    for (int i=0; i<NUMBER_OF_PAGES; i++) {
        UIImageView *imgInfo=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*i,0,SCREEN_WIDTH,SCREEN_HEIGHT)];
        imgInfo.image=[UIImage imageNamed:[NSString stringWithFormat:@"%d.png",i+1]];
        [scrollBG addSubview:imgInfo];
        
    }
    nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 160, 60)];
    nextBtn.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/100 *90);
    [nextBtn addTarget:self action:@selector(changeRootViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
#if !PAGECTL_ON_IMG
    pageCol=[[UIPageControl alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-30, 320, 20)];
    pageCol.numberOfPages=NUMBER_OF_PAGES;
    //pageCol.center=CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-30);
    [self.view addSubview:pageCol];
#endif
    
    // Do any additional setup after loading the view from its nib.
}
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    
    
#if !PAGECTL_ON_IMG
    int pageIndex = fabs(sender.contentOffset.x) /sender.frame.size.width;
    pageCol.currentPage = pageIndex;
#endif
    

    if(sender.contentOffset.x>=(SCREEN_WIDTH*(NUMBER_OF_PAGES - 2)+40))
    {
        
        [self.view addSubview:nextBtn];
    }
    else
    {
        [nextBtn removeFromSuperview];
    }
    
    
    if (sender.contentOffset.x>(SCREEN_WIDTH*(NUMBER_OF_PAGES - 1)+40)) {
        
        set_sp(@"FIRST_ENTER", @"1");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeRootView" object:nil ];
    }
    
    
}

-(void)changeRootViewBtnClick:(UIButton *)sender
{
    set_sp(@"FIRST_ENTER", @"1");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeRootView" object:nil ];
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
