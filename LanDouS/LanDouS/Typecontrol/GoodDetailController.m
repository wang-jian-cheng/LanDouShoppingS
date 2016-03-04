//
//  GoodDetailController.m
//  LanDouS
//
//  Created by Mao-MacPro on 15/1/6.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import "GoodDetailController.h"
#import "LPLabel.h"
#import "ColGoodDetailCell.h"
#import "CommentCell.h"
#import "DataProvider.h"
#import "UIImageView+WebCache.h"
#define KCellID @"ColGoodDetailCell"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "MJRefresh.h"
#import "ShoppingCartController.h"
#import <ShareSDK/ShareSDK.h>
#import "SureCartController.h"
@interface GoodDetailController ()
{
    NSInteger goodsNum;
}
@property (weak, nonatomic) IBOutlet UIButton *joinCartBtn;
@property (nonatomic) NSMutableDictionary *dictStandard;
@property (nonatomic) NSMutableArray *standardBtnArr;
@end

@implementation GoodDetailController
@synthesize imageLine,viewGoodDetailTop,viewCommentHeader,goodsId,lblGoodsTitle,lblLookNum,lblPrice,lblSaleNum,lblSendTime,lblShopName,lblYunFei,lblcommentsNum,lblgoodComments,scrollTop,detailFootView,pageCol,btnComment,btnGoodsDetail,btnPicture,viewToplbl;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarTitle:@"商品详情"];
    _lblTitle.textColor=[UIColor whiteColor];
    _topView.backgroundColor=navi_bar_bg_color;
    [self addLeftButton:@"whiteback@2x.png"];
    [self addRightButton:@"sharebgbai@2x.png"];
    page=1;
    perpage=20;
    
    standardIdStr = @"000|000";
    
    
    _joinCartBtn.backgroundColor = navi_bar_bg_color;
    
    btngotoCart=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-80,22,40,40)];
    [btngotoCart setImage:img(@"b2_btn_carbai@2x.png") forState:UIControlStateNormal];
    [btngotoCart addTarget:self action:@selector(gotocart) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:btngotoCart];
    
    
    btncollect=[[UIButton alloc]initWithFrame:CGRectMake(20,0,40,40)];
    [btncollect setImage:img(@"goodsuncollect.png") forState:UIControlStateNormal];
    [btncollect setImage:img(@"goodscollect.png") forState:UIControlStateSelected];
    [btncollect setSelected:NO];
    [btncollect addTarget:self action:@selector(collectclick:) forControlEvents:UIControlEventTouchUpInside];
    //[btncollect setBackgroundColor:[UIColor blueColor]];
    [detailFootView addSubview:btncollect];
    _btnRight.frame=CGRectMake(SCREEN_WIDTH - 40, _orginY, 40, NavigationBar_HEIGHT);
    
    UIView *viewline=[[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-40, 27, 0.6, 30)];
    viewline.backgroundColor=[UIColor lightGrayColor];
    [_topView addSubview:viewline];
    
    dicGoodsDetail=[[NSMutableDictionary alloc]init];
    arrayRecommends=[[NSMutableArray alloc]init];
    arrayComments=[[NSMutableArray alloc]init];
    
    [self getGoodsDetail:goodsId];
    
    
//    [self getGoodsStandards:goodsId];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

-(void)shareContentBuild
{
    NSArray* imageArray = @[[UIImage imageNamed:@"1136.png"]];
    
    NSString *strurl=[NSString stringWithFormat:@"http://wap.landous.com/tmpl/product_detail.html?goods_id=%@",goodsId];
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:[[@"东方云商城上线啦！快来乐享" stringByAppendingString:[dicGoodsDetail objectForKey:@"goods_name"]] stringByAppendingString:strurl]
                                         images:imageArray
                                            url:[NSURL URLWithString:strurl]
                                          title:@"东方云商城"
                                           type:SSDKContentTypeAuto];
        
        
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                       
                   }];
    }
}


-(void)clickRightButton:(UIButton *)sender{
//    UIImage *image=img(@"1136.png");
//    NSString *strurl=[NSString stringWithFormat:@"   http://wap.landous.com/tmpl/product_detail.html?goods_id=%@",goodsId];
//    
//    
//    id<ISSContent> publishContent = [ShareSDK content:[[@"懒豆商城上线啦！快来乐享" stringByAppendingString:[dicGoodsDetail objectForKey:@"goods_name"]] stringByAppendingString:strurl]
//                                       defaultContent:[[@"懒豆商城上线啦！快来乐享" stringByAppendingString:[dicGoodsDetail objectForKey:@"goods_name"]] stringByAppendingString:strurl]
//                                                image:[ShareSDK jpegImageWithImage:image quality:1.0]
//                                                title:@"懒豆商城"
//                                                  url:strurl
//                                          description:[dicGoodsDetail objectForKey:@"goods_name"]
//                                            mediaType:SSPublishContentMediaTypeNews];
//    //创建弹出菜单容器
//    id<ISSContainer> container = [ShareSDK container];
//    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
//    
//    //弹出分享菜单
//    [ShareSDK showShareActionSheet:container
//                         shareList:nil
//                           content:publishContent
//                     statusBarTips:YES
//                       authOptions:nil
//                      shareOptions:nil
//                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                                
//                                if (state == SSResponseStateSuccess)
//                                {
//                                                [Dialog simpleToast:@"YEAH，分享成功"];
//                                    [self addSharePoints];
//                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
//                                }
//                                else if (state == SSResponseStateFail)
//                                {
//                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
//                                }
//                            }];
//    
    
    [self shareContentBuild];
    
    
}

