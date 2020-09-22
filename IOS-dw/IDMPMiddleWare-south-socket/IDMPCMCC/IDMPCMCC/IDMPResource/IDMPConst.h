//
//  IDMPConst.h
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking－cmcc on 14-8-25.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDMPConfigure.h"

@interface IDMPConst : NSObject

typedef void (^accessBlock)(NSDictionary *paraments);




#pragma mark - 便捷变量
#define currentNorth  (NSString *)[userInfoStorage getInfoWithKey:currentIsNorth]
#define currentDomain (NSString *)[userInfoStorage getInfoWithKey:currentIsDomain]
#define appidString   (NSString *)[userInfoStorage getInfoWithKey:IDMP_APPIDsk]
#define appkeyString  (NSString *)[userInfoStorage getInfoWithKey:IDMP_APPKEYsk]


#pragma mark - 地址
//#define domainURL @"http://218.205.115.220:"
//#define domainPort @"10085"
//#define SmsAccessNum @"106584040185"
#define domainURL [userInfoStorage getInfoWithKey:IDMPCONFIGS] ? (NSString *)[(NSDictionary *)[userInfoStorage getInfoWithKey:IDMPCONFIGS] objectForKey:IDMPHOST] : DefaultdomainURL
#define ipURL [userInfoStorage getInfoWithKey:IDMPCONFIGS] ? (NSString *)[(NSDictionary *)[userInfoStorage getInfoWithKey:IDMPCONFIGS] objectForKey:IDMPHOST_IP] : DefaultipURL
#define NorthForwardwapURL [userInfoStorage getInfoWithKey:IDMPCONFIGS] ? (NSString *)[(NSDictionary *)[userInfoStorage getInfoWithKey:IDMPCONFIGS] objectForKey:IDMPWAP_AUTH_URL] : DefaultNorthForwardwapURL
#define domainWapURL DefaultdomainWapURL

#define wapURL [currentNorth boolValue]? NorthForwardwapURL:domainWapURL
#define PIECEURL(suburl) [currentDomain boolValue]  ? [NSString stringWithFormat:@"%@%@",domainURL,suburl]:[NSString stringWithFormat:@"%@%@",ipURL,suburl]
#define requestUrl  PIECEURL(@"/client/authRequest")
#define requestHSUrl  PIECEURL(@"/client/hsAuth")
#define vcUrl PIECEURL(@"/client/userManage")
#define qapUrl PIECEURL(@"/client/queryAppPsd")
#define appCheckUrl PIECEURL(@"/client/ckRequest")
#define updateUrl PIECEURL(@"/client/updateKs")
#define cleanSsoUrl PIECEURL(@"/client/synLifeTime")
#define reAuthStatusReqUrl PIECEURL(@"/client/reAuthStatusRequest")
#define reAuthReqUrl PIECEURL(@"/client/reAuthRequest")
#define secCodeManageUrl PIECEURL(@"/client/secCodeManage")
#define configsUrl DefaultConfigURL
#define logReportUrl DefaultLogReportURL
#define ipHost @"211.136.10.131"


#pragma mark - 文本
//UP文本
#define ksEnPasswd @"encpasswd"


//临时短信文本

#define TMUserManage @"UserManage"


//Wap文本
#define ksWP_clientversion @"WP clientversion"
#define ksWP_nonce @"WP Nonce"
#define ksWP_GBA @"WP_GBA_Ks"
#define ksClientkek @"kek"

//应用合法性检查
#define isChecked @"hasChecked"
#define yesFlag @"1"
#define noFlag @"0"

//公共文本
#define ksClientversion @"clientversion"
#define ksIOS_ID @"Phone_ID"
#define IDMPTraceId @"traceId"
#define ksEnClientNonce @"enccnonce"
#define ksAuthorization @"Authorization"

#define ksSignature @"signature"
#define ksWWW_Authenticate @"WWW-Authenticate"
#define ksDomainName @"idmp.chinamobile.com"
#define ksUserName @"username"
#define userList @"accountsList"
#define userDetailInfo @"userDetailInfo"

//---------------SIP
#define isSipApp @"isSipApp"
#define isSip @"2"
#define noSip @"1"
#define sipPassword @"password"

#define sipEncFlag @"sipPwdEncFlag"

#define currentIsNorth @"secwapURL"
#define currentIsDomain @"currentisdomain"


#define clientversionValue @"1.0"

//sourceid
#define sipFlag @"isSipApp"

#define ksRAND @"rand"


#define kRC_data @"rcData"

#define IDMPKS @"KS"
#define IDMPBTID @"BTID"
#define IDMPSQN @"sqn"
#define IDMPOPENID @"openid"
#define IDMPMAC @"mac"
#define IDMPResCode @"resultCode"
#define IDMPResStr @"resultString"
#define IDMPbtid @"btid"

