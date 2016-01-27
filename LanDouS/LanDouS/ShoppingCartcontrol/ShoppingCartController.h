//
//  ShoppingCartController.h
//  LanDouS
//
//  Created by Mao-MacPro on 14/12/23.
//  Copyright (c) 2014年 Mao-MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
@interface ShoppingCartController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tableCart;
    NSMutableArray *arrayCartList;//用来展示数据的数组
    NSMutableArray *arrayAddCart;//用来传进确认界面的数组
    float totalprice;
}
@property(nonatomic,copy)NSString *strType;
- (IBAction)goHomeviewclick:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *viewNothing;
@property (strong, nonatomic) IBOutlet UIView *viewDown;
@property (strong, nonatomic) IBOutlet UIButton *btnSure;
- (IBAction)sureclick:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblAllPrice;
@property (strong, nonatomic) IBOutlet UIButton *btnAllSelect;
- (IBAction)allselectedclick:(id)sender;
@end
