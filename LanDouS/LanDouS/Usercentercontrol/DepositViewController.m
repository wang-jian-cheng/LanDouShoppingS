//
//  DepositViewController.m
//  LanDouS
//
//  Created by 王建成 on 15/12/1.
//  Copyright © 2015年 Mao-MacPro. All rights reserved.
//

#import "DepositViewController.h"

@interface DepositViewController ()
{
    SegmentedPageView *_taskPageSeg;
    
    UITableView *_tradeTabView;
    UITableView *_payTabView;
    UITableView *_getMoneyTabView;
    UITableView *_refundTabView;
    
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

#define PAYTAB_TAG      1
#define GETMONEY_TAG    2

-(void)initViews
{

    [self addLeftButton:@"whiteback@2x.png"];
    [self setBarTitle:@"预存款"];
    [self addRightButton:@"充值"];
    //_taskPageSeg 分页器  _tableViews存储所有页面
    _taskPageSeg = [[SegmentedPageView alloc] initWithFrame:CGRectMake(0, 64, [[UIScreen mainScreen]bounds].size.width, 44)];
   // _taskPageSeg.segType = SegTypeTitleOnly;//要在numOfPages之前设置
    _taskPageSeg.numOfPages = 4;
    _taskPageSeg.backgroundColor = [UIColor whiteColor];
    _taskPageSeg.titleFont = [UIFont boldSystemFontOfSize:14];
    
    NSArray *title = @[@"交易",@"充值",@"提现",@"退款"];
    _taskPageSeg.delegate = self;
    [_taskPageSeg setItemTitle:title];
    _cellCount = 3;
    _cellHeight = SCREEN_HEIGHT / 12;
    
    _tableViews = [NSMutableArray array];
    
    _tradeTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 44, self.view.frame.size.width, [[UIScreen mainScreen] bounds].size.height -44-64)];
    [self setPageIndexPath:_tradeTabView indexPage:0];
    [_tableViews addObject:_tradeTabView];
    
    _payTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 44, self.view.frame.size.width, [[UIScreen mainScreen] bounds].size.height -44-64)];
    [self setPageIndexPath:_payTabView indexPage:PAYTAB_TAG];
    [_tableViews addObject:_payTabView];
    
    _getMoneyTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 44, self.view.frame.size.width, [[UIScreen mainScreen] bounds].size.height -44-64)];
    [self setPageIndexPath:_getMoneyTabView indexPage:GETMONEY_TAG];
    [_tableViews addObject:_getMoneyTabView];
    
    _refundTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 44, self.view.frame.size.width, [[UIScreen mainScreen] bounds].size.height -44-64)];
    [self setPageIndexPath:_refundTabView indexPage:3];
    [_tableViews addObject:_refundTabView];
    
//    _tradeTabView.contentSize = CGSizeMake(self.view.frame.size.width, _cellCountMyTask*50);
//    _tradeTabView.contentSize = CGSizeMake(self.view.frame.size.width, _cellCountGetTask*50);
//    
   
    
    
    
    
    
    
    [_taskPageSeg setItemTitle:title];
    
    [self.view  addSubview:_taskPageSeg];
    [self.view  addSubview:_tradeTabView];
    [self.view  addSubview:_payTabView];
    [self.view  addSubview:_getMoneyTabView];
    [self.view  addSubview:_refundTabView];
    
    [_taskPageSeg setCurrentPage:0];//页面都设置完成后再调用
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
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
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
    if(_tableViews.count>0)
        [self.view bringSubviewToFront:[_tableViews objectAtIndex:page]];
}
#pragma mark -  tableview  Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    
    return _cellCount;
}

#pragma mark - setting for cell
//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, _cellHeight)];

    
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    return cell;
    
}

//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
    UIView *tempView = [[UIView alloc] init];
  
    

    return tempView;
    
}


//设置section header 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 0.5;
}
//设置section footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 1;
    
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
