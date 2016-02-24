//
//  StandardsView.m
//  LanDouS
//
//  Created by Wangjc on 16/2/23.
//  Copyright © 2016年 Mao-MacPro. All rights reserved.
//

#import "StandardsView.h"


#define ViewHeight  (SCREEN_HEIGHT/3*2)
#define ViewWidth   (SCREEN_WIDTH)

#define GapToLeft   20

#define ItemsBaseColor  [UIColor whiteColor]

@interface StandardsView ()
{
//    UILabel *tipLab;
//    UILabel *titleLab;
//    UILabel *contentLab;
    
    CGFloat _cellHeight;
    NSInteger _cellNum;
    
    UIButton *cancelBtn;
    UIButton *sureBtn;
    
    UIView *coverView;
    UIView *showView;
    
}
@property(nonatomic) UITableView *mainTableView;
@property (nonatomic) NSMutableArray *standardBtnArr;
//@property(nonatomic)UITextView *contentTextView;
//@property(nonatomic)UILabel *holderLab;

@end


@implementation StandardsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)init{
    self = [super init];
    if (self) {
        
        [self buildViews];
        
    }
    return self;
}


-(void)buildViews
{

    self.frame = [self screenBounds];
    coverView =  [[UIView alloc]initWithFrame:[self topView].bounds];
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha = 0;
    coverView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [[self topView] addSubview:coverView];
    
    showView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight)];
    showView.center = CGPointMake(self.frame.size.width/2, (SCREEN_HEIGHT - ViewHeight)+ViewHeight/2);
    showView.layer.masksToBounds = YES;
    showView.layer.cornerRadius = 5;
    showView.backgroundColor = [UIColor whiteColor];
    [self addSubview:showView];
    
    
    

//    tipLab = [[UILabel alloc] initWithFrame:CGRectMake(GapToLeft, 0, ViewWidth - GapToLeft*2, 50)];
//    tipLab.text = self.tip;
//    tipLab.textColor = [UIColor whiteColor];
//    tipLab.font = [UIFont boldSystemFontOfSize:16];
//    
//    [showView addSubview:tipLab];
    
    self.mainImgView = [[UIImageView alloc] initWithFrame:CGRectMake(GapToLeft,
                                                                     0,
                                                                     100, 100)];
    self.mainImgView.layer.cornerRadius = 5;
    self.mainImgView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.mainImgView.layer.borderWidth = 3;
    
    self.mainImgView.image = self.mainImg;
    self.mainImgView.center = CGPointMake(80, showView.frame.origin.y+self.mainImgView.frame.size.height/3);
    self.mainImgView.image = [UIImage imageNamed:@"landou_square_default.png"];
    
    self.mainImgView.contentMode = UIViewContentModeScaleAspectFit;
//    self.mainImgView.alpha = 0;
    [self addSubview:self.mainImgView];
