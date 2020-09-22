//
//  IDMPWapMode.m
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking－cmcc on 14-8-21.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import "IDMPWapMode.h"
#import "NSString+IDMPAdd.h"
#import "IDMPHttpRequest.h"
#import "userInfoStorage.h"
#import "IDMPAuthModel.h"
#import "IDMPCheckKS.h"
#import "IDMPRusultHandler.h"
#import "IDMPDevice.h"
#import "IDMPUtility.h"

#define uniTelecomNetUrl PIECEURL(@"/client/uniTelecomNet")
#define uniTelecomAuthUrl PIECEURL(@"/client/uniTelecomAuth")

#define CTNET_clientversion @"CT_NET clientversion"
#define CUNET_clientversion @"CU_NET clientversion"


@implementation IDMPWapMode

-(void)getWapKSWithSipInfo:(NSString *)sipinfo traceId:(NSString *)traceId isTmpCache:(BOOL)isTmpCache successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    NSLog(@"start wap ks");
    OperatorName operatorName = [IDMPDevice getChinaOperatorName];
    switch (operatorName) {
        case CMCC:
            [self getKsWithOperatorName:CMCC cert:nil sipInfo:sipinfo traceId:traceId isTmpCache:isTmpCache successBlock:successBlock failBlock:failBlock];
            break;
        case CTCC:
        case CUCC:
        {
            [self getCertWithOperatorName:operatorName sipInfo:sipinfo traceId:traceId isTmpCache:isTmpCache successBlock:^(NSDictionary *paraments) {
                NSString *cert = paraments[@"WWW-Authenticate"];
                NSUInteger certLoc = [cert rangeOfString:@"cert="].location;
                if (certLoc == 0) {
                    cert = [cert substringFromIndex:5];
                }

                [self getKsWithOperatorName:operatorName cert:cert sipInfo:sipinfo traceId:traceId isTmpCache:isTmpCache successBlock:successBlock failBlock:failBlock];
            } failBlock:^(NSDictionary *paraments) {
                if (!paraments) {
                    paraments = @{IDMPResCode:@"102401",IDMPResStr:@"取号失败"};
                }
                failBlock(paraments);
            }];
        }
            break;
        case Unkown:
        {            
            NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:@"102205",IDMPResCode,@"当前环境不支持指定的登录方式",IDMPResStr, nil];
            failBlock(result);
        }
            break;
    }
}

- (void)getCertWithOperatorName:(OperatorName)operatorName sipInfo:(NSString *)sipinfo traceId:(NSString *)traceId isTmpCache:(BOOL)isTmpCache successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    NSString *clientNonce = [NSString idmp_getClientNonce];
    NSString *encryptClientNonce= [IDMPUtility rsaOrSM4EncryptWithRawData:clientNonce]; 
    NSString *deviceID = [IDMPDevice getDeviceID];

    NSString *authorization= [NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"", operatorName==CUCC?CUNET_clientversion:CTNET_clientversion,clientversionValue,sdkversion,sdkversionValue,kAPPID,appidString,sipEncFlag,yesFlag,sipFlag,sipinfo,ksClientkek,encryptClientNonce,ksIOS_ID,deviceID,IDMPTraceId,traceId];
    NSString *signature = [authorization idmp_RSASign];
    NSString *RC_data = [IDMPDevice getLocalUserDeviceData];
    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:authorization,ksAuthorization,signature,ksSignature,RC_data,kRC_data, nil];
    IDMPHttpRequest *request = [[IDMPHttpRequest alloc] init];
    [request getAsynWithHeads:heads url:uniTelecomNetUrl timeOut:20. successBlock:successBlock failBlock:failBlock];
}

- (void)getKsWithOperatorName:(OperatorName)operatorName cert:(NSString *)cert sipInfo:(NSString *)sipinfo  traceId:(NSString *)traceId isTmpCache:(BOOL)isTmpCache successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    NSString *clientNonce = [NSString idmp_getClientNonce];
    NSString *url = nil;
    NSDictionary *heads = nil;
    IDMPHttpRequest *request = [[IDMPHttpRequest alloc] init];
    if (operatorName == CMCC) {
        url = wapURL;
        heads = [[IDMPAuthModel alloc] initWPWithSipInfo:sipinfo clientNonce:clientNonce traceId:traceId isTmpCache:isTmpCache].heads;
        [request getWapAsynWithHeads:heads urlStr:url timeOut:20. isRetry:YES successBlock:^(NSDictionary *parameters) {
            @autoreleasepool {
                NSDictionary *wwwauthenticate = [IDMPCheckKS checkWAPKSIsValid:parameters clientNonce:clientNonce isTmpCache:isTmpCache];
                [IDMPRusultHandler getRusultByHandlerWWWAuthenticate:wwwauthenticate userName:nil authType:IDMPWP sipinfo:sipinfo traceId:traceId isTmpCache:isTmpCache successBlock:successBlock failBlock:failBlock];
            }
        } failBlock:failBlock];
    } else {
        if (operatorName == CUCC) {
            heads = [[IDMPAuthModel alloc] initCUCCWPWithCert:cert sipInfo:sipinfo clientNonce:clientNonce traceId:traceId isTmpCache:isTmpCache].heads;
        } else {
            heads = [[IDMPAuthModel alloc] initCTCCWPWithCert:cert sipInfo:sipinfo clientNonce:clientNonce traceId:traceId isTmpCache:isTmpCache].heads;
        }
        url = uniTelecomAuthUrl;
        [request getAsynWithHeads:heads url:url timeOut:20. successBlock:^(NSDictionary *parameters) {
            @autoreleasepool {
                NSDictionary *wwwauthenticate = [IDMPCheckKS checkWAPKSIsValid:parameters clientNonce:clientNonce isTmpCache:isTmpCache];
                [IDMPRusultHandler getRusultByHandlerWWWAuthenticate:wwwauthenticate userName:nil authType:IDMPWP sipinfo:sipinfo traceId:traceId isTmpCache:isTmpCache successBlock:successBlock failBlock:failBlock];
            }
        } failBlock:failBlock];
    }
}


@end
