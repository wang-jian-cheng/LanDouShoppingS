//
//  WaitPayController.h
//  LanDouS
//
//  Created by Mao-MacPro on 15/1/16.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"



#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "AppDelegate.h"
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
#define kUrl            @"http://218.244.151.190/demo/charge" // 你的服务端创建并返回 charge 的 URL 地址，此地址仅供测试用。


@interface WaitPayController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    UITableView *tableWaitpay;
    NSMutableArray *arrayWaitpay;
    int page;
    int perpage;
    
    NSInteger rowID;
    NSInteger sectionID;
    NSString *pay_sn;
    float realpaymoney;
    float minTotalPrice;
    float onLinePayDiscount;
    
    
     UIAlertView* mAlert;
    
}
@property (strong, nonatomic) IBOutlet UIImageView *imgNoData;//没有数据时显示的默认图

@property(nonatomic, retain)NSString *channel;


@end
