//
//  DepositViewController.m
//  LanDouS
//
//  Created by 王建成 on 15/12/1.
//  Copyright © 2015年 Mao-MacPro. All rights reserved.
//

#import "DepositViewController.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
@interface DepositViewController ()
{
    SegmentedPageView *_taskPageSeg;
//    
//    UITableView *_tradeTabView;
//    UITableView *_payTabView;
//    UITableView *_getMoneyTabView;
//    UITableView *_refundTabView;
    
    
    UITableView *_mainTableView;
    NSInteger pageIndex;
    CGFloat _cellHeight;
    NSInteger _cellCount;
}
@end

@implementation DepositViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self initViews];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

#define PAYTAB_TAG      1
#define GETMONEY_TAG    2



#define JiaoYiTag   0
#define ChongZhi    1
#define TiXian      2
#define TuiKuan     3



-(void)initViews
{

    [self addLeftButton:@"whiteback@2x.png"];
    [self setBarTitle:@"预存款"];
    _lblTitle.textColor = [UIColor whiteColor];
    [self addRightButton:@"充值"];
    //_taskPageSeg 分页器  _tableViews存储所有页面
    _taskPageSeg = [[SegmentedPageView alloc] initWithFrame:CGRectMake(0, 64, [[UIScreen mainScreen]bounds].size.width, 44)];
   // _taskPageSeg.segType = SegTypeTitleOnly;//要在numOfPages之前设置
    _taskPageSeg.numOfPages = 4;
    _taskPageSeg.backgroundColor = [UIColor whiteColor];
    _taskPageSeg.titleFont = [UIFont boldSystemFontOfSize:14];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _taskPageSeg.frame.size.height - 3, SCREEN_WIDTH, 3)];
    lineView.backgroundColor  = [UIColor colorWithRed:177/255.0 green:178/255.0 blue:176/255.0 alpha:1.0];
    [_taskPageSeg addSubview:lineView];
    [_taskPageSeg sendSubviewToBack:lineView];
    NSArray *title = @[@"交易",@"充值",@"提现",@"退款"];
    _taskPageSeg.delegate = self;
    [_taskPageSeg setItemTitle:title];
    _cellCount = 3;
    _cellHeight = SCREEN_HEIGHT / 11;
    

    [_taskPageSeg setItemTitle:title];
    
    [self.view  addSubview:_taskPageSeg];
//    [self.view  addSubview:_tradeTabView];
//    [self.view  addSubview:_payTabView];
//    [self.view  addSubview:_getMoneyTabView];
//    [self.view  addSubview:_refundTabView];
//
    
    
    [self initTableView];
    
    [_taskPageSeg setCurrentPage:0];//页面都设置完成后再调用
}


-(void)initTableView
{
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 44, SCREEN_WIDTH, SCREEN_HEIGHT -44-64 - TabBar_HEIGHT)];
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;//UITableViewCellSeparatorStyleSingleLine;
    _mainTableView.separatorInset = UIEdgeInsetsZero;
//    _mainTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    // tableView.separatorColor =  [UIColor colorWithRed:189/255.0 green:170/255.0 blue:152/255.0 alpha:1.0];
    _mainTableView.tableFooterView = [[UIView alloc] init];
    //设置cell分割线从最左边开始
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
    {
        if ([_mainTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_mainTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        }
        
        if ([_mainTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_mainTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        }
    }
    
    
    [_mainTableView addHeaderWithTarget:self action:@selector(headerRereshing)];

    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [_mainTableView addFooterWithTarget:self action:@selector(footerRereshing)];
    

    [self.view addSubview:_mainTableView];
}

-(void)headerRereshing
{
    [_mainTableView headerEndRefreshing];
}

-(void)footerRereshing
{
    [_mainTableView headerEndRefreshing];
}

-(void) setPageIndexPath:(UITableView *) tableView indexPage:(NSInteger)page
{
    
    //   UITableView *sendTaskView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    tableView.tag = page;
    UIView *tempView = [[UIView alloc] init];
    switch (tableView.tag) {
        case PAYTAB_TAG:
        {
            tempView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight);
            UIButton *tempBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 100)/2, 5, 100, _cellHeight-10)];
            tempBtn.backgroundColor = [UIColor redColor];
            [tempBtn setTitle:@"充值" forState:UIControlStateNormal];
            [tempView addSubview:tempBtn];
            tableView.tableHeaderView = tempView;
        }
            break;
        case GETMONEY_TAG:
        {
            tempView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight);
            UIButton *tempBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 100)/2, 5, 100, _cellHeight-10)];
            tempBtn.backgroundColor = [UIColor redColor];
            [tempBtn setTitle:@"提现" forState:UIControlStateNormal];
            [tempView addSubview:tempBtn];
            tableView.tableHeaderView = tempView;
        }
            break;
        default:
            
            break;
    }
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;//UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorInset = UIEdgeInsetsZero;
//    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
   // tableView.separatorColor =  [UIColor colorWithRed:189/255.0 green:170/255.0 blue:152/255.0 alpha:1.0];
    tableView.tableFooterView = [[UIView alloc] init];
    //设置cell分割线从最左边开始
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
    {
        if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        }
        
        if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        }
    }
}


