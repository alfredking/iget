//
//  IDMPConst.h
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking－cmcc on 14-8-25.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDMPConst : NSObject

#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)

//杭研
#define hyURL @"http://112.54.207.14:"
#define hyport @"80"
//杭研上行短信接入号
#define hyUpSmsNum @"1069013329401"

//咪咕
#define miguURL @"http://passport.migu.cn:"
#define miguport @"80"
//咪咕上行短信接入号
#define miguUpSmsNum @"106581061"

//南方
#define southURL @"http://wap.cmpassport.com:"
#define southport @"8080"
//咪咕上行短信接入号
#define southUpSmsNum @"106581022"

#define URL [[NSUserDefaults standardUserDefaults] objectForKey:@"URL"]
#define port [[NSUserDefaults standardUserDefaults] objectForKey:@"port"]
#define UpSmsNum [[NSUserDefaults standardUserDefaults] objectForKey:@"UpSmsNum"]

//#define URL @"http://wap.cmpassport.com:"
//#define port @"8080"
//#define URL @"http://112.54.207.14:"
//#define port @"80"
#define PIECEURL(url,port,suburl) [NSString stringWithFormat:@"%@%@%@",url,port,suburl]

//#define APPID @"10000033"
//#define APPKEY @"88A01AB6F83BF946"
//#define requestUrl @"http://112.54.207.14:8080/client/authRequest"
//#define vcUrl @"http://218.206.179.130:9042/client/userManage"
//#define qapUrl @"http://211.136.10.131:8080/client/queryAppPsd"
//#define tokenUrl @"http://218.206.179.130:9042/api/tokenValidate"
//#define appCheckUrl @"http://218.206.179.130:9042/client/ckRequest"
#define requestUrl PIECEURL(URL,port,@"/client/authRequest")
#define vcUrl PIECEURL(URL,port,@"/client/userManage")
#define qapUrl PIECEURL(URL,port,@"/client/queryAppPsd")
#define tokenUrl PIECEURL(URL,port,@"/api/tokenValidate")
#define appCheckUrl PIECEURL(URL,port,@"/client/ckRequest")




/**
 验证token的接入环境
 公网  112.54.207.14:8080
 */
#define tokenValidateUrl @"http://112.54.207.14:8080/client/encryptionKey"


/*
 验证验证码的接入环境
 内网  192.168.12.104       192.168.11.181：8083
 公网  112.54.207.16:8082
 短信接入号：1065840410+104
 */
#define validateUrl @"http://112.54.207.16:8082/client/userManage"


/*
 风控数据采集的接入环境
 内网  192.168.11.179:8089
 公网  112.54.207.13:8089
 接入号：1065840480+179
 */
#define riskControlOuternetUrl @"http://112.54.207.13:8089/client/authRequest"

#define riskControlIntranetUrl @"http://192.168.11.179:8089/client/authRequest"


//存取本地的风控接口URL的文本key
#define riskURL @"riskURL"

#define riskControlURL [[NSUserDefaults standardUserDefaults] objectForKey:riskURL]


//UP文本
#define ksUP_clientversion @"UP clientversion"
#define ksEnPasswd @"encpasswd"
#define Encoldpasswd @"encoldpasswd"
#define ksUP_nonce @"UP Nonce"
#define ksPW_GBA @"PW_GBA"
#define ksUP_GBA @"PW_GBA_Ks"
#define ksPW_GBA_Value @"x-gbatype"

//临时短信文本
#define CVlientversion @"CV clientversion"//验证码校验获取凭证，返回cert
#define Vclientversion @"VC clientversion"//短信验证码获取
#define Rgclientversion @"RG clientversion"//注册
#define Cpclientversion @"CP clientversion"//修改密码
#define Rpclientversion @"RP clientversion"//重置密码
#define DUPclientversion @"DUP clientversion"
#define Validcode @"validcode"
#define kDUP_verificationcode @"verificationcode"
#define kDUP_resultString @"DUP resultString"
#define ksTS_nonce @"DUP Nonce"
#define ksTS_GBA @"SS_GBA_Ks"
#define TMMsgType @"msgtype"
#define TMIsdn @"msisdn"
#define TMUserManage @"UserManage"
#define kBusiType @"busiType"
#define kcert @"cert"

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
#define isChecked @"hasChecked"
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
#define userDetailInfo @"userDetailInfo"
#define getType @"gettype"
#define nowLoginUser @"nowLoginUser"

//sourceid
#define requestAppid @"CK appid"
#define requestAppPsd @"QAP souceid"
#define sourceidKey @"Query"
#define SIP @"isSipApp"
#define source @"sourceId"
#define eAppid @"eappid"

//设备参数文本
#define kDeviceToken @"push_token"
#define kopenUDID @"open_udid"
#define kIDFA @"idfa"
#define kIDFV @"idfv"
#define ksystemName @"systemName"
#define ksystemVersion @"systemVersion"
#define kos @"os"
#define kphoneModel @"dev_model"
#define kwifiSSID @"wifi_ssid"
#define kgatewayIP @"gatewayIP"
#define klongitude @"longitude"
#define klatitude @"latitude"
#define kloc_info @"loc_info"
#define kmnc @"mnc"
#define kRC_data @"rcData"



