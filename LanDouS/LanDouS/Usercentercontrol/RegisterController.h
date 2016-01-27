//
//  RegisterController.h
//  LanDouS
//
//  Created by Mao-MacPro on 14/12/24.
//  Copyright (c) 2014年 Mao-MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
@interface RegisterController : BaseNavigationController
@property(nonatomic,copy)NSString *strPhone;
@property (strong, nonatomic) IBOutlet UILabel *lblPhone;
@property (strong, nonatomic) IBOutlet UITextField *textUsername;
@property (strong, nonatomic) IBOutlet UITextField *textPassword;
@property (strong, nonatomic) IBOutlet UITextField *textPasswordAgain;
@property (strong, nonatomic) IBOutlet UITextField *textEmail;
- (IBAction)registerclick:(id)sender;
- (IBAction)useragrementclick:(id)sender;

@end
