//
//  IDMPTempSmsMode.h
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking－cmcc on 14-8-21.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDMPTempSmsMode : NSObject

typedef void (^IDMPBlock)(void);

-(void)getTMMessageCodeWithUserName:(NSString *)userName successBlock:(IDMPBlock)successBlock failBlock:(IDMPBlock)failBlock;

-(void)getTMKSWithUserName:(NSString *)userName messageCode:(NSString *)messageCode successBlock:(IDMPBlock)successBlock failBlock:(IDMPBlock)failBlock;
@end
