//
//  IDMPAuthModel.h
//  IDMPCMCC
//
//  Created by wj on 2017/8/17.
//  Copyright © 2017年 zwk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDMPConst.h"



@interface IDMPAuthModel : NSObject

@property (nonatomic, strong, readonly) NSDictionary *heads;

- (instancetype)initWPWithSipInfo:(NSString *)sipinfo clientNonce:(NSString *)clientNonce traceId:(NSString *)traceId;

- (instancetype)initHSWithcount:(NSString *)count sipInfo:(NSString *)sipinfo clientNonce:(NSString *)clientNonce traceId:(NSString *)traceId;

- (instancetype)initUPWithUserName:(NSString *)userName password:(NSString *)password sipInfo:(NSString *)sipinfo clientNonce:(NSString *)clientNonce traceId:(NSString *)traceId;

- (instancetype)initDUPWithUserName:(NSString *)userName messgeCode:(NSString *)messgeCode sipInfo:(NSString *)sipinfo clientNonce:(NSString *)clientNonce traceId:(NSString *)traceId;

- (instancetype)initSUPWithUserName:(NSString *)userName messgeCode:(NSString *)messgeCode sipInfo:(NSString *)sipinfo clientNonce:(NSString *)clientNonce voiceVersion:(NSString *)voiceVersion traceId:(NSString *)traceId;

- (instancetype)initUPDKSWithUserName:(NSString *)userName sipInfo:(NSString *)sipinfo clientNonce:(NSString *)clientNonce traceId:(NSString *)traceId;


@end
