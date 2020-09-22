//
//  IDMPAuthModel.m
//  IDMPCMCC
//
//  Created by wj on 2017/8/17.
//  Copyright © 2017年 zwk. All rights reserved.
//

#import "IDMPAuthModel.h"
#import "userInfoStorage.h"
#import "IDMPDevice.h"
#import "IDMPNonce.h"
#import "IDMPRSA_Encrypt_Decrypt.h"
#import "IDMPRSA_Sign_Verify.h"
#import "IDMPDateFormatter.h"

typedef NS_ENUM(NSInteger, IDMPAuthType) {
    IDMPAuthWP = 0,
    IDMPAuthHS,
    IDMPAuthUP,
    IDMPAuthDUP,
    IDMPUpdateKS,
    IDMPAuthVUP
};

@interface IDMPAuthModel()
@property (nonatomic, strong) NSDictionary *heads;

@end


@implementation IDMPAuthModel

- (instancetype)initWPWithSipInfo:(NSString *)sipinfo clientNonce:(NSString *)clientNonce traceId:(NSString *)traceId {
    return [self initWithAuthType:IDMPAuthWP countHS:nil userName:nil password:nil sipInfo:sipinfo clientNonce:clientNonce voiceVersion:nil traceId:traceId];
}

- (instancetype)initUPDKSWithUserName:(NSString *)userName sipInfo:(NSString *)sipinfo clientNonce:(NSString *)clientNonce traceId:(NSString *)traceId {
    return [self initWithAuthType:IDMPUpdateKS countHS:nil userName:userName password:nil sipInfo:sipinfo clientNonce:clientNonce voiceVersion:nil traceId:traceId];
}

- (instancetype)initHSWithcount:(NSString *)count sipInfo:(NSString *)sipinfo clientNonce:(NSString *)clientNonce traceId:(NSString *)traceId {
    return [self initWithAuthType:IDMPAuthHS countHS:count userName:nil password:nil sipInfo:sipinfo clientNonce:clientNonce voiceVersion:nil traceId:traceId];
}

- (instancetype)initDUPWithUserName:(NSString *)userName messgeCode:(NSString *)messgeCode sipInfo:(NSString *)sipinfo clientNonce:(NSString *)clientNonce traceId:(NSString *)traceId {
    return [self initWithAuthType:IDMPAuthDUP countHS:nil userName:userName password:messgeCode sipInfo:sipinfo clientNonce:clientNonce voiceVersion:nil traceId:traceId];
}

- (instancetype)initSUPWithUserName:(NSString *)userName messgeCode:(NSString *)messgeCode sipInfo:(NSString *)sipinfo clientNonce:(NSString *)clientNonce voiceVersion:(NSString *)voiceVersion traceId:(NSString *)traceId {
    return [self initWithAuthType:IDMPAuthVUP countHS:nil userName:userName password:messgeCode sipInfo:sipinfo clientNonce:clientNonce voiceVersion:voiceVersion traceId:traceId];
}

- (instancetype)initUPWithUserName:(NSString *)userName password:(NSString *)password sipInfo:(NSString *)sipinfo clientNonce:(NSString *)clientNonce traceId:(NSString *)traceId {
    return [self initWithAuthType:IDMPAuthUP countHS:nil userName:userName password:password sipInfo:sipinfo clientNonce:clientNonce voiceVersion:nil traceId:traceId];
}

- (instancetype)initWithAuthType:(IDMPAuthType)authType countHS:(NSString *)count userName:(NSString *)userName password:(NSString *)password sipInfo:(NSString *)sipinfo clientNonce:(NSString *)clientNonce voiceVersion:(NSString *)voiceVersion traceId:(NSString *)traceId{
    if (self = [super init]) {
        NSString *BTID;
        NSString *sqn;
        NSString *version = [IDMPDevice getAppVersion];
        NSString *deviceID = [IDMPDevice getDeviceID];
        NSString *encryptClientNonce= secRSA_Encrypt(clientNonce);
        NSString *authorization = nil;

        if (authType == IDMPAuthUP || authType == IDMPAuthDUP || authType == IDMPUpdateKS || authType == IDMPAuthVUP) {
            NSDictionary *user = (NSDictionary *)[userInfoStorage getInfoWithKey:userName];
            if([user objectForKey:ksBTID]&&[user objectForKey:@"KS"]&&[user objectForKey:ksSQN]) {
                BTID = [user objectForKey:ksBTID];
                sqn = [user objectForKey:ksSQN];
            }
        }
        switch (authType) {
            case IDMPAuthWP:
                authorization= [NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"", ksWP_clientversion,version,sdkversion,sdkversionValue,@"appid",appidString,sipEncFlag,yesFlag,httpsFlag,yesFlag,ksBTID,BTID,sipFlag,sipinfo,ksClientkek,encryptClientNonce,ksIOS_ID,deviceID,IDMPTraceId,traceId];
                
                break;
            case IDMPAuthHS:
                authorization = [NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"",ksDS_clientversion,version,sdkversion,sdkversionValue,@"appid",appidString,sipEncFlag,yesFlag,ksBTID,BTID,sipFlag,sipinfo,ksEnClientkek,encryptClientNonce,ksRAND,clientNonce,ksIOS_ID,deviceID,@"hscount",count,IDMPTraceId,traceId];
                break;
            case IDMPAuthUP:
            {
                NSString *encryptPassWd = secRSA_Encrypt(password);
                authorization = [NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"", ksUP_clientversion,version,sdkversion,sdkversionValue,@"appid",appidString,sipEncFlag,@"1",ksBTID,BTID,sipFlag,sipinfo,ksUserName,userName,ksEnClientNonce,encryptClientNonce,ksEnPasswd,encryptPassWd,ksIOS_ID,deviceID,IDMPTraceId,traceId];
                
            }
                break;
            case IDMPAuthDUP:
                authorization = [NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"",DUPclientversion,version,sipFlag,sipinfo,sdkversion,sdkversionValue,@"appid",appidString,sipEncFlag,@"1",ksBTID,BTID,ksUserName,userName,ksEnClientNonce,encryptClientNonce,kDUP_verificationcode,password,ksIOS_ID,deviceID,IDMPTraceId,traceId];
                break;
            case IDMPAuthVUP:
                authorization = [NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"",VUPclientversion,version,sipFlag,sipinfo,sdkversion,sdkversionValue,@"appid",appidString,sipEncFlag,@"1",ksBTID,BTID,ksUserName,userName,ksEnClientNonce,encryptClientNonce,kDUP_verificationcode,password,ksIOS_ID,deviceID,IDMPTraceId,traceId,@"voiceversion",voiceVersion];
                break;
            case IDMPUpdateKS:
            {
                NSDateFormatter *dateFormat = [IDMPDateFormatter cachedDateFormatter];
                NSString *currentDateStr = [dateFormat stringFromDate:[NSDate date]];
                authorization = [NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"", updateKSClientversion,version,sdkversion,sdkversionValue,@"appid",appidString,sipEncFlag,@"1",ksBTID,BTID,sipFlag,sipinfo,ksEnClientNonce,encryptClientNonce,ksIOS_ID,deviceID,systemTime,currentDateStr,httpsFlag,yesFlag,IDMPTraceId,traceId,ksSQN,sqn];
            }
                break;
        }
        
        NSString *Signature = secRSA_EVP_Sign(authorization);
        NSString *RC_data = [IDMPDevice getLocalUserDeviceData];
        self.heads = [NSDictionary dictionaryWithObjectsAndKeys:authorization,ksAuthorization,Signature,ksSignature,RC_data,kRC_data, nil];
    }
    return self;
}

@end
