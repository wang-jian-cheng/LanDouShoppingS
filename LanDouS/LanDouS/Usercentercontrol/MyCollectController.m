//
//  MyCollectController.m
//  LanDouS
//
//  Created by Mao-MacPro on 14/12/26.
//  Copyright (c) 2014年 Mao-MacPro. All rights reserved.
//

#import "MyCollectController.h"
#import "LPLabel.h"
#import "AppDelegate.h"
#import "MJRefresh.h"
#import "DataProvider.h"
#import "UIImageView+WebCache.h"
#import "ShopListCell.h"
#import "ShopInfoController.h"
#import "MJRefresh.h"
#import "ColGoodDetailCell.h"
#define KCellID @"ColGoodDetailCell"
#import "GoodDetailController.h"
@interface MyCollectController ()

@end

@implementation MyCollectController
@synthesize imLine,collectionGoods;
- (void)viewDidLoad {
    [super viewDidLoad];
    shopPage=1;
    shopPerpage=20;
    [self setBarTitle:@"我的收藏"];
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
//    image.image=[UIImage imageNamed:@"navgreen.png"];
//    [_topView addSubview:image];
//    _topView.backgroundColor=[UIColor colorWithRed:0.51 green:0.57 blue:0.29 alpha:1];
    _lblTitle.textColor=[UIColor whiteColor];
    [self addLeftButton:@"whiteback@2x.png"];
    
    arrayGoodsList=[[NSMutableArray alloc]init];
    [collectionGoods registerClass:[ColGoodDetailCell class] forCellWithReuseIdentifier:KCellID];
    [collectionGoods addHeaderWithTarget:self action:@selector(headerRereshing)];
    [collectionGoods addFooterWithTarget:self action:@selector(footerRereshing)];
    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longPressGr.minimumPressDuration = 1.0;
    [collectionGoods addGestureRecognizer:longPressGr];
    
    
    
    
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self headerRereshing];
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}
- (IBAction)goodsclick:(id)sender {
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
        
        imLine.frame=CGRectMake(32, 36, 97,2);
    } completion:^(BOOL finished) {
        
        
    }];
    
}

- (IBAction)shopclick:(id)sender {
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
        
        imLine.frame=CGRectMake(187, 36, 97,2);
    } completion:^(BOOL finished) {
        
        
    }];

}

- (void)headerRereshing
{
    shopPage=1;
    
    [self refreshShopList];
    
}

- (void)footerRereshing
{
    shopPage=shopPage+1;
    
    [self GetMoreShop];
}
-(void)refreshShopList
{
    [SVProgressHUD showWithStatus:@"正在加载"];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        NSLog(@"^^^^%@", resultDict );
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            if ([[resultDict objectForKey:@"list"]isKindOfClass:[NSArray class]]) {
                if ([[resultDict objectForKey:@"list"]count]>0) {
                    [arrayGoodsList removeAllObjects];
                    for (int i=0; i<[[resultDict objectForKey:@"list"]count]; i++) {
                        [arrayGoodsList addObject: [[resultDict objectForKey:@"list"]objectAtIndex:i ]];
                    }
                    
                }
                [collectionGoods reloadData];
                
            }
        }
        else{
            
        }
        [collectionGoods headerEndRefreshing];
        
        
    }];
    
    [dataProvider setFailedBlock:^(NSString *strError){
        [SVProgressHUD dismiss];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"检查网络！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [collectionGoods headerEndRefreshing];
    }];
    [dataProvider getFavoriteGoods:shopPage andPerPage:shopPerpage];
    //[dataProvider getStoreList:@"nothing" andPage:shopPage andPerpage:shopPerpage];
}
-(void)GetMoreShop
{
    
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        NSLog(@"^^^^%@", resultDict );
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            if ([[resultDict objectForKey:@"list"]isKindOfClass:[NSArray class]]) {
                if ([[resultDict objectForKey:@"list"]count]>0) {
                    for (int i=0; i<[[resultDict objectForKey:@"list"]count]; i++) {
                        [arrayGoodsList addObject: [[resultDict objectForKey:@"list"]objectAtIndex:i ]];
                    }
                    
                }
                [collectionGoods reloadData];
                
            }
        }
        else{
            
        }
        [collectionGoods footerEndRefreshing];
        
        
    }];
    
    [dataProvider setFailedBlock:^(NSString *strError){
        [SVProgressHUD dismiss];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"检查网络！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [collectionGoods footerEndRefreshing];
    }];
    
    [dataProvider getFavoriteGoods:shopPage andPerPage:shopPerpage];
}
-(void)delFavoriteGoods:(NSString *)goodsID
{
    
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        NSLog(@"^^^^%@", resultDict );
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            [Dialog simpleToast:@"取消收藏成功"];
            [self headerRereshing];
            
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
-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [gesture locationInView:collectionGoods];
        NSIndexPath * indexPath=[collectionGoods indexPathForItemAtPoint:point];
        //NSIndexPath * indexPath = [collectionGoods indexPathForRowAtPoint:point];
        if(indexPath == nil)
        {
           return ;
        }
//        NSLog(@"^^^^%d",indexPath.row);
        //add your code here
        
        
        indexid=indexPath.row;
        //chatuser= [showData objectAtIndex:indexPath.row];
        
        //collect_id=[[[list objectAtIndex:indexPath.row] objectForKey:@"shopid"] intValue];
        // NSLog(@"###collectid=%d",collect_id);
        
        
        
        
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"确认取消该收藏？"  delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        [alert setTag:1112];
        
    }
    //[recentTable reloadData];//zlk
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1112) {
        if (buttonIndex==1) {
            [self delFavoriteGoods:[[arrayGoodsList objectAtIndex:indexid] objectForKey:@"goods_id"]];
        }
    }
}

#pragma collectionViewdelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section

{
    
    // 每个Section的item个数
    
    return  arrayGoodsList.count;
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH/2-10,210);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath

{
    
    
    
    ColGoodDetailCell *cell = (ColGoodDetailCell *)[collectionView dequeueReusableCellWithReuseIdentifier:KCellID forIndexPath:indexPath];
    
    cell.backgroundColor=[UIColor whiteColor];
    
    // 图片的名称
    cell.lblGoodsDisc.text=[[arrayGoodsList objectAtIndex:indexPath.row] objectForKey:@"goods_name"];
    cell.lblGoodsPrice.text=[NSString stringWithFormat:@"￥%@",[[arrayGoodsList objectAtIndex:indexPath.row] objectForKey:@"goods_price"]];
    cell.lblGoodsBuyed.text=[NSString stringWithFormat:@"%@人已购买",[[arrayGoodsList objectAtIndex:indexPath.row] objectForKey:@"goods_salenum"]];
     NSURL *URL=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",GOODS_IMG_URL,[[arrayGoodsList objectAtIndex:indexPath.row] objectForKey:@"store_id"],[[arrayGoodsList objectAtIndex:indexPath.row] objectForKey:@"goods_image"]]];
    [cell.imgGood setImageWithURL:URL placeholderImage:img(@"landou_square_default.png")];
    
    
    
    
    
    return cell;
    
    
    
}





-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoodDetailController *GoodDetail=[[GoodDetailController alloc]init];
    GoodDetail.goodsId=[[arrayGoodsList objectAtIndex:indexPath.row] objectForKey:@"goods_id"];
    [self.navigationController pushViewController:GoodDetail animated:YES];
    
    
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
