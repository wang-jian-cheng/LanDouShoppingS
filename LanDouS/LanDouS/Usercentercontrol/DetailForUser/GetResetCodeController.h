//
//  GetResetCodeController.h
//  LanDouS
//
//  Created by Mao-MacPro on 15/1/25.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
@interface GetResetCodeController : BaseNavigationController
{
    int seconds;
    NSTimer *timer;
}

@property (nonatomic,copy)NSString *strPhone;
@property (strong, nonatomic) IBOutlet UILabel *lblPhone;
@property (strong, nonatomic) IBOutlet UITextField *textCode;
@property (strong, nonatomic) IBOutlet UIButton *btnGetCode;
- (IBAction)getcodeclick:(id)sender;
- (IBAction)nextclick:(id)sender;
@end
