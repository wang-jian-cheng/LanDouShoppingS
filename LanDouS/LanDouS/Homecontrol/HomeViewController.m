//
//  HomeViewController.m
//  LanDouS
//
//  Created by Mao-MacPro on 14/12/23.
//  Copyright (c) 2014年 Mao-MacPro. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeCell.h"
#import "AppDelegate.h"
#import "CustomSearchBar.h"
#import <ShareSDK/ShareSDK.h>
#import "DataProvider.h"
#import "UIImageView+WebCache.h"
#import "GoodDetailController.h"
#import "GoodsListController.h"
#import "ZhuanTiController.h"
#import "MJRefresh.h"
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKInterfaceAdapter/ISSContainer.h>


@interface HomeViewController ()<CustomSearchBarDelegate>
{
    CustomSearchBar *_searchBar;
}
@end

@implementation HomeViewController
@synthesize btnIndexView,scrollBG,pageControl;
- (void)viewDidLoad {
    [super viewDidLoad];
    //[self setBarTitle:@"首页"];
    
    
    arrGcId = [NSMutableArray array];
    
    [self addRightButton:@"whiteshare@2x.png"];
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
   // image.image=[UIImage imageNamed:@"navgreen.png"];
//    [_topView addSubview:image];
    UIImageView *imageline1=[[UIImageView alloc]initWithFrame:CGRectMake(10,20, 40, 40)];
    imageline1.image=[UIImage imageNamed:@"lanchong.png"];
    [_topView addSubview:imageline1];
    searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(60, 30, SCREEN_WIDTH-120, 30)];
    //searchBar.barTintColor=[UIColor colorWithRed:0.51 green:0.57 blue:0.29 alpha:1];
    //searchBar.backgroundImage=[UIImage imageNamed:@"searchBarBG.png"];
    //    searchBar.placeholder=@"请输入搜索信息";
    //    searchBar.backgroundColor=[UIColor whiteColor];
    //    searchBar.searchBarStyle=UISearchBarStyleMinimal;
    //    [_topView addSubview:searchBar];
    
    _searchBar = [[CustomSearchBar alloc] initWithFrame:CGRectMake(70, 20, SCREEN_WIDTH-130, NavigationBar_HEIGHT)];
    _searchBar.delegate = self;
    [_topView addSubview:_searchBar];
    
    UIButton *btnsearch=[[UIButton alloc]initWithFrame:_searchBar.frame];
    
    [btnsearch addTarget:self action:@selector(gotogoodslist) forControlEvents:UIControlEventTouchUpInside];
    btnsearch.backgroundColor=[UIColor clearColor];
    [_topView addSubview:btnsearch];
    
//    _topView.backgroundColor=[UIColor colorWithRed:0.51 green:0.57 blue:0.29 alpha:1];
    tableHome = [[UITableView alloc] initWithFrame:CGRectMake(0,NavigationBar_HEIGHT+20, SCREEN_WIDTH, SCREEN_HEIGHT-113)];
    tableHome.dataSource = self;
    tableHome.delegate = self;
    [tableHome addHeaderWithTarget:self action:@selector(headrefresh)];
    [self.view addSubview:tableHome];
    
    slideImages=[[NSMutableArray alloc]init];
    arrayHomeList=[[NSMutableArray alloc]init];
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
    //[self getScreenList];
    [self getHomelist];
    [scrollBG bringSubviewToFront:pageControl];
    
    
    
    self.Btn1.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.Btn2.imageView.contentMode = UIViewContentModeScaleAspectFit;
    // Do any additional setup after loading the view from its nib.
}
-(void)headrefresh
{
    
    [self getHomelist];
}


