//
//  StandardModel.h
//  LanDouS
//
//  Created by Wangjc on 16/2/24.
//  Copyright © 2016年 Mao-MacPro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface standardClassInfo : NSObject
/**
 * 规格分类名称
 */
@property(nonatomic) NSString *standardClassName;
/**
 * 规格分类id
 */
@property(nonatomic) NSString *standardClassId;

@end




@interface StandardModel : NSObject
/**
 * 规格名称
 */
@property(nonatomic) NSString *standardName;
/**
 * 每个规格下分类信息
 */
@property(nonatomic) NSArray<standardClassInfo *> *standardClassInfo;

@end