-(void)setPageIndex:(NSInteger)page
{
    pageIndex = page;
    [_mainTableView reloadData];
    
}
#pragma mark -  tableview  Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
    
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    if(section == 0)
        return 1;
    else
    {
        return _cellCount;
    }
}

#pragma mark - setting for cell

#define GapToLeft    10
//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, _cellHeight)];

    
    if(indexPath.section == 0)
    {
        
        cell.selectionStyle  = UITableViewCellSelectionStyleNone;
        UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake(GapToLeft, 10, SCREEN_WIDTH, 30)];
        tipLab.text = @"当前余额";
        tipLab.textColor = [UIColor grayColor];
        tipLab.font = [UIFont systemFontOfSize:17];
        [cell.contentView addSubview:tipLab];
        
        UILabel *moneyLab = [[UILabel alloc] initWithFrame:CGRectMake(GapToLeft, 40, SCREEN_WIDTH, _cellHeight+(_cellHeight -60))];
        
        moneyLab.textColor = [UIColor orangeColor];
        moneyLab.font = [UIFont systemFontOfSize:33];
        moneyLab.text = @"0.0元";
        [cell.contentView addSubview:moneyLab];
        
        
        UIButton *getMoneyBtn = [[UIButton alloc] initWithFrame:CGRectMake(GapToLeft, _cellHeight*2 - 10, (SCREEN_WIDTH  - GapToLeft*3)/2, _cellHeight )];
        
        getMoneyBtn.backgroundColor = [UIColor colorWithRed:0 green:183/255.0 blue:238/255.0 alpha:1.0];
        [getMoneyBtn setTitle:@"提现" forState:UIControlStateNormal];
        
        [cell.contentView addSubview:getMoneyBtn];
        
        UIButton *saveMoneyBtn = [[UIButton alloc] initWithFrame:CGRectMake((getMoneyBtn.frame.origin.x + getMoneyBtn.frame.size.width+10),
                                                                           getMoneyBtn.frame.origin.y,
                                                                           getMoneyBtn.frame.size.width,
                                                                            getMoneyBtn.frame.size.height)];
        
        saveMoneyBtn.backgroundColor = [UIColor colorWithRed:50/255.0 green:177/255.0 blue:108/255.0 alpha:1.0];
        [saveMoneyBtn setTitle:@"充值" forState:UIControlStateNormal];
        [cell.contentView addSubview:saveMoneyBtn];
        
        
    }
    else
    {
        
        if (indexPath.row == 0) {
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            switch (pageIndex) {
                case JiaoYiTag:
                    cell.textLabel.text = @"交易明细";
                    break;
                case ChongZhi:
                    cell.textLabel.text = @"充值明细";
                    break;
                case TiXian:
                    cell.textLabel.text = @"提现明细";
                    break;
                case TuiKuan:
                    cell.textLabel.text = @"退款明细";
                    break;
                default:
                    break;
            }
            
        }
        else
        {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(GapToLeft, 5, _cellHeight -10 , _cellHeight - 10)];
            [cell.contentView addSubview:imgView];
            
            UILabel *dealLab = [[UILabel alloc] initWithFrame:CGRectMake(imgView.frame.size.width+imgView.frame.origin.x + 10,
                                                                        imgView.frame.origin.y,
                                                                        (SCREEN_WIDTH - (imgView.frame.size.width+imgView.frame.origin.x + 10))/2,
                                                                         imgView.frame.size.height/2)];
            
            
            dealLab.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:dealLab];
            
            UILabel *countLab = [[UILabel alloc] initWithFrame:CGRectMake(dealLab.frame.origin.x+dealLab.frame.size.width,
                                                                         (dealLab.frame.origin.y),
                                                                         (SCREEN_WIDTH - (dealLab.frame.origin.x+dealLab.frame.size.width) - 10),
                                                                          dealLab.frame.size.height)];
            countLab.font = [UIFont systemFontOfSize:14];
            countLab.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:countLab];
            
            UILabel *dateLab = [[UILabel alloc] initWithFrame:CGRectMake(dealLab.frame.origin.x,
                                                                        dealLab.frame.origin.y + dealLab.frame.size.height,
                                                                        dealLab.frame.size.width,
                                                                        dealLab.frame.size.height)];
            dateLab.font = [UIFont systemFontOfSize:14];
            dateLab.textColor = [UIColor grayColor];
            [cell.contentView addSubview:dateLab];
            
            
            UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake(dateLab.frame.origin.x + dateLab.frame.size.width,
                                                                         dateLab.frame.origin.y ,
                                                                         countLab.frame.size.width,
                                                                         dateLab.frame.size.height)];
            tipLab.font = [UIFont systemFontOfSize:14];
            tipLab.text = @"操作成功";
            tipLab.textAlignment = NSTextAlignmentRight;
            tipLab.textColor = [UIColor grayColor];
            [cell.contentView addSubview:tipLab];
            
            switch (pageIndex) {
                case JiaoYiTag:
                    {
                        imgView.image = [UIImage imageNamed:@"58"];
                        dealLab.text = @"吃饭";
                        countLab.text = @"-7.50";
                        dateLab.text = @"03-20 14:30";
                    }
                    break;
                case ChongZhi:
                    {
                        imgView.image = [UIImage imageNamed:@"58"];
                        dealLab.text = @"充值";
                        countLab.text = @"+7.50";
                        dateLab.text = @"03-20 14:30";
                    }
                    
                    break;
                case TiXian:
                    {
                        imgView.image = [UIImage imageNamed:@"58"];
                        dealLab.text = @"提现";
                        countLab.text = @"-7.50";
                        dateLab.text = @"03-20 14:30";
                    }
                    break;
                case TuiKuan:
                    {
                        imgView.image = [UIImage imageNamed:@"58"];
                        dealLab.text = @"退款";
                        countLab.text = @"+7.50";
                        dateLab.text = @"03-20 14:30";
                    }
                    break;
                default:
                    break;
            }
        }
    }
    
    
    
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    return cell;
    
}

