//
//  ShopInfoSecondClassController.h
//  LanDouS
//
//  Created by Mao-MacPro on 15/1/9.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
@interface ShopInfoSecondClassController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tableKinds;
    NSMutableArray *arrayKinds;
}
@property (nonatomic,copy)NSString *storeID;
@property(nonatomic,copy)NSString *parentID;
@end