-(void)addSharePoints
{
    
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        NSLog(@"添加积分^^^^%@", resultDict );
        NSString* message =(NSString*)[resultDict objectForKey:@"message"];
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            
            NSDictionary* data=(NSDictionary*)[resultDict objectForKey:@"data"];
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"恭喜您获得%@积分",(NSString*)[data objectForKey:@"pl_points"] ]];
            
        }
        else{
            if ([message isEqualToString:Nopermissiontodothis]) {
                
                
                [SVProgressHUD showErrorWithStatus:@"您还没有登陆，不能获取通过分享获得的积分哦！"];
            }
        }
        
        
        
        
    }];
    
    [dataProvider setFailedBlock:^(NSString *strError){
        [SVProgressHUD dismiss];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"检查网络！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        
    }];
    [dataProvider addSharePoints];
    //[dataProvider getStoreList:@"nothing" andPage:shopPage andPerpage:shopPerpage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)gotocart
{
    if (get_Dsp(@"userinfo")) {
        ShoppingCartController *ShoppingCart=[[ShoppingCartController alloc]init];
        ShoppingCart.strType=@"allscreen";
        [self.navigationController pushViewController:ShoppingCart animated:YES];
        //        [dicPost setObject:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
        //        [dicPost setObject:[NSString stringWithFormat:@"%d",perpage] forKey:@"perpage"];
        
        //[self getproduct:dicPost];
    }
    else{
        LoginViewController *LoginView=[[LoginViewController alloc]init];
        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:LoginView];
        nav.navigationBar.hidden=YES;
        LoginView.strType=@"nav";
        [self presentViewController:nav animated:YES completion:nil];
    }
}


- (IBAction)goodsdetailclick:(id)sender {
    scrollGoodsDetail.hidden=NO;
    viewComment.hidden=YES;
    imageweb.hidden=YES;
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
        
        imageLine.frame=CGRectMake(btnGoodsDetail.frame.origin.x, 35, 70, 2);
    } completion:^(BOOL finished) {
    
    }];
}

- (IBAction)picturedetailclick:(id)sender {
    scrollGoodsDetail.hidden=YES;
    viewComment.hidden=YES;
    imageweb.hidden=NO;
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
        
        imageLine.frame=CGRectMake(SCREEN_WIDTH/2-35, 35, 70, 2);
    } completion:^(BOOL finished) {
        
        
    }];
}

- (IBAction)commentclick:(id)sender {
    scrollGoodsDetail.hidden=YES;
    viewComment.hidden=NO;
    imageweb.hidden=YES;
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
        
        imageLine.frame=CGRectMake(btnComment.frame.origin.x, 35, 70, 2);
    } completion:^(BOOL finished) {
        
        
    }];
}

- (void)collectclick:(id)sender {
    if (get_Dsp(@"userinfo")) {
        if (btncollect.selected) {
            [self delFavoriteGoods:goodsId];
        }
        else{
            [self addFavoriteGoods:goodsId];
        }
    }
    else{
        LoginViewController *LoginView=[[LoginViewController alloc]init];
        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:LoginView];
        nav.navigationBar.hidden=YES;
        LoginView.strType=@"nav";
        [self presentViewController:nav animated:YES completion:nil];
    }
    
    
}


-(void)addFavoriteGoods:(NSString *)goodsID
{
    
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        NSLog(@"^^^^%@", resultDict );
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            [btncollect setSelected:YES];
            [Dialog simpleToast:@"YEAH，收藏商品成功"];
            
            
            
        }
        else{
            
        }
        
        
        
    }];
    
    [dataProvider setFailedBlock:^(NSString *strError){
        [SVProgressHUD dismiss];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"检查网络！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        
    }];
    
    [dataProvider addFavoriteGoods:goodsID];
}
-(void)delFavoriteGoods:(NSString *)goodsID
{
    
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        NSLog(@"^^^^%@", resultDict );
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            
            [btncollect setSelected:NO];
            [Dialog simpleToast:@"取消收藏成功"];
            
        }
        else{
            
        }
        
        
        
    }];
    
    [dataProvider setFailedBlock:^(NSString *strError){
        [SVProgressHUD dismiss];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"检查网络！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        
    }];
    
    [dataProvider delFavoriteGoods:goodsID];
}

