//
//  GoodDetailController.h
//  LanDouS
//
//  Created by Mao-MacPro on 15/1/6.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
#import "StandardsView.h"
#import "UIImageView+WebCache.h"
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKInterfaceAdapter/ISSContainer.h>

@interface GoodDetailController : BaseNavigationController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UIWebViewDelegate,StandardsViewDelegate,StandardsViewDataSource>
{
    UIButton *btncollect;
    UIButton *btngotoCart;
    
    
    UIView *viewPictureDetail;//图片详情的视图
    UIWebView *imageweb;
    UIView *viewComment;
    UIView *viewFootTwoButton;//下面收藏和加入购物车的视图
    UIScrollView *scrollGoodsDetail;//商品详情滚动的依靠
    UICollectionView *collectionGoodsDetail;//猜你喜欢列表
    UITableView *tableComment;//评论列表
    
    NSMutableDictionary *dicGoodsDetail;//商品详情字典
    NSMutableArray *arrayRecommends;//猜你喜欢的数组
    NSMutableArray *arrayComments;//评论列表的数组
    
    int page;
    int perpage;
    
    StandardsView *standardsView;
    
    
    NSDictionary *goodImgUrl;
    NSDictionary *specListGoodsDict;//商品规格信息
    NSString *standardIdStr;
    
    
    
}
@property (strong, nonatomic) IBOutlet UIView *viewToplbl;

@property (strong, nonatomic) IBOutlet UIButton *btnGoodsDetail;
@property (strong, nonatomic) IBOutlet UIButton *btnPicture;
@property (strong, nonatomic) IBOutlet UIButton *btnComment;
@property (strong, nonatomic) IBOutlet UILabel *lblKucun;

@property(copy,nonatomic)NSString *goodsId;

- (IBAction)goodsdetailclick:(id)sender;
- (IBAction)picturedetailclick:(id)sender;
- (IBAction)commentclick:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *imageLine;
@property (strong, nonatomic) IBOutlet UIView *viewGoodDetailTop;
@property (strong, nonatomic) IBOutlet UIView *viewCommentHeader;

////////////////以下是详情界面基本信息UI
@property (strong, nonatomic) IBOutlet UIScrollView *scrollTop;
@property (strong, nonatomic) IBOutlet UILabel *lblGoodsTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblLookNum;
@property (strong, nonatomic) IBOutlet UILabel *lblSaleNum;
@property (strong, nonatomic) IBOutlet UILabel *lblPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblYunFei;
@property (strong, nonatomic) IBOutlet UIPageControl *pageCol;

@property (strong, nonatomic) IBOutlet UILabel *lblSendTime;
@property (strong, nonatomic) IBOutlet UILabel *lblShopName;
//////////////
///////以下收藏和加入购物车按钮

- (IBAction)buyNowclick:(id)sender;
 
- (IBAction)addCartclick:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *detailFootView;

@property (strong, nonatomic) IBOutlet UILabel *lblgoodComments;
@property (strong, nonatomic) IBOutlet UILabel *lblcommentsNum;




@end
