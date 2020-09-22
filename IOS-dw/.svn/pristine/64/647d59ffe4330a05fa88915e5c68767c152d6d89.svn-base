//
//  FreeDataAuthMode.m
//  IDMPCMCC
//
//  Created by wj on 2017/11/30.
//  Copyright © 2017年 zwk. All rights reserved.
//

#import "FreeDataAuthMode.h"
#import "IDMPHttpRequest.h"
#import "IDMPDevice.h"
#import "NSString+IDMPAdd.h"
#import "NSData+IDMPAdd.h"
#import "IDMPOpensslDigest.h"
#import "IDMPKDF.h"
#import "IDMPFormatTransform.h"
#import "IDMPParseParament.h"
#import "PhoneSimCardSeparateAlertView.h"
#import "UnsubscibePromptView.h"
#import "IDMPQueryModel.h"
#import "IDMPDate.h"
#import "UIColor+Hex.h"
#import "IDMPScreen.h"
#import "IDMPUtility.h"
#import "userInfoStorage.h"

#define flowAuth @"http://wap.cmpassport.com:8080/client/flowAuthRequest"

#define flowManage PIECEURL(@"/client/flowManage")
#define sdkversionFlowValue [NSString stringWithFormat:@"%@_FLOW",sdkversionValue]
#define FM_clientversion @"FM clientversion"
#define FMAuthorization @"flowManage"

#define PhoneSimCardSepMessage1 @"亲爱的用户：\n        您正在使用4G+终端定向流量优惠，但检测到您并非使用绑定的手机终端或未开启应用授权；如果继续当前操作，按照业务规则将为您退订该优惠。建议您用回原手机或为应用开启“获取手机信息”等权限。\n退订后次月生效，若您后续用回原手机终端或开启授权，将提示您续订并实时生效。"
#define PhoneSimCardSepMessage2 @"继续当前操作，将为您退订该优惠，次月月初生效。"

typedef NS_ENUM(NSUInteger, FlowManageMode) {
    FlowQueryStatus = 1,        //状态查询
    FlowSubscribe,              //订购
    FlowReject,                 //拒绝订购
    FlowUnsubscribe,            //退订
    FlowRemainQuery             //剩余流量查询
};

@implementation FreeDataAuthMode

