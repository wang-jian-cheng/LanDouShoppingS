//
//  UserCenterController.m
//  LanDouS
//
//  Created by Mao-MacPro on 14/12/23.
//  Copyright (c) 2014年 Mao-MacPro. All rights reserved.
//

#import "UserCenterController.h"
#import "MyCollectController.h"
#import "MyScoreController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "SettingController.h"
#import "MyAdressMagController.h"
#import "WaitPayController.h"
#import "WaitSendGoodsController.h"
#import "WaitTakeGoodsController.h"
#import "YetTakeGoodsController.h"
#import "DataProvider.h"
#import "UIImageView+WebCache.h"
#import "MyScoreLogController.h"
@interface UserCenterController ()<UIActionSheetDelegate>
{
    UIActionSheet  *_actionSheet;
}

@end

@implementation UserCenterController
@synthesize imageface,scrollBG,lblUserName,lblwelcome,lblMoney,lblScore,btnWaitPay,btnWaitReceive,btnWaitSend,btnYetReceive;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarTitle:@"会员中心"];
    [self addRightButton:@"setting@2x.png"];
    
    self.YuCunKuan.hidden = YES;
    CGRect tempRect =  self.JIFen.bounds ;
    tempRect.size.width  = SCREEN_WIDTH - 16;
    self.JIFen.bounds = tempRect;
    
    CGRect tempRect1 =  self.JIFenView.bounds ;
    tempRect1.size.width  = SCREEN_WIDTH - 16;
     self.JIFenView.bounds = tempRect1;
    CGPoint center = self.JIFenView.center;
    center.x = SCREEN_WIDTH/2;
    self.JIFenView.center = center;
    
    
    CGRect tempRect2 =  self.lblScore.frame ;
    tempRect2.origin.x = 45;
    self.lblScore.frame = tempRect2;
    
    
    
    
    _lblTitle.textColor=[UIColor whiteColor];
    _topView.backgroundColor=navi_bar_bg_color;
    [imageface.layer setMasksToBounds:YES];
    imageface.layer.cornerRadius=33;
    scrollBG.contentSize=CGSizeMake(SCREEN_WIDTH, 560);
    dicPost=[[NSMutableDictionary alloc]init];
    numWaitPay=[[JSBadgeView alloc]initWithParentView:btnWaitPay alignment:JSBadgeViewAlignmentInTopRight];
    numWaitPay.badgeBackgroundColor=[UIColor colorWithRed:1 green:0.51 blue:0.04 alpha:1];
    
    
    numWaitReceive=[[JSBadgeView alloc]initWithParentView:btnWaitReceive alignment:JSBadgeViewAlignmentInTopRight];
    numWaitReceive.badgeBackgroundColor=[UIColor colorWithRed:1 green:0.51 blue:0.04 alpha:1];
    numWaitSend=[[JSBadgeView alloc]initWithParentView:btnWaitSend alignment:JSBadgeViewAlignmentInTopRight];
    numWaitSend.badgeBackgroundColor=[UIColor colorWithRed:1 green:0.51 blue:0.04 alpha:1];
    numYetReceive=[[JSBadgeView alloc]initWithParentView:btnYetReceive alignment:JSBadgeViewAlignmentInTopRight];
    numYetReceive.badgeBackgroundColor=[UIColor colorWithRed:1 green:0.51 blue:0.04 alpha:1];
    
    
    //    imageface.layer.borderWidth=2;
    //    imageface.layer.bo                                                rderColor=[[UIColor whiteColor]CGColor];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] showTabBar];
    
    
    if (get_Dsp(@"userinfo")) {
        CGSize size = [[get_Dsp(@"userinfo") objectForKey:@"member_name"] sizeWithFont:[UIFont boldSystemFontOfSize:13.0f] constrainedToSize:CGSizeMake(200, 44)];
        lblUserName.text=[get_Dsp(@"userinfo") objectForKey:@"member_name"];
        lblUserName.frame=CGRectMake(90, 84, size.width+5,20);
        lblwelcome.frame=CGRectMake(90+size.width+10, 84, 51, 20);
        _lblSecurity.frame=CGRectMake(90, 117, 68, 21);
        _lblSecuritylow.frame=CGRectMake(152, 122, 35, 12);
        _lblSecuritymedium.frame=CGRectMake(188, 122, 35, 12);
        _lblSecurityhigh.frame=CGRectMake(224, 122, 35, 12);
        
        [self edituserinfo];
        //        [dicPost setObject:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
        //        [dicPost setObject:[NSString stringWithFormat:@"%d",perpage] forKey:@"perpage"];
        
        //[self getproduct:dicPost];
    }
    else{
        [self clearUserInfo];
        LoginViewController *LoginView=[[LoginViewController alloc]init];
        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:LoginView];
        nav.navigationBar.hidden=YES;
        [self presentViewController:nav animated:YES completion:nil];
    }
    
    
}
-(void)clearUserInfo{
    
    [self addLeftButton:@"qiandaoed@2x.png"];
    
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",USER_IMAGE_URL,@""]];
    [imageface setImageWithURL:url placeholderImage:img(@"landou_square_default.png")];
    
    lblUserName.text=@"";
    lblScore.text=[NSString stringWithFormat:@"积分:%@",[get_Dsp(@"userinfo") objectForKey:@"member_points"]];
    lblMoney.text=[NSString stringWithFormat:@"预存款:￥%@",[get_Dsp(@"userinfo") objectForKey:@"available_predeposit"]];
    
    numWaitPay.badgeText=@"";
    
    
    numWaitSend.badgeText=@"";
    
    
    numWaitReceive.badgeText=@"";
    numYetReceive.badgeText=@"";
    
}
-(void)clickRightButton:(UIButton *)sender
{
    SettingController *Setting=[[SettingController alloc]init];
    [self.navigationController pushViewController:Setting animated:YES];
}
-(void)clickLeftButton:(UIButton *)sender
{
    [self addCheckPoints];
}