-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] showTabBar];
}
-(void)clickRightButton:(UIButton *)sender{
//    UIImage *image=img(@"1136.png");
//    id<ISSContent> publishContent = [ShareSDK content:@"懒豆商城，上线啦！快来一起享受购物的乐趣吧！http://www.landous.com"
//                                       defaultContent:@"懒豆商城，上线啦！快来一起享受购物的乐趣吧！http://www.landous.com"
//                                                image:[ShareSDK jpegImageWithImage:image quality:3.0]
//                                                title:@"懒豆商城"
//                                                  url:@"http://www.landous.com"
//                                          description:@"懒豆商城"
//                                            mediaType:SSPublishContentMediaTypeNews];
//    //创建弹出菜单容器
//    id<ISSContainer> container = [ShareSDK container];
//    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
//    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
//                                                         allowCallback:YES
//                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
//                                                          viewDelegate:nil
//                                               authManagerViewDelegate:nil];
//    //弹出分享菜单
//    [ShareSDK showShareActionSheet:container
//                         shareList:nil
//                           content:publishContent
//                     statusBarTips:YES
//                       authOptions:authOptions
//                      shareOptions:nil
//                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                                
//                                if (state == SSResponseStateSuccess)
//                                {
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

-(void)shareContentBuild
{
    NSArray* imageArray = @[[UIImage imageNamed:@"1136.png"]];
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"淘小七商城，上线啦！快来一起享受购物的乐趣吧！http://zhongyangjituan.com/zysc/shop/index.php"
                                         images:imageArray
                                            url:[NSURL URLWithString:@"http://zhongyangjituan.com/zysc/shop/index.php"]
                                          title:@"淘小七商城"
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

-(void)gotogoodslist
{
    GoodsListController *GoodsList=[[GoodsListController alloc]init];
    GoodsList.searchID=@"search";
    [self.navigationController pushViewController:GoodsList animated:YES];
    
}
// scrollview 委托函数
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if (sender==tableHome) {
        [searchBar resignFirstResponder];
    }
    else{
        CGFloat pagewidth = scrollBG.frame.size.width;
        int page = floor((scrollBG.contentOffset.x - pagewidth/([slideImages count]+2))/pagewidth)+1;
        page --;  // 默认从第二页开始
        pageControl.currentPage = page;
    }
}
// scrollview 委托函数
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pagewidth = scrollBG.frame.size.width;
    int currentPage = floor((scrollBG.contentOffset.x - pagewidth/ ([slideImages count]+2)) / pagewidth) + 1;
    //    int currentPage_ = (int)self.scrollView.contentOffset.x/320; // 和上面两行效果一样
    //    NSLog(@"currentPage_==%d",currentPage_);
    if (currentPage==0)
    {
        [scrollBG scrollRectToVisible:CGRectMake(320 * [slideImages count],0,SCREEN_WIDTH,121) animated:YES]; // 序号0 最后1页
    }
    else if (currentPage==([slideImages count]+1))
    {
        [scrollBG scrollRectToVisible:CGRectMake(SCREEN_WIDTH,0,SCREEN_WIDTH,121) animated:YES]; // 最后+1,循环第1页
    }
}
// pagecontrol 选择器的方法
- (void)turnPage
{
    long page = pageControl.currentPage; // 获取当前的page
    [scrollBG scrollRectToVisible:CGRectMake(SCREEN_WIDTH*(page+1),0,SCREEN_WIDTH,121) animated:YES]; // 触摸pagecontroller那个点点 往后翻一页 +1
}
// 定时器 绑定的方法
- (void)runTimePage
{
    long page = pageControl.currentPage; // 获取当前的page
    page++;
    long imj=slideImages.count;
    page = page > imj-1 ? 0 : page ;
    pageControl.currentPage = page;
    [self turnPage];
}

