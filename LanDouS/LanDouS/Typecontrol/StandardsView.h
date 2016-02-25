//
//  StandardsView.h
//  LanDouS
//
//  Created by Wangjc on 16/2/23.
//  Copyright © 2016年 Mao-MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "StandardModel.h"


@protocol StandardsViewDataSource <NSObject>


@end
@class StandardsView;

@protocol StandardsViewDelegate <NSObject>

/**
 * 自定义btn点击事件
 */

-(void)StandardsViewCustomBtnClickAction:(UIButton *)sender;

/**
 * 设置自定义btn属性
 */
-(void)StandardsViewSetBtn:(UIButton *)btn andStandView:(StandardsView *)standardView;
/**
 * 为设置自定义按钮时，点击确认按键的回调事件
 */
-(void)StandardsSureBtnClick:(NSString *)content;
/**
 * 点击规格分类按键回调
 * @param sender 点击的按键
 * @param selectID 选中规格id
 * @param standName 规格名称
 * @param index  规格所在cell的row
 */
-(void)StandardsSelectBtnClick:(UIButton *)sender andSelectID:(NSString *)selectID andStandName:(NSString *)standName andIndex:(NSInteger)index;

@end

@interface StandardsView : UIView<UITextViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic)id<StandardsViewDelegate>delegate;
@property(nonatomic)id<StandardsViewDataSource>dataSource;

//商品简介view
@property(nonatomic) UIImageView *mainImgView;//商品图片
@property(nonatomic) UILabel *priceLab;//价格
@property(nonatomic) UILabel *goodNum;//数量
@property(nonatomic) UILabel *tipLab;//规格

@property(nonatomic) NSArray<NSString *> *customBtns;//自定义btn

/**
 * 规格数据
 */
@property(nonatomic) NSArray<StandardModel *>* standardArr;
/**
 * reload 内部的tableview(暂时没啥用处)
 */
- (void)standardsViewReload;
/**
 * 显示规格
 */
- (void)show;
/**
 * 关闭显示
 */
- (void)dismiss;
@end