-(void)addCheckPoints
{
    [SVProgressHUD showWithStatus:@"正在加载"];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        [SVProgressHUD dismiss];
        @try {
            DLog(@"^^^^%@", resultDict );
            if ([[resultDict objectForKey:@"result"]intValue]==1) {
                //            [Dialog simpleToast:@"签到成功"];
                [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"签到成功，获得%@积分！",            (NSString*)[[resultDict objectForKey:@"data"]objectForKey:@"pl_points"]]];
                [self  edituserinfo];
                [[resultDict objectForKey:@"data"]objectForKey:@"pl_points"];
                
            }
            else{
                [Dialog simpleToast:[resultDict objectForKey:@"message"]];
            }
            

        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
        
    }];
    
    [dataProvider setFailedBlock:^(NSString *strError){
        [SVProgressHUD dismiss];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"检查网络！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        
    }];
    [dataProvider addCheckPoints];
    //[dataProvider getStoreList:@"nothing" andPage:shopPage andPerpage:shopPerpage];
}
-(void)edituserinfo
{
    
    DataProvider *dataProvider = [[DataProvider alloc]  init];
    [dataProvider setFinishBlock:^(NSDictionary *resultDict){
        //        [SVProgressHUD dismiss];
        DLog(@"^^^^%@", resultDict );
        if ([[resultDict objectForKey:@"result"]intValue]==1) {
            set_sp(@"userinfo",[resultDict objectForKey:@"data"]);
            [sp synchronize];
            if ([[[resultDict objectForKey:@"data"] objectForKey:@"check_status"]intValue]==1) {
                [self addLeftButton:@"qiandaoed@2x.png"];
            }
            else{
                [self addLeftButton:@"unqiandao@2x.png"];
            }
            NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",USER_IMAGE_URL,[[resultDict objectForKey:@"data"] objectForKey:@"member_avatar"]]];
            [imageface setImageWithURL:url placeholderImage:img(@"landou_square_default.png")];
            
            
            lblScore.text=[NSString stringWithFormat:@"积分:%@",[get_Dsp(@"userinfo") objectForKey:@"member_points"]];
            lblMoney.text=[NSString stringWithFormat:@"预存款:￥%@",[get_Dsp(@"userinfo") objectForKey:@"available_predeposit"]];
            if ([[[resultDict objectForKey:@"data"] objectForKey:@"order_state_new"]intValue]==0) {
                numWaitPay.badgeText=@"";
            }
            else{
                numWaitPay.badgeText=[[resultDict objectForKey:@"data"] objectForKey:@"order_state_new"];
            }
            if ([[[resultDict objectForKey:@"data"] objectForKey:@"order_state_pay"] intValue]==0) {
                numWaitSend.badgeText=@"";
            }
            else{
                numWaitSend.badgeText=[[resultDict objectForKey:@"data"] objectForKey:@"order_state_pay"];
            }
            if (  [[[resultDict objectForKey:@"data"] objectForKey:@"order_state_send"] intValue]==0 ) {
                numWaitReceive.badgeText=@"";
            }
            else{
                numWaitReceive.badgeText=[[resultDict objectForKey:@"data"] objectForKey:@"order_state_send"];
            }
            if ([[[resultDict objectForKey:@"data"] objectForKey:@"order_state_success"]intValue]==0) {
                numYetReceive.badgeText=@"";
            }
            else{
                numYetReceive.badgeText=[[resultDict objectForKey:@"data"] objectForKey:@"order_state_success"];
            }
            
        }
        else{
            [Dialog simpleToast:[resultDict objectForKey:@"message"]];
        }
        
        
        
    }];
    
    [dataProvider setFailedBlock:^(NSString *strError){
        [SVProgressHUD dismiss];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"检查网络！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        
    }];
    [dataProvider useredit:dicPost];
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
- (IBAction)depositBtnClick:(id)sender {
    DepositViewController *depositView = [[DepositViewController alloc] init];
    [self.navigationController pushViewController:depositView animated:YES];
}

- (IBAction)mycollectclick:(id)sender {
    MyCollectController *MyCollect=[[MyCollectController alloc]init];
    [self.navigationController pushViewController:MyCollect animated:YES];
}

- (IBAction)myaddressclick:(id)sender {
    MyAdressMagController *MyAdressMag=[[MyAdressMagController alloc]init];
    [self.navigationController pushViewController:MyAdressMag animated:YES];
}
- (IBAction)waitpayclick:(id)sender {
    WaitPayController *WaitPay=[[WaitPayController alloc]init];
    [self.navigationController pushViewController:WaitPay animated:YES];
}

- (IBAction)waitsendgoodsclick:(id)sender {
    WaitSendGoodsController *WaitSendGoods=[[WaitSendGoodsController alloc]init];
    [self.navigationController pushViewController:WaitSendGoods animated:YES];
    
}

- (IBAction)waittakeclick:(id)sender {
    WaitTakeGoodsController *WaitTakeGoods=[[WaitTakeGoodsController alloc]init];
    [self.navigationController pushViewController:WaitTakeGoods animated:YES];
    
}

- (IBAction)yettakeclick:(id)sender {
    YetTakeGoodsController *YetTakeGoods=[[YetTakeGoodsController alloc]init];
    [self.navigationController pushViewController:YetTakeGoods animated:YES];
    
}

- (IBAction)myscoreclick:(id)sender {
    MyScoreController *MyScore=[[MyScoreController alloc]init];
    [self.navigationController pushViewController:MyScore animated:YES];
}

- (IBAction)changeimageclick:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"打开图库", @"拍照",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}
#pragma mark - ActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger sourceType;
    [_actionSheet removeFromSuperview];
    _actionSheet = nil;
    
    if (buttonIndex == 2)
        return ;
    
    switch (buttonIndex) {
        case 0:
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
        case 1:
            sourceType = UIImagePickerControllerSourceTypeCamera;
        default:
            break;
    }
    
    UIImagePickerController * imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *photoImage = [info objectForKey:UIImagePickerControllerEditedImage];
    //NSData *imageData = UIImageJPEGRepresentation(photoImage,0.05);
    
    
    [dicPost setObject:photoImage forKey:@"userimage"];
    imageface.image=photoImage;
    //[btnuserimage setImage:photoImage forState:UIControlStateNormal];
    
    // 如果是相机拍照的，保存在本地
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        UIImageWriteToSavedPhotosAlbum(photoImage, nil, nil, nil);
    }
    
    [self edituserinfo];
    
}


- (IBAction)scorelogclick:(id)sender {
    MyScoreLogController *MyScoreLog=[[MyScoreLogController alloc]init];
    [self.navigationController pushViewController:MyScoreLog animated:YES];
}
@end
