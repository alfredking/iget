//
//  IDMPAutoLoginViewController.h
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking－cmcc on 14-9-15.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface IDMPAutoLoginViewController :NSObject

typedef void (^accessBlock)(NSDictionary *paraments);



/**
 *  此函数获取当前的网络状态，在主线程调用会有超时被系统强制结束造成应用崩溃的风险，需要在子线程中调用
 *
 *  @return 网络状态。“0”表示同时开启wifi和蜂窝网络；“1”表示只开启蜂窝网络；“2”表示连有wifi且有中国移动SIM卡，但没有开启无蜂窝网络；“3”表示连有wifi，但没有有中国移动SIM卡和没有开启无蜂窝网络；“-1”表示无网络。
 */
- (int)getAuthType;


/**
 接口用于获取运营商标识

 @return 运营商标识。“0”表示中国移动；“1”表示中国联通；“2”表示中国电信；“-1”表示无法识别。
 */
- (int)getOperatorType;


/**
 *  接口用于初始化appid、appkey、设置。
 *  建议在appDelegate中调用。
 *  @param appid        应用的AppID
 *  @param appkey       应用密钥
 *  @param aTime        请求超时时间等设置
 *  @param successBlock 初始化成功时调用，由应用开发者自行实现。
 *  @param failBlock    初始化失败时调用，由应用开发者自行实现。
 */
- (void)validateWithAppid:(NSString *)appid appkey:(NSString *)appkey timeoutInterval:(float)aTime finishBlock:(accessBlock)successBlcok failBlock:(accessBlock)failBlock;

/**
 *  接口用于获取统一认证的身份标识。
 *  如果一个号码曾经调用本接口或者getAccessTokenByConditionWithUserName接口成功获取过身份标识，则会有该号码的本地缓存。
 *  此接口在没有缓存的情况下会重新协商获取身份标识，此时userName必须传nil且获得的身份标识为本手机号码。
 *  此接口在有缓存的情况下会视情况用缓存获取身份标识。
 *  对于用本机号码的缓存登录，userName参数可以传nil，也可以传本机号码。不过传nil时如果遇到没有本机号码缓存的情况，则会重新协商获取身份标识。
 *  对于用非本机号码的缓存登录，userName参数必须传非本机号码，且这个号码是曾经调用getAccessTokenByConditionWithUserName接口获取身份标识。如果遇到没有此号码缓存的情况，会报错。
 *  如果为sip应用需要返回应用密码则调用getAppPassword接口来完成。
 *  本接口可以和getAuthType接口一起结合使用。
 *
 *  @param userName        指定用户登陆时的用户名。如果传入nil，会用本机号码登录。如果传入手机号，则代表用缓存登录。
 *  @param loginType       指定登录方式.0表示wifi和蜂窝网络同时开启时走蜂窝网络方式;1表示蜂窝网络方式,须开启蜂窝网络,wifi可开可不开;
 *                         2表示数据短信方式,须连接网络。
 *                         在没有缓存的情况下，如果传2，会弹出发送短信界面，需用户点击发送，才能获取身份标识。
 *                         在有缓存的情况下，如果传2，会用缓存所以不会有界面弹出。
 *  @param isUserDefaultUI 不再支持，填写NO
 *  @param successBlock    获取身份标识成功之后使用的block方法，由应用开发者自行实现。
 *  @param failBlock       获取身份标识失败之后使用的block方法，由应用开发者自行实现。
 */
- (void)getAccessTokenWithUserName:(NSString *)userName andLoginType:(NSUInteger)loginType isUserDefaultUI:(BOOL)isUserDefaultUI finishBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock;



/**
 *  接口用于获取非本机号码的统一认证的身份标识。
 *  此接口在获取身份标识成功后会有这个号码的本地缓存。
 *
 *  @param userName     登陆的用户名。
 *  @param content      认证方式为1时需要传入的内容为用户密码,认证方式为2时需要传入的内容为短信验证码。
 *  @param loginType    选择认证方式：1表示使用固定密码登陆,2表示使用临时密码登陆。
 *  @param successBlock 获取身份标识之后执行的block方法，有调用者自行实现。
 *  @param failBlock    获取身份标识之后执行的block方法，有调用者自行实现。
 */
- (void)getAccessTokenByConditionWithUserName:(NSString *)userName Content:(NSString *)content andLoginType:(NSUInteger)loginType finishBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock;



/**
 *  接口用于sip应用获取统一认证身份标识以及sip密码
 *  此接口和getAccessTokenByConditionWithUserName类似，但是会多返回一个sip密码。
 *
 *  @param userName     登陆的用户名。
 *  @param content      认证方式为1时需要传入的内容为用户密码,认证方式为2时需要传入的内容为短信验证码。
 *  @param loginType    选择认证方式.为1时使用固定密码登陆;为2时使用临时密码登陆。
 *  @param successBlock 获取应用密码成功之后执行的block方法，有调用者自行实现。
 *  @param failBlock    获取应用密码失败之后执行的block方法，有调用者自行实现。
 */
- (void)getAppPasswordByConditionWithUserName:(NSString *)userName Content:(NSString *)content andLoginType:(NSUInteger)loginType finishBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock;


