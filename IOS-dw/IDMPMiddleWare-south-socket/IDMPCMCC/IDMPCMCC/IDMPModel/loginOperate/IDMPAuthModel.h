//
//  IDMPAuthModel.h
//  IDMPCMCC
//
//  Created by wj on 2017/8/17.
//  Copyright © 2017年 zwk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDMPAuthModel : NSObject

@property (nonatomic, strong, readonly) NSDictionary *heads;

//中国移动wap协商
- (instancetype)initWPWithSipInfo:(NSString *)sipinfo clientNonce:(NSString *)clientNonce traceId:(NSString *)traceId isTmpCache:(BOOL)isTmpCache;

//中国联通wap协商
- (instancetype)initCUCCWPWithCert:(NSString *)cert sipInfo:(NSString *)sipinfo clientNonce:(NSString *)clientNonce traceId:(NSString *)traceId isTmpCache:(BOOL)isTmpCache;

//中国电信wap协商
- (instancetype)initCTCCWPWithCert:(NSString *)cert sipInfo:(NSString *)sipinfo clientNonce:(NSString *)clientNonce traceId:(NSString *)traceId isTmpCache:(BOOL)isTmpCache;

- (instancetype)initHSWithcount:(NSString *)count sipInfo:(NSString *)sipinfo clientNonce:(NSString *)clientNonce traceId:(NSString *)traceId isTmpCache:(BOOL)isTmpCache;

- (instancetype)initUPWithUserName:(NSString *)userName password:(NSString *)password sipInfo:(NSString *)sipinfo clientNonce:(NSString *)clientNonce traceId:(NSString *)traceId;

- (instancetype)initDUPWithUserName:(NSString *)userName messgeCode:(NSString *)messgeCode sipInfo:(NSString *)sipinfo clientNonce:(NSString *)clientNonce traceId:(NSString *)traceId;

- (instancetype)initUPDKSWithUserName:(NSString *)userName sipInfo:(NSString *)sipinfo clientNonce:(NSString *)clientNonce traceId:(NSString *)traceId;


@end
