//
//  IDMPConfigure.h
//  IDMPCMCC
//
//  Created by wj on 2017/6/29.
//  Copyright © 2017年 zwk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDMPConfigure : NSObject



//现网https
//#define DefaultNorthForwardwapURL @"http://www.cmpassport.com/openapi/NorthForwardServlet"
//#define DefaultdomainWapURL @"http://wap.cmpassport.com:8080/client/authRequest"
//#define DefaultdomainURL @"https://wap.cmpassport1.com:8443"
//#define DefaultipURL @"https://211.136.10.131:8443"
//#define DefaultSmsAccessNum @"106581022"
//#define DefaultConfigURL @"https://wap.cmpassport.com:8443/client/getConfigs"
//#define DefaultLogReportURL @"https://wap.cmpassport1.com:8443/log/logReport"

//new测试

//#define DefaultNorthForwardwapURL @"http://218.205.115.242:30000/client/authRequest"
//#define DefaultdomainWapURL @"http://218.205.115.242:30000/client/authRequest"
//#define DefaultdomainURL @"http://218.205.115.242:30000"
//#define DefaultipURL @"http://218.205.115.242:30009"
//#define DefaultSmsAccessNum @"1065840480270"
//#define DefaultConfigURL @"http://218.205.115.242:30000/conf/client/getConfigs"
//#define DefaultLogReportURL @"http://218.205.115.242:30000/log/log/logReport"


//联调

#define DefaultNorthForwardwapURL @"http://www.cmpassport.com/openapi/NorthForwardServlet"
#define DefaultdomainWapURL @"http://wap.cmpassport.com:8080/client/authRequest"
#define DefaultdomainURL @"http://218.205.115.220:10085"
#define DefaultipURL @"http://218.205.115.242:10085"
#define DefaultSmsAccessNum @"106581022"
#define DefaultConfigURL @"http://218.205.115.245:10088/client/getConfigs"
#define DefaultLogReportURL @"http://218.205.115.220:10086/log/logReport"

#define getVoiceSmsURL @"http://218.205.115.220:10085/dev/client/voiceSendRequest"
#define voiceAuthRequest @"http://218.205.115.220:10085/dev/client/voiceAuthRequest"

//-----------------------------------------------------------------------------//
//现网

//#define NorthForwardwapURL @"http://www.cmpassport.com/openapi/NorthForwardServlet"
//#define domainWapURL @"http://wap.cmpassport.com:8080/client/authRequest"
//#define domainURL @"http://wap.cmpassport.com:8080"
////#define domainPort @"8080"
//#define ipURL @"http://211.136.10.131:8080"
////#define ipPort @"8080"
//#define SmsAccessNum @"106581022"




//现网https测试
//#define NorthForwardwapURL @"http://www.cmpassport.com/openapi/NorthForwardServlet"
//#define domainWapURL @"http://wap.cmpassport.com:8080/client/authRequest"
//#define domainURL @"https://211.136.10.131:"
//#define domainPort @"8443"
//#define ipURL @"https://211.136.10.131:"
//#define ipPort @"8443"
//#define SmsAccessNum @"106581022"
//

//压力测试
//#define NorthForwardwapURL @"http://218.205.115.220:10085/client/authRequest"
//#define domainWapURL @"http://218.205.115.220:10085/client/authRequest"
//#define domainURL @"http://218.205.115.220:"
//#define domainPort @"10085"
//#define ipURL @"http://218.205.115.220:"
//#define ipPort @"10085"
//#define SmsAccessNum @"1065840401197"


@end
