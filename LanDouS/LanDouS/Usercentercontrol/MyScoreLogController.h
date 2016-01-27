//
//  MyScoreLogController.h
//  LanDouS
//
//  Created by Mao-MacPro on 15/1/28.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
@interface MyScoreLogController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tableScore;
    NSMutableArray *arrayScore;
    int page;
    int perpage;
    int indexId;
    
}

@end
