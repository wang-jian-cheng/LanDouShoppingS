//
//  CommentEditController.h
//  LanDouS
//
//  Created by Mao-MacPro on 15/1/25.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
@interface CommentEditController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{
    UITableView *tableComment;
    NSMutableArray *arrayComment;
    NSMutableDictionary *dicPost;
    NSMutableArray *arrayPost;
    NSMutableArray *arrayStar;
    NSMutableArray *arrayDesc;
    
    NSString *storeid;
}
@property(nonatomic,copy)NSString *orderId;
@property (strong, nonatomic) IBOutlet UIButton *btnCheck;
- (IBAction)postinfoclick:(id)sender;
- (IBAction)checkclick:(id)sender;
@end