-(void)getGoodsDetail:(NSString *)goodsID
{
    [SVProgressHUD show];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        DLog(@"^^^^%@", resultDict );
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            dicGoodsDetail=[NSMutableDictionary dictionaryWithDictionary:[resultDict objectForKey:@"data"][@"goods_info"]];
            
            goodImgUrl =resultDict[@"data"][@"goods_image"];
            specListGoodsDict = resultDict[@"data"][@"spec_list_goods"];
            specListNewGoodsIDDict = resultDict[@"data"][@"spec_list"];
//            if(![resultDict[@"data"][@"spec_name"] isEqual:[NSNull null]])
//            {
//                [self.dictStandard setObject:resultDict[@"data"][@"spec_name"] forKey:@"spec_name"];
//            }
//            if(![resultDict[@"data"][@"spec_value"] isEqual:[NSNull null]])
//            {
//               [self.dictStandard setObject:resultDict[@"data"][@"spec_value"] forKey:@"spec_value"];
//            }
//            
            
            if ([[resultDict objectForKey:@"recommends"] isKindOfClass:[NSArray class]]) {
                arrayRecommends=[NSMutableArray arrayWithArray:[resultDict objectForKey:@"recommends"]];
            }
            [self initGoodsDetailView];
            [self initPicDetailView];
            [self initCommentView];
            
        }
        else{
            
        }
     
        
        
    }];
    
    [dataProvider setFailedBlock:^(NSString *strError){
        [SVProgressHUD dismiss];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"检查网络！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        
    }];
    
    [dataProvider getGoodsDetail:goodsID];
}
-(void)refreshGoodsComments:(NSString *)goodsID
{
    [SVProgressHUD show];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        NSLog(@"^^^^%@", resultDict );
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            lblgoodComments.text=[NSString stringWithFormat:@"%@%%好评",[[resultDict objectForKey:@"info"]objectForKey:@"good_percent"]];
            lblcommentsNum.text=[NSString stringWithFormat:@"%@人已评",[[resultDict objectForKey:@"info"]objectForKey:@"all"]];
            if ([[resultDict objectForKey:@"list"]isKindOfClass:[NSArray class]]) {
                if ([[resultDict objectForKey:@"list"]count]>0) {
                    [arrayComments removeAllObjects];
                    for (int i=0; i<[[resultDict objectForKey:@"list"]count]; i++) {
                        [arrayComments addObject:[[resultDict objectForKey:@"list"] objectAtIndex:i]];
                    }
                    
                }
            }
            [tableComment reloadData];
            
        }
        else{
            
        }
        
        [tableComment headerEndRefreshing];
        
    }];
    
    [dataProvider setFailedBlock:^(NSString *strError){
        [SVProgressHUD dismiss];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"检查网络！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [tableComment headerEndRefreshing];
        
    }];
    
    [dataProvider getGoodsComments:goodsID andPage:page andPerpage:perpage];
}
-(void)getmoreGoodsComments:(NSString *)goodsID
{
    [SVProgressHUD show];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        NSLog(@"^^^^%@", resultDict );
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            if ([[resultDict objectForKey:@"list"]isKindOfClass:[NSArray class]]) {
                if ([[resultDict objectForKey:@"list"]count]>0) {
                    
                    for (int i=0; i<[[resultDict objectForKey:@"list"]count]; i++) {
                        [arrayComments addObject:[[resultDict objectForKey:@"list"] objectAtIndex:i]];
                    }
                    
                }
            }
            [tableComment reloadData];
            
        }
        else{
            
        }
        [tableComment footerEndRefreshing];
        
        
        
    }];
    
    [dataProvider setFailedBlock:^(NSString *strError){
        [SVProgressHUD dismiss];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"检查网络！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [tableComment footerEndRefreshing];
        
    }];
    
    [dataProvider getGoodsComments:goodsID andPage:page andPerpage:perpage];
}

-(void)addCart:(NSString *)goods_id andCount:(int)count
{
    
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        DLog(@"^^^^%@", resultDict );
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            
            [Dialog simpleToast:@"添加购物车成功"];
            
            
        }
        else{
            [Dialog simpleToast:[resultDict objectForKey:@"message"]];
        }
        
        
        
    }];
    
    [dataProvider setFailedBlock:^(NSString *strError){
        [SVProgressHUD dismiss];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"检查网络！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        
    }];
    
    [dataProvider addCart:goods_id andCount:count];
}


- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if (sender==scrollTop) {
        int pageIndex = fabs(sender.contentOffset.x) /sender.frame.size.width;
        pageCol.currentPage = pageIndex;
    }
    
    
    
    
    
}

