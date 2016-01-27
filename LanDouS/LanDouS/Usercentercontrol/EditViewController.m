//
//  EditViewController.m
//  LanDouS
//
//  Created by Mao-MacPro on 15/1/15.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import "EditViewController.h"
#import "DataProvider.h"
#import "ChooseAreaController.h"
@interface EditViewController ()

@end

@implementation EditViewController
@synthesize dicPost,lblArea,textAddressDetail,textName,textPhone;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarTitle:@"编辑地址"];
    [self addLeftButton:@"whiteback@2x.png"];
    _lblTitle.textColor=[UIColor whiteColor];
    _topView.backgroundColor=navi_bar_bg_color;
    UIImageView *imageline1=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-60    , 27, 58,28)];
    imageline1.image=[UIImage imageNamed:@"btnSureAdress.png"];
    [_topView addSubview:imageline1];
    //[self addRightButton:@"btnsurearea@2x.png"];
    textName.text=[dicPost objectForKey:@"true_name"];
     textPhone.text=[dicPost objectForKey:@"mob_phone"];
    textAddressDetail.text=[dicPost objectForKey:@"address"];
    [self getProvinceList];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getarea:) name:@"editchoosearea" object:nil];
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
         [self changeAddress];
    }
    else{
        [Dialog simpleToast:@"亲，请把信息填写正确"];
    }
    
    
}

- (IBAction)chooseareaclick:(id)sender
{
    ChooseAreaController *ChooseArea=[[ChooseAreaController alloc]init];
    ChooseArea.strType=@"edit";
    [self.navigationController pushViewController:ChooseArea animated:YES];
}
-(void)changeAddress
{
    [SVProgressHUD showWithStatus:@"正在加载"];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        NSLog(@"^^^^%@", resultDict );
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            [Dialog simpleToast:@"亲，地址修改成功"];
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
    [dataProvider changeAddress:dicPost];
    //[dataProvider getStoreList:@"nothing" andPage:shopPage andPerpage:shopPerpage];
}
-(void)getProvinceList
{
    
    
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        if ([[resultDict objectForKey:@"result"] intValue] == 1)
        {
            if ([[resultDict objectForKey:@"list"]isKindOfClass:[NSArray class]]) {
                NSArray *array=[resultDict objectForKey:@"list"];
                for (int i=0; i<array.count; i++) {
                    if ([[[array objectAtIndex:i] objectForKey:@"area_id"]isEqualToString:[dicPost objectForKey:@"area_id"]]) {
                        lblArea.text=[[array objectAtIndex:i] objectForKey:@"area_name"];
                    }
                }
            }
            
            
            
            
        }
        else
        {
            
        }
        
        
        
        
    }];
    
    [dataProvider setFailedBlock:^(NSString *strError){
        [SVProgressHUD dismiss];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"检查网络！" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert show];
        
    }];
    // NSString *password_md5=[MyMD5 md5:text_password.text];
    [dataProvider getArea:@"235"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
