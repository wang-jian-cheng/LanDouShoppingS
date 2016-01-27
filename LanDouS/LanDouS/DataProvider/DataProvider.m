//
//  DataProvider.m
//  BestOne
//
//  Created by hank on 13-10-19.
//  Copyright (c) 2013年 hank. All rights reserved.
//

#import "DataProvider.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "Toolkit.h"


#define kPerPage 20

//#define BASE_URL @"http://www.itcan.cn:9000/appif/api.php?"
//#define BASE_URL @"http://112.53.78.18:8088/appif/api.php?"
#if LANDOU
#define BASE_URL @"http://api.landous.com/api.php?"
#else
#define BASE_URL @"http://115.28.67.86/zysc/appif/api.php?"
//@"http://103.56.17.40/appif/api.php?"
//@"http://192.168.199.174/appif/api.php?"
#endif
//m=user&a=getGoodsList&gc_id=1
@implementation DataProvider


-(void)setOrder
{
    
}


-(void)getAlipay
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@m=user&a=getAlipay", BASE_URL]];
    [self requestData:url];
}
-(void)isPhoneRegged:(NSString *)phone
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@m=user&a=searchPhone&phone=%@", BASE_URL,phone]];
    [self requestData:url];
}
-(void)userregister:(NSString *)phone andPassword:(NSString *)password andName:(NSString *)name andEmail:(NSString *)email
{
    name=[name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@m=user&a=register&member_name=%@&member_passwd=%@&member_email=%@&member_phone=%@", BASE_URL,name,password,email,phone]];
    [self requestData:url];
}

-(void)userlogin:(NSString *)phone andPassword:(NSString *)password
{
    phone=[phone stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@m=user&a=login&login_name=%@&login_password=%@", BASE_URL,phone,password]];
    [self requestData:url];
}

-(void)getScreenList
{
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@m=user&a=getSpecialList", BASE_URL]];
//    [self requestData:url];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@m=user&a=getSpecialList", BASE_URL]];
    [self requestData:url];
}

-(void)getSpecial:(NSString *)specialid
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@m=user&a=getSpecial&special_id=%@", BASE_URL,specialid]];
    [self requestData:url];
}


-(void)getHomeGoods
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@m=user&a=getHomeGoods", BASE_URL]];
    [self requestData:url];
}

-(void)getGoodsClass:(NSString *)parent_id
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@m=user&a=getGoodsClass&parent_id=%@", BASE_URL,parent_id]];
    [self requestData:url];
}
-(void)getGoodsList:(NSDictionary *)infoDict andPage:(int)page andPerPage:(int)perpage
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@m=user&a=getGoodsList&page=%d&per_page=%d",BASE_URL,page,perpage]]];
    [request setRequestMethod:@"POST"];
    
    if ([infoDict objectForKey:@"gc_id"]!=nil) {
        [request setPostValue:[infoDict objectForKey:@"gc_id"] forKey:@"gc_id"];
    }
    if ([infoDict objectForKey:@"store_id"]!=nil) {
        [request setPostValue:[infoDict objectForKey:@"store_id"] forKey:@"store_id"];
    }
    if ([infoDict objectForKey:@"search_text"]!=nil) {
        [request setPostValue:[infoDict objectForKey:@"search_text"] forKey:@"search_text"];
    }
    if ([infoDict objectForKey:@"orderby"]!=nil) {
        [request setPostValue:[infoDict objectForKey:@"orderby"] forKey:@"orderby"];
    }
    [request buildRequestHeaders];
    __block ASIFormDataRequest *resultRequst = request;
    
    [request setCompletionBlock:^{
        NSError *error = nil;
        NSData *dataResult = [resultRequst responseData];
        NSString *str=[[NSString alloc]initWithData:dataResult encoding:NSUTF8StringEncoding];
        str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSLog(@"%@",str);
        
        NSData* aData = [str dataUsingEncoding: NSUTF8StringEncoding];
        if (aData)
            self.resultDict = [NSJSONSerialization JSONObjectWithData:aData options:kNilOptions error:&error];
        self.finishBlock(self.resultDict);
    }];
    [request setFailedBlock:^{
        NSError *error = nil;
        NSData *dataResult = [resultRequst responseData];
        if (dataResult)
            self.resultDict = [NSJSONSerialization JSONObjectWithData:dataResult options:kNilOptions error:&error];
    }];
    [request startAsynchronous];
}

