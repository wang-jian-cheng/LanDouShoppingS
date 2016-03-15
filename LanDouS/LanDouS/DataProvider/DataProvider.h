//
//  DataProvider.h
//  BestOne
//
//  Created by hank on 13-10-19.
//  Copyright (c) 2013年 hank. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DataProvider;

typedef void(^dataProviderFinishBlock)(NSDictionary *);
typedef void(^dataProviderFailedBlock)(NSString *);

@interface DataProvider : NSObject
-(void)getAlipay;
-(void)getPingPPChargeChannel:(NSString *)channel andAmount:(NSString *)amount andOrdernum:(NSString *)ordernum andSubject:(NSString *)subject andBody:(NSString *)body;
 -(void)isPhoneRegged:(NSString *)phone;
-(void)userregister:(NSString *)phone andPassword:(NSString *)password andName:(NSString *)name andEmail:(NSString *)email;
-(void)userlogin:(NSString *)phone andPassword:(NSString *)password;
-(void)getScreenList;
-(void)getSpecial:(NSString *)specialid;

-(void)getHomeGoods;
-(void)getGoodsClass:(NSString *)parent_id;
-(void)getGoodsList:(NSDictionary *)infoDict andPage:(int)page andPerPage:(int)perpage;
-(void)getGoodsDetail:(NSString *)goodsId;
-(void)getGoodsSpec:(NSString *)goodsId;
-(void)getGoodsComments:(NSString *)goodsId andPage:(int)page andPerpage:(int)perpage;
-(void)getStoreList:(NSString *)searchText andPage:(int)page andPerpage:(int)perpage;
-(void)getStoreGoodsClass:(NSString *)store_id andParentID:(NSString *)parent_id;

-(void)addFavoriteGoods:(NSString *)goods_id;
-(void)delFavoriteGoods:(NSString *)goods_id;
-(void)getFavoriteGoods:(int)page andPerPage:(int)perpage;

-(void)addFavoriteStore:(NSString *)store_id;
-(void)delFavoriteStore:(NSString *)store_id;
-(void)getFavoriteStore:(int)page andPerPage:(int)perpage;

-(void)addCart:(NSString *)goodsID andCount:(int)count;
-(void)updateCart:(NSString *)cart_id andCount:(int)count;
-(void)delCart:(NSString *)cart_id;
-(void)getCartList;

-(void)getOrderComfirm:(NSDictionary *)infoDict;//订单确认
-(void)addOrder:(NSDictionary *)infoDict;//提交订单

-(void)getArea:(NSString *)parent_id;
-(void)getAddress;
-(void)addAddress:(NSDictionary *)infoDict;
-(void)changeAddress:(NSDictionary *)infoDict;
-(void)delAddress:(NSString *)address_id;
-(void)setDefaultAddress:(NSString *)address_id;

-(void)getOrderList:(NSString *)order_state andpage:(int)page andPerPage:(int)perpage;
-(void)cancelOrder:(NSString *)orderid;
-(void)receiveGoods:(NSString *)orderid;
-(void)getExpress:(NSString *)orderid;


-(void)getPointsLog:(int)page andperpage:(int)perpage;
-(void)getPointsGoods:(int)page andperpage:(int)perpage;
-(void)addPointsOrder:(NSString *)pgoods_id andCount:(int)count andAddress:(NSString *)addressid;
-(void)cancelPointsOrder:(NSString *)point_orderid;
-(void)payPointsOrder:(NSString *)point_orderid;
-(void)getPointsOrder:(int)page andperpage:(int)perpage;

-(void)addSharePoints;
-(void)addCheckPoints;

-(void)useredit:(NSDictionary *)infoDict;
-(void)getOrderDetail:(NSString *)order_id;
- (void)getAPPVersionWithPlatform;
-(void)resetPassword:(NSString *)phone andPassword:(NSString *)password;
-(void)orderEvaluation:(NSString *)str andOrderId:(NSString *)orderID;
-(void)refund:(NSDictionary *)infoDict;

-(void)payorder:(NSString *)pay_sn;
-(void)getDiscountSetting;
-(void)updateMobileDiscout:(NSString*)pay_sn pay_method:(NSString*)pay_method discount:(NSString*)discount;
@property(nonatomic, strong)dataProviderFinishBlock finishBlock;
@property(nonatomic, strong)dataProviderFailedBlock failedBlock;
@property(nonatomic, strong)NSDictionary *resultDict;
@end
