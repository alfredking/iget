//
//  WBHttpResponseResultKit.h
//  Fenvo
//
//  Created by Neil on 15/8/31.
//  Copyright © 2015年 Caesar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONKit.h"

@interface WBHttpResponseResultKit : NSObject
+ (void)timelineStringToArray:(NSString *)string
                      success:(void(^)(NSArray *array, NSNumber *since_id, NSNumber *max_id))success
                      failure:(void(^)(NSString *description))failure;
@end
