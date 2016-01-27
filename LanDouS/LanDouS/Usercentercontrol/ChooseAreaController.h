//
//  ChooseAreaController.h
//  LanDouS
//
//  Created by Mao-MacPro on 15/1/15.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
@interface ChooseAreaController : BaseNavigationController
{
    NSMutableArray *array_city;
    NSMutableDictionary *dic_data;
}
@property(nonatomic,copy)NSString *strType;
@property (strong, nonatomic) IBOutlet UITableView *tableArea;

@end
