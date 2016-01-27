//
//  ShopInfoController.h
//  LanDouS
//
//  Created by Mao-MacPro on 14/12/25.
//  Copyright (c) 2014年 Mao-MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
@interface ShopInfoController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tableShopinfo;
    int page;
    int perpage;
    NSMutableArray *arrayShopGoods;//商店的热销商品数组
    NSMutableDictionary *dicPost;//调接口post请求用的字典
}

@property (strong, nonatomic) IBOutlet UIView *topview;
@property (strong, nonatomic) IBOutlet UILabel *lblShopName;
@property (strong, nonatomic) IBOutlet UILabel *lblShopDisc;
@property (strong, nonatomic) IBOutlet UIImageView *imgShop;
@property (strong, nonatomic) IBOutlet UIButton *btnCollect;
- (IBAction)collectclick:(id)sender;
//以上是店铺介绍

@property(nonatomic,strong)NSMutableDictionary *dicShopInfo;//上个页面传过来的商店信息
@end