+ (void)freeDataAuthWithTraceId:(NSString *)traceId successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    BOOL isCellularOpened = [IDMPDevice checkCellular];
    BOOL isChinaMobile = [IDMPDevice checkChinaMobile];
    if (!isCellularOpened || !isChinaMobile) {
        NSLog(@"当前环境不支持");
        failBlock(@{IDMPResCode:@"102205",IDMPResStr:@"当前环境不支持"});
        return;
    }
    NSString *appid = appidString;
    NSString *appkey = appkeyString;
    NSLog(@"appid is %@", appid);
    [IDMPQueryModel checkWithAppId:appid andAppkey:appkey traceId:traceId finishBlock:^(NSDictionary *paraments) {
        //4g取号协商
        NSLog(@"4g取号协商");
        [self getWPInfoWithAppid:appid traceId:traceId successBlock:^(NSDictionary *paraments) {
            NSString *ks = paraments[IDMPKS];
            NSString *btid = paraments[IDMPBTID];
            //订购状态查询
            NSLog(@"订购状态查询");
            [self flowManageWithAppid:appid actionId:FlowQueryStatus rand:nil btid:btid ks:ks traceId:traceId successBlock:^(NSDictionary *paraments) {
                NSString *queryHret = paraments[@"hret"];
                if (!([queryHret isEqualToString:@"1"] && [paraments[@"needDialog"] isEqualToString:@"1"])) {
                    NSDictionary *res = [NSDictionary dictionaryWithObjectsAndKeys:@"102000",IDMPResCode,@"成功",IDMPResStr,queryHret,@"state", nil];
                    successBlock(res);
                    return;
                }
                NSString *retMsg = paraments[@"RetMsg"];
                NSData *retMsgData = [retMsg idmp_dataWithBase64Encoded];
                NSString *finalRetMsg = [[NSString alloc] initWithData:retMsgData encoding:NSUTF8StringEncoding];
                if (!finalRetMsg) {
                    finalRetMsg = PhoneSimCardSepMessage1;
                }
                NSString *rand = paraments[ksRAND];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //显示机卡分离弹窗
                    NSLog(@"机卡分离弹窗");

                    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"FreeFlowConfigure" ofType:@"plist"];
                    NSDictionary *data = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
                    NSMutableAttributedString *attrString1 = [[NSMutableAttributedString alloc] initWithString:finalRetMsg];
                    NSRange range1 = [finalRetMsg rangeOfString:@"如果继续当前操作，按照业务规则将为您退订该优惠。"];
                    [attrString1 addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14.0 * IDMPWidthScale] range:range1];
                    NSRange range2 = [finalRetMsg rangeOfString:@"退订"];
                    [attrString1 addAttribute:NSForegroundColorAttributeName value:[UIColor idmp_colorWithHexString:data[@"phoneSimSepMsgStressColor"]] range:range2];
                    //退订后次月生效，若您后续用回原手机终端或开启授权，将提示您续订并实时生效。
                    NSRange range3 = [finalRetMsg rangeOfString:@"退订后次月生效，若您后续用回原手机终端或开启授权，将提示您续订并实时生效。"];
                    [attrString1 addAttribute:NSForegroundColorAttributeName value:[UIColor idmp_colorWithHexString:data[@"phoneSimSepMsgColor2"]] range:range3];
                    [attrString1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0 * IDMPWidthScale] range:range3];

                    PhoneSimCardSeparateAlertView *alertView = [[PhoneSimCardSeparateAlertView alloc] initWithAlertSize:CGSizeMake(312, 333) headerViewSize:CGSizeMake(312, 69) headerImageSize:CGSizeMake(312, 69) headerImage:[UIImage imageNamed:@"IDMPCMCC.bundle/icon_phone_sim_sep"]  messagePoint:CGPointMake(21, 14) message:attrString1 buttonBottomSpace:30 cancelButtonTitle:@"我再想想" confirmButtonTitle:@"继续操作" confirmHandler:^{

                        NSLog(@"退订确认弹窗");
                        NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:PhoneSimCardSepMessage2];
                        [attrString2 addAttribute:NSForegroundColorAttributeName value:[UIColor idmp_colorWithHexString:data[@"unsubscribeWarnMsgColor"]] range:NSMakeRange(0, attrString2.length)];
                        PhoneSimCardSeparateAlertView *alertConfirmView = [[PhoneSimCardSeparateAlertView alloc] initWithAlertSize:CGSizeMake(312, 292) headerViewSize:CGSizeMake(312, 97) headerImageSize:CGSizeMake(56, 50) headerImage:[UIImage imageNamed:@"IDMPCMCC.bundle/icon_unsubscribe_warn"]  messagePoint:CGPointMake(43, 30) message:attrString2 buttonBottomSpace:33 cancelButtonTitle:@"返回" confirmButtonTitle:@"确认退订" confirmHandler:^{
                            //sim卡不存在
                            if (![IDMPDevice simExist]) {
                                failBlock(@{IDMPResCode:@"102205",IDMPResStr:@"sim卡不存在",@"userOperator":@"userChoseUnsubscrible"});
                                [self alertWithMsg:@"退订失败"];
                                return;
                            };
                            //退订
                            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                NSLog(@"退订免流");
                                [self flowManageWithAppid:appid actionId:FlowUnsubscribe rand:rand btid:btid ks:ks traceId:traceId successBlock:^(NSDictionary *paraments) {
                                    NSString *unsubscibeHret = paraments[@"hret"];
                                    if ([unsubscibeHret isEqualToString:@"9"]) {
                                        //退订成功
                                        successBlock(@{IDMPResCode:@"102000",IDMPResStr:@"success",@"state":@"5",@"userOperator":@"userChoseUnsubscrible"});
                                        [self alertWithMsg:@"退订成功"];
                                        return;
                                    }
                                    //退订失败
                                    NSLog(@"成功退订");
                                    successBlock(@{IDMPResCode:@"102000",IDMPResStr:@"success",@"state":@"10",@"userOperator":@"userChoseUnsubscrible"});
                                    [self alertWithMsg:@"退订失败"];
                                    return;
                                } failBlock:^(NSDictionary *paraments) {
                                    NSMutableDictionary * extraParam = [NSMutableDictionary dictionaryWithDictionary:paraments];
                                    [extraParam setObject:@"userChoseUnsubscrible" forKey:@"userOperator"];
                                    failBlock([extraParam copy]);
                                    [self alertWithMsg:@"退订失败"];
                                    return;
                                }];
                            });
                        } cancelHandler:^{
                            //取消（不退订）
                            NSDictionary *res = [NSDictionary dictionaryWithObjectsAndKeys:@"102000",IDMPResCode,@"success",IDMPResStr,queryHret,@"state",@"userChoseCancel",@"userOperator", nil];
                            successBlock(res);
                            return;
                        }];
                        [alertConfirmView show];
                    } cancelHandler:^{
                        //取消（不退订）
                        NSDictionary *res = [NSDictionary dictionaryWithObjectsAndKeys:@"102000",IDMPResCode,@"success",IDMPResStr,queryHret,@"state",@"userChoseCancel",@"userOperator", nil];
                        successBlock(res);
                        return;
                    }];
                    [alertView show];
                });
            } failBlock:failBlock];     //订购状态查询失败
        } failBlock:failBlock];         //4g取号是失败
    } failBlock:failBlock];             //ck校验失败
}

