//
//  WeiboRemind.h
//  Fenvo
//
//  Created by Caesar on 15/7/19.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface WeiboRemind : NSManagedObject

@property (nonatomic, retain) NSNumber * badge;
@property (nonatomic, retain) NSNumber * cmt;
@property (nonatomic, retain) NSNumber * dm;
@property (nonatomic, retain) NSNumber * follower;
@property (nonatomic, retain) NSNumber * group;
@property (nonatomic, retain) NSNumber * invite;
@property (nonatomic, retain) NSNumber * mention_cmt;
@property (nonatomic, retain) NSNumber * mention_status;
@property (nonatomic, retain) NSNumber * msgbox;
@property (nonatomic, retain) NSNumber * notice;
@property (nonatomic, retain) NSNumber * photo;
@property (nonatomic, retain) NSNumber * private_group;
@property (nonatomic, retain) NSNumber * weiboMsg;

@end
