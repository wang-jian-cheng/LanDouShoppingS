//
//  SureScoreCartController.h
//  LanDouS
//
//  Created by Mao-MacPro on 15/1/23.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
#import "Pingpp.h"
@interface SureScoreCartController : BaseNavigationController
{
    NSMutableDictionary *dicPost;
    NSString *point_orderid;
    NSString *point_orderSn;
    NSString *relpayChannel;
}
@property(nonatomic,strong)NSMutableDictionary *dicScoreInfo;
@property(assign)int num;
- (IBAction)addresschooseclick:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblGoodsName;
@property (strong, nonatomic) IBOutlet UILabel *lblGoodsScore;
@property (strong, nonatomic) IBOutlet UIImageView *imgGoods;
@property (strong, nonatomic) IBOutlet UILabel *lblNum;
- (IBAction)sureCartclick:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnSurecart;
@property (strong, nonatomic) IBOutlet UILabel *lblPhone;
@property (strong, nonatomic) IBOutlet UILabel *lblUsername;
@property (strong, nonatomic) IBOutlet UILabel *lblAddressDetail;
@end
