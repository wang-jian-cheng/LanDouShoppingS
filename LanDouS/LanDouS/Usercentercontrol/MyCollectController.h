//
//  MyCollectController.h
//  LanDouS
//
//  Created by Mao-MacPro on 14/12/26.
//  Copyright (c) 2014年 Mao-MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
@interface MyCollectController : BaseNavigationController<UICollectionViewDataSource,UICollectionViewDelegate>
{
    
    UIView *viewGoods;
    
    UIView *viewShop;
    UITableView *tableShopList;
    NSMutableArray *arrayGoodsList;
    int shopPage;
    int shopPerpage;
    NSInteger indexid;
}
@property (strong, nonatomic) IBOutlet UICollectionView *collectionGoods;
- (IBAction)goodsclick:(id)sender;
- (IBAction)shopclick:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *imLine;
@end
