//
//  IDMPRegisterMode.m
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by zwk on 14/11/24.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import "IDMPAccountManagerMode.h"
#import "IDMPDevice.h"
#import "IDMPParseParament.h"
#import "IDMPKDF.h"
#import "IDMPFormatTransform.h"
#import "IDMPToken.h"
#import "IDMPHttpRequest.h"
#import "IDMPTempSmsMode.h"
#import "NSString+IDMPAdd.h"
#import "userInfoStorage.h"
#import "IDMPPublicParam.h"
#import "IDMPUtility.h"

#define Encoldpasswd @"encoldpasswd"
#define Rgclientversion @"RG clientversion"
#define Cpclientversion @"CP clientversion"
#define Rpclientversion @"RP clientversion"
#define Validcode @"validcode"



@implementation IDMPAccountManagerMode

static IDMPAccountManagerMode *manager = nil;

+ (IDMPAccountManagerMode *)shareAccountManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[IDMPAccountManagerMode alloc]init];
    });
    return manager;
}

- (void)manageAccount:(NSString *)phoneNo passWord:(NSString *)password validCodeOrNewPwd:(NSString *)validCodeOrNewPwd option:(NSUInteger)option traceId:(NSString *)traceId finishBlock:(accessBlock) successBlock failBlock:(accessBlock)failBlock {
    if ([IDMPUtility checkNSStringisNULL:phoneNo] || [IDMPUtility checkNSStringisNULL:password] || [IDMPUtility checkNSStringisNULL:validCodeOrNewPwd]) {
        failBlock(@{IDMPResCode:@"102203",IDMPResStr:@"输入参数错误"});
        return;
    }
    if (![phoneNo idmp_isPhoneNum]) {
        failBlock(@{IDMPResCode:@"102307",IDMPResStr:@"用户名格式错误"});
        return;
    }
    if (![password idmp_isPassword]) {
        failBlock(@{IDMPResCode:@"102311",IDMPResStr:@"密码格式错误"});
        return;
    }
    if (option == IDMPChangePwd) {
        if (![validCodeOrNewPwd idmp_isPassword]) {
            failBlock(@{IDMPResCode:@"102311",IDMPResStr:@"密码格式错误"});
            return;
        }
    }
    
    NSString *clientNonce = [NSString idmp_getClientNonce];
    NSString *encryptClientNonce= [IDMPUtility rsaOrSM2EncryptWithRawData:clientNonce];
    
    NSMutableString *userManage = [IDMPPublicParam genPublicParamWithTraceId:traceId];
    [userManage appendString:[NSString stringWithFormat:@",%@=\"%@\"",ksEnClientNonce, encryptClientNonce]];
    [userManage appendString:[NSString stringWithFormat:@",%@=\"%@\"",IDMPMsisdn, phoneNo]];
#ifdef STATESECRET
    if (option == IDMPRegister || option == IDMPResetPwd) {
        [userManage appendString:[NSString stringWithFormat:@",%@=\"%@\"",@"pwdEncType",@"1"]];
    }
#endif
    NSString *encryptPassWd= [IDMPUtility rsaOrSM2EncryptWithRawData:password];
    switch (option) {
        case IDMPRegister:
            [userManage appendString:[NSString stringWithFormat:@",%@=\"%@\"",ksEnPasswd,encryptPassWd]];
            [userManage appendString:[NSString stringWithFormat:@",%@=\"%@\"",Validcode,validCodeOrNewPwd]];
            [userManage insertString:[NSString stringWithFormat:@"%@=\"%@\"",Rgclientversion, clientversionValue] atIndex:0];
            break;
        case IDMPResetPwd:
            [userManage appendString:[NSString stringWithFormat:@",%@=\"%@\"",ksEnPasswd,encryptPassWd]];
            [userManage appendString:[NSString stringWithFormat:@",%@=\"%@\"",Validcode,validCodeOrNewPwd]];
            [userManage insertString:[NSString stringWithFormat:@"%@=\"%@\"",Rpclientversion, clientversionValue] atIndex:0];
            break;
        case IDMPChangePwd:
        {
#ifdef STATESECRET
            [userManage appendString:[NSString stringWithFormat:@",%@=\"%@\"",@"pwdEncType",@"1"]];
#endif
            NSString *encryptPassWd = [IDMPUtility rsaOrSM2EncryptWithRawData:password];
            NSString *encryptNewPassWd = [IDMPUtility rsaOrSM2EncryptWithRawData:validCodeOrNewPwd];
            [userManage appendString:[NSString stringWithFormat:@",%@=\"%@\"",Encoldpasswd, encryptPassWd]];
            [userManage appendString:[NSString stringWithFormat:@",%@=\"%@\"",ksEnPasswd, encryptNewPassWd]];
            [userManage insertString:[NSString stringWithFormat:@"%@=\"%@\"",Cpclientversion, clientversionValue] atIndex:0];

        }
            break;
    }
    NSString *finalUserManage = [userManage copy];
    NSString *signature = [finalUserManage idmp_RSASign];
    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:finalUserManage,TMUserManage,signature,ksSignature, nil];
    IDMPHttpRequest *request = [[IDMPHttpRequest alloc]init];
    [request getAsynWithHeads:heads url:vcUrl timeOut:20 successBlock:^(NSDictionary *parameters){
         successBlock(@{IDMPResCode:[parameters objectForKey:IDMPResCode],IDMPResStr:@"success"});
     } failBlock:failBlock];
    
}

@end
