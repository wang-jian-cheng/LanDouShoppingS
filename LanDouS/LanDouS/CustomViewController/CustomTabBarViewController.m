//
//  CustomTabBarViewController.m
//  Blinq
//
//  Created by Sugar on 13-8-12.
//  Copyright (c) 2013年 Sugar Hou. All rights reserved.
//

#import "CustomTabBarViewController.h"
#import "CommenDef.h"
#import "Toolkit.h"
#import "HomeViewController.h"
#import "TypeViewController.h"
#import "ShopListViewController.h"
#import "ShoppingCartController.h"
#import "UserCenterController.h"


#import "UIImage+NSBundle.h"


#define tabBarButtonNum 4

@interface CustomTabBarViewController ()
{
    NSArray *_arrayImages;
    UIButton *_btnSelected;
    UIView *_tabBarBG;
}
@end

@implementation CustomTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //隐藏系统tabbar
    self.tabBar.hidden = YES;
    self.hidesBottomBarWhenPushed = YES;
     NSArray *arrayImages_H = [[NSArray alloc] initWithObjects:@"home_H@2x.png",@"classes_H@2x.png" ,@"cate_H@2x.png",@"user_H@2x.png", nil];
 	NSArray *arrayImages = [[NSArray alloc] initWithObjects:@"home@2x.png",@"class@2x.png",@"cate@2x.png",@"user@2x.png",  nil];
 
    _tabBarBG = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - TabBar_HEIGHT, SCREEN_WIDTH, TabBar_HEIGHT)];
      _tabBarBG.backgroundColor = [UIColor colorWithRed:0.99 green:0.99 blue:0.99 alpha:1];
    
    //_tabBarBG.backgroundColor=[UIColor clearColor];
    //_tabBarBG.alpha=0.9;
    [self.view addSubview:_tabBarBG];
//    UIImageView *imageline1=[[UIImageView alloc]initWithFrame:CGRectMake(0,0.3, SCREEN_WIDTH, 0.3)];
//    imageline1.backgroundColor=[UIColor colorWithRed:0.88 green:0.89 blue:0.89 alpha:1];
//    [self.view addSubview:imageline1];
    //自定义tabbar的按钮和图片
	
    int tabBarWitdh = SCREEN_WIDTH * 1.0f / tabBarButtonNum;
	for(int i = 0; i < tabBarButtonNum; i++)
	{
		CGRect frame=CGRectMake(i * tabBarWitdh, 0, tabBarWitdh, 49);
    
		UIButton * btnTabBar = [[UIButton alloc] initWithFrame:frame];
		 [btnTabBar setImage: [UIImage imageWithBundleName:[arrayImages objectAtIndex:i]] forState:UIControlStateNormal];
         [btnTabBar setImage:[UIImage imageWithBundleName:[arrayImages_H objectAtIndex:i]]forState:UIControlStateSelected] ;
//        btnTabBar.titleLabel.font=[UIFont systemFontOfSize:8.0];
//        btnTabBar.titleLabel.textAlignment=NSTextAlignmentCenter;
//         [btnTabBar setTitle:[arrayTitle objectAtIndex:i] forState:UIControlStateNormal];
//         [btnTabBar setTitleEdgeInsets:UIEdgeInsetsMake(30, -30, 0, 0)];
//         [btnTabBar setImageEdgeInsets:UIEdgeInsetsMake(-10, 15, 0, 0)];
		btnTabBar.tag = i + 1000;
		[btnTabBar addTarget:self action:@selector(onTabButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
		[_tabBarBG addSubview:btnTabBar];
        
        
//        UILabel *lbl_title = [[UILabel alloc] initWithFrame:CGRectMake(btnTabBar.frame.origin.x, 37, btnTabBar.frame.size.width, 9)];
//        lbl_title.text =[arrayTitle objectAtIndex:i];
//        lbl_title.textAlignment=NSTextAlignmentCenter;
//        lbl_title.numberOfLines = 0;
//        lbl_title.font = [UIFont systemFontOfSize:10];
//        lbl_title.textColor = [UIColor darkGrayColor];
//        lbl_title.backgroundColor = [UIColor clearColor];
//        [_tabBarBG addSubview:lbl_title];
        
        
        
        
	}
    
    
   
    HomeViewController *HomeView=[[HomeViewController alloc]init];
    if ([Toolkit isSystemIOS7]||[Toolkit isSystemIOS8])
        HomeView.automaticallyAdjustsScrollViewInsets = NO;
    UINavigationController * homeviewnav=[[UINavigationController alloc]initWithRootViewController:HomeView];
//    homePageNavigation.automaticallyAdjustsScrollViewInsets = YES;
    HomeView.hidesBottomBarWhenPushed = YES;
    homeviewnav.navigationBar.hidden=YES;
    
    TypeViewController *typeView=[[TypeViewController alloc]init];
    UINavigationController *typeViewnav = [[UINavigationController alloc] initWithRootViewController:typeView];
    typeView.hidesBottomBarWhenPushed=YES;
    typeViewnav.navigationBar.hidden=YES;
    
    ShopListViewController *shoplistView=[[ShopListViewController alloc]init];
    UINavigationController *shoplistViewnav = [[UINavigationController alloc] initWithRootViewController:shoplistView];
    shoplistView.hidesBottomBarWhenPushed = YES;
    shoplistViewnav.navigationBarHidden=YES;
    //消息
    
    ShoppingCartController *ShoppingCart=[[ShoppingCartController alloc]init];
    UINavigationController *ShoppingCartnav = [[UINavigationController alloc] initWithRootViewController:ShoppingCart];
    ShoppingCart.hidesBottomBarWhenPushed=YES;
    ShoppingCartnav.navigationBar.hidden=YES;
 
    UserCenterController *UserCenterView=[[UserCenterController alloc]init];
    UINavigationController *UserCenterViewnav=[[UINavigationController alloc]initWithRootViewController:UserCenterView];
    UserCenterView.hidesBottomBarWhenPushed = YES;
    UserCenterViewnav.navigationBarHidden=YES;
    //加入到真正的tabbar
    //fix me 商铺选项卡暂时隐藏
    self.viewControllers=[NSArray arrayWithObjects:homeviewnav,typeViewnav,ShoppingCartnav,UserCenterViewnav,nil];
    
    UIButton *btnSender = (UIButton *)[self.view viewWithTag:0 + 1000];
    [self onTabButtonPressed:btnSender];
    
    
}

 


//点击tab页时的响应
-(void)onTabButtonPressed:(UIButton *)sender
{
    
    
    
    if (_btnSelected == sender)
        return ;
    
    if (_btnSelected)
        _btnSelected.selected = !_btnSelected.selected;
    
    sender.selected = !sender.selected;
    _btnSelected = sender;
    [self setSelectedIndex:sender.tag - 1000];
}

- (void)selectTableBarIndex:(NSInteger)index
{
    if (index < 0 || index > 5)
        return ;
    UIButton *btnSender = (UIButton *)[self.view viewWithTag:index + 1000];
    [self onTabButtonPressed:btnSender];
}

//隐藏tabbar
- (void)hideCustomTabBar
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	_tabBarBG.frame=CGRectMake(0, SCREEN_HEIGHT, 320, _tabBarBG.frame.size.height);
	[UIView commitAnimations];
	
}
//显示tabbar
-(void)showTabBar
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	_tabBarBG.frame=CGRectMake(0, SCREEN_HEIGHT - TabBar_HEIGHT, SCREEN_WIDTH, _tabBarBG.frame.size.height);
	[UIView commitAnimations];
}

- (void)goToHomePage
{
    [self setSelectedIndex:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