#define IDMPTmpUserInfo @"IDMPTmpUserInfo"

#define IDMPPassID @"passid"
#define IDMPMsisdn @"msisdn"
#define kAPPID @"appid"
#define IDMPUserName @"userName"

#define IDMPQuery  @"query"


//存储文本
#define AESEncKeysk @"AESEncKey"
#define IDMP_APPIDsk @"IDMP_APPID"
#define IDMP_APPKEYsk @"IDMP_APPKEY"
#define secCurrentURLsk @"secCurrentURL"
#define secDataSmsHttpTimesk @"secDataSmsHttpTime"
#define sourceIdsk @"sourceId"
#define lastVersionsk @"lastVersion"
#define secCurrentPortsk @"secCurrentPort"


#define SECLocalNumberYES @"102315"//检测是本机号码
#define SECLocalNumberNO @"102316"//检测非本机号码


#define ksUpdateDate @"ksUpdateDate"
#define httpsFlag @"httpsFlag"

//国密相关
#ifdef STATESECRET

#define sm2PUBLIC_KEY @"964FBF58663230CE0E2144831FF4B01EB77276B54E89104B07C784369E8B284EFF1521639607AE2CCEB40E6729AA918161B9BCC8C516898438C2D6B461C8080A"

#define PinCode @"x8_1s9!"
#define MskNameKey @"MskNameKey"    //本地msk库名称
#define NCANameKey @"NCANameKey"    //服务端返回的NCA名称

//test envi
//#define sm2PUBLIC_KEY @"48FBC40CF170AD23F52754DE5E002422B1AABCF317A04D23E2214993C8D2C7AC85F4BCC1D8BA059227740FDA99CE9B836A31FD19A8C02F8FAFB8EAA0F6D396B3"

#define sm2Index 21
#define sm4Index 37

#endif




//配置文本
#define IDMPCONFIGS                 @"IDMPConfigs"
#define IDMPHOST_IP                 @"host_ip"
#define IDMPWAP_AUTH_URL            @"wap_auth_url"
#define IDMPHOST                    @"host"
#define IDMPCUCC_SMS                @"cucc_sms"
#define IDMPCMCC_SMS                @"cmcc_sms"
#define IDMPCTCC_SMS                @"ctcc_sms"
#define IDMPNON_CMCC_LOGIN_FLAG     @"non_cmcc_login_flag"
#define IDMPLastGetConfigDate       @"IDMPLastGetConfigDate"

#pragma mark - 打印调用者
#define PrintCaller    NSString *sourceString = [[NSThread callStackSymbols] objectAtIndex:1];\
NSCharacterSet *separatorSet = [NSCharacterSet characterSetWithCharactersInString:@" -[]+?.,"];\
NSMutableArray *array = [NSMutableArray arrayWithArray:[sourceString  componentsSeparatedByCharactersInSet:separatorSet]];\
[array removeObject:@""];\
NSString *stack          = [array objectAtIndex:0];\
NSString *framework      = [array objectAtIndex:1];\
NSString *memoryAddress  = [array objectAtIndex:2];\
NSString *classCaller    = [array objectAtIndex:3];\
NSString *functionCaller = [array objectAtIndex:4];\
NSString *lineCaller     = [array objectAtIndex:5];\
NSLog(@"[%@ %@]-%@",classCaller,functionCaller,[NSString stringWithUTF8String:__func__]);




#pragma mark - 版本号
#define sdkversion @"sdkversion"
#ifdef CELLULARFREE
#define sdkversionValue @"andidmp-iosv3.2.0.5-cellular-free"
#elif STATESECRET
#define sdkversionValue @"andidmp-iosv3.1.7.1-state-secret"
#else
#define sdkversionValue @"andidmp-iosv3.2.4"
#endif


