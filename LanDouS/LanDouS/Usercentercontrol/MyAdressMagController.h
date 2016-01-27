//
//  MyAdressMagController.h
//  LanDouS
//
//  Created by Mao-MacPro on 15/1/12.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
@interface MyAdressMagController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tableAddress;
    NSMutableArray *arrayAddress;
    NSString *addressId;
    NSInteger indexID;
}
@property(nonatomic,copy)NSString *strType;
@end
