//
//  UserCenterController.h
//  LanDouS
//
//  Created by Mao-MacPro on 14/12/23.
//  Copyright (c) 2014年 Mao-MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
#import "JSBadgeView.h"
#import "DepositViewController.h"

@interface UserCenterController : BaseNavigationController
{
    NSMutableDictionary *dicPost;
    
    JSBadgeView *numWaitPay;
    JSBadgeView *numWaitSend;
    JSBadgeView *numWaitReceive;
    JSBadgeView *numYetReceive;
    
    
}
@property (strong, nonatomic) IBOutlet UIImageView *imageface;
- (IBAction)mycollectclick:(id)sender;
- (IBAction)myaddressclick:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollBG;
@property (strong, nonatomic) IBOutlet UILabel *lblUserName;
@property (strong, nonatomic) IBOutlet UILabel *lblwelcome;
@property (strong, nonatomic) IBOutlet UILabel *lblScore;
@property (strong, nonatomic) IBOutlet UILabel *lblMoney;
- (IBAction)waitpayclick:(id)sender;
- (IBAction)waitsendgoodsclick:(id)sender;
- (IBAction)waittakeclick:(id)sender;
- (IBAction)yettakeclick:(id)sender;
- (IBAction)myscoreclick:(id)sender;
- (IBAction)changeimageclick:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnWaitPay;
@property (strong, nonatomic) IBOutlet UIButton *btnWaitSend;
@property (strong, nonatomic) IBOutlet UIButton *btnWaitReceive;
@property (strong, nonatomic) IBOutlet UIButton *btnYetReceive;
- (IBAction)scorelogclick:(id)sender;
 
@property (weak, nonatomic) IBOutlet UILabel *lblSecurity;
@property (weak, nonatomic) IBOutlet UILabel *lblSecuritylow;
@property (weak, nonatomic) IBOutlet UILabel *lblSecuritymedium;
 
@property (weak, nonatomic) IBOutlet UILabel *lblSecurityhigh;

@end
