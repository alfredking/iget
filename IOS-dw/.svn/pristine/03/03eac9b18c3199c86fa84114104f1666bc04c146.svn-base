//
//  IDMPRegisterMode.h
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by zwk on 14/11/24.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDMPAccountManagerMode : NSObject

typedef void (^accessBlock)(NSDictionary *paraments);

+ (IDMPAccountManagerMode *)shareAccountManager;

- (void)registerUserWithPhoneNo:(NSString *)phoneNo passWord:(NSString *)password andValidCode:(NSString *)validCode finishBlock:(accessBlock)successBlock failBlock:(accessBlock )failBlock;

- (void)resetPasswordWithPhoneNo:(NSString *)phoneNo passWord:(NSString *)password andValidCode:(NSString *)validCode finishBlock:(accessBlock)successBlock failBlock:(accessBlock )failBlock;

- (void)changePasswordWithPhoneNo:(NSString *)phoneNo passWord:(NSString *)password andNewPSW:(NSString *)newpassword finishBlock:(accessBlock)successBlock failBlock:(accessBlock )failBlock;

@end