-(void)initGoodsDetailView
{
    scrollGoodsDetail=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 102, SCREEN_WIDTH, SCREEN_HEIGHT-102-40)];
    
    scrollGoodsDetail.userInteractionEnabled=YES;
    [self.view addSubview:scrollGoodsDetail];
    //scrollGoodsDetail.hidden=YES;
    
    viewGoodDetailTop.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH+120);
    scrollTop.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH);
    pageCol.frame=CGRectMake(0, SCREEN_WIDTH-37, SCREEN_WIDTH, 37);
//    lblGoodsTitle.frame= CGRectMake(8, scrollTop.frame.size.height, 211, 35) ;
//    lblGoodsTitle.frame= CGRectMake(8, scrollTop.frame.size.height, 211, 35) ;
    viewToplbl.frame=CGRectMake(0,SCREEN_WIDTH, SCREEN_WIDTH, 120);
    
    
    
    
    
    
    LPLabel *lblOldPrice = [[LPLabel alloc] initWithFrame:CGRectMake(85,43,70,20)];
     lblOldPrice.text =[NSString stringWithFormat:@"￥%@",[dicGoodsDetail objectForKey:@"goods_marketprice"]];
    lblOldPrice.numberOfLines = 0;
    //lblOldPrice.textAlignment=NSTextAlignmentRight;
    lblOldPrice.font = [UIFont systemFontOfSize:12];
    lblOldPrice.textColor = [UIColor grayColor];
    lblOldPrice.backgroundColor = [UIColor clearColor];
    [viewToplbl addSubview:lblOldPrice];
    [scrollGoodsDetail addSubview:viewGoodDetailTop];
    
    
    UICollectionViewFlowLayout *layout= [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize=CGSizeMake(150,210);
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    collectionGoodsDetail=[[UICollectionView alloc]initWithFrame:CGRectMake(0, viewToplbl.frame.origin.y+viewToplbl.frame.size.height, SCREEN_WIDTH, 550)collectionViewLayout:layout];
    collectionGoodsDetail.dataSource=self;
    collectionGoodsDetail.delegate=self;
    collectionGoodsDetail.backgroundColor=[UIColor colorWithRed:0.93 green:0.94 blue:0.93 alpha:1];
    collectionGoodsDetail.userInteractionEnabled=YES;
    [collectionGoodsDetail registerClass:[ColGoodDetailCell class] forCellWithReuseIdentifier:KCellID];
    [scrollGoodsDetail addSubview:collectionGoodsDetail];
    
    scrollGoodsDetail.contentSize=CGSizeMake(SCREEN_WIDTH, collectionGoodsDetail.frame.origin.y+collectionGoodsDetail.frame.size.height-100);
    //以下给界面赋值
     
    if ([[dicGoodsDetail objectForKey:@"favorite"]intValue]==1) {
        [btncollect setSelected:YES];
    }
    else{
        [btncollect setSelected:NO];
    }
    NSArray *imagearray=[[NSArray alloc]initWithArray:[dicGoodsDetail objectForKey:@"images"]];
    if (imagearray.count > 0) {
        pageCol.numberOfPages=imagearray.count;
        
        scrollTop.pagingEnabled=YES;
        scrollTop.contentSize=CGSizeMake(SCREEN_WIDTH*imagearray.count,SCREEN_WIDTH);
        for (int i=0;i<imagearray.count;i++) {
            UIImageView *imgGoodsDetail=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*i,0,SCREEN_WIDTH,SCREEN_WIDTH)];
            NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",GOODS_IMG_URL,[dicGoodsDetail objectForKey:@"store_id"],[[imagearray objectAtIndex:i]objectForKey:@"goods_image"]]];
            [imgGoodsDetail setImageWithURL:url placeholderImage:img(@"landou_square_default.png")];
            imgGoodsDetail.contentMode= UIViewContentModeScaleAspectFit;
            //imgGoodsDetail.image=[UIImage imageNamed:@"line_01.png"];
            [scrollTop addSubview:imgGoodsDetail];
        }
    }
    else{
        UIImageView *imgGoodsDetail=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,250)];
        //NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",GOODS_IMG_URL,[dicGoodsDetail objectForKey:@"store_id"],[[imagearray objectAtIndex:i]objectForKey:@"goods_image"]]];
         imgGoodsDetail.image= img(@"landou_square_default.png");
        //imgGoodsDetail.image=[UIImage imageNamed:@"line_01.png"];
        [scrollTop addSubview:imgGoodsDetail];
    }
    
    
    
    NSString *strTitle=[NSString stringWithFormat:@"<h3>%@</h3>",[dicGoodsDetail objectForKey:@"goods_name"]];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[strTitle dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    lblGoodsTitle.attributedText=attributedString;
    //lblGoodsTitle.text=[dicGoodsDetail objectForKey:@"goods_name"];
    
    
    lblPrice.text=[NSString stringWithFormat:@"￥%@",[dicGoodsDetail objectForKey:@"goods_price"]];
    lblSaleNum.text=[NSString stringWithFormat:@"销量：%@件",[dicGoodsDetail objectForKey:@"goods_salenum"]];
    lblLookNum.text=[NSString stringWithFormat:@"浏览量：%@",[dicGoodsDetail objectForKey:@"goods_click"]];
    lblShopName.text=[NSString stringWithFormat:@"店铺：%@",[dicGoodsDetail objectForKey:@"store_name"]];
    self.lblKucun.text=[NSString stringWithFormat:@"库存：%@",[dicGoodsDetail objectForKey:@"goods_storage"]];
    
}
-(void)initPicDetailView
{
    imageweb=[[UIWebView alloc]init];
    
    imageweb.frame=CGRectMake(0, 102, SCREEN_WIDTH, SCREEN_HEIGHT-102-40);
    
     imageweb.scalesPageToFit=YES ;
    //imageweb.backgroundColor=[UIColor blueColor];
    imageweb.delegate=self;
    NSURL *url=[NSURL URLWithString:@""/*goodImgUrl[@"0"]*/];
    NSURLRequest *urlrequest=[NSURLRequest requestWithURL:url];
    [imageweb loadRequest:urlrequest];
    [self.view addSubview:imageweb];
    imageweb.hidden=YES;
}
-(void)initCommentView

