//
//  MyScoreController.h
//  LanDouS
//
//  Created by Mao-MacPro on 15/1/19.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
@interface MyScoreController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tableScore;
    NSMutableArray *arrayScore;
    int page;
    int perpage;
    NSInteger indexId;

}
@end
