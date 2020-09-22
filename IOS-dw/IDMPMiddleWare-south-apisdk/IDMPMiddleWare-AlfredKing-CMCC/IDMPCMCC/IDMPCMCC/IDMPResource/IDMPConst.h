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
//判断真机和模拟器
#if TARGET_IPHONE_SIMULATOR
#define SIMULATOR 1
#elif TARGET_OS_IPHONE
#define SIMULATOR 0
#endif


#define appidString     [[NSUserDefaults standardUserDefaults] objectForKey:@"IDMP_APPID"]
#define appkeyString    [[NSUserDefaults standardUserDefaults] objectForKey:@"IDMP_APPKEY"]

//线上环境
//#define URL             @"http://wap.cmpassport.com:"
//#define port            @"8080"
//#define SmsAccessNum    @"106581023"

//联调环境
//#define URL             @"http://218.205.115.220:"
//#define port            @"10086"
//#define SmsAccessNum    @"106584040190"


//线上环境https
//#define URL             @"https://wap.cmpassport.com:"
//#define port            @"8443"
//#define SmsAccessNum    @"106581023"

#define httpsURL             [[[NSUserDefaults standardUserDefaults] objectForKey:@"IDMP_environment"] isEqualToString:@"debug"] ? @"http://218.205.115.220:" : @"https://wap.cmpassport.com:"
#define httpsPort            [[[NSUserDefaults standardUserDefaults] objectForKey:@"IDMP_environment"] isEqualToString:@"debug"] ? @"10086" : @"8443"
#define SmsAccessNum    [[[NSUserDefaults standardUserDefaults] objectForKey:@"IDMP_environment"] isEqualToString:@"debug"] ? @"106584040190" : @"106581023"
#define httpURL             [[[NSUserDefaults standardUserDefaults] objectForKey:@"IDMP_environment"] isEqualToString:@"debug"] ? @"http://218.205.115.220:" : @"http://wap.cmpassport.com:"
#define httpPort            [[[NSUserDefaults standardUserDefaults] objectForKey:@"IDMP_environment"] isEqualToString:@"debug"] ? @"10086" : @"8080"


//https://wap.cmpassport.com:8443/ua/sdkAuth?func=createKeystore
//https://wap.cmpassport.com:8443/ua/sdkAuth?func=queryKS
//https://wap.cmpassport.com:8443/ua/client/ckRequest

#define PIECEURL(url,port,suburl) [NSString stringWithFormat:@"%@%@%@",url,port,suburl]

#define ckRequestUrl        PIECEURL(httpsURL,httpsPort,@"/ua/client/ckRequest")
#define authLoginUrl        PIECEURL(httpsURL,httpsPort,@"/ua/apiAuth?func=authLogin")
#define httpAuthLoginUrl    PIECEURL(httpURL,httpPort,@"/ua/apiAuth?func=authLogin")
#define createKSUrl         PIECEURL(httpsURL,httpsPort,@"/ua/sdkAuth?func=createKeystore")
#define queryKSUrl          PIECEURL(httpsURL,httpsPort,@"/ua/sdkAuth?func=queryKS")
#define getSmsCodeUrl       PIECEURL(httpsURL,httpsPort,@"/ua/apiAuth?func=GetSMSCodeRequest")
#define checkSmsUrl         PIECEURL(httpsURL,httpsPort,@"/ua/apiAuth?func=CheckSMSCodeRequest")
#define mobileDecodeUrl     PIECEURL(httpsURL,httpsPort,@"/ua/apiAuth?func=MobileDecodeRequest")
#define tokenValidateUrl    PIECEURL(httpURL,httpPort,@"/api/passportValidate")


//UP文本
#define ksUP_clientversion @"UP clientversion"
#define ksEnPasswd @"encpasswd"
#define Encoldpasswd @"encoldpasswd"
#define ksUP_nonce @"UP Nonce"
#define ksPW_GBA @"PW_GBA"
#define ksUP_GBA @"PW_GBA_Ks"
#define ksPW_GBA_Value @"x-gbatype"

//临时短信文本
#define Vclientversion @"VC clientversion"
#define Rgclientversion @"RG clientversion"
#define Cpclientversion @"CP clientversion"
#define Rpclientversion @"RP clientversion"
#define DUPclientversion @"DUP clientversion"
#define Validcode @"validcode"
#define kDUP_verificationcode @"verificationcode"
#define kDUP_resultString @"DUP resultString"
#define ksTS_nonce @"DUP Nonce"
#define ksTS_GBA @"SS_GBA_Ks"
#define TMMsgType @"msgtype"
#define TMIsdn @"msisdn"
#define TMUserManage @"UserManage"

//Wap文本
#define ksWP_clientversion @"WP clientversion"
#define ksWP_nonce @"WP Nonce"
#define ksWP_GBA @"WP_GBA_Ks"
#define ksClientkek @"kek"

#define ksWP_certClientversion @"WP_AUTH clientversion"
#define ksWP_certAuthType @"WP_AUTH"

//数据短信文本
#define ksDS_clientversion @"HS clientversion"
#define ksRAND @"rand"
#define ksDS_GBA @"HS_GBA_Ks"
#define ksDS_nonce @"HS Nonce"
#define ksEnClientkek @"encckek"

#define ksDS_certClientversion @"HS_AUTH clientversion"
#define ksDS_certAuthType @"HS_AUTH"

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
#define ksWWW_Authenticate @"Www-Authenticate"
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


#define ks_CK_SDK_cnonce @"CK_SDK cnonce"
#define ks_cert @"cert"
#define ks_appid @"appid"
#define ks_appkey @"appkey"
#define KS_QK_SDK_hmac @"QK_SDK hmac"


//sourceid
#define requestAppid @"CK appid"
#define requestAppPsd @"QAP souceid"
#define sourceidKey @"Query"
#define SIP @"isSipApp"
#define source @"sourceId"
#define eAppid @"eappid"


#define certAuthtype @"authtype"

#define sdkversion @"sdkversion"
#define sdkversionValue @"api+sdk"


//设备参数文本
#define kDeviceToken @"push_token"
#define kopenUDID @"open_udid"
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
    /* 平台异常应答码 end */
    
    
    /* 客户端异常应答码 begin */
    IDMPSuccess = 102000, // token请求成功
    IDMPNetworkDisable = 102101, // network error
    IDMPNetworkError = 102102, // network error
    IDMPKSTimeExpireError = 102114, //ks过期
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
    IDMPCheckFailed = 102298,  //应用合法性校验失败
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