//    
//    titleLab = [[UILabel alloc] initWithFrame:CGRectMake(self.mainImgView.frame.size.width+self.mainImgView.frame.origin.x+10,
//                                                         self.mainImgView.frame.origin.y,
//                                                         ViewWidth - (self.mainImgView.frame.size.width+self.mainImgView.frame.origin.x) - GapToLeft,
//                                                         self.mainImgView.frame.size.height/4)];
//    
//    
//    
//    titleLab.textColor = [UIColor whiteColor];
//    titleLab.text = self.title;
//    titleLab.font = [UIFont systemFontOfSize:14];
//    [showView addSubview:titleLab];
//    
//    contentLab = [[UILabel alloc] initWithFrame:CGRectMake(titleLab.frame.origin.x,
//                                                           titleLab.frame.origin.y+titleLab.frame.size.height,
//                                                           titleLab.frame.size.width,
//                                                           self.mainImgView.frame.size.height/4*3)];
//    contentLab.numberOfLines = 0;
//    contentLab.font = [UIFont systemFontOfSize:14];
//    contentLab.text = self.content;
//    contentLab.textColor = [UIColor whiteColor];
//    [showView addSubview:contentLab];
//    
//    
    
    cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, ViewHeight-44, ViewWidth/2, 44)];
    cancelBtn.tag = 1000 + 1;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.backgroundColor = ItemsBaseColor;
    [cancelBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [showView addSubview:cancelBtn];
    
    
    sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(ViewWidth/2, ViewHeight-44, ViewWidth/2, 44)];
    sureBtn.tag = 1000 + 2;
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    sureBtn.backgroundColor = ItemsBaseColor;
    [sureBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [showView addSubview:sureBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(cancelBtn.frame.size.width, cancelBtn.frame.origin.y, 1, cancelBtn.frame.size.height)];
    lineView.backgroundColor = BACKGROUND_COLOR;
    [showView addSubview:lineView];
    
//    self.contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, sureBtn.frame.origin.y - 40 -10,
//                                                                        ViewWidth - 20*2,
//                                                                        40)];
//    
//    self.contentTextView.delegate = self;
//    self.contentTextView.backgroundColor = [UIColor grayColor];
//    self.contentTextView.font = [UIFont systemFontOfSize:14];
//    [showView addSubview:self.contentTextView];
//    
//    self.holderLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.contentTextView.frame.size.width,self.contentTextView.frame.size.height)];
//    self.holderLab.text = @"来，讲两句！";
//    self.holderLab.font = [UIFont systemFontOfSize:14];
//    [self.contentTextView addSubview:self.holderLab];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAction:) ];
    [self addGestureRecognizer:tapGesture];
    
    
    self.goodNum = [[UILabel alloc] init];
    self.priceLab = [[UILabel alloc] init];
    self.tipLab = [[UILabel alloc] init];
    
    [self initTableView];
    
}


-(void) initTableView
{
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    
    self.priceLab.frame = CGRectMake(self.mainImgView.frame.size.width+self.mainImgView.frame.origin.x+10,
                                     0,
                                     (SCREEN_WIDTH - (self.mainImgView.frame.size.width+self.mainImgView.frame.origin.x) - 10),
                                     30);
    
    self.priceLab.textColor = [UIColor redColor];
    self.priceLab.font = [UIFont systemFontOfSize:14];
    self.priceLab.text =@"价格";// [NSString stringWithFormat:@"¥%@-%@",dicGoodsDetail[@"goods_price"],self.dictStandard[@"goods_marketprice"]];
    
    [tempView addSubview:self.priceLab];
    
    
    self.goodNum.frame =CGRectMake(self.priceLab.frame.origin.x,
                                   self.priceLab.frame.origin.y+self.priceLab.frame.size.height,
                                   self.priceLab.frame.size.width, 30);
    self.goodNum.textColor = [UIColor blackColor];
    self.goodNum.font = [UIFont systemFontOfSize:14];
    self.goodNum.text =@"库存";// [NSString stringWithFormat:@"库存%@件",dicGoodsDetail[@"goods_storage"]];
    [tempView addSubview:self.goodNum];
    
    
    self.tipLab.frame = CGRectMake(self.goodNum.frame.origin.x,
                                   self.goodNum.frame.origin.y+self.goodNum.frame.size.height,
                                   self.goodNum.frame.size.width, 30);
    self.tipLab.textColor = [UIColor blackColor];
    self.tipLab.font = [UIFont systemFontOfSize:14];
    
    NSString *str = @"请选择 ";
    //    NSArray *tempArr = dicGoodsDetail[@"spec_name"];
    //
    //    for (int i = 0; i<tempArr.count; i++) {
    //        str = [NSString stringWithFormat:@"%@%@ ",str,tempArr[i][@"name"]];
    //    }
    
    self.tipLab.text = str;
    [tempView addSubview:self.tipLab];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, tempView.frame.size.height-1, SCREEN_WIDTH - 20, 0.5)];
    lineView.backgroundColor = [UIColor grayColor];
    [tempView addSubview:lineView];
    
    [showView addSubview:tempView];
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, tempView.frame.size.height, ViewWidth,ViewHeight - sureBtn.frame.size.height - tempView.frame.size.height )];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.separatorColor =  [UIColor grayColor];
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _mainTableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
    _mainTableView.tableFooterView = [[UIView alloc] init];
    
    _cellHeight = _mainTableView.frame.size.height/2;
    [showView addSubview:_mainTableView];
}

