//
//  SureCartController.h
//  LanDouS
//
//  Created by Mao-MacPro on 15/1/12.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
#import "Pingpp.h"



#define kWaiting          @"正在获取支付凭据,请稍后..."
#define kNote             @"提示"
#define kConfirm          @"确定"
#define kErrorNet         @"网络错误"
#define kResult           @"支付结果：%@"

#define kPlaceHolder      @"支付金额"
#define kMaxAmount        9999999

//#define kUrlScheme      @"demoapp001" // 这个是你定义的 URL Scheme，支付宝、微信支付和测试模式需要。
//#define kUrl            @"http://218.244.151.190/demo/charge" // 你的服务端创建并返回 charge 的 URL 地址，此地址仅供测试用。
//

#define kUrlScheme      @"com.taoxiaoqi.app" // 这个是你定义的 URL Scheme，支付宝、微信支付和测试模式需要。

@interface SureCartController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tableCart;
    
    NSMutableDictionary *dicPost;
    NSString *goodsName;
    NSString *dingDanNum;
    NSMutableDictionary *dicAddress;
    float minTotalPrice;
    float onLinePayDiscount;
    
    UIAlertView* mAlert;
    
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
