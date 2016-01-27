//
//  ResetPasswordController.h
//  LanDouS
//
//  Created by 张留扣 on 15/1/24.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import "BaseNavigationController.h"

@interface ResetPasswordController : BaseNavigationController

@property (strong, nonatomic) IBOutlet UITextField *myField;
- (IBAction)NextAction:(id)sender;
- (IBAction)agreementclick:(id)sender;
@end
