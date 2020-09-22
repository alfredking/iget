//
//  WeiboStore.h
//  Fenvo
//
//  Created by Caesar on 15/7/29.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WeiboMsg;

@interface WeiboStore : NSManagedObject

@property (nonatomic, retain) NSNumber * weiboID;
@property (nonatomic, retain) WeiboMsg *weiboMsg;

+ (WeiboStore *)createByWeiboMsg:(WeiboMsg *)weiboMsg;
@end
