//
//  HomeViewController.h
//  LanDouS
//
//  Created by Mao-MacPro on 14/12/23.
//  Copyright (c) 2014年 Mao-MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
@interface HomeViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    UITableView *tableHome;
    
    NSMutableArray *arrGcId;
    
    NSMutableArray *slideImages;
    NSMutableArray *arrayHomeList;
    UISearchBar *searchBar;
}
@property (strong, nonatomic) IBOutlet UIView *viewtopClassBG;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollBG;
@property (strong, nonatomic) IBOutlet UIView *btnIndexView;
 
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
- (IBAction)snackFoodclick:(id)sender;
- (IBAction)personwashclick:(id)sender;
- (IBAction)drinkwineclick:(id)sender;
- (IBAction)oilclick:(id)sender;
- (IBAction)homecleanclick:(id)sender;
- (IBAction)lifeuseclick:(id)sender;
- (IBAction)household:(id)sender;
- (IBAction)workgift:(id)sender;

@end
