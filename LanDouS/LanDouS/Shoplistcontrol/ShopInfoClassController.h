//
//  ShopInfoClassController.h
//  LanDouS
//
//  Created by Mao-MacPro on 14/12/25.
//  Copyright (c) 2014年 Mao-MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
@interface ShopInfoClassController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tableKinds;
    NSMutableArray *arrayKinds;
}
@property (nonatomic,copy)NSString *storeID;
@end
