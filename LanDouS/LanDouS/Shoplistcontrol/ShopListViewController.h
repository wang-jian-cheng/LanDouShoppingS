//
//  ShopListViewController.h
//  LanDouS
//
//  Created by Mao-MacPro on 14/12/23.
//  Copyright (c) 2014年 Mao-MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
@interface ShopListViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tableShopList;
    NSMutableArray *arrayShopList;
    int page;
    int perpage;
}
@end