//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if(indexPath.section == 0)
    {
        return _cellHeight *3;
    }
    else if (indexPath.row == 0)
    {
        return _cellHeight/2;
    }
    return _cellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    NSLog(@"click cell section : %ld row : %ld",(long)indexPath.section,(long)indexPath.row);

}


- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor); CGContextFillRect(context, rect); //上分割线，
    
    CGContextSetStrokeColorWithColor(context, [UIColor yellowColor].CGColor);
    CGContextStrokeRect(context, CGRectMake(5, -1, rect.size.width - 10, 1)); //下分割线
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextStrokeRect(context, CGRectMake(5, 10, 100, 10));
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
    NSMutableArray *numberRowOfCellArray = [NSMutableArray array] ;
    [numberRowOfCellArray addObject:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    NSLog(@"点击了删除  Section  = %ld Row =%ld",(long)indexPath.section,(long)indexPath.row);
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //        [_mainTableView.cell.infoItems removeObjectAtIndex:(indexPath.row*2)];
        //        [_mainTableView.cell.infoItems removeObjectAtIndex:(indexPath.row*2)];
        //        [_mainTableView beginUpdates];
        //        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
        //        [_mainTableView endUpdates];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
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

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tempView = [[UIView alloc] init];
    
   
    tempView.backgroundColor = [UIColor grayColor];
    return tempView;
}

//设置section的footer view
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    if(section== 0)
    {
        UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        tempView.backgroundColor = [UIColor colorWithRed:177/255.0 green:178/255.0 blue:176/255.0 alpha:1.0];
        return tempView;
    }
    else
    {
        UIView *tempView = [[UIView alloc] init];
        return tempView;
    }
}


//设置section header 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 0;
}
//设置section footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 0) {
        return 10;
    }
    
    return 0;
    
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

@end