-(void)getGoodsDetail:(NSString *)goodsId
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@m=user&a=getGoodsDetail&goods_id=%@", BASE_URL,goodsId]];
    [self requestData:url];
}
-(void)getGoodsComments:(NSString *)goodsId andPage:(int)page andPerpage:(int)perpage
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@m=user&a=getGoodsComments&goods_id=%@&page=%d&per_page=%d", BASE_URL,goodsId,page,perpage]];
    [self requestData:url];
}

-(void)getStoreList:(NSString *)searchText andPage:(int)page andPerpage:(int)perpage
{
    if ([searchText isEqualToString:@"nothing"]) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@m=user&a=getStoreList&page=%d&per_page=%d", BASE_URL,page,perpage]];
        [self requestData:url];
    }
    else{
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@m=user&a=getStoreList&search_text=%@&page=%d&per_page=%d", BASE_URL,searchText,page,perpage]];
        [self requestData:url];
    }
}

-(void)getStoreGoodsClass:(NSString *)store_id andParentID:(NSString *)parent_id
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@m=user&a=getStoreGoodsClass&store_id=%@&parent_id=%@", BASE_URL,store_id,parent_id]];
    [self requestData:url];
}

-(void)addFavoriteGoods:(NSString *)goods_id
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@m=user&a=addFavoriteGoods&goods_id=%@", BASE_URL,goods_id]];
    [self requestData:url];
}
-(void)delFavoriteGoods:(NSString *)goods_id
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@m=user&a=delFavoriteGoods&goods_id=%@", BASE_URL,goods_id]];
    [self requestData:url];
}
-(void)getFavoriteGoods:(int)page andPerPage:(int)perpage
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@m=user&a=getFavoriteGoods&page=%d&per_page=%d", BASE_URL,page,perpage]];
    [self requestData:url];
}

-(void)addFavoriteStore:(NSString *)store_id
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@m=user&a=addFavoriteStore&store_id=%@", BASE_URL,store_id]];
    [self requestData:url];
}
-(void)delFavoriteStore:(NSString *)store_id
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@m=user&a=delFavoriteStore&store_id=%@", BASE_URL,store_id]];
    [self requestData:url];
}
-(void)getFavoriteStore:(int)page andPerPage:(int)perpage
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@m=user&a=getFavoriteStore&page=%d&per_page=%d", BASE_URL,page,perpage]];
    [self requestData:url];
}
-(void)addCart:(NSString *)goodsID andCount:(int)count
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@m=user&a=addCart&goods_id=%@&count=%d", BASE_URL,goodsID,count]];
    [self requestData:url];
}
-(void)updateCart:(NSString *)cart_id andCount:(int)count
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@m=user&a=updateCart&cart_id=%@&count=%d", BASE_URL,cart_id,count]];
    [self requestData:url];
}
-(void)delCart:(NSString *)cart_id
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@m=user&a=delCart&cart_id=%@", BASE_URL,cart_id]];
    [self requestData:url];
}
-(void)getCartList
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@m=user&a=getCartList", BASE_URL]];
    [self requestData:url];
}

