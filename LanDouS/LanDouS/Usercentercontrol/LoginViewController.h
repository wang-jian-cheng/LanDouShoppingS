//
//  LoginViewController.h
//  LanDouS
//
//  Created by Mao-MacPro on 14/12/24.
//  Copyright (c) 2014年 Mao-MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
@interface LoginViewController : BaseNavigationController
@property (strong, nonatomic) IBOutlet UITextField *textUsername;
@property (strong, nonatomic) IBOutlet UITextField *textPassword;
- (IBAction)loginclick:(id)sender;
- (IBAction)forgetpassword:(id)sender;
@property(copy,nonatomic)NSString *strType;
@end
