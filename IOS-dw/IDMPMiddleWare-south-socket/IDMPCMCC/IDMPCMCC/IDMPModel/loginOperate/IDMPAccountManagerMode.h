//
//  IDMPRegisterMode.h
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by zwk on 14/11/24.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDMPAccountManagerMode : NSObject

typedef NS_ENUM(NSUInteger, IDMPAccountOption) {
    IDMPRegister,
    IDMPChangePwd,
    IDMPResetPwd,
};

typedef void (^accessBlock)(NSDictionary *paraments);

+ (IDMPAccountManagerMode *)shareAccountManager;

- (void)manageAccount:(NSString *)phoneNo passWord:(NSString *)password validCodeOrNewPwd:(NSString *)validCodeOrNewPwd option:(NSUInteger)option traceId:(NSString *)traceId finishBlock:(accessBlock) successBlock failBlock:(accessBlock)failBlock;

@end