//+ (NSString *)formateDateString:(NSString *)inDateString inDateFormat:(NSString *)inDateFormat outDateFormat:(NSString *)outDateFormat{
//    NSDateFormatter *inDateFormatter = [[NSDateFormatter alloc] init];
//    [inDateFormatter setLocale:[NSLocale currentLocale]];
//    [inDateFormatter setDateFormat:inDateFormat];
//    NSDate *inDate = [inDateFormatter dateFromString:inDateString];
//    NSDateFormatter *outDateFormatter = [[NSDateFormatter alloc] init];
//    [outDateFormatter setLocale:[NSLocale currentLocale]];
//    [outDateFormatter setDateFormat:outDateFormat];
//    NSString *outDateString = [outDateFormatter stringFromDate:inDate];
//    return outDateString;
//}

//+ (void)unsubscribeSuccessWithParam:(NSDictionary *)param fakeMsisdn:(NSString *)fakeMsisdn successBlock:(accessBlock)successBlock{
//    NSString *cancelTime = param[@"cancelTime"];
//    NSString *subTime = param[@"subTime"];
//    NSString *formateCancelTime = [self formateDateString:cancelTime inDateFormat:@"yyyyMMddHHmmss" outDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString *formateSubTime = [self formateDateString:subTime inDateFormat:@"yyyyMMdd" outDateFormat:@"yyyy-MM-dd"];
//    NSString *finalCancelTime = [NSString stringWithFormat:@"%@, 下月初生效",formateCancelTime];
//    NSArray *statusArr = @[fakeMsisdn,@"已退订",finalCancelTime,formateSubTime];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        UnsubscibePromptView *unsubscibePromptView = [[UnsubscibePromptView alloc] initWithStatusArr:statusArr CloseHandler:^{
//            successBlock(@{@"resultCode":@"102000",@"resultString":@"成功",@"state":@"5"});
//        }];
//        [unsubscibePromptView show];
//    });
//}

+ (void)alertWithMsg:(NSString *)msg {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alertView show];
        [self performSelector:@selector(dimissAlertView:) withObject:alertView afterDelay:1];
    });
}

+ (void)dimissAlertView:(UIAlertView *)alertView {
    if(alertView) {
        [alertView dismissWithClickedButtonIndex:[alertView cancelButtonIndex] animated:YES];
    }
}

+ (NSDictionary *)analysisParaments:(NSDictionary *)paraments clientNonce:(NSString *)clientNonce{
    NSString *wwwauthenticate = [paraments objectForKey:ksWWW_Authenticate];
    if (!wwwauthenticate) {
        wwwauthenticate = [paraments objectForKey:@"Www-Authenticate"];
    }
    NSString *serverMac = [paraments objectForKey:IDMPMAC];
    if(!wwwauthenticate||!serverMac) {
        return nil;
    }
    //解析返回参数
    NSDictionary *parament = [IDMPParseParament parseParamentFrom:wwwauthenticate];
    //解析服务端随机数
    NSString *serverNonce= [parament objectForKey:ksWP_nonce];
    
    unsigned char *ksChar = kdf_sms((unsigned char *)[clientNonce UTF8String],(char *)[ksWP_GBA UTF8String],(char *)[serverNonce UTF8String]);
    if (ksChar == NULL) {
        return nil;
    }
    //计算mac
    NSString *nativeMac=[IDMPKDF getNativeMac:ksChar data:wwwauthenticate];
    if(![nativeMac isEqualToString:serverMac]) {
        return nil;
    }
    
    NSString *ks = [NSString idmp_hexStringWithChar:ksChar length:16];
    NSString *btid= [parament objectForKey:IDMPBTID];
    NSString *encMsisdn = [parament objectForKey:IDMPMsisdn];
    NSString *msisdn = nil;
    if (![IDMPUtility checkNSStringisNULL:encMsisdn]) {
        msisdn = [encMsisdn idmp_RSASign];
    }
    
    free(ksChar);
    ksChar = NULL;
    return [NSDictionary dictionaryWithObjectsAndKeys:ks,IDMPKS,btid,IDMPBTID,msisdn,IDMPMsisdn, nil];
}