-(void)getOrderComfirm:(NSDictionary *)infoDict;//订单确认
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@m=user&a=getOrderConfirm",BASE_URL]]];
    [request setRequestMethod:@"POST"];
    
    if ([infoDict objectForKey:@"ship_method"]!=nil) {
        [request setPostValue:[infoDict objectForKey:@"ship_method"] forKey:@"ship_method"];
    }
    if ([infoDict objectForKey:@"pay_method"]!=nil) {
        [request setPostValue:[infoDict objectForKey:@"pay_method"] forKey:@"pay_method"];
    }
    if ([infoDict objectForKey:@"address_id"]!=nil) {
        [request setPostValue:[infoDict objectForKey:@"address_id"] forKey:@"address_id"];
    }
    if ([infoDict objectForKey:@"cart_id"]!=nil) {
        [request setPostValue:[infoDict objectForKey:@"cart_id"] forKey:@"cart_id"];
    }
    [request buildRequestHeaders];
    __block ASIFormDataRequest *resultRequst = request;
    
    [request setCompletionBlock:^{
        NSError *error = nil;
        NSData *dataResult = [resultRequst responseData];
        NSString *str=[[NSString alloc]initWithData:dataResult encoding:NSUTF8StringEncoding];
        str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSLog(@"%@",str);
        
        NSData* aData = [str dataUsingEncoding: NSUTF8StringEncoding];
        if (aData)
            self.resultDict = [NSJSONSerialization JSONObjectWithData:aData options:kNilOptions error:&error];
        self.finishBlock(self.resultDict);
    }];
    [request setFailedBlock:^{
        NSError *error = nil;
        NSData *dataResult = [resultRequst responseData];
        if (dataResult)
            self.resultDict = [NSJSONSerialization JSONObjectWithData:dataResult options:kNilOptions error:&error];
    }];
    [request startAsynchronous];
}
-(void)addOrder:(NSDictionary *)infoDict;
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@m=user&a=addOrder",BASE_URL]]];
    [request setRequestMethod:@"POST"];
    
    if ([infoDict objectForKey:@"ship_method"]!=nil) {
        [request setPostValue:[infoDict objectForKey:@"ship_method"] forKey:@"ship_method"];
    }
    if ([infoDict objectForKey:@"pay_method"]!=nil) {
        [request setPostValue:[infoDict objectForKey:@"pay_method"] forKey:@"pay_method"];
    }
    if ([infoDict objectForKey:@"address_id"]!=nil) {
        [request setPostValue:[infoDict objectForKey:@"address_id"] forKey:@"address_id"];
    }
    if ([infoDict objectForKey:@"cart_id"]!=nil) {
        [request setPostValue:[infoDict objectForKey:@"cart_id"] forKey:@"cart_id"];
    }
    if ([infoDict objectForKey:@"goods_id"]!=nil) {
        [request setPostValue:[infoDict objectForKey:@"goods_id"] forKey:@"goods_id"];
    }
    if ([infoDict objectForKey:@"goods_num"]!=nil) {
        [request setPostValue:[infoDict objectForKey:@"goods_num"] forKey:@"count"];
    }
    
    [request buildRequestHeaders];
    __block ASIFormDataRequest *resultRequst = request;
    
    [request setCompletionBlock:^{
        NSError *error = nil;
        NSData *dataResult = [resultRequst responseData];
        NSString *str=[[NSString alloc]initWithData:dataResult encoding:NSUTF8StringEncoding];
        str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSLog(@"%@",str);
        
        NSData* aData = [str dataUsingEncoding: NSUTF8StringEncoding];
        if (aData)
            self.resultDict = [NSJSONSerialization JSONObjectWithData:aData options:kNilOptions error:&error];
        self.finishBlock(self.resultDict);
    }];
    [request setFailedBlock:^{
        NSError *error = nil;
        NSData *dataResult = [resultRequst responseData];
        if (dataResult)
            self.resultDict = [NSJSONSerialization JSONObjectWithData:dataResult options:kNilOptions error:&error];
    }];
    [request startAsynchronous];
}
-(void)getAddress
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@m=user&a=getAddress", BASE_URL]];
    [self requestData:url];
}
-(void)addAddress:(NSDictionary *)infoDict
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@m=user&a=addAddress",BASE_URL]]];
    [request setRequestMethod:@"POST"];
    
    if ([infoDict objectForKey:@"true_name"]!=nil) {
        [request setPostValue:[infoDict objectForKey:@"true_name"] forKey:@"true_name"];
    }
    if ([infoDict objectForKey:@"area_id"]!=nil) {
        [request setPostValue:[infoDict objectForKey:@"area_id"] forKey:@"area_id"];
    }
    if ([infoDict objectForKey:@"address"]!=nil) {
        [request setPostValue:[infoDict objectForKey:@"address"] forKey:@"address"];
    }
    if ([infoDict objectForKey:@"tel_phone"]!=nil) {
        [request setPostValue:[infoDict objectForKey:@"tel_phone"] forKey:@"tel_phone"];
    }
    if ([infoDict objectForKey:@"mob_phone"]!=nil) {
        [request setPostValue:[infoDict objectForKey:@"mob_phone"] forKey:@"mob_phone"];
    }
    [request buildRequestHeaders];
    __block ASIFormDataRequest *resultRequst = request;
    
    [request setCompletionBlock:^{
        NSError *error = nil;
        NSData *dataResult = [resultRequst responseData];
        NSString *str=[[NSString alloc]initWithData:dataResult encoding:NSUTF8StringEncoding];
        str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSLog(@"%@",str);
        
        NSData* aData = [str dataUsingEncoding: NSUTF8StringEncoding];
        if (aData)
            self.resultDict = [NSJSONSerialization JSONObjectWithData:aData options:kNilOptions error:&error];
        self.finishBlock(self.resultDict);
    }];
    [request setFailedBlock:^{
        NSError *error = nil;
        NSData *dataResult = [resultRequst responseData];
        if (dataResult)
            self.resultDict = [NSJSONSerialization JSONObjectWithData:dataResult options:kNilOptions error:&error];
    }];
    [request startAsynchronous];
}
-(void)changeAddress:(NSDictionary *)infoDict
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@m=user&a=changeAddress",BASE_URL]]];
    [request setRequestMethod:@"POST"];
    
    if ([infoDict objectForKey:@"true_name"]!=nil) {
        [request setPostValue:[infoDict objectForKey:@"true_name"] forKey:@"true_name"];
    }
    if ([infoDict objectForKey:@"area_id"]!=nil) {
        [request setPostValue:[infoDict objectForKey:@"area_id"] forKey:@"area_id"];
    }
    if ([infoDict objectForKey:@"address"]!=nil) {
        [request setPostValue:[infoDict objectForKey:@"address"] forKey:@"address"];
    }
    if ([infoDict objectForKey:@"tel_phone"]!=nil) {
        [request setPostValue:[infoDict objectForKey:@"tel_phone"] forKey:@"tel_phone"];
    }
    if ([infoDict objectForKey:@"mob_phone"]!=nil) {
        [request setPostValue:[infoDict objectForKey:@"mob_phone"] forKey:@"mob_phone"];
    }
    if ([infoDict objectForKey:@"address_id"]!=nil) {
        [request setPostValue:[infoDict objectForKey:@"address_id"] forKey:@"address_id"];
    }
    [request buildRequestHeaders];
    __block ASIFormDataRequest *resultRequst = request;
    
    [request setCompletionBlock:^{
        NSError *error = nil;
        NSData *dataResult = [resultRequst responseData];
        NSString *str=[[NSString alloc]initWithData:dataResult encoding:NSUTF8StringEncoding];
        str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSLog(@"%@",str);
        
        NSData* aData = [str dataUsingEncoding: NSUTF8StringEncoding];
        if (aData)
            self.resultDict = [NSJSONSerialization JSONObjectWithData:aData options:kNilOptions error:&error];
        self.finishBlock(self.resultDict);
    }];
    [request setFailedBlock:^{
        NSError *error = nil;
        NSData *dataResult = [resultRequst responseData];
        if (dataResult)
            self.resultDict = [NSJSONSerialization JSONObjectWithData:dataResult options:kNilOptions error:&error];
    }];
    [request startAsynchronous];
}
-(void)delAddress:(NSString *)address_id
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@m=user&a=delAddress&address_id=%@", BASE_URL,address_id]];
    [self requestData:url];
}
-(void)setDefaultAddress:(NSString *)address_id
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@m=user&a=setDefaultAddress&address_id=%@", BASE_URL,address_id]];
    [self requestData:url];
}
-(void)getArea:(NSString *)parent_id
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@m=user&a=getArea&parent_id=%@", BASE_URL,parent_id]];
    [self requestData:url];
}
-(void)getOrderList:(NSString *)order_state andpage:(int)page andPerPage:(int)perpage
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@m=user&a=getOrderList&order_state=%@&page=%d&per_page=%d", BASE_URL,order_state,page,perpage]];
    [self requestData:url];
}

