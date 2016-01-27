//
//  CustomSearchBar.h
//  BestOne
//
//  Created by hank on 13-10-13.
//  Copyright (c) 2013年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomSearchBar;

@protocol CustomSearchBarDelegate <NSObject>

- (void)CustomSearchBarStartSearch:(CustomSearchBar *)searchBar andText:(NSString *)textSearch;
- (void)CustomSearchBarStartInput:(CustomSearchBar *)searchBar;
@end

@interface CustomSearchBar : UIView
{
    UITextField *_searchTextView;
}

- (void)resignKeyboard;
- (BOOL)isEmpty;

@property(nonatomic, weak)id<CustomSearchBarDelegate> delegate;
@property(nonatomic, strong)UITextField *searchTextView;
@end
