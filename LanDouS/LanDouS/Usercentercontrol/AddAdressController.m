//
//  AddAdressController.m
//  LanDouS
//
//  Created by Mao-MacPro on 15/1/12.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import "AddAdressController.h"
#import "DataProvider.h"
#import "ChooseAreaController.h"
@interface AddAdressController ()

@end

@implementation AddAdressController
@synthesize textAddressDetail,lblArea,textName,textPhone;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarTitle:@"新增地址"];
    [self addLeftButton:@"whiteback@2x.png"];
    _lblTitle.textColor=[UIColor whiteColor];
    _topView.backgroundColor=navi_bar_bg_color;
    //[self addRightButton:@"btnsurearea@2x.png"];
    UIImageView *imageline1=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-60    , 27, 58,28)];
    imageline1.image=[UIImage imageNamed:@"btnSureAdress.png"];
    UILabel* sureBtn=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-60    , 27, 58,28)];
    sureBtn.text=@"确定";
    sureBtn.textColor=[UIColor whiteColor];
    [_topView addSubview:sureBtn];
    
    
    dicPost=[[NSMutableDictionary alloc]init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getarea:) name:@"choosearea" object:nil];
    // Do any additional setup after loading the view from its nib.
}
-(void)getarea:(NSNotification *)notion
{
    NSDictionary *dic=[notion object];
    lblArea.text=[dic objectForKey:@"area_name"];
    [dicPost setObject:[dic objectForKey:@"area_id"] forKey:@"area_id"];
}
-(void)clickRightButton:(UIButton *)sender{
    if (textName.text.length>0&&textPhone.text.length==11&&[[dicPost objectForKey:@"area_id"] length]>0&&textAddressDetail.text.length>0) {
        [dicPost setObject:textName.text forKey:@"true_name"];
        [dicPost setObject:textPhone.text forKey:@"mob_phone"];
        [dicPost setObject:textAddressDetail.text forKey:@"address"];
        [self addAddress];
    }
    else{
        [Dialog simpleToast:@"亲，请把信息填写正确"];
    }
    
    
    
    
}
-(void)addAddress
{
    [SVProgressHUD showWithStatus:@"正在加载"];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        NSLog(@"^^^^%@", resultDict );
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            [Dialog simpleToast:@"地址添加成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            
        }
        
        
        
    }];
    
    [dataProvider setFailedBlock:^(NSString *strError){
        [SVProgressHUD dismiss];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"检查网络！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        
    }];
    [dataProvider addAddress:dicPost];
    //[dataProvider getStoreList:@"nothing" andPage:shopPage andPerpage:shopPerpage];
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

- (IBAction)chooseareaclick:(id)sender {
    [textPhone resignFirstResponder];
    [textName resignFirstResponder];
    ChooseAreaController *ChooseArea=[[ChooseAreaController alloc]init];
    [self.navigationController pushViewController:ChooseArea animated:YES];
}
@end
