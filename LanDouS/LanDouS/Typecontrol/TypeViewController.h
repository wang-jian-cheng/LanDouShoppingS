//
//  TypeViewController.h
//  LanDouS
//
//  Created by Mao-MacPro on 14/12/23.
//  Copyright (c) 2014年 Mao-MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
@interface TypeViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tableFirst;
    UITableView *tableSecond;
    UITableView *tableThird;
    NSMutableArray *arrayFirstClass;
    NSMutableArray *arraySecondClass;
    NSMutableArray *arrayThirdClass;
    int newRow ;
    NSIndexPath *lastIndexPath;
    
    int secondNewRow;
    NSIndexPath *secondLastIndexPath;
    
    int  firstClassID;
    int  secondClassID;
    
}
@end
