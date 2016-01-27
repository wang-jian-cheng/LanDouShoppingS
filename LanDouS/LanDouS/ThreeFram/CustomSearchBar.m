//
//  CustomSearchBar.m
//  BestOne
//
//  Created by hank on 13-10-13.
//  Copyright (c) 2013年 hank. All rights reserved.
//

#import "CustomSearchBar.h"
#import "UIImage+NSBundle.h"

@interface CustomSearchBar ()<UITextFieldDelegate>

@end

@implementation CustomSearchBar
@synthesize searchTextView = _searchTextView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIView *viewBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        viewBG.backgroundColor = [UIColor clearColor];
        [self addSubview:viewBG];
        
        _searchTextView = [[UITextField alloc] initWithFrame:CGRectMake(0, 5, frame.size.width, 30)];
        _searchTextView.delegate = self;
        [_searchTextView.layer setMasksToBounds:YES];
        _searchTextView.layer.cornerRadius =4.0f;
        _searchTextView.placeholder = @"     请输入搜索信息";
        _searchTextView.backgroundColor = [UIColor whiteColor];
        _searchTextView.font = [UIFont systemFontOfSize:14];
        _searchTextView.textAlignment = NSTextAlignmentLeft;
        _searchTextView.keyboardType = UIKeyboardTypeDefault;
        _searchTextView.returnKeyType = UIReturnKeySearch;
        _searchTextView.center = CGPointMake(_searchTextView.center.x, viewBG.center.y);
        [viewBG addSubview:_searchTextView];
        
//        UIButton *btnSearch = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 40 - 10, 10, 56 / 2.0, 56 / 2.0)];
//        [btnSearch addTarget:self action:@selector(searchStart:) forControlEvents:UIControlEventTouchUpInside];
//        [btnSearch setImage:[UIImage imageWithBundleName:@"btnSearch.png"] forState:UIControlStateNormal];
//        btnSearch.backgroundColor = [UIColor blueColor];
//        btnSearch.center = CGPointMake(btnSearch.center.x, viewBG.center.y);
//        [viewBG addSubview:btnSearch];
    }
    return self;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if([self.delegate respondsToSelector:@selector(CustomSearchBarStartInput:)])
        [self.delegate CustomSearchBarStartInput:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self searchStart:nil];
    return YES;
}

- (void)searchStart:(UIButton *)sender
{
    NSLog(@"search start");
    [self resignKeyboard];
//    if ([self.delegate respondsToSelector:@selector(CustomSearchBarStartSearch: andText:)] && [_searchTextView hasText]){
        [self.delegate CustomSearchBarStartSearch:self andText:_searchTextView.text];
    //}
}

- (void)resignKeyboard
{
    [_searchTextView resignFirstResponder];
}

- (BOOL)isEmpty
{
    return [_searchTextView.text length] ? NO : YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
