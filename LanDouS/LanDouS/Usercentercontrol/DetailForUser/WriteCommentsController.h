//
//  WriteCommentsController.h
//  LanDouS
//
//  Created by 张留扣 on 15/1/24.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import "BaseNavigationController.h"

@interface WriteCommentsController : BaseNavigationController

@property (strong, nonatomic) IBOutlet UITextView *myTextView;
- (IBAction)writeCommentsAction:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *myLabel;
@end
