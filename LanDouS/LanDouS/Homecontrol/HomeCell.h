//
//  HomeCell.h
//  LanDouS
//
//  Created by Mao-MacPro on 14/12/24.
//  Copyright (c) 2014年 Mao-MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblClass;
@property (strong, nonatomic) IBOutlet UILabel *lblLeftTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblLeftPrice;
@property (strong, nonatomic) IBOutlet UIImageView *imLeft;
@property (strong, nonatomic) IBOutlet UILabel *lblRightTopTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblRightTopPrice;
@property (strong, nonatomic) IBOutlet UIImageView *imRightTop;
@property (strong, nonatomic) IBOutlet UILabel *lblRightUnderTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblRightUnderPrice;
@property (strong, nonatomic) IBOutlet UIImageView *imRightUnder;
@property (strong, nonatomic) IBOutlet UIButton *btnLeft;
@property (strong, nonatomic) IBOutlet UIButton *btnRiUp;
@property (strong, nonatomic) IBOutlet UIButton *btnRiDowN;

@end
