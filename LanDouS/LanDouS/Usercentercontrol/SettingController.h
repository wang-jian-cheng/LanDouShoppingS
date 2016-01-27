//
//  SettingController.h
//  LanDouS
//
//  Created by Mao-MacPro on 15/1/7.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
@interface SettingController : BaseNavigationController
- (IBAction)logoutclick:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollBG;

@end