#pragma mark - 返回码
typedef enum
{
    IDMPResultCodeSuccess = 103000,                    //正确返回
    IDMPResultCodeRecentlyUpdated=103200,
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
    IDMPWapIPError = 103111, // WAP网关IP不合法/错误
    IDMPReqError = 103112, // 请求错误 reqError/错误的请求
    IDMPTokenValidateError = 103113, // Token内容错误
    IDMPKSExpireError = 103114, // token验证  KS过期
    IDMPKSNoExist = 103115, // token验证 KS不存在
    IDMPTVSqnError = 103116, // token验证 sqn错误
    IDMPMacError = 103117, // mac异常 macError
    IDMPSourceIdNoExist = 103118, // sourceid不存在
    IDMPAppIdNoExist = 103119, // appid不存在appidNoExist
    IDMPClientauthNoExist = 103120, //clientauth不存在
    IDMPPassIDNOExist = 103121, //passid不存在
    IDMPBtidNoExist = 103122, // btid不存在
    IDMPRedisInfoNOExist = 103123, //redisinfo不存在
    IDMPKsnafError = 103124, //ksnaf校验不一致
    IDMPMsisdnFormatError = 103125, //手机号格式错误
    IDMPMobileNumberNoExist = 103126, //手机号不存在
    IDMPCrtCheckTimeoutError = 103127, //证书验证：版本过期
    IDMPWebServiceError = 103128, //gba:webservice error
    IDMPMsgTypeError = 103129, //获取短信验证码的msgtype异常
    IDMPOldPWDCanNotBeNewPWDError = 103130, //新密码不能与当前密码相同
    IDMPPasswordTooSimpleError = 103131, //密码过于简单
    IDMPRegisterUserError = 103132, //用户注册失败
    IDMPSourceidIlegal = 103133, //sourceid不合法
    IDMPWapMobileNumberNoExist = 103134,//wap没有检测到本机号码/wap方式手机号码为空
    IDMPNickNameIlegal = 103135, //昵称非法
    IDMPEmailIlegal = 103136, //邮箱非法
    IDMPRequestOtherPlatformError = 103137, //请求其他平台token验证接口时异常
    IDMPAppIDIsExistError = 103138, //appid已存在
    IDMPSourceIDIsExistError = 103139, //sourceid已存在
    IDMPDMError = 103201, // 数据库中间件服务异常 dmerror
    IDMPSBDecError = 103202, // 平台解密异常
    IDMPCacheUserNoExist = 103203, // 缓存用户不存在
    IDMPCacheRandNoExist = 103204, // 缓存随机数不存在
    IDMPServiceError = 103205, // 服务器内部异常
    IDMPSecError = 103206, // 加密机异常 secError
    IDMPSendmsgError = 103207, // 调rpc发送短信失败
    IDMPInterfaceError = 103208, // 调用第三方接口失败
    IDMPSyncPasswordError = 103209, // 同步应用密码失败
    IDMPChangePWDError = 103210, // 修改密码失败
    IDMPOtherError = 103211, // 其它错误
    IDMPValidataUserError = 103212, // 用户验证失败/校验密码失败
    IDMPOldPasswordError = 103213, //旧密码失败
    IDMPRegisterUserExist = 103265, // 用户已存在
    IDMPRegisterUserPWDError = 103266, // 密码格式非法
    IDMPPasswordLenthError = 103267, //密码长度非法
    IDMPRandomCertTimeOutError = 103270, //随机校验凭证过期
    IDMPRandomCertError = 103271, //随机校验凭证错误
    IDMPRandomCertNotExistError = 103272, //随机校验凭证不存在
    
    IDMPSipSuccess = 103300, //sip 成功状态码
    IDMPSipTokenError = 103301, //sip token check failed
    IDMPSipUserExistError = 103302, //sip 用户已存在
    IDMPSipGetPassUserNotExistError = 103303, //sip 用户未开户（获取应用密码）
    IDMPSipOffUserNotExistError = 103304, //sip 用户未开户（注销用户）
    IDMPSipOpenAccountUserNameError = 103305, //sip 开户用户名错误
    IDMPSipGetPassUserNameNotNullError = 103306, //sip 用户名不能为空（获取应用密码）
    IDMPSipOffUserNameNotNullError = 103307, //sip 用户名不能为空（注销用户）
    IDMPSipUserNameError = 103308, //sip 手机号不合法
    IDMPSipOperTypeNullError = 103309, //sip opertype 为空
    IDMPSipSourceIDNotExistError = 103310, //sip sourceid 为空
    IDMPSipSourceIDIlegal = 103311, //sip sourceid 不合法
    IDMPSipBtidNotExistError = 103312, //sip btid 不存在
    IDMPSipKsNotExistError = 103313, //sip ks 不存在
    IDMPSipSysError = 103399, //sip sys 错误
    IDMPAuthorizationNullError = 103400, //authorization 为空
    IDMPSignatureNullError = 103401, //签名消息为空
    IDMPAuthwayInvalidError = 103402, //无效的 authWay
    IDMPDefaultRegisterUserError = 103403, //默认注册失败
    IDMPEncryptionError = 103404, //加密失败
    IDMPMsisdnIsNullError = 103405, //保存数据短信手机号为空
    IDMPDataMsgIsNullError = 103406, //保存数据短信短信内容为空
    IDMPAkExistError = 103407, //此sourceId, appPackage, sign已注册
    IDMPAkSourceidUpperLimitError = 103408, //此sourceId注册已达上限  99次
    IDMPQueryNullError = 103409, //query 为空
    IDMPMacInvalidError = 103410, //无效的mac
    IDMPQueryInvalidError = 103411, //无效的qurey
    IDMPRequestNullError = 103412, //无效的请求
    IDMPRuntimeExceptionError = 103413, //运行时异常
    IDMPParameterValidateFailedError = 103414, //参数效验异常
    
    IDMPSecRegisterUserInBlackList = 103500, //注册用户处于黑名单，无法操作
    IDMPSecChangePassUserInBlackList = 103501, //修改密码用户处于黑名单，无法操作
    IDMPSecResetPassUserInBlackList = 103502, //重置密码用户处于黑名单，无法操作
    IDMPSecLoginUserInBlackList = 103503, //登录用户处于黑名单，无法操作
    
    IDMPATMobileNumberError = 103801, //aoi token 手机号码非法
    IDMPATMobileNumberNotRegister = 103802, //aoi token 手机号码未注册
    IDMPATRequestTimeOut = 103803, //aoi token 请求超时
    IDMPATUserAffirm = 103804, //aoi token 用户已确认登录
    IDMPATUserCancel = 103805, //aoi token 用户已取消登录
    IDMPATSourceIDError = 103806, //aoi token sourceid不合法
    IDMPATUserNoOnline = 103807, //aoi 用户不在线
    IDMPATUserNoAffirm = 103808, //aoi 短信已发送，用户还未确认
    IDMPATMsgSendFail = 103809, //aoi 短信发送失败
    IDMPATOtherError = 103899, //aoi token 其他错误
    IDMPPlatformMigrationAccessError = 103906,
    /* 平台异常应答码 end */
    
    
    /* 客户端异常应答码 begin */
    IDMPSuccess = 102000, // token请求成功
    IDMPNetworkDisable = 102101, // network error
    IDMPNetworkError = 102102, // network error
//    IDMPAutoLoginFailed = 102201,// 自动登陆失败
//    IDMPAPPCheckFailed = 102202, // appcheck failed
    IDMPParamInputError = 102203, // 输入参数错误
//    IDMPGettokenRunning = 102204, // 正在gettoken处理
    IDMPLoginTypeNoSupport = 102205,// 当前环境不支持指定的登陆方式
    IDMPSelectedUserNoExist = 102206, // 选择用户登陆时，本地不存在指定的用户
    IDMPSipAppNoSupport = 102207, // SIP应用不支持选择登录方式
    IDMPDataSmsFailed = 102208, // data sms send failed
//    IDMPResponseIsNull = 102220, // http响应值为空
//    IDMPResponseNo200 = 102221, // http响应非200
//    IDMPResponseNoResultCode = 102222, // http响应头中没有结果码
//    IDMPResponseNoUName = 102223, // http响应头中没有返回用户名
    IDMPCheckFailed = 102298,  //应用合法性校验失败
//    IDMPFailed = 102299, // other failed
    
    
    IDMPUserCancel = 102301, // 用户取消认证
    
    IDMPCacheUserEmpty = 102302,//缓存的用户列表为空
    IDMPUserNameEmpty = 102303,//用户名为空
    IDMPPasswordEmpty = 102304,//密码为空
    IDMPVerifySuccess = 102305,//验证码获得成功
    IDMPVerifyFail = 102306,//验证码获得失败
    IDMPUserNameFormatError = 102307,//用户名格式错误
    IDMPVerifyEmpty = 102308,//验证码为空
    IDMPVerifyFormatError = 102309,//验证码格式错误
//    IDMPUserNameAndVerifyError = 102310,//用户名和验证码格式错误
    IDMPPasswordFormatError = 102311,//密码格式错误
//    IDMPUserNameAndPasswordError = 102312,//用户名和密码格式错误
    IDMPDataSMSFail = 102313,//短信登录失败
    IDMPNoUserCache = 102314,//指定用户缓存不存在
    IDMPGetTokenFail = 102317,//token生成失败
//    IDMPOpenidEmpty = 102318,//获取的openid为空
    IDMPConfigsNoChange = 102319,//获取的配置与缓存配置相同
    IDMPConfigsNoExcessData = 102320,//获取的配置没有超过时间限制
    IDMPLogReportNotAllowed = 102321,//不允许日志上报

    IDMPTimeOut = 102400,//响应超时
    IDMPGetCertFail = 102401,//取号失败
    IDMPNCAFail = 102402,//mk生成mk失败
    IDMPKVFail = 102403,//mk上传后没有返回kv
    /* 平台异常应答码 end */
}
IDMPResultCode;



@end