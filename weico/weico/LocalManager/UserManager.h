//
//  UserManager.h
//  Fenvo
//
//  Created by Caesar on 15/8/20.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WeiboUserInfo;

@interface UserManager : NSObject
+ (WeiboUserInfo *)queryObject:(NSNumber *)ID;
@end