{
    viewComment=[[UIView alloc]initWithFrame:CGRectMake(0, 102, SCREEN_WIDTH,SCREEN_HEIGHT-102-40)];
    
    viewComment.backgroundColor=[UIColor blueColor];
    [self.view addSubview:viewComment];
    
    tableComment=[[UITableView alloc]initWithFrame:CGRectMake(0, 0,viewComment.frame.size.width, viewComment.frame.size.height)];
    [tableComment addHeaderWithTarget:self action:@selector(headerRereshing)];
    [tableComment addFooterWithTarget:self action:@selector(footerRereshing)];
    tableComment.delegate=self;
    tableComment.dataSource=self;
    [viewComment addSubview:tableComment];
    tableComment.tableHeaderView=viewCommentHeader;
    
    
    
    viewComment.hidden=YES;
    
    [self refreshGoodsComments:goodsId];
    
    
    
}
- (void)headerRereshing
{
    page=1;
    
    [self refreshGoodsComments:goodsId];
    
}

- (void)footerRereshing
{
    page=page+1;
    
    [self getmoreGoodsComments:goodsId];
}

-(void)getGoodsStandards:(NSString *)goodsID
{
    
//    standardsView.delegate = self;
    
    [SVProgressHUD show];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        DLog(@"^^^^%@", resultDict );
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            
            
            
//            standardsView.delegate = self;
//            [standardsView show];
            
          
        }
        else{
            
        }
        
        
        
    }];
    
    [dataProvider setFailedBlock:^(NSString *strError){
        [SVProgressHUD dismiss];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"检查网络！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        
    }];
    
    [dataProvider getGoodsSpec:goodsID];
}

-(NSMutableDictionary *)dictStandard
{
    if(_dictStandard ==nil)
    {
        _dictStandard = [NSMutableDictionary dictionary];
    }
    
    return _dictStandard;
}


