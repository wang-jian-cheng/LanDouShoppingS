//
//  SureCartController.h
//  LanDouS
//
//  Created by Mao-MacPro on 15/1/12.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
@interface SureCartController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tableCart;
    
    NSMutableDictionary *dicPost;
    NSString *goodsName;
    NSString *dingDanNum;
    NSMutableDictionary *dicAddress;
    float minTotalPrice;
    float onLinePayDiscount;
    
}
@property(nonatomic) NSMutableArray *goosStandardIDStrArr;//商品规格列表
@property(nonatomic) NSMutableArray *standardIDStrArr;//选择规格列表
@property(nonatomic,copy)NSString *strType;
@property(nonatomic,copy)NSString *strFreightPrice;
@property (strong, nonatomic) IBOutlet UIButton *btnPeisong;
@property(assign)float totalPrice;
@property(strong,nonatomic)NSMutableArray *arrayCartList;
@property (strong, nonatomic) IBOutlet UIView *viewHeader;
@property (strong, nonatomic) IBOutlet UILabel *lblallPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblYunFei;
@property (strong, nonatomic) IBOutlet UIButton *btnsure;

@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblPhone;
@property (strong, nonatomic) IBOutlet UILabel *lblAddress;

- (IBAction)shipMethod:(id)sender;
- (IBAction)payMethod:(id)sender;
 
- (IBAction)sureclick:(id)sender;
- (IBAction)chooseaddress:(id)sender;

@end