-(void)initLunBoView
{
    scrollBG.frame=CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_WIDTH/2.5+20);
    pageControl.frame=CGRectMake(0, scrollBG.frame.size.height-37+40, 320, 37);
    btnIndexView.frame=CGRectMake(0, 100+40, SCREEN_WIDTH,scrollBG.frame.size.height+158+40);
    tableHome.tableHeaderView=btnIndexView;
    
    self.viewtopClassBG.frame=CGRectMake(0,scrollBG.frame.size.height+40, SCREEN_WIDTH, 158);
    
    
    // 初始化mypagecontrol
    
    //    [pageControl setCurrentPageIndicatorTintColor:[UIColor redColor]];
    //    [pageControl setPageIndicatorTintColor:[UIColor blackColor]];
    // 触摸mypagecontrol触发change这个方法事件
    
    // 创建四个图片 imageview
    for (int i = 0;i<[slideImages count];i++)
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake((SCREEN_WIDTH * i) + SCREEN_WIDTH,0,SCREEN_WIDTH,scrollBG.frame.size.height);
        //imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",[slideImages objectAtIndex:i]]];
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",LUNBO_IMAGE_URL,[[slideImages objectAtIndex:i] objectForKey:@"special_image"]]];
        [imageView setImageWithURL:url placeholderImage:img(@"landou_rectangle_default.png")];
        [scrollBG addSubview:imageView]; // 首页是第0页,默认从第1页开始的。所以+320。。。
        UIButton  *btn_info=[[UIButton alloc]initWithFrame:imageView.frame];
        //[btn_info setTitle:@"评论" forState:UIControlStateNormal];
        [btn_info setBackgroundColor:[UIColor clearColor]];
        [btn_info addTarget:self action:@selector(gotoinfoDetail:) forControlEvents:UIControlEventTouchUpInside];
        btn_info.tag=3000+i;
        
        [scrollBG addSubview:btn_info];
        
        
        
        
    }
    // 取数组最后一张图片 放在第0页
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[[slideImages objectAtIndex:([slideImages count]-1)] objectForKey:@"special_image"]]];
    imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH,scrollBG.frame.size.height); // 添加最后1页在首页 循环
    [scrollBG addSubview:imageView];
    // 取数组第一张图片 放在最后1页
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[[slideImages objectAtIndex:0] objectForKey:@"special_image"]]];
    imageView.frame = CGRectMake((SCREEN_WIDTH * ([slideImages count] + 1)) , 0, SCREEN_WIDTH,scrollBG.frame.size.height); // 添加第1页在最后 循环
    [scrollBG addSubview:imageView];
    
    [scrollBG setContentSize:CGSizeMake(SCREEN_WIDTH * ([slideImages count] + 2),scrollBG.frame.size.height)]; //  +上第1页和第4页  原理：4-[1-2-3-4]-1
    [scrollBG setContentOffset:CGPointMake(0, 0)];
    [scrollBG scrollRectToVisible:CGRectMake(SCREEN_WIDTH,0,SCREEN_WIDTH,scrollBG.frame.size.height) animated:NO];
    
    
    pageControl.numberOfPages = [slideImages count];
    pageControl.currentPage = 0;
    [pageControl addTarget:self action:@selector(turnPage) forControlEvents:UIControlEventValueChanged];
    [scrollBG bringSubviewToFront:pageControl];
}
-(void)gotoinfoDetail:(UIButton *)sender
{
    int i=sender.tag-3000;
    ZhuanTiController *ZhuanTi=[[ZhuanTiController alloc]init];
    ZhuanTi.specialId=[[slideImages objectAtIndex:i] objectForKey:@"special_id"];
    [self.navigationController pushViewController:ZhuanTi animated:YES];
    
}


