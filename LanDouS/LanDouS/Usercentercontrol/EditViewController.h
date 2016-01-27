//
//  EditViewController.h
//  LanDouS
//
//  Created by Mao-MacPro on 15/1/15.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
@interface EditViewController : BaseNavigationController
{
    //NSMutableDictionary *dicPost;
}
@property (strong, nonatomic)NSMutableDictionary *dicPost;
@property (strong, nonatomic) IBOutlet UITextField *textName;
@property (strong, nonatomic) IBOutlet UITextField *textPhone;
@property (strong, nonatomic) IBOutlet UILabel *lblArea;
@property (strong, nonatomic) IBOutlet UITextField *textAddressDetail;
- (IBAction)chooseareaclick:(id)sender;
@end
