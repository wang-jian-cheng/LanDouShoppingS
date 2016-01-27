//
//  ExpressDetailViewController.m
//  LanDouS
//
//  Created by 王建成 on 15/12/2.
//  Copyright © 2015年 Mao-MacPro. All rights reserved.
//

#import "ExpressDetailViewController.h"

@interface ExpressDetailViewController ()
{
    CGFloat _cellHeight;
    NSInteger _cellCount;
    
    
    NSMutableArray *expressDataArr;
    
    NSDictionary *expressCompanyInfo;
}
@end

@implementation ExpressDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    expressDataArr = [NSMutableArray array];
    
    [self initViews];
    // Do any additional setup after loading the view.
}

-(void)initViews
{
    [self setBarTitle:@"物流详情"];
    [self addLeftButton:@"whiteback@2x.png"];
    
    //_cellCount = 0;
    _cellHeight = SCREEN_HEIGHT/12;
    
    _expressTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 , self.view.frame.size.width, [[UIScreen mainScreen] bounds].size.height- 64)];
    _expressTabView.delegate = self;
    _expressTabView.dataSource = self;
    _expressTabView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;//UITableViewCellSeparatorStyleSingleLine;
    _expressTabView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    // tableView.separatorColor =  [UIColor colorWithRed:189/255.0 green:170/255.0 blue:152/255.0 alpha:1.0];
    _expressTabView.tableFooterView = [[UIView alloc] init];


    UILabel *expressCompanyLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH , 60)];
    expressCompanyLab.text  = expressCompanyInfo[@"e_name"];
    expressCompanyLab.textAlignment = NSTextAlignmentCenter;
    _expressTabView.tableHeaderView = expressCompanyLab;
    
    [self.view addSubview:_expressTabView];
}


-(void)setExpressDict:(NSDictionary *)expressDict
{
    _expressDict = expressDict;
    
    @try {
        if (_expressDict !=nil ) {
            
       
            NSArray *tempArr;
            
            tempArr  = [expressDict objectForKey:@"data"][@"data"];
            
            expressCompanyInfo =[expressDict objectForKey:@"express"];
            if(tempArr != nil&&tempArr.count > 0)
            {
                if(expressDataArr == nil)
                {
                    expressDataArr = [NSMutableArray array];
                }
                
                if(expressDataArr.count > 0)
                {
                    [expressDataArr removeAllObjects];
                }
                
                
                [expressDataArr addObjectsFromArray:tempArr];
                _cellCount = expressDataArr.count;
                
                [_expressTabView reloadData];
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
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
    
    
    
    @try {
        if(indexPath.row > expressDataArr.count - 1 || expressDataArr.count == 0 || expressDataArr == nil)
        {
            return cell;
        }
        
        UILabel *expressTextLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, cell.frame.size.width-20, cell.frame.size.height)];
        expressTextLab.numberOfLines = 0;
        expressTextLab.text = expressDataArr[indexPath.row][@"context"];
        expressTextLab.font = [UIFont systemFontOfSize:14];
        if(indexPath.row ==0)
        {
            expressTextLab.textColor = [UIColor greenColor];
        }
        [cell addSubview:expressTextLab];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
         return cell;
    }
    
   
    
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
    
    return 0;
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
