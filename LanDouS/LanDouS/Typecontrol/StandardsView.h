//
//  StandardsView.h
//  LanDouS
//
//  Created by Wangjc on 16/2/23.
//  Copyright © 2016年 Mao-MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "StandardModel.h"
@protocol StandardsViewDelegate <NSObject>

-(void)StandardsSureBtnClick:(NSString *)content;

-(void)StandardsSelectBtnClick:(UIButton *)sender andSelectID:(NSString *)selectID andStandName:(NSString *)standName;

-(void)StandTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath andCell:(UITableViewCell *)cell;
-(CGFloat)StandTableView:(UITableView *)tableView  heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface StandardsView : UIView<UITextViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic)UIImage *mainImg;
//@property(nonatomic)NSString *title;
//@property(nonatomic)NSString *content;
//@property(nonatomic)NSString *tip;
@property(nonatomic)id<StandardsViewDelegate>delegate;
@property(nonatomic) UIImageView *mainImgView;
@property(nonatomic) NSDictionary *specDict;
//商品简介lab
@property(nonatomic) UILabel *priceLab;
@property(nonatomic) UILabel *goodNum;
@property(nonatomic) UILabel *tipLab;//规格

/**
 * 规格数据
 */
@property(nonatomic) NSArray<StandardModel *>* standardArr;

- (void)standardsViewReload;
- (void)show;
@end
