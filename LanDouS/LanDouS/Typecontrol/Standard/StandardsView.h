//
//  StandardsView.h
//  LanDouS
//
//  Created by Wangjc on 16/2/23.
//  Copyright © 2016年 Mao-MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "StandardModel.h"

#ifndef SCREEN_WIDTH
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#endif

#ifndef SCREEN_HEIGHT
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#endif


#define StandardViewHeight  (SCREEN_HEIGHT/4*3)//View 高度
#define StandardViewWidth   (SCREEN_WIDTH)  // view宽度


@protocol StandardsViewDataSource <NSObject>


@end
@class StandardsView;

@protocol StandardsViewDelegate <NSObject>

/**
 * 自定义btn点击事件
 */

-(void)StandardsView:(StandardsView *)standardView CustomBtnClickAction:(UIButton *)sender;

/**
 * 设置自定义btn属性
 */
-(void)StandardsView:(StandardsView *)standardView SetBtn:(UIButton *)btn andStandView:(StandardsView *)standardView;
/**
 * 为设置自定义按钮时，点击确认按键的回调事件
 */
-(void)Standards:(StandardsView *)standardView SureBtnClick:(NSString *)content;
/**
 * 点击规格分类按键回调
 * @param sender 点击的按键
 * @param selectID 选中规格id
 * @param standName 规格名称
 * @param index  规格所在cell的row
 */
-(void)Standards:(StandardsView *)standardView SelectBtnClick:(UIButton *)sender andSelectID:(NSString *)selectID andStandName:(NSString *)standName andIndex:(NSInteger)index;



/**
 * 自定义出场动画 StandsBackViewAnimationType 需设置成StandsViewAnimationCustom
 */
-(void)CustomShowAnimation;
/**
 * 自定义消失动画 StandsBackViewAnimationType 需设置成StandsViewAnimationCustom
 */
-(void)CustomDismissAnimation;
@end





//出场动画
typedef enum _StandsViewShowAnimationType
{
    StandsViewShowAnimationShowFrombelow ,//从下面
    StandsViewShowAnimationFlash,//闪出
    StandsViewShowAnimationCustom = 0xFFFF // 自定义

} StandsViewShowAnimationType;

//退场动画
typedef enum _StandsViewAnimationType
{
    StandsViewDismissAnimationDisFrombelow,//从下面退出
    StandsViewDismissAnimationFlash,//逐渐消失
    
    StandsViewDismissAnimationCustom = 0xFFFF // 自定义
    
} StandsViewDismissAnimationType;








@interface StandardsView : UIView<UITextViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic)id<StandardsViewDelegate>delegate;
@property(nonatomic)id<StandardsViewDataSource>dataSource;
#pragma mark - 必要条件
//商品简介view
@property(nonatomic) UIImageView *mainImgView;//商品图片
@property(nonatomic) UILabel *priceLab;//价格
@property(nonatomic) UILabel *goodNum;//库存数量
@property(nonatomic) UILabel *tipLab;//规格
@property(nonatomic) NSInteger buyNum;//购买数量 read － write(初始值)

/**
 * 自定义btn  原始btn功能有限 必需使用自定义btn 可使用代理方法
 * -(void)StandardsViewSetBtn:(UIButton *)btn andStandView:(StandardsView *)standardView; 去设置btn的属性
 */
@property(nonatomic) NSArray<NSString *> *customBtns;
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

#pragma mark - 非必需 效果相关

@property (nonatomic) UIView *GoodDetailView;//商品详情页 设置该属性调用show会自带商品详情页后移动画
@property (nonatomic) StandsViewShowAnimationType showAnimationType;
@property (nonatomic) StandsViewDismissAnimationType dismissAnimationType;

#pragma mark - animation
/**
 * 将商品图片抛到指定点
 * @param destPoint  扔到的点
 * @param height  高度，抛物线最高点比起点/终点y坐标最低(即高度最高)所超出的高度
 * @param duration  动画时间 传0  默认1.6s
 * @param Scale  view 变小的比例 传0  默认20
 */
-(void)ThrowGoodTo:(CGPoint)destPoint andDuration:(NSTimeInterval)duration andHeight:(CGFloat)height andScale:(CGFloat)Scale;
/**
 * 按比例改变view的大小
 * @param backView  要改变的view
 * @param duration  动画时间
 * @param valuex  x缩小的比例
 * @param valueY  y缩小的比例
 */
-(void)setBackViewAnimationScale:(UIView *)backView andDuration:(NSTimeInterval)duration toValueX:(CGFloat)valueX andValueY:(CGFloat)valueY;


@end
