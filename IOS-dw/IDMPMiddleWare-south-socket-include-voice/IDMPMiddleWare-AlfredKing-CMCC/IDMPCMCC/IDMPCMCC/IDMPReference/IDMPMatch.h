//
//  IDMPMatch.h
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by zwk on 14/11/18.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDMPMatch : NSObject

+ (BOOL) validateMobile:(NSString *)mobile;
+ (BOOL) validatePassword:(NSString *)passWord;
+ (BOOL) validateCheck:(NSString *)checkWord;
+ (BOOL) validateEmail:(NSString *)email;
+ (BOOL) validatePassID:(NSString *)passId;


@end