-(void)getPointsLog:(int)page andperpage:(int)perpage
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@m=user&a=getPointsLog&page=%d&per_page=%d", BASE_URL,page,perpage]];
    [self requestData:url];
}

-(void)getPointsGoods:(int)page andperpage:(int)perpage
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@m=user&a=getPointsGoods&page=%d&per_page=%d", BASE_URL,page,perpage]];
    [self requestData:url];
}
-(void)cancelOrder:(NSString *)orderid
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@m=user&a=cancelOrder&order_id=%@", BASE_URL,orderid]];
    [self requestData:url];
}
-(void)receiveGoods:(NSString *)orderid
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@m=user&a=receiveGoods&order_id=%@", BASE_URL,orderid]];
    [self requestData:url];
}
-(void)getExpress:(NSString *)orderid;
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@m=user&a=getExpress&order_id=%@", BASE_URL,orderid]];
    [self requestData:url];
}
-(void)addPointsOrder:(NSString *)pgoods_id andCount:(int)count andAddress:(NSString *)addressid
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@m=user&a=addPointsOrder&pgoods_id=%@&count=%d&ship_method=delivery&address_id=%@", BASE_URL,pgoods_id,count,addressid]];
    [self requestData:url];
}
-(void)payPointsOrder:(NSString *)point_orderid
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@m=user&a=payPointsOrder&point_orderid=%@", BASE_URL,point_orderid]];
    [self requestData:url];
}
-(void)cancelPointsOrder:(NSString *)point_orderid
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@m=user&a=cancelPointsOrder&point_orderid=%@", BASE_URL,point_orderid]];
    [self requestData:url];
}