+ (void)getWPInfoWithAppid:(NSString *)appid traceId:(NSString *)traceId successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    NSString *BTID;
    NSString *deviceID = [IDMPDevice getDeviceID];
    NSString *clientNonce = [NSString idmp_getClientNonce];
    NSData *encImeiData = [@"null" idmp_aesEncryptWithKey:[[clientNonce substringToIndex:16] lowercaseString]];
    NSString *encryptClientNonce = [clientNonce idmp_RSAEncrypt];
    NSString *authorization= [NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"", ksWP_clientversion,clientversionValue,sdkversion,sdkversionFlowValue,kAPPID,appid,sipEncFlag,yesFlag,httpsFlag,yesFlag,IDMPBTID,BTID,sipFlag,@"1",ksClientkek,encryptClientNonce,ksIOS_ID,deviceID,@"imei",encImeiData,IDMPTraceId,traceId];
    NSString *signature = [authorization idmp_RSASign];
    NSString *RC_data = [IDMPDevice getLocalUserDeviceData];
    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:authorization,ksAuthorization,signature,ksSignature,RC_data,kRC_data, nil];
    IDMPHttpRequest *request = [IDMPHttpRequest new];
    [request getWapAsynWithHeads:paramDic urlStr:flowAuth timeOut:20.0 isRetry:YES successBlock:^(NSDictionary *parameters){
        NSDictionary *analyzedParm = [self analysisParaments:parameters clientNonce:clientNonce];
        if (!analyzedParm) {
            NSLog(@"mac不一致");
            failBlock(@{IDMPResCode:@"103117",IDMPResStr:@"mac不一致"});
            return;
        }
        successBlock(analyzedParm);
    } failBlock:failBlock];
    
}

+ (void)flowManageWithAppid:(NSString *)appid actionId:(FlowManageMode)actionid rand:(NSString *)rand btid:(NSString *)btid ks:(NSString *)ks traceId:(NSString *)traceId successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    NSString *deviceID = [IDMPDevice getDeviceID];
    NSDateFormatter *dateFormat = [IDMPDate cachedDateFormatter];
    NSString *time = [dateFormat stringFromDate:[NSDate date]];
    NSString *imei = @"null";
    NSString *actionidStr = [NSString stringWithFormat:@"%lu",(unsigned long)actionid];
    NSString *rootStatus = [NSString stringWithFormat:@"%d",[IDMPDevice checkJailbroken]];
    NSString *rawDataStr = [NSString stringWithFormat:@"%@%@%@",imei,actionidStr,rootStatus];
    NSString *encSign = [IDMPKDF getNativeMac:(unsigned char *)[[[ks substringToIndex:16] lowercaseString] UTF8String] data:rawDataStr];
    NSString *authorization = [NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"",FM_clientversion,clientversionValue,@"actionid",actionidStr,ksRAND,rand,ksIOS_ID,deviceID,kAPPID,appid,IDMPBTID,btid,@"encsign",encSign,sdkversion,sdkversionFlowValue,@"imei",imei,@"systemtime",time,@"rootStatus",rootStatus, IDMPTraceId,traceId];
    NSString *Signature = [authorization idmp_RSASign];
    NSString *RC_data = [IDMPDevice getLocalUserDeviceData];
    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:authorization,FMAuthorization,Signature,ksSignature,RC_data,kRC_data, nil];
    IDMPHttpRequest *request = [IDMPHttpRequest new];
    [request getAsynWithHeads:paramDic url:flowManage timeOut:20.0 successBlock:^(NSDictionary *parameters) {
        NSString *queryResStr = [parameters objectForKey:ksWWW_Authenticate];
        NSDictionary *queryResDic = [IDMPParseParament parseParamentFrom:queryResStr];
        successBlock(queryResDic);
    } failBlock:^(NSDictionary *parameters) {
        failBlock(parameters);
    }];
}

@end

