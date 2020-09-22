//
//  WeiboAtMeStore.h
//  Fenvo
//
//  Created by Caesar on 15/8/9.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WeiboMsg;

@interface WeiboAtMeStore : NSManagedObject

@property (nonatomic, retain) NSNumber * atMeID;
@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) WeiboMsg *weiboMsg;

+ (WeiboAtMeStore *)createByWeiboMsg:(WeiboMsg *)weiboMsg;
@end