-(void)getScreenList
{
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        DLog(@"^^^^%@", resultDict );
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            if ([[resultDict objectForKey:@"list"]isKindOfClass:[NSArray class]]) {
                if ([[resultDict objectForKey:@"list"]count]>0) {
                    slideImages=[NSMutableArray arrayWithArray:[resultDict objectForKey:@"list"]];
                    [self initLunBoView];
                }
            }
        }
        else{
            
        }
        
        [tableHome headerEndRefreshing];
        
    }];
    
    [dataProvider setFailedBlock:^(NSString *strError){
        [SVProgressHUD dismiss];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"检查网络！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [tableHome headerEndRefreshing];
    }];
    
    [dataProvider getScreenList];
}
-(void)getHomelist
{
    
    [SVProgressHUD showWithStatus:@"正在加载"];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        DLog(@"^^^^%@", resultDict );
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            [arrayHomeList removeAllObjects];
            if ([[resultDict objectForKey:@"list"]isKindOfClass:[NSArray class]]) {
                if ([[resultDict objectForKey:@"list"]count]>0) {
                    for (int i=0; i<[[resultDict objectForKey:@"list"]count]; i++) {
                        if(!([[[[resultDict objectForKey:@"list"] objectAtIndex:i] objectForKey:@"gc_name"] isEqualToString:@"进口专区"]||[[[[resultDict objectForKey:@"list"] objectAtIndex:i] objectForKey:@"gc_name"] isEqualToString:@"计生保健"]||[[[[resultDict objectForKey:@"list"] objectAtIndex:i] objectForKey:@"gc_name"] isEqualToString:@"内衣服饰"])){
                            if ([[[[resultDict objectForKey:@"list"] objectAtIndex:i]objectForKey:@"goods"]isKindOfClass:[NSArray class]]) {
                                [arrayHomeList addObject:[[resultDict objectForKey:@"list"] objectAtIndex:i]];
                            }
                        }
                        
                        [arrGcId addObject:[resultDict objectForKey:@"list"][i][@"gc_id"]];
                    }
                    //arrayHomeList=[NSMutableArray arrayWithArray:[resultDict objectForKey:@"list"]];
                    
                }
                [self getScreenList];
                [tableHome reloadData];
            }
        }
        else{
            
        }
        //[tableHome headerEndRefreshing];
        
        
    }];
    
    [dataProvider setFailedBlock:^(NSString *strError){
        [SVProgressHUD dismiss];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"检查网络！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        //[tableHome headerEndRefreshing];
    }];
    
    [dataProvider getHomeGoods];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return arrayHomeList.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    static NSString *CellIdentifier = @"HomeCellIdentifier";
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"HomeCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        //cell.backgroundColor=[UIColor colorWithRed:0.94 green:0.95 blue:0.95 alpha:1];
    }
    cell.lblClass.text=[[arrayHomeList objectAtIndex:indexPath.section] objectForKey:@"gc_name"];
    
    cell.imLeft.contentMode=UIViewContentModeScaleAspectFit;
    cell.imRightTop.contentMode=UIViewContentModeScaleAspectFit;
    cell.imRightUnder.contentMode=UIViewContentModeScaleAspectFit;
    
    
    
    
    
    
    
    
    
    if ([[[arrayHomeList objectAtIndex:indexPath.section] objectForKey:@"goods"]isKindOfClass:[NSArray class]]) {
        
        
        if ([[[arrayHomeList objectAtIndex:indexPath.section] objectForKey:@"goods"]count]==3) {
            NSURL *urlLeft=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",GOODS_IMG_URL,[[[[arrayHomeList objectAtIndex:indexPath.section] objectForKey:@"goods"] objectAtIndex:0] objectForKey:@"store_id"],[[[[arrayHomeList objectAtIndex:indexPath.section] objectForKey:@"goods"] objectAtIndex:0] objectForKey:@"goods_image"]]];
            [cell.imLeft setImageWithURL:urlLeft placeholderImage:img(@"landou_square_default.png")];
            cell.lblLeftTitle.text=[[[[arrayHomeList objectAtIndex:indexPath.section] objectForKey:@"goods"] objectAtIndex:0] objectForKey:@"goods_name"];
            cell.lblLeftPrice.text=[NSString stringWithFormat:@"优惠价￥%@",[[[[arrayHomeList objectAtIndex:indexPath.section] objectForKey:@"goods"] objectAtIndex:0] objectForKey:@"goods_price"]];
            
            
            
            
            
            NSString *strTitleRT=[NSString stringWithFormat:@"<p2>%@</p2>",[[[[arrayHomeList objectAtIndex:indexPath.section] objectForKey:@"goods"] objectAtIndex:1] objectForKey:@"goods_name"]];
            NSAttributedString *RTtext = [[NSAttributedString alloc] initWithData:[strTitleRT dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            
            
            cell.lblRightTopTitle.attributedText=RTtext;
            //cell.lblRightTopTitle.text=[[[[arrayHomeList objectAtIndex:indexPath.section] objectForKey:@"goods"] objectAtIndex:1] objectForKey:@"goods_name"];
            NSURL *urlRT=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",GOODS_IMG_URL,[[[[arrayHomeList objectAtIndex:indexPath.section] objectForKey:@"goods"] objectAtIndex:1] objectForKey:@"store_id"],[[[[arrayHomeList objectAtIndex:indexPath.section] objectForKey:@"goods"] objectAtIndex:1] objectForKey:@"goods_image"]]];
            [cell.imRightTop setImageWithURL:urlRT placeholderImage:img(@"landou_square_default.png")];
            cell.lblRightTopPrice.text=[NSString stringWithFormat:@"优惠价￥%@",[[[[arrayHomeList objectAtIndex:indexPath.section] objectForKey:@"goods"] objectAtIndex:1] objectForKey:@"goods_price"]];
            
            
            NSString *strTitleRU=[NSString stringWithFormat:@"<p2>%@</p2>",[[[[arrayHomeList objectAtIndex:indexPath.section] objectForKey:@"goods"] objectAtIndex:2] objectForKey:@"goods_name"]];
            NSAttributedString *RUtext = [[NSAttributedString alloc] initWithData:[strTitleRU dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            
            
            cell.lblRightUnderTitle.attributedText=RUtext;
            
            
            //cell.lblRightUnderTitle.text=[[[[arrayHomeList objectAtIndex:indexPath.section] objectForKey:@"goods"] objectAtIndex:2] objectForKey:@"goods_name"];
            NSURL *urlRU=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",GOODS_IMG_URL,[[[[arrayHomeList objectAtIndex:indexPath.section] objectForKey:@"goods"] objectAtIndex:2] objectForKey:@"store_id"],[[[[arrayHomeList objectAtIndex:indexPath.section] objectForKey:@"goods"] objectAtIndex:2] objectForKey:@"goods_image"]]];
            [cell.imRightUnder setImageWithURL:urlRU placeholderImage:img(@"landou_square_default.png")];
            cell.lblRightUnderPrice.text=[NSString stringWithFormat:@"优惠价￥%@",[[[[arrayHomeList objectAtIndex:indexPath.section] objectForKey:@"goods"] objectAtIndex:2] objectForKey:@"goods_price"]];
            
        }
        if ([[[arrayHomeList objectAtIndex:indexPath.section] objectForKey:@"goods"]count]==2) {
            NSURL *urlLeft=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",GOODS_IMG_URL,[[[[arrayHomeList objectAtIndex:indexPath.section] objectForKey:@"goods"] objectAtIndex:0] objectForKey:@"store_id"],[[[[arrayHomeList objectAtIndex:indexPath.section] objectForKey:@"goods"] objectAtIndex:0] objectForKey:@"goods_image"]]];
            [cell.imLeft setImageWithURL:urlLeft placeholderImage:img(@"landou_square_default.png")];
            cell.lblLeftTitle.text=[[[[arrayHomeList objectAtIndex:indexPath.section] objectForKey:@"goods"] objectAtIndex:0] objectForKey:@"goods_name"];
            cell.lblLeftPrice.text=[NSString stringWithFormat:@"优惠价￥%@",[[[[arrayHomeList objectAtIndex:indexPath.section] objectForKey:@"goods"] objectAtIndex:0] objectForKey:@"goods_price"]];
            
            NSString *strTitleRT=[NSString stringWithFormat:@"<p2>%@</p2>",[[[[arrayHomeList objectAtIndex:indexPath.section] objectForKey:@"goods"] objectAtIndex:1] objectForKey:@"goods_name"]];
            NSAttributedString *RTtext = [[NSAttributedString alloc] initWithData:[strTitleRT dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            
            cell.lblRightTopTitle.attributedText=RTtext;
            //cell.lblRightTopTitle.text=[[[[arrayHomeList objectAtIndex:indexPath.section] objectForKey:@"goods"] objectAtIndex:1] objectForKey:@"goods_name"];
            NSURL *urlRT=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",GOODS_IMG_URL,[[[[arrayHomeList objectAtIndex:indexPath.section] objectForKey:@"goods"] objectAtIndex:1] objectForKey:@"store_id"],[[[[arrayHomeList objectAtIndex:indexPath.section] objectForKey:@"goods"] objectAtIndex:1] objectForKey:@"goods_image"]]];
            [cell.imRightTop setImageWithURL:urlRT placeholderImage:img(@"landou_square_default.png")];
            cell.lblRightTopPrice.text=[NSString stringWithFormat:@"优惠价￥%@",[[[[arrayHomeList objectAtIndex:indexPath.section] objectForKey:@"goods"] objectAtIndex:1] objectForKey:@"goods_price"]];
            
            
        }
        if ([[[arrayHomeList objectAtIndex:indexPath.section] objectForKey:@"goods"]count]==1) {
            NSURL *urlLeft=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",GOODS_IMG_URL,[[[[arrayHomeList objectAtIndex:indexPath.section] objectForKey:@"goods"] objectAtIndex:0] objectForKey:@"store_id"],[[[[arrayHomeList objectAtIndex:indexPath.section] objectForKey:@"goods"] objectAtIndex:0] objectForKey:@"goods_image"]]];
            [cell.imLeft setImageWithURL:urlLeft placeholderImage:img(@"landou_square_default.png")];
            cell.lblLeftTitle.text=[[[[arrayHomeList objectAtIndex:indexPath.section] objectForKey:@"goods"] objectAtIndex:0] objectForKey:@"goods_name"];
            cell.lblLeftPrice.text=[NSString stringWithFormat:@"优惠价￥%@",[[[[arrayHomeList objectAtIndex:indexPath.section] objectForKey:@"goods"] objectAtIndex:0] objectForKey:@"goods_price"]];
            
            
        }
    }
    
    [cell.btnLeft addTarget:self action:@selector(leftgotoDetail:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnRiUp addTarget:self action:@selector(rightUp:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnRiDowN addTarget:self action:@selector(rightDown:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
    
    
    
    
    
    // Configure the cell...
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 143;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(void)leftgotoDetail:(UIButton *)sender
{
    HomeCell * cell;
    if ([Toolkit isSystemIOS8]) {
        cell=  (HomeCell *)[[sender  superview]superview] ;
    }else{
        cell=  (HomeCell *)[[[sender superview] superview]superview];
    }
    NSIndexPath * path = [tableHome indexPathForCell:cell];
    NSLog(@"******%ld",(long)path.row);
    if ([[[arrayHomeList objectAtIndex:path.section] objectForKey:@"goods"]isKindOfClass:[NSArray class]]) {
        if ([[[arrayHomeList objectAtIndex:path.section] objectForKey:@"goods"]count]>0) {
            GoodDetailController *gooddetail=[[GoodDetailController alloc]init];
            gooddetail.goodsId=[[[[arrayHomeList objectAtIndex:path.section] objectForKey:@"goods"] objectAtIndex:0] objectForKey:@"goods_id"];
            [self.navigationController pushViewController:gooddetail animated:YES];
        }
    }
}
-(void)rightUp:(UIButton *)sender
{
    HomeCell * cell;
    if ([Toolkit isSystemIOS8]) {
        cell=  (HomeCell *)[[sender  superview]superview] ;
    }else{
        cell=  (HomeCell *)[[[sender superview] superview]superview];
    }
    NSIndexPath * path = [tableHome indexPathForCell:cell];
    NSLog(@"******%ld",(long)path.row);
    if ([[[arrayHomeList objectAtIndex:path.section] objectForKey:@"goods"]isKindOfClass:[NSArray class]]) {
        if ([[[arrayHomeList objectAtIndex:path.section] objectForKey:@"goods"]count]>1) {
            GoodDetailController *gooddetail=[[GoodDetailController alloc]init];
            gooddetail.goodsId=[[[[arrayHomeList objectAtIndex:path.section] objectForKey:@"goods"] objectAtIndex:1] objectForKey:@"goods_id"];
            [self.navigationController pushViewController:gooddetail animated:YES];
        }
    }
    
}
-(void)rightDown:(UIButton *)sender
{
    HomeCell * cell;
    if ([Toolkit isSystemIOS8]) {
        cell=  (HomeCell *)[[sender  superview]superview] ;
    }else{
        cell=  (HomeCell *)[[[sender superview] superview]superview];
    }
    NSIndexPath * path = [tableHome indexPathForCell:cell];
    NSLog(@"******%ld",(long)path.row);
    if ([[[arrayHomeList objectAtIndex:path.section] objectForKey:@"goods"]isKindOfClass:[NSArray class]]) {
        if ([[[arrayHomeList objectAtIndex:path.section] objectForKey:@"goods"]count]>1) {
            GoodDetailController *gooddetail=[[GoodDetailController alloc]init];
            gooddetail.goodsId=[[[[arrayHomeList objectAtIndex:path.section] objectForKey:@"goods"] objectAtIndex:2] objectForKey:@"goods_id"];
            [self.navigationController pushViewController:gooddetail animated:YES];
        }
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)snackFoodclick:(id)sender {
    GoodsListController *GoodsList=[[GoodsListController alloc]init];
    GoodsList.gcId=arrGcId[0];//@"3025";
    [self.navigationController pushViewController:GoodsList animated:YES];
}

- (IBAction)personwashclick:(id)sender {
    GoodsListController *GoodsList=[[GoodsListController alloc]init];
    GoodsList.gcId=arrGcId[1];//@"3035";
    [self.navigationController pushViewController:GoodsList animated:YES];
}

- (IBAction)drinkwineclick:(id)sender {
    GoodsListController *GoodsList=[[GoodsListController alloc]init];
    GoodsList.gcId=arrGcId[2];//@"3037";
    [self.navigationController pushViewController:GoodsList animated:YES];
}

- (IBAction)oilclick:(id)sender {
    GoodsListController *GoodsList=[[GoodsListController alloc]init];
    GoodsList.gcId=arrGcId[3];//@"3029";
    [self.navigationController pushViewController:GoodsList animated:YES];
}

- (IBAction)homecleanclick:(id)sender {
    GoodsListController *GoodsList=[[GoodsListController alloc]init];
    GoodsList.gcId=arrGcId[4];//@"3032";
    [self.navigationController pushViewController:GoodsList animated:YES];
}

- (IBAction)lifeuseclick:(id)sender {
    GoodsListController *GoodsList=[[GoodsListController alloc]init];
    GoodsList.gcId=arrGcId[5];//@"3036";
    [self.navigationController pushViewController:GoodsList animated:YES];
}

- (IBAction)household:(id)sender {
    GoodsListController *GoodsList=[[GoodsListController alloc]init];
    GoodsList.gcId=arrGcId[6];//@"3028";
    [self.navigationController pushViewController:GoodsList animated:YES];
}

- (IBAction)workgift:(id)sender {
    GoodsListController *GoodsList=[[GoodsListController alloc]init];
    GoodsList.gcId=arrGcId[7];//@"3031";
    [self.navigationController pushViewController:GoodsList animated:YES];
}
@end
