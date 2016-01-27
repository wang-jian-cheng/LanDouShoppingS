//
//  CartStateController.h
//  LanDouS
//
//  Created by Mao-MacPro on 15/1/14.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
@interface CartStateController : BaseNavigationController
@property(nonatomic,copy)NSString *strState;
@property(nonatomic,copy)NSString *strNum;
@property(nonatomic,copy)NSString *strName;
@property(nonatomic,copy)NSString *strPrice;
@property (strong, nonatomic) IBOutlet UIImageView *imgState;
@property (strong, nonatomic) IBOutlet UILabel *lblNum;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblPrice;

@end