#pragma mark - self property

-(void)setMainImg:(UIImage *)mainImg
{
    _mainImg = mainImg;
    self.mainImgView.image = _mainImg;
}

-(void)setStandardArr:(NSArray<StandardModel *> *)standardArr
{
    _standardArr = standardArr;
    
    [_mainTableView reloadData];
}


-(NSMutableArray *)standardBtnArr
{
    if(_standardBtnArr == nil)
    {
        _standardBtnArr = [NSMutableArray array];
    }
    
    return _standardBtnArr;
}

-(void)tapViewAction:(id)sender
{
    [self endEditing:YES];
}

- (CGRect)screenBounds
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    // On iOS7, screen width and height doesn't automatically follow orientation
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
            CGFloat tmp = screenWidth;
            screenWidth = screenHeight;
            screenHeight = tmp;
        }
    }
    
    return CGRectMake(0, 0, screenWidth, screenHeight);
}

#pragma mark - clicks

-(void)standardBtnClick:(UIButton *)sender
{
    sender.backgroundColor = [UIColor orangeColor];
    
    NSArray *tempArr = self.standardBtnArr[(sender.tag & 0x0000ffff)/100 ];
    
    for (UIButton *tempBtn in tempArr) {
        if(tempBtn.tag == sender.tag)
        {
            continue;
        }
        
        tempBtn.backgroundColor = [UIColor whiteColor];
    }
    NSString *tagStr = [NSString stringWithFormat:@"%ld",(sender.tag & 0xffff0000)>>16];
    
    if([self.delegate respondsToSelector:@selector(StandardsSelectBtnClick:andSelectID:andStandName:)])
    {
        [self.delegate StandardsSelectBtnClick:sender andSelectID:tagStr andStandName:self.standardArr[(sender.tag & 0x0000ffff)/100].standardName];
    }

}


-(void)clickAction:(UIButton *)sender
{
    if(sender == sureBtn)
    {
        sureBtn.backgroundColor = [UIColor yellowColor];
        cancelBtn.backgroundColor = ItemsBaseColor;
        
        if([self.delegate respondsToSelector:@selector(StandardsSureBtnClick:)])
        {
            [self.delegate StandardsSureBtnClick:@""];
        }
        
    }
    else if(sender == cancelBtn)
    {
        cancelBtn.backgroundColor = [UIColor yellowColor];
        sureBtn.backgroundColor = ItemsBaseColor;
    }
    
    [self dismiss];
}

-(UIView*)topView{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    return  window.subviews[0];
}

- (void)show {
    [UIView animateWithDuration:0.5 animations:^{
        coverView.alpha = 0.5;
        
    } completion:^(BOOL finished) {
        
    }];
    
    [[self topView] addSubview:self];
    [self showAnimation];
//    self.mainImgView.alpha = 1.0;
}

- (void)dismiss {
    [self hideAnimation];
    [self endEditing:YES];
}

- (void)showAnimation {
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [showView.layer addAnimation:popAnimation forKey:nil];
    [self.mainImgView.layer addAnimation:popAnimation forKey:nil];
}

