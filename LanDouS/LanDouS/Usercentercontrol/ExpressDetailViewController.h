//
//  ExpressDetailViewController.h
//  LanDouS
//
//  Created by 王建成 on 15/12/2.
//  Copyright © 2015年 Mao-MacPro. All rights reserved.
//

#import "BaseNavigationController.h"

@interface ExpressDetailViewController : BaseNavigationController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_expressTabView;
}
@property(nonatomic)NSDictionary *expressDict;
@end
