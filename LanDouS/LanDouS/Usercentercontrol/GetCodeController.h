//
//  GetCodeController.h
//  LanDouS
//
//  Created by Mao-MacPro on 14/12/24.
//  Copyright (c) 2014年 Mao-MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
@interface GetCodeController : BaseNavigationController
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
