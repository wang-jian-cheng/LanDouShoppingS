//
//  AppDelegate.h
//  LanDouS
//
//  Created by Mao-MacPro on 14/12/23.
//  Copyright (c) 2014年 Mao-MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTabBarViewController.h"
#import "FirstScrollController.h"
#import "WXApi.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate>
{
    CustomTabBarViewController *_tabBarViewCol;
    FirstScrollController *firstCol;
}
- (void)showTabBar;
- (void)hiddenTabBar;
-(CustomTabBarViewController *)getTabBar;
@property (strong, nonatomic) UIWindow *window;
//@property(nonatomic,strong)

@end

