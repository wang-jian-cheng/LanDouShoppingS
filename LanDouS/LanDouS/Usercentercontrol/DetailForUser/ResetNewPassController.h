//
//  ResetNewPassController.h
//  LanDouS
//
//  Created by Mao-MacPro on 15/1/25.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
@interface ResetNewPassController : BaseNavigationController
@property(nonatomic,copy)NSString *strPhone;
@property (strong, nonatomic) IBOutlet UILabel *lblPhone;

@property (strong, nonatomic) IBOutlet UITextField *textPassword;
@property (strong, nonatomic) IBOutlet UITextField *textPasswordAgain;
 
- (IBAction)registerclick:(id)sender;
- (IBAction)agreementclick:(id)sender;
@end
