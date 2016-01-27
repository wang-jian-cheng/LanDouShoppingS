//
//  GoodsListController.h
//  LanDouS
//
//  Created by Mao-MacPro on 15/1/4.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
@interface GoodsListController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UIScrollViewDelegate>
{
    UITableView *tableGood;
    int page;
    int perpage;
    NSMutableDictionary *dicPost;
    NSMutableArray *arrayList;
    UIButton *btnShopCart;
    UISearchBar *searchBar;
}
@property (copy, nonatomic)NSString *gcId;
@property(copy,nonatomic)NSString *storeID;
@property(copy,nonatomic)NSString *searchID;//首页搜索框进来的区分
@property (strong, nonatomic) IBOutlet UIButton *btnSaleNum;
@property (strong, nonatomic) IBOutlet UIButton *btnPrice;
@property (strong, nonatomic) IBOutlet UIButton *btnGood;
@property (strong, nonatomic) IBOutlet UIButton *btnNew;
- (IBAction)salenumclick:(id)sender;
- (IBAction)priceclick:(id)sender;
- (IBAction)goodclick:(id)sender;
- (IBAction)newclick:(id)sender;
 

@end