-(CGFloat)WidthWithString:(NSString*)string fontSize:(CGFloat)fontSize height:(CGFloat)height
{
    NSDictionary *attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    return  [string boundingRectWithSize:CGSizeMake(0, height) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size.width;
}

-(NSMutableArray *)standardBtnArr
{
    if(_standardBtnArr == nil)
    {
        _standardBtnArr = [NSMutableArray array];
    }
    
    return _standardBtnArr;
}

#pragma mark - standardsView delegate

-(void)StandardsView:(StandardsView *)standardView CustomBtnClickAction:(UIButton *)sender
{
    DLog(@"sender tag %ld click",(long)sender.tag);
    
    if(sender.tag == 0)
    {
       
        
        if (standardIdStr == nil||standardIdStr.length ==0) {
            [Dialog simpleToast:@"亲，请正确选择规格"];
            return;
        }
        self.goodsIdWithSpec = specListNewGoodsIDDict[standardIdStr];
        if (([self.goodsIdWithSpec isEqual:[NSNull null]] || self.goodsIdWithSpec == nil)) {
            [Dialog simpleToast:@"亲，请正确选择规格"];
            return;
        }
        [standardsView ThrowGoodTo:CGPointMake(200, 40) andDuration:1.0 andHeight:0 andScale:20.0];
        if (self.goodsIdWithSpec !=nil) {
            [self addCart:self.goodsIdWithSpec andCount:(int)(standardsView.buyNum)];
        }
        else
        {
            [self addCart:goodsId andCount:(int)(standardsView.buyNum)];
        }
        
        
    }
    else if(sender.tag == 1)
    {
        goodsNum = standardsView.buyNum;
        if (standardIdStr == nil||standardIdStr.length ==0) {
            [Dialog simpleToast:@"亲，请正确选择规格"];
            return;
        }
        NSDictionary *specInfo = specListGoodsDict[standardIdStr];
        if (([specInfo isEqual:[NSNull null]] || specInfo == nil)) {
            [Dialog simpleToast:@"亲，请正确选择规格"];
            return;
        }
        
        [standardsView dismiss];
        
        if (get_Dsp(@"userinfo")) {
            if ([[dicGoodsDetail objectForKey:@"goods_storage"] intValue]==0) {
                [Dialog simpleToast:@"亲，商品库存不足"];
                return;
            }

            
            if (goodsNum ==0) {
                [Dialog simpleToast:@"亲，购买数量不能为零"];
                return;
            }
            if ([[dicGoodsDetail objectForKey:@"goods_storage"] intValue]<goodsNum) {
                [Dialog simpleToast:@"亲，库存不足了"];
                return;
            }

            [dicGoodsDetail setObject:[NSString stringWithFormat:@"%ld",goodsNum] forKey:@"goods_num"];
            
            SureCartController *SureCart=[[SureCartController alloc]init];
            SureCart.arrayCartList=[[NSMutableArray alloc]init];
            [SureCart.arrayCartList addObject:dicGoodsDetail];
            SureCart.strType=@"buynow";
            
            SureCart.goosStandardIDStrArr = [NSMutableArray array];
            [SureCart.goosStandardIDStrArr addObject:specListGoodsDict];
            SureCart.standardIDStrArr = [NSMutableArray array];
            [SureCart.standardIDStrArr addObject:standardIdStr];
            [self.navigationController pushViewController:SureCart animated:YES];


//            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入商品数量" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//
//            alert.tag=543;
//            alert.alertViewStyle=UIAlertViewStylePlainTextInput;
//            UITextField *tf = [alert textFieldAtIndex:0];
//            tf.keyboardType = UIKeyboardTypeNumberPad;
//
//            [alert show];
        }
        else{
            LoginViewController *LoginView=[[LoginViewController alloc]init];
            UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:LoginView];
            nav.navigationBar.hidden=YES;
            LoginView.strType=@"nav";
            [self presentViewController:nav animated:YES completion:nil];
        }

        
//        [standardsView setBackViewAnimationScale:self.view andDuration:1.0 toValueX:(1.0/0.9) andValueY:(1.0/0.9)];
        
    }
}


-(void)StandardsView:(StandardsView *)standardView SetBtn:(UIButton *)btn andStandView:(StandardsView *)standardView
{
    if(btn.tag == 0 )
    {
        btn.backgroundColor = [UIColor yellowColor];
    }
    else if(btn.tag == 1)
    {
        btn.backgroundColor = [UIColor orangeColor];
    }
}
-(void)Standards:(StandardsView *)standardView SelectBtnClick:(UIButton *)sender andSelectID:(NSString *)selectID andStandName:(NSString *)standName andIndex:(NSInteger)index
{
    DLog(@"selectId:%@  standName:%@  index:%ld",selectID,standName,(unsigned long)index);
    
    if(index == 0)
    {
        standardIdStr = [NSString stringWithFormat:@"%@|%@",selectID,[standardIdStr substringFromIndex:4]];
    }
    else if(index == 1)
    {
        standardIdStr = [NSString stringWithFormat:@"%@|%@",[standardIdStr substringToIndex:3],selectID];
    }

    DLog(@"standardIdStr = %@",standardIdStr);
    NSDictionary *specInfo = specListGoodsDict[standardIdStr];
    if(!([specInfo isEqual:[NSNull null]] || specInfo == nil))
    {
        DLog(@"price:%@",specInfo[@"goods_price"]);
        DLog(@"storage:%@",specInfo[@"goods_storage"]);
        
        standardsView.priceLab.text = [NSString stringWithFormat:@"¥%@",specInfo[@"goods_price"]];
        standardsView.goodNum.text = [NSString stringWithFormat:@"库存%@件",specInfo[@"goods_storage"]];
        
        
        self.goodsIdWithSpec =[NSString stringWithFormat:@"%@",specListNewGoodsIDDict[standardIdStr]];
    }

}


