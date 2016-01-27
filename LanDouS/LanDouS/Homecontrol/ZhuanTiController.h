//
//  ZhuanTiController.h
//  LanDouS
//
//  Created by Mao-MacPro on 15/1/24.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
@interface ZhuanTiController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tableZhuanTi;
    NSMutableArray *arrayList;
    UIButton *btnShopCart;
}
@property(nonatomic,copy)NSString *specialId;
@end