-(void)getPointsOrder:(int)page andperpage:(int)perpage
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@m=user&a=getPointsOrder&page=%d&per_page=%d", BASE_URL,page,perpage]];
    [self requestData:url];
}

-(void)addSharePoints
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@m=user&a=addSharePoints", BASE_URL]];
    [self requestData:url];
}
-(void)addCheckPoints
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@m=user&a=addCheckPoints", BASE_URL]];
    [self requestData:url];
}
-(void)useredit:(NSDictionary *)infoDict
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@m=user&a=edit",BASE_URL]]];
    [request setRequestMethod:@"POST"];
    
    
    if ([infoDict objectForKey:@"userimage"]!=nil) {
        NSData *data = nil;
        
        data = UIImageJPEGRepresentation( [infoDict objectForKey:@"userimage"],0.4 );
        [request addData:data withFileName:@"photo.png" andContentType:@"image/png" forKey:@"member_avatar"];
    }
    
    
    
    
    
    [request buildRequestHeaders];
    __block ASIFormDataRequest *resultRequst = request;
    
    [request setCompletionBlock:^{
        NSError *error = nil;
        NSData *dataResult = [resultRequst responseData];
        NSString *str=[[NSString alloc]initWithData:dataResult encoding:NSUTF8StringEncoding];
        str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSLog(@"%@",str);
        
        NSData* aData = [str dataUsingEncoding: NSUTF8StringEncoding];
        if (aData)
            self.resultDict = [NSJSONSerialization JSONObjectWithData:aData options:kNilOptions error:&error];
        self.finishBlock(self.resultDict);
    }];
    [request setFailedBlock:^{
        NSError *error = nil;
        NSData *dataResult = [resultRequst responseData];
        if (dataResult)
            self.resultDict = [NSJSONSerialization JSONObjectWithData:dataResult options:kNilOptions error:&error];
    }];
    [request startAsynchronous];
}
-(void)getOrderDetail:(NSString *)order_id
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@m=user&a=getOrderDetail&order_id=%@", BASE_URL,order_id]];
    [self requestData:url];
}
- (void)getAPPVersionWithPlatform
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@m=user&a=getAppVersion&platform=%@", BASE_URL,@"ios"]];
    [self requestData:url];
}

-(void)resetPassword:(NSString *)phone andPassword:(NSString *)password
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@m=user&a=resetPassword&member_phone=%@&password=%@", BASE_URL,phone,password]];
    [self requestData:url];
}
-(void)orderEvaluation:(NSString *)str andOrderId:(NSString *)orderID;
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@m=user&a=orderEvaluation&%@&order_id=%@", BASE_URL,str,orderID]];
    [self requestData:url];
}

