//
//  ImageViewCell.m
//  WaterFlowViewDemo
//
//  Created by Smallsmall on 12-6-12.
//  Copyright (c) 2012年 activation group. All rights reserved.
//

#import "ImageViewCell.h"

#define kConponHeight 60
#define kConponWidth 135

#define TOPMARGIN 8.0f
#define LEFTMARGIN 8.0f

#define IMAGEVIEWBG [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0]

@implementation ImageViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithIdentifier:(NSString *)indentifier
{
	if(self = [super initWithIdentifier:indentifier])
	{
        imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = [UIColor clearColor];
        [self addSubview:imageView];
        _imgPlusAndMin = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 37 / 2.0, 37 / 2.0)];
        _imgPlusAndMin.backgroundColor = [UIColor clearColor];
        [self addSubview:_imgPlusAndMin];
        
//        imageView.layer.borderWidth = 1;
//        imageView.layer.borderColor = [[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0] CGColor];
	}
	
	return self;
}

-(void)setImageWithURL:(NSURL *)imageUrl{

    [imageView setImageWithURL:imageUrl];
    
}

-(void)setImage:(UIImage *)image
{
    imageView.image = image;
    CGPoint point = imageView.center;

    CGSize size = image.size;
    if (size.width > kConponWidth - 16)
    {
        int width = size.width;
        size.width = kConponWidth - 16;
        size.height =  size.width * size.height / width;
    }
    
    if (size.height > kConponHeight - 16)
    {
        int height = size.height;
        size.height = kConponHeight - 16;
        size.width = size.width * size.height / height;
    }

    
    imageView.frame = CGRectMake(0, 0, size.width, size.height);
    imageView.center = point;
    _imgPlusAndMin.center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
}

//保持图片上下左右有固定间距
-(void)relayoutViews
{
    float originX = 0.0f;
    float originY = 0.0f;
    float width = 0.0f;
    float height = 0.0f;
    
    originY = TOPMARGIN;
    height = CGRectGetHeight(self.frame) - TOPMARGIN;
    if (self.indexPath.column == 0) {
        
        originX = LEFTMARGIN;
        width = CGRectGetWidth(self.frame) - LEFTMARGIN - 1/2.0*LEFTMARGIN;
    }else if (self.indexPath.column < self.columnCount - 1){
    
        originX = LEFTMARGIN/2.0;
        width = CGRectGetWidth(self.frame) - LEFTMARGIN;
    }else{
    
        originX = LEFTMARGIN/2.0;
        width = CGRectGetWidth(self.frame) - LEFTMARGIN - 1/2.0*LEFTMARGIN;
    }
//    [self resizeImageSize];
    imageView.frame = CGRectMake(originX, originY,imageView.frame.size.width, imageView.frame.size.height);
    imageView.center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
    _imgPlusAndMin.center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
    
    [super relayoutViews];

}

//- (void)resizeImageSize
//{
//    CGSize size = imageView.image.size;
//    if (size.width > kConponWidth)
//    {
//        int width = size.width;
//        size.width = kConponWidth;
//        size.height =  size.width * size.height / width;
//    }
//    
//    if (size.height > kConponHeight)
//    {
//        int height = size.height;
//        size.height = kConponHeight;
//        size.width = size.width * size.height / height;
//    }
//}

@end
