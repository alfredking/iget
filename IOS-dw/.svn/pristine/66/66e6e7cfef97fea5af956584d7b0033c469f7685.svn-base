//
//  MskResponse.h
//  msk
//
//  Created by wanggp on 2017/8/17.
//  Copyright © 2017年 wanggp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MskResponse : NSObject


-(NSString *)getStringValue:(NSString *)key;

- (void)putStringValue:(NSString *)key value:(NSString *)value;


- (void)putDataValue:(NSString *)key value:(NSData *)value;

-(NSData *)getDataValue:(NSString *)key;


-(BOOL) checkResult:(int)ret;

- (int)getResCode;
- (NSString *)getResRemark;


@end
