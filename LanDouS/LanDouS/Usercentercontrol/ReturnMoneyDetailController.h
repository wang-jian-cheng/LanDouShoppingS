//
//  ReturnMoneyDetailController.h
//  LanDouS
//
//  Created by Mao-MacPro on 15/1/26.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
@interface ReturnMoneyDetailController : BaseNavigationController
{
    NSMutableDictionary *dicPost;
}
@property(nonatomic,strong)NSMutableDictionary *dicinfo;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollBG;
@property (strong, nonatomic) IBOutlet UILabel *lblDingDanMoney;
@property (strong, nonatomic) IBOutlet UILabel *lblGoodsName;
@property (strong, nonatomic) IBOutlet UILabel *lblGoodsPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblBuyNum;
@property (strong, nonatomic) IBOutlet UILabel *lblCanReturnMoney;
@property (strong, nonatomic) IBOutlet UIButton *btnOnlyReturnMoney;
- (IBAction)onlymoneyclick:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnMoneyAndGoods;
- (IBAction)moneyandgoodsclick:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *textReturnMoney;
@property (strong, nonatomic) IBOutlet UITextField *textReturnNum;
@property (strong, nonatomic) IBOutlet UITextView *textReturnReson;
- (IBAction)sureclick:(id)sender;
@end
