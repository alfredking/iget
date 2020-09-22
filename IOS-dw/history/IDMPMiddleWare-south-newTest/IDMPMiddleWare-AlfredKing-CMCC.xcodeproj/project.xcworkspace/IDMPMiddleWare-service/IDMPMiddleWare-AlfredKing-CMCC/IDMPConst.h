//
//  IDMPConst.h
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking－cmcc on 14-8-25.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDMPConst : NSObject

#define requestUrl @"http://218.206.179.130:9042/client/authRequest"
//#define requestUrl @"http://north.cmpassport.com/client/authRequest"
//#define requestUrl @"http://192.168.107.226:8080/client/authRequest"
#define tokenUrl @"http://218.206.179.130:8080/ResReq/testUrl"
//#define tokenUrl @"http://218.206.179.130:9042/api/tokenValidate"
#define appCheckUrl @"http://218.206.179.130:9042/client/ckRequest"

#define pubKeyPath [[NSBundle mainBundle] pathForResource:@"serverPublicKey" ofType:@"pem"]
#define priKeyPath [[NSBundle mainBundle] pathForResource:@"clientPrivateKey" ofType:@"pem"]


//UP文本
#define ksUP_clientversion @"UP clientversion"
#define ksEnPasswd @"encpasswd"
#define ksUP_nonce @"UP Nonce"
#define ksPW_GBA @"PW_GBA"
#define ksUP_GBA @"PW_GBA_Ks"
#define ksPW_GBA_Value @"x-gbatype"

//临时短信文本
#define kDUP1_clientversion @"DUP1 clientversion"
#define kDUP2_clientversion @"DUP2 clientversion"
#define kDUP_verificationcode @"verificationcode"
#define kDUP_resultString @"DUP resultString"
#define ksTS_nonce @"DUP Nonce"
#define ksTS_GBA @"SS_GBA_Ks"

//Wap文本
#define ksWP_clientversion @"WP clientversion"
#define ksWP_nonce @"WP Nonce"
#define ksWP_GBA @"WP_GBA_Ks"
#define ksClientkek @"kek"

//数据短信文本
#define ksDS_clientversion @"HS clientversion"
#define ksRAND @"rand"
#define ksDS_GBA @"HS_GBA_Ks"
#define ksDS_nonce @"HS Nonce"
#define ksEnClientkek @"encckek"

//应用合法性检查
#define checkAppQuery @"query"
#define checkAppMac @"mac"
#define checkAppBundle @"bundleIdentifier"
#define checkAppSignature @"signature"

//公共文本
#define ksClientversion @"clientversion"
#define ksIOS_ID @"Phone_ID"
#define ksEnClientNonce @"enccnonce"
#define ksAuthorization @"Authorization"
#define ksSignature @"signature"
#define ksWWW_Authenticate @"WWW-Authenticate"
#define ksMac @"mac"
#define ksDomainName @"idmp.chinamobile.com"
#define kslifetime @"lifetime"
#define ksSQN @"sqn"
#define ksBTID @"BTID"
#define ksExpiretime @"expiretime"
#define ksGba_me @"gba-me"
#define ksResultCode @"resultCode"
#define ksUserName @"username"
#define userList @"accountsList"


typedef enum
{
    IDMPResultCodeSuccess = 103001,                    //正确返回
    IDMPTokenSuccess=103002,
    IDMPCheckAppSuccess = 103003
}
IDMPResultCode;

@end