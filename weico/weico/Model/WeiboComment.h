//
//  WeiboComment.h
//  Fenvo
//
//  Created by Caesar on 15/8/5.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WeiboComment, WeiboMsg, WeiboUserInfo;

@interface WeiboComment : NSManagedObject<NSCoding>

@property (nonatomic, retain) NSString * created_at;
@property (nonatomic, retain) NSNumber * ids;
@property (nonatomic, retain) NSString * mid;
@property (nonatomic, retain) NSString * source;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * idstr;
@property (nonatomic, retain) WeiboComment *reply_comment;
@property (nonatomic, retain) WeiboMsg *weiboMsg;
@property (nonatomic, retain) WeiboUserInfo *user;

//
@property (nonatomic, assign) NSNumber * height;

+ (WeiboComment *)createByDictionary:(NSDictionary *)dic Option:(BOOL)isSave;
+ (WeiboComment *)createdInCoreData;

@end