- (void)hideAnimation{
    [UIView animateWithDuration:0.5 animations:^{
        coverView.alpha = 0.0;
        showView.alpha = 0.0;
        self.mainImgView.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
    
}

#pragma mark - self tools
-(CGFloat)WidthWithString:(NSString*)string fontSize:(CGFloat)fontSize height:(CGFloat)height
{
    NSDictionary *attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    return  [string boundingRectWithSize:CGSizeMake(0, height) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size.width;
}

#pragma mark - api for custom
-(void)standardsViewReload
{
    if(_mainTableView!=nil)
    {
        [_mainTableView reloadData];
    }
}


#pragma mark -  tableview  Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
    
}

#pragma mark - setting for cell

#define ViewsGaptoLine 20
//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight)];
    
    if(self.standardArr == nil || self.standardArr.count == 0 || self.standardArr.count -1 < indexPath.row)
        return cell;
    
    @try {
        
        StandardModel *standardModel = self.standardArr[indexPath.row];
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH, 30)];
        titleLab.text = standardModel.standardName;//  dicGoodsDetail[@"spec_name"][indexPath.row ][@"name"];
        titleLab.textColor = [UIColor blackColor];
        titleLab.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:titleLab];
        
        CGFloat oneLineBtnWidtnLimit = 300;//每行btn占的最长长度，超出则换行
        CGFloat btnGap = 10;//btn的x间距
        CGFloat btnGapY = 10;
        NSInteger BtnlineNum = 0;
        CGFloat BtnHeight = 30;
        CGFloat minBtnLength =  50;//每个btn的最小长度
        CGFloat maxBtnLength = oneLineBtnWidtnLimit - btnGap*2;//每个btn的最大长度
        CGFloat Btnx ;//每个btn的起始位置
        Btnx += btnGap;
        
//        NSString *strID = [NSString stringWithFormat:@"%@",dicGoodsDetail[@"spec_name"][indexPath.row][@"id"]];
        NSArray<standardClassInfo *> *specArr = standardModel.standardClassInfo;
        
        NSMutableArray *tempArr = [NSMutableArray array];
        
        for (int i = 0; i < specArr.count; i++) {
            NSString *str = specArr[i].standardClassName ;
            CGFloat btnWidth = [self WidthWithString:str fontSize:14 height:BtnHeight];
            btnWidth += 20;//让文字两端留出间距
            
            if(btnWidth<minBtnLength)
                btnWidth = minBtnLength;
            
            if(btnWidth>maxBtnLength)
                btnWidth = maxBtnLength;
            
            
            if(Btnx + btnWidth > oneLineBtnWidtnLimit)
            {
                BtnlineNum ++;//长度超出换到下一行
                Btnx = btnGap;
            }
            
            
            UIButton *btn = [[UIButton alloc] init];
            btn.frame = CGRectMake(Btnx, titleLab.frame.size.height+titleLab.frame.origin.x + (BtnlineNum*(BtnHeight+btnGapY)),
                                   btnWidth,BtnHeight );
            [btn setTitle:str forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor whiteColor];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.layer.cornerRadius = 5;
            btn.layer.borderWidth = 0.5;
            btn.layer.borderColor = [[UIColor grayColor] CGColor];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn addTarget:self action:@selector(standardBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            
            btn.tag = indexPath.row*100 + i/*低16位*/ | ([specArr[i].standardClassId intValue] << 16) /*高16位*/;
            
            
            [tempArr addObject:btn];
            
            Btnx = btn.frame.origin.x + btn.frame.size.width + btnGap;
            [cell.contentView addSubview:btn];
            
            
        }
        
        [self.standardBtnArr addObject:tempArr];
//        if([self.delegate respondsToSelector:@selector(StandTableView:cellForRowAtIndexPath:andCell:)])
//        {
//            [self.delegate StandTableView:tableView cellForRowAtIndexPath:indexPath andCell:cell];
//        }
//        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
         return cell;
    }
    
}

//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([self.delegate respondsToSelector:@selector(StandTableView:heightForRowAtIndexPath:)])
    {
        CGFloat temp = [self.delegate StandTableView:tableView heightForRowAtIndexPath:indexPath];
        
        if (temp == 0) {
            return _cellHeight;
        }
        else
        {
            return temp;
        }
    }
    
    return _cellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    NSLog(@"click cell section : %ld row : %ld",(long)indexPath.section,(long)indexPath.row);
    
    
}


//设置划动cell是否出现del按钮，可供删除数据里进行处理

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NO;
}

- (UITableViewCellEditingStyle)tableView: (UITableView *)tableView editingStyleForRowAtIndexPath: (NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  @"删除";
}

//设置选中的行所执行的动作

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return indexPath;
    
}

#pragma mark - setting for section
//设置section的header view

#define SectionHeight  0

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tempView = [[UIView alloc] init];
    
   
    
    return tempView;
}

//设置section header 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

//设置section footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
    
}


@end
