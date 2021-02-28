//
//  HistorySearchModel.h
//  NST
//
//  Created by 陈乐杰 on 2018/8/7.
//  Copyright © 2018年 owner. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,HistorySearchType) {
    HistorySearchSuplly = 0,
    HistorySearchMerchant,
    HistorySearchNeed
};
@interface HistorySearchModel : NSObject
@property (strong,nonatomic) NSString * title;
@property (assign,nonatomic) HistorySearchType type;
+(instancetype)initWithTitle:(NSString *)title andType:(HistorySearchType)type;
- (void)encodeWithCoder:(NSCoder *)coder;
- (instancetype)initWithCoder:(NSCoder *)coder;
@end
