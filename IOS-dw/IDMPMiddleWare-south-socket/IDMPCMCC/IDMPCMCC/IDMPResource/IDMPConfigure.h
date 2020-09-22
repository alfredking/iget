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
#define DefaultNorthForwardwapURL @"http://www.cmpassport.com/openapi/NorthForwardServlet"
#define DefaultdomainWapURL @"http://wap.cmpassport.com:8080/client/authRequest"
#define DefaultdomainURL @"https://wap.cmpassport.com:8443"
#define DefaultipURL @"https://211.136.10.131:8443"
#define DefaultSmsAccessNum @"106581022"
#define DefaultConfigURL @"https://wap.cmpassport.com:8443/client/getConfigs"
#define DefaultLogReportURL @"https://wap.cmpassport.com:8443/log/logReport"
#define localUrl @"http://wap.cmpassport.com:8080/client/getWPMobile"
#define DefaultKeyUploadURL @"https://wap.cmpassport.com:8443/client/ncaKey"


//灰度
//#define DefaultNorthForwardwapURL @"http://wap.cmpassport.com:8080/test/client/authRequest"
//#define DefaultdomainWapURL @"http://wap.cmpassport.com:8080/test/client/authRequest"
//#define DefaultdomainURL @"http://wap.cmpassport.com:8080/test"
//#define DefaultipURL @"http://wap.cmpassport.com:8080/test"
//#define DefaultSmsAccessNum @"106581022"
//#define DefaultConfigURL @"http://wap.cmpassport.com:8080/test/client/getConfigs"
//#define DefaultLogReportURL @"http://wap.cmpassport.com:8080/test/log/logReport"
//#define DefaultKeyUploadURL @"http://wap.cmpassport.com:8080/test/client/ncaKey"
//#define localUrl @"http://wap.cmpassport.com:8080/test/client/getWPMobile"


//测试

//#define DefaultNorthForwardwapURL @"http://218.205.115.242:30000/client/authRequest"
//#define DefaultdomainWapURL @"http://218.205.115.242:30000/client/authRequest"
//#define DefaultdomainURL @"http://218.205.115.242:30000"
//#define DefaultipURL @"http://218.205.115.242:30009"
//#define DefaultSmsAccessNum @"1065840480270"
//#define DefaultConfigURL @"http://218.205.115.242:30000/conf/client/getConfigs"
//#define DefaultLogReportURL @"http://218.205.115.242:30000/log/log/logReport"


//联调
//#define DefaultNorthForwardwapURL @"http://218.205.115.242:30000/client/authRequest"
//#define DefaultdomainWapURL @"http://wap.cmpassport.com:8080/client/authRequest"
//#define DefaultdomainURL @"http://218.205.115.220:10085"
//#define DefaultipURL @"http://218.205.115.242:10085"
//#define DefaultSmsAccessNum @"106581022"
//#define DefaultConfigURL @"http://218.205.115.220:10085/client/getConfigs"
//#define DefaultLogReportURL @"http://218.205.115.220:10085/log/logReport"

//联调国密
//#define DefaultNorthForwardwapURL @"http://112.13.96.207:10080/nca/client/authRequest"
//#define DefaultdomainWapURL @"http://112.13.96.207:10080/nca/client/authRequest"
//#define DefaultdomainURL @"http://112.13.96.207:10080/nca"
//#define DefaultipURL @"http://112.13.96.207:10080/nca"
//#define DefaultSmsAccessNum @"106581022"
//#define DefaultConfigURL @"http://218.205.115.220:10085/client/getConfigs"
//#define DefaultLogReportURL @"http://218.205.115.220:10085/log/logReport"
//#define DefaultKeyUploadURL @"http://112.13.96.207:10080/nca/client/ncaKey"



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
