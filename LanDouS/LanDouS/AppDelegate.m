//
//  AppDelegate.m
//  LanDouS
//
//  Created by Mao-MacPro on 14/12/23.
//  Copyright (c) 2014年 Mao-MacPro. All rights reserved.
//

#import "AppDelegate.h"
#import <SMS_SDK/SMSSDK.h>
#import <AlipaySDK/AlipaySDK.h>

#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//#import <QZoneConnection/QZoneConnection.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import "DataProvider.h"
#import <PgySDK/PgyManager.h>
@interface AppDelegate ()

@end

#define SMS_APPKEY @"cc23178c0780"
#define SMS_SECRET @"75e9e33e79359a4fd1da9b99d9f89cb0"

#define SHARESDK_APPKEY     @"cc2679d4acce"
#define SHARESDK_APPSECRET  @"5ae1517d9e09b3685d40de8ec754c372"-

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[PgyManager sharedPgyManager] setEnableFeedback:NO];
    
    [[PgyManager sharedPgyManager] startManagerWithAppId:@"38300e1864f178c57beafdc68932058c"];//蒲公英app-id
//    [[PgyManager sharedPgyManager] checkUpdate];
    
    [SMSSDK registerApp:SMS_APPKEY withSecret:SMS_SECRET];
    
    


    [ShareSDK registerApp:SHARESDK_APPKEY
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformSubTypeQZone),
                            @(SSDKPlatformSubTypeWechatTimeline),
                            @(SSDKPlatformSubTypeQQFriend),
                            @(SSDKPlatformSubTypeWechatSession),
                            @(SSDKPlatformSubTypeWechatFav)
                            ]
                 onImport:^(SSDKPlatformType platformType)
                 {
                     switch (platformType)
                     {
                         case SSDKPlatformTypeWechat:
                             [ShareSDKConnector connectWeChat:[WXApi class]];
                             break;
                         case SSDKPlatformTypeQQ:
                             [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                             break;
                         case SSDKPlatformTypeSinaWeibo:
                             [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                             break;
                             
                         default:
                             break;
                     }
                 }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"568898243"
                                           appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                                         redirectUri:@"http://www.sharesdk.cn"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx4868b35061f87885"
                                       appSecret:@"64020361b8ec4c99936c0e3999a9f249"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1104996234"
                                      appKey:@"dDLYKqeukigatPgE"
                                    authType:SSDKAuthTypeBoth];
                 break;
                 
                 
             default:
                 break;
         }
     }];

    

    
    
    _tabBarViewCol = [[CustomTabBarViewController alloc] init];
    firstCol=[[FirstScrollController alloc]init];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds] ];
    if ([get_sp(@"FIRST_ENTER")isEqualToString:@"1"]) {
        self.window.rootViewController =_tabBarViewCol;
    }
    else
    {
       self.window.rootViewController =firstCol;
    }
    
    [self.window makeKeyAndVisible];
    //[self getAliPay];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRootView) name:@"changeRootView" object:nil];
    // Override point for customization after application launch.
    return YES;
    
}
-(void)getAliPay
{
    
    
    
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        
        NSLog(@"^^^^%@", resultDict );
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            
            
            
            
        }
        else{
            
        }
        
        
        
    }];
    
    [dataProvider setFailedBlock:^(NSString *strError){
        
         
        
    }];
    
    [dataProvider getAlipay];
}






-(void)changeRootView
{
    self.window.rootViewController=_tabBarViewCol;
}


- (void)showTabBar
{
    [_tabBarViewCol showTabBar];
}
- (void)hiddenTabBar
{
    [_tabBarViewCol hideCustomTabBar];
}
-(CustomTabBarViewController *)getTabBar
{
    return _tabBarViewCol;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
//- (BOOL)application:(UIApplication *)application
//      handleOpenURL:(NSURL *)url
//{
//    [ShareSDK handleOpenURL:url wxDelegate:self];
//    
//    return  [TencentOAuth HandleOpenURL:url];
//    
//    
//}
//
#pragma mark - 如果使用SSO（可以简单理解成客户端授权），以下方法是必要的
- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
//    
//      return [ShareSDK handleOpenURL:url
//                        wxDelegate:self];
}




- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    
    
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService]processOrderWithPaymentResult:(NSURL *)url standbyCallback:^(NSDictionary *resultDic){
            NSLog(@"result = %@",resultDic);
            
            
            
            
        }];
//        [[AlipaySDK defaultService] processAuth_V2Result:url
//                                         standbyCallback:^(NSDictionary *resultDic) {
//                                             NSLog(@"result = %@",resultDic);
//                                             NSString *resultStr = resultDic[@"result"];
//                                         }];
        
    }
//    return YES;
//    [ShareSDK handleOpenURL:url
//          sourceApplication:sourceApplication
//                 annotation:annotation
//                 wxDelegate:self];
    [WXApi handleOpenURL:url delegate:self];
    NSLog(@"url: %@, annotation: %@", url, annotation);
    
    return [TencentOAuth HandleOpenURL:url];
}

/**
 *  微信支付完成的回调
 *
 *  @param resp 返回参数信息
 */
-(void) onResp:(BaseResp*)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，微信支付完成，结果返回
        strTitle = [NSString stringWithFormat:@"支付结果"];
        NSLog(@"app-delegate 中的微信支付status:%@,,,,,,%d",resp.errStr,resp.errCode);
        switch (resp.errCode) {
            case WXSuccess:
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"wxpaySuccess" object:nil];
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
                
            default:
                [[NSNotificationCenter defaultCenter] postNotificationName:@"wxpayFail" object:nil];
//                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"wxpaySuccess" object:nil];
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
    }
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alert show];

}



@end