typedef enum
{
    IDMPResultCodeSuccess = 103000,                    //正确返回
    IDMPTokenSuccess=103002,
    IDMPCheckAppSuccess = 103003,
    /* 平台异常应答码 begin */
    IDMPSignValidateFail = 103101, // 签名验证出错
    IDMPSignAuthFail = 103102, // 签名校验失败
    IDMPUserNoExist = 103103, // 用户不存在
    IDMPN0SupportAuth = 103104, // 用户不支持该种登录方式
    IDMPErrorPassword = 103105,// 密码错误
    IDMPErrorUserName = 103106, // 用户名错误
    IDMPRandomExist = 103107, // 已存在相同的随机数
    IDMPSmsPasswordError = 103108, // 短信验证码错误
    IDMPSmsPasswordExpireError = 103109, // 短信验证码超时
    IDMPRandError = 103110, // 数据短信随机数和http请求随机数不一致(http+sms)
    IDMPWapIPError = 103111, // WAP网关IP不合法
    IDMPReqError = 103112, // 请求错误 reqError
    IDMPTokenValidateError = 103113, // Token内容错误
    IDMPKSExpireError = 103114, // token验证  KS过期
    IDMPKSNoExist = 103115, // token验证 KS不存在
    IDMPTVSqnError = 103116, // token验证 sqn错误
    IDMPMacError = 103117, // mac异常 macError
    IDMPSourceIdNoExist = 103118, // sourceid不存在
    IDMPAppIdNoExist = 103119, // appid不存在appidNoExist
    IDMPBtidNoExist = 103122, // btid不存在
    IDMPWapMobileNumberNoExist = 103134,//wap没有检测到本机号码
    IDMPDMError = 103201, // 数据库中间件服务异常 dmerror
    IDMPSBDecError = 103202, // 平台解密异常
    IDMPCacheUserNoExist = 103203, // 缓存用户不存在
    IDMPCacheRandNoExist = 103204, // 缓存随机数不存
    IDMPServiceError = 103205, // 服务器内部异常
    IDMPSecError = 103206, // 加密机异常 secError
    IDMPSendmsgError = 103207, // 调rpc发送短信失败
    IDMPInterfaceError = 103208, // 调用第三方接口失败
    IDMPSyncPasswordError = 103209, // 同步应用密码失败
    IDMPChangePWDError = 103210, // 修改密码失败
    IDMPOtherError = 103211, // 其它错误
    IDMPValidataUserError = 103212, // 用户验证失败
    IDMPRegisterUserExist = 103265, // 用户已存在
    IDMPRegisterUserPWDError = 103266, // 密码格式非法
    /* 平台异常应答码 end */
    /* 客户端异常应答码 begin */
    IDMPSuccess = 102000, // token请求成功
    IDMPNetworkDisable = 102101, // network error
    IDMPNetworkError = 102102, // network error
    IDMPAutoLoginFailed = 102201,// 自动登陆失败
    IDMPAPPCheckFailed = 102202, // appcheck failed
    IDMPParamInputError = 102203, // 输入参数错误
    IDMPGettokenRunning = 102204, // 正在gettoken处理
    IDMPLoginTypeNoSupport = 102205,// 当前环境不支持指定的登陆方式
    IDMPSelectedUserNoExist = 102206, // 选择用户登陆时，本地不存在指定的用户
    IDMPSipAppNoSupport = 102207, // SIP应用不支持选择登录方式
    IDMPDataSmsFailed = 102208, // data sms send failed
    IDMPResponseIsNull = 102220, // http响应值为空
    IDMPResponseNo200 = 102221, // http响应非200
    IDMPResponseNoResultCode = 102222, // http响应头中没有结果码
    IDMPResponseNoUName = 102223, // http响应头中没有返回用户名
    IDMPFailed = 102299, // other failed
    IDMPUserCancel = 102301, // 用户取消认证
    
    IDMPCacheUserEmpty = 102302,//缓存的用户列表为空
    IDMPUserNameEmpty = 102303,//用户名为空
    IDMPPasswordEmpty = 102304,//密码为空
    IDMPVerifySuccess = 102305,//验证码获得成功
    IDMPVerifyFail = 102306,//验证码获得失败
    IDMPUserNameFormatError = 102307,//用户名格式错误
    IDMPVerifyEmpty = 102308,//验证码为空
    IDMPVerifyFormatError = 102309,//验证码格式错误
    IDMPUserNameAndVerifyError = 102310,//用户名和验证码格式错误
    IDMPPasswordFormatError = 102311,//密码格式错误
    IDMPUserNameAndPasswordError = 102312,//用户名和密码格式错误
    IDMPDataSMSFail = 102313,//短信登录失败

    /* 平台异常应答码 end */

}
IDMPResultCode;

@end