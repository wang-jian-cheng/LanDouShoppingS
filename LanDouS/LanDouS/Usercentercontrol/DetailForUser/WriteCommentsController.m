//
//  WriteCommentsController.m
//  LanDouS
//
//  Created by 张留扣 on 15/1/24.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import "WriteCommentsController.h"

@interface WriteCommentsController ()<UITextViewDelegate>

@end

@implementation WriteCommentsController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setBarTitle:@"应用评价"];
    [self addLeftButton:@"whiteback@2x.png"];
    _lblTitle.textColor=[UIColor whiteColor];
    _topView.backgroundColor=navi_bar_bg_color;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.myTextView.layer.masksToBounds = YES;
    self.myTextView.layer.borderWidth = 1;
    self.myTextView.layer.borderColor = [UIColor grayColor].CGColor;
    self.myTextView.layer.cornerRadius = 5;
    
    self.myTextView.delegate = self;
    
    
}

- (IBAction)writeCommentsAction:(id)sender
{
    //写评论
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.myTextView resignFirstResponder];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {//检测到“完成”
        [textView resignFirstResponder];//释放键盘
        return NO;
    }
    if (textView.text.length==0){//textview长度为0
        if ([text isEqualToString:@""]) {//判断是否为删除键
            self.myLabel.hidden=NO;//隐藏文字
        }else{
            self.myLabel.hidden=YES;
        }
    }else{//textview长度不为0
        if (textView.text.length==1){//textview长度为1时候
            if ([text isEqualToString:@""]) {//判断是否为删除键
                self.myLabel.hidden=NO;
            }else{//不是删除
                self.myLabel.hidden=YES;
            }
        }else{//长度不为1时候
            self.myLabel.hidden=YES;
        }
    }
    return YES;
}

@end