/**
 *  接口用于sip应用获取统一认证身份标识以及sip密码。
 *  此接口与getAccessTokenWithUserName类似，但是会多返回一个sip密码。
 *
 *  @param userName        指定用户登陆时的用户名。如果传入nil，会用本机号码登录。如果传入手机号，则代表用缓存登录。
 *  @param loginType       指定登录方式.0表示wifi和蜂窝网络同时开启时走蜂窝网络方式;1表示蜂窝网络方式,须开启蜂窝网络,wifi可开可不开;
 *                         2表示数据短信方式,须连接网络。
 *                         在没有缓存的情况下，如果传2，会弹出发送短信界面，需用户点击发送，才能获取身份标识。
 *                         在有缓存的情况下，如果传2，会用缓存所以不会有界面弹出。
 *  @param isUserDefaultUI 不再支持，填写NO
 *  @param successBlock    获取身份标识成功之后使用的block方法，由应用开发者自行实现。
 *  @param failBlock       获取身份标识失败之后使用的block方法，由应用开发者自行实现。
 */
- (void)getAppPasswordWithUserName:(NSString *)userName andLoginType:(NSUInteger)loginType isUserDefaultUI:(BOOL)isUserDefaultUI finishBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock;





/**
 *  接口用于第三方应用进行用户注册，本接口仅支持手机号码注册
 *
 *  @param phoneNo      手机号码；
 *  @param password     注册用户的密码；
 *  @param validCode    短信验证码；
 *  @param successBlock 注册用户成功时调用，由应用开发者自行实现。
 *  @param failBlock    注册用户失败时调用，由应用开发者自行实现。
 */
- (void)registerUserWithPhoneNo:(NSString *)phoneNo passWord:(NSString *)password andValidCode:(NSString *)validCode finishBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock;


/**
 *  接口用于第三方应用重置密码
 *
 *  @param phoneNo      手机号码；
 *  @param password     重置后的新密码；
 *  @param validCode    短信验证码
 *  @param successBlock 重置密码成功时调用，由应用开发者自行实现。
 *  @param failBlock    重置密码失败时调用，由应用开发者自行实现。
 */
- (void)resetPasswordWithPhoneNo:(NSString *)phoneNo passWord:(NSString *)password andValidCode:(NSString *)validCode finishBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock;


/**
 *  接口用于第三方应用密码修改
 *
 *  @param phoneNo      手机号码；
 *  @param password     旧密码；
 *  @param newpassword  新密码
 *  @param successBlock 修改密码成功时调用，由应用开发者自行实现。
 *  @param failBlock    修改密码失败时调用，由应用开发者自行实现。
 */
- (void)changePasswordWithPhoneNo:(NSString *)phoneNo passWord:(NSString *)password andNewPSW:(NSString *)newpassword finishBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock;


/**
 *  接口用于第三方应用在Token验证失败时调用此方法清理本地环境使用。
 *
 *  @return YES清除缓存成功
 */
- (BOOL)cleanSSO;


/**
 *  接口用于根据用户名清除其对应的缓存
 *
 *  @param userName 输入的用户名
 *
 *  @return YES清除缓存成功
 */
- (BOOL)cleanSSOWithUserName:(NSString *)userName;



/**
 接口用于有日志版本打印当前版本号。
 */
- (NSString *)currentEdition;



/**
 *	接口用于判断当前手机号码是否为本机号码
 *
 *  @param userName   手机号码；
 *
 *  @param successBlock 手机号码变化做的操作，由应用开发者自行实现。
 *  @param failBlock    手机号码不变(包括无法检测)的操作，由应用开发者自行实现。
 */
-(void)checkIsLocalNumberWith:(NSString *)userName finishBlock:(accessBlock) successBlock failBlock:(accessBlock )failBlock;





/**
 接口用于二次鉴权
 
 @param userName 手机号码
 @param successBlock 二次鉴权成功时回调，由开发者自行实现
 @param failBlock 二次鉴权失败时回调，由开发者自行实现
 */
- (void)reAuthenticationWithUserName:(NSString *)userName successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock;


/**
 接口用于免流查询

 @param successBlock 成功时回调，由开发者自行实现
 @param failBlock 失败时回调，由开发者自行实现
 */
- (void)freeDataAuthWithSuccessBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock;

/**
 *  接口用于获取统一认证的身份标识。
 *  此接口每次都重新协商获取身份标识，不会使用缓存。
 *  此接口可以和getAuthType接口一起结合使用。
 *
 *  @param loginType       指定登录方式.0表示wifi和蜂窝网络同时开启时走蜂窝网络方式;1表示蜂窝网络方式,须开启蜂窝网络,wifi可开可不开;
 *                         2表示数据短信方式,须连接网络。
 *  @param successBlock    获取身份标识成功之后使用的block方法，由应用开发者自行实现。
 *  @param failBlock       获取身份标识失败之后使用的block方法，由应用开发者自行实现。
 */
- (void)getAccessTokenNoCacheWithLoginType:(NSUInteger)loginType finishBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock;

@end