-(void)refund:(NSDictionary *)infoDict
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@m=user&a=refund",BASE_URL]]];
    [request setRequestMethod:@"POST"];
    
    if ([infoDict objectForKey:@"order_id"]!=nil) {
        [request setPostValue:[infoDict objectForKey:@"order_id"] forKey:@"order_id"];
    }
    if ([infoDict objectForKey:@"rec_id"]!=nil) {
        [request setPostValue:[infoDict objectForKey:@"rec_id"] forKey:@"rec_id"];
    }
    if ([infoDict objectForKey:@"refund_type"]!=nil) {
        [request setPostValue:[infoDict objectForKey:@"refund_type"] forKey:@"refund_type"];
    }
    if ([infoDict objectForKey:@"refund_amount"]!=nil) {
        [request setPostValue:[infoDict objectForKey:@"refund_amount"] forKey:@"refund_amount"];
    }
    if ([infoDict objectForKey:@"goods_num"]!=nil) {
        [request setPostValue:[infoDict objectForKey:@"goods_num"] forKey:@"goods_num"];
    }
    if ([infoDict objectForKey:@"extend_msg"]!=nil) {
        [request setPostValue:[infoDict objectForKey:@"extend_msg"] forKey:@"extend_msg"];
    }
    [request buildRequestHeaders];
    __block ASIFormDataRequest *resultRequst = request;
    
    [request setCompletionBlock:^{
        NSError *error = nil;
        NSData *dataResult = [resultRequst responseData];
        NSString *str=[[NSString alloc]initWithData:dataResult encoding:NSUTF8StringEncoding];
        str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSLog(@"%@",str);
        
        NSData* aData = [str dataUsingEncoding: NSUTF8StringEncoding];
        if (aData)
            self.resultDict = [NSJSONSerialization JSONObjectWithData:aData options:kNilOptions error:&error];
        self.finishBlock(self.resultDict);
    }];
    [request setFailedBlock:^{
        NSError *error = nil;
        NSData *dataResult = [resultRequst responseData];
        if (dataResult)
            self.resultDict = [NSJSONSerialization JSONObjectWithData:dataResult options:kNilOptions error:&error];
    }];
    [request startAsynchronous];
}
-(void)payorder:(NSString *)pay_sn
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@m=user&a=payOrder&pay_sn=%@", BASE_URL,pay_sn]];
    [self requestData:url];
}
-(void)getDiscountSetting
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@m=user&a=getDiscountSetting",BASE_URL]];
    [self requestData:url];
    
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@m=user&a=getDiscountSetting", BASE_URL]];
//    [self requestData:url];
}


-(void)updateMobileDiscout:(NSString*)pay_sn pay_method:(NSString*)pay_method discount:(NSString*)discount{
    NSString* urlStr=[NSString stringWithFormat:@"%@m=user&a=updateMobileDiscount&pay_sn=%@&pay_method=%@&discount=%@",BASE_URL,pay_sn,pay_method,discount];
    NSString *newUrlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",newUrlStr);
    NSURL *url = [NSURL URLWithString:newUrlStr];
    [self requestData:url];
}
//以上为懒豆商城



- (void)requestData:(NSURL *)url
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setUseCookiePersistence:YES];
    __block ASIHTTPRequest *resultRequst = request;
    //[request setTimeOutSeconds:15];
    [request setCompletionBlock:^{
        NSError *error = nil;
        NSData *dataResult = [resultRequst responseData];
        NSString *str=[[NSString alloc]initWithData:dataResult encoding:NSUTF8StringEncoding];
        str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSLog(@"%@",str);
        
        NSData* aData = [str dataUsingEncoding: NSUTF8StringEncoding];
        
        if (dataResult)
            self.resultDict = [NSJSONSerialization JSONObjectWithData:aData options:kNilOptions error:&error];
        self.finishBlock(self.resultDict);
    }];
    [request setFailedBlock:^{
        NSError *error = nil;
        NSData *dataResult = [resultRequst responseData];
        if (dataResult)
            self.resultDict = [NSJSONSerialization JSONObjectWithData:dataResult options:kNilOptions error:&error];
        
        self.failedBlock(@"fail");
    }];
    [request startAsynchronous];
}


- (void)dealloc
{
    self.resultDict = nil;
    self.finishBlock = nil;
    self.failedBlock = nil;
}

@end
