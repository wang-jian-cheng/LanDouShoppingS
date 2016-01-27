//
//  InputPhoneNumController.h
//  LanDouS
//
//  Created by Mao-MacPro on 14/12/24.
//  Copyright (c) 2014年 Mao-MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
@interface InputPhoneNumController : BaseNavigationController
{
    BOOL isphoneUsed;
}
@property (strong, nonatomic) IBOutlet UITextField *textPhone;
- (IBAction)nextclick:(id)sender;
- (IBAction)agreementclick:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblReminder;

@end