#pragma mark tableview delegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return arrayComments.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    UITableViewCell *cell = [tableView
    //                             dequeueReusableCellWithIdentifier:@"Cell"];
    static NSString *CellIdentifier = @"CommentCellIdentifier";
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"CommentCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        //cell.backgroundColor=[UIColor colorWithRed:0.94 green:0.95 blue:0.95 alpha:1];
    }
    [cell.imgUser.layer setMasksToBounds:YES];
    cell.imgUser.layer.cornerRadius=20.0;
    if ([[[arrayComments objectAtIndex:indexPath.row] objectForKey:@"geval_image"] length]>0) {
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",USER_IMAGE_URL,[[arrayComments objectAtIndex:indexPath.row] objectForKey:@"geval_image"]]];
        [cell.imgUser setImageWithURL:url placeholderImage:img(@"noimage.jpg")];
    }
    else{
        cell.imgUser.image=img(@"noimage.jpg");
    }
    
    NSString *nickname=[[arrayComments objectAtIndex:indexPath.row]objectForKey:@"geval_frommembername"];
    if ([[[arrayComments objectAtIndex:indexPath.row]objectForKey:@"geval_isanonymous"]intValue]==1) {
        NSString *newnickname=[nickname substringToIndex:1];
        cell.lblNickName.text=[NSString stringWithFormat:@"%@***",newnickname];
    }
    else{
        cell.lblNickName.text=nickname;
    }
    
    cell.lblDisc.text=[[arrayComments objectAtIndex:indexPath.row]objectForKey:@"geval_content"];
    
//    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
//    [formatter setDateFormat:@"yyyyMMddHHMMss"];
//    NSString *strdate=[[arrayComments objectAtIndex:indexPath.row]objectForKey:@"geval_addtime"];
//    NSDate *date =  [formatter dateFromString:strdate] ;
//    NSLog(@"date1:%@",date);
//    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:strdate];
    NSString *str= [[arrayComments objectAtIndex:indexPath.row]objectForKey:@"geval_addtime"];//时间戳
    NSTimeInterval time=[str doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSLog(@"date:%@",[detaildate description]);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    cell.lblInfo.text=[NSString stringWithFormat:@"%@ %@",currentDateStr,[[arrayComments objectAtIndex:indexPath.row]objectForKey:@"geval_goodsname"]];
    
    [cell.btn1 setImage:img(@"starunsel") forState:UIControlStateNormal];
    [cell.btn1 setImage:img(@"starsel") forState:UIControlStateSelected];
    
    [cell.btn2 setImage:img(@"starunsel") forState:UIControlStateNormal];
    [cell.btn2 setImage:img(@"starsel") forState:UIControlStateSelected];
    
    [cell.btn3 setImage:img(@"starunsel") forState:UIControlStateNormal];
    [cell.btn3 setImage:img(@"starsel") forState:UIControlStateSelected];
    
    [cell.btn4 setImage:img(@"starunsel") forState:UIControlStateNormal];
    [cell.btn4 setImage:img(@"starsel") forState:UIControlStateSelected];
    
    [cell.btn5 setImage:img(@"starunsel") forState:UIControlStateNormal];
    [cell.btn5 setImage:img(@"starsel") forState:UIControlStateSelected];
    
    if ([[[arrayComments objectAtIndex:indexPath.row] objectForKey:@"geval_scores"] intValue]==1) {
        [cell.btn1 setSelected:YES];
        [cell.btn2 setSelected:NO];
        [cell.btn3 setSelected:NO];
        [cell.btn4 setSelected:NO];
        [cell.btn5 setSelected:NO];
    }
    else if([[[arrayComments objectAtIndex:indexPath.row] objectForKey:@"geval_scores"] intValue]==2)
    {
        [cell.btn1 setSelected:YES];
        [cell.btn2 setSelected:YES];
        [cell.btn3 setSelected:NO];
        [cell.btn4 setSelected:NO];
        [cell.btn5 setSelected:NO];
    }
    else if([[[arrayComments objectAtIndex:indexPath.row] objectForKey:@"geval_scores"] intValue]==3)
    {
        [cell.btn1 setSelected:YES];
        [cell.btn2 setSelected:YES];
        [cell.btn3 setSelected:YES];
        [cell.btn4 setSelected:NO];
        [cell.btn5 setSelected:NO];
    }
    else if([[[arrayComments objectAtIndex:indexPath.row] objectForKey:@"geval_scores"] intValue]==4)
    {
        [cell.btn1 setSelected:YES];
        [cell.btn2 setSelected:YES];
        [cell.btn3 setSelected:YES];
        [cell.btn4 setSelected:YES];
        [cell.btn5 setSelected:NO];
    }
    else if([[[arrayComments objectAtIndex:indexPath.row] objectForKey:@"geval_scores"] intValue]==5)
    {
        [cell.btn1 setSelected:YES];
        [cell.btn2 setSelected:YES];
        [cell.btn3 setSelected:YES];
        [cell.btn4 setSelected:YES];
        [cell.btn5 setSelected:YES];
    }
    
    
    
    // Configure the cell...
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}






#pragma mark collection delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section

