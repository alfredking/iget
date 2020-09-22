//
//  WeiboVisibleInfo.h
//  Fenvo
//
//  Created by Caesar on 15/3/28.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeiboVisibleInfo : NSObject
@property (nonatomic, assign)NSInteger type;
@property (nonatomic, assign)NSInteger list_id;
-(WeiboVisibleInfo *)initWithDictionary:(NSDictionary *)visible;
@end
