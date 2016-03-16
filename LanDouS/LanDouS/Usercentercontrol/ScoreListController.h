//
//  ScoreListController.h
//  LanDouS
//
//  Created by Mao-MacPro on 15/1/25.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
#import "Pingpp.h"

@interface ScoreListController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tableScore;
    NSMutableArray *arrayList;
    int page;
    int perpage;
    NSInteger indexId;
    
    NSString *relpayChannel;
    
}
@end