{
    
    // 每个Section的item个数
    
    return 4;
    
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView{
    
    return 1;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH/2-10,210);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath

{
    
    
    
    static NSString * CellIdentifier = @"ColGoodDetailCell";
    ColGoodDetailCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    if(arrayRecommends.count - 1 < indexPath.row || arrayRecommends.count == 0 || arrayRecommends == nil)
    {
        return cell;
    }
    
    cell.backgroundColor=[UIColor whiteColor];
    NSURL *URL=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",GOODS_IMG_URL,[[arrayRecommends objectAtIndex:indexPath.row] objectForKey:@"store_id"],[[arrayRecommends objectAtIndex:indexPath.row] objectForKey:@"goods_image"]]];
    [cell.imgGood setImageWithURL:URL placeholderImage:img(@"landou_square_default.png")];
    cell.lblGoodsDisc.text=[[arrayRecommends objectAtIndex:indexPath.row] objectForKey:@"goods_name"];
    cell.lblGoodsPrice.text=[NSString stringWithFormat:@"￥%@", [[arrayRecommends objectAtIndex:indexPath.row]objectForKey:@"goods_price"]] ;
    cell.lblGoodsBuyed.text=[NSString stringWithFormat:@"%@人已购买", [[arrayRecommends objectAtIndex:indexPath.row]objectForKey:@"goods_salenum"]] ;
    
    
    
    // 图片的名称
  
    return cell;
    
    
    
}
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
 
{
    GoodDetailController *GoodDetail=[[GoodDetailController alloc]init];
    GoodDetail.goodsId=[[arrayRecommends objectAtIndex:indexPath.row] objectForKey:@"goods_id"];
    [self.navigationController pushViewController:GoodDetail animated:YES];
}





- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag==543) {
//        UITextField *textNum=[alertView textFieldAtIndex:0];
        if (goodsNum ==0) {
            [Dialog simpleToast:@"亲，购买数量不能为零"];
            return;
        }
        if ([[dicGoodsDetail objectForKey:@"goods_storage"] intValue]<goodsNum) {
            [Dialog simpleToast:@"亲，库存不足了"];
            return;
        }
        if (buttonIndex==1) {
            [dicGoodsDetail setObject:[NSString stringWithFormat:@"%ld",goodsNum] forKey:@"goods_num"];
            [self getGoodsStandards:goodsId];
            
            
            
            
        }
    }
}


-(void)showSelectStandard:(NSInteger)tag
{
    
    standardIdStr = @"000|000";
    
    standardsView = [[StandardsView alloc] init];
    standardsView.tag = tag;
    standardsView.delegate = self;
    /*head 信息*/
    standardsView.priceLab.text = [NSString stringWithFormat:@"¥%@",dicGoodsDetail[@"goods_price"]];
    standardsView.goodNum.text = [NSString stringWithFormat:@"库存%@件",dicGoodsDetail[@"goods_storage"]];
    
    standardsView.customBtns = @[@"加入购物车",@"立即购买"];
    NSArray *tempArr = dicGoodsDetail[@"spec_name"];
    NSString *str = @"请选择 ";
    for (int i = 0; i<tempArr.count; i++) {
        str = [NSString stringWithFormat:@"%@%@ ",str,tempArr[i][@"name"]];
    }
    standardsView.tipLab.text = str;
    [standardsView.mainImgView setImageWithURL:[NSURL URLWithString:goodImgUrl[@"0"]] placeholderImage:[UIImage imageNamed:@"landou_square_default.png"]];
    /*规格详情*/
    NSMutableArray *standardModelArr = [NSMutableArray array];
    
    for (int i = 0; i < tempArr.count; i++) {
        StandardModel *tempModel = [[StandardModel alloc] init];
        tempModel.standardName = tempArr[i][@"name"];
        
        NSString *strID = [NSString stringWithFormat:@"%@",tempArr[i][@"id"]];
        NSArray *specArr = [dicGoodsDetail[@"spec_value"] objectForKey:strID];
        NSMutableArray *tempInfoArr = [NSMutableArray array];
        for (int j = 0 ; j < specArr.count; j++) {
            standardClassInfo *tempInfo = [[standardClassInfo alloc] init];
            tempInfo.standardClassName = specArr[j][@"name"];
            tempInfo.standardClassId = specArr[j][@"id"];
            
            [tempInfoArr addObject:tempInfo];
        }
        
        tempModel.standardClassInfo = tempInfoArr;
        [standardModelArr addObject:tempModel];
    }
    
    standardsView.standardArr = standardModelArr;
    //    standardsView.showAnimationType = StandsViewShowAnimationShowFrombelow;
    //    [standardsView setBackViewAnimationScale:self.view andDuration:1.6 toValueX:0.9 andValueY:0.9];
    standardsView.GoodDetailView = self.view;
    [standardsView show];

}

- (IBAction)buyNowclick:(id)sender {
    
    [self showSelectStandard:0];
    
}

- (IBAction)addCartclick:(id)sender {
    if (get_Dsp(@"userinfo")) {
        
        [self showSelectStandard:1];
        
        
    }
    else{
        LoginViewController *LoginView=[[LoginViewController alloc]init];
        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:LoginView];
        nav.navigationBar.hidden=YES;
        LoginView.strType=@"nav";
        [self presentViewController:nav animated:YES completion:nil];
    }
}



@end
