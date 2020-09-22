//
//  IDMPHttpRequest.m
//  httptest
//
//  Created by zwk on 14/11/11.
//  Copyright (c) 2014年 zwk. All rights reserved.
//

#import "IDMPHttpRequest.h"
#import "IDMPParseParament.h"
#import "NSString+IDMPAdd.h"
#import "IDMPGCDAsyncSocket.h"
#import "IDMPQueryModel.h"
#import "userInfoStorage.h"

static  NSURLSession *session;
static NSOperationQueue *queue;

typedef NS_ENUM(NSInteger, IDMPRequestParameterType) {
    IDMPHead = 0,
    IDMPBody
};

#define wapSwitchDate @"wapSwitchDate"
#define ipSwitchDate @"ipswitchdate"


@interface IDMPHttpRequest ()<NSURLSessionDataDelegate,IDMPGCDAsyncSocketDelegate>

@property (strong, nonatomic) IDMPGCDAsyncSocket *asyncSocket;
@property (strong, nonatomic) NSTimer *socketTimer;

@property (nonatomic,assign) NSInteger httpStatusCode;

@property (nonatomic,copy) accessBlock socketFinishblock;
@property (nonatomic,copy) accessBlock socketErrorblock;
@property (nonatomic,strong) NSDictionary *socketHeads;
@property (nonatomic,strong) NSURL *socketUrl;
@property (nonatomic,assign) BOOL retryCMCCSocket;     //用于中国移动wap一键登录地址切换尝试

@property (nonatomic,assign) BOOL isGetMobile;     //用于判断是否获取本机号码接口



@end
@implementation IDMPHttpRequest

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        static dispatch_once_t httpOnceToken;
        dispatch_once(&httpOnceToken, ^{
            queue =  [[NSOperationQueue alloc]init];
            session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:queue];
            self.retryCMCCSocket = NO;
            self.isGetMobile = NO;
            
     });
   }
   return self;
}

- (void)dealloc {
    NSLog(@"dealloc %@",self);
    [self.socketTimer invalidate];
    self.socketTimer = nil;
}

- (void)postAsynWithBody:(NSDictionary *)body url:(NSString *)urlStr timeOut:(float)aTime successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    [self requestRetryConfigWithParam:body parameterType:IDMPBody url:urlStr timeOut:aTime isAsyn:YES successBlock:successBlock failBlock:failBlock];
}


- (void)postSynWithBody:(NSDictionary *)body url:(NSString *)urlStr timeOut:(float)aTime successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    [self requestWithParam:body parameterType:IDMPBody url:urlStr timeOut:aTime isAsyn:NO successBlock:successBlock failBlock:failBlock];
}

- (void)getAsynWithHeads:(NSDictionary *)heads url:(NSString *)urlStr timeOut:(float)aTime successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    [self requestRetryConfigWithParam:heads parameterType:IDMPHead url:urlStr timeOut:aTime isAsyn:YES successBlock:successBlock failBlock:failBlock];
}


- (NSURL *)ipDomainSwitchWithUrl:(NSString *)urlStr {
    NSURL *currentUrl=[NSURL URLWithString:urlStr];
    if ([[currentUrl host] idmp_isIPAddress]) {
        NSDate *ipswitchdate = (NSDate *)[userInfoStorage getInfoWithKey:ipSwitchDate];
        if (ipswitchdate) {
            double timezoneFix = [NSTimeZone localTimeZone].secondsFromGMT;
            if ((int)(([[NSDate date] timeIntervalSince1970] + timezoneFix)/(86400)) -
                (int)(([ipswitchdate timeIntervalSince1970] + timezoneFix)/(86400))
                > 0) {
                NSLog(@"switch exceeded for one day");
                NSString *swithUrl=[NSString stringWithFormat:@"%@%@",domainURL,[currentUrl path]];
                currentUrl=[NSURL URLWithString:swithUrl];
                [userInfoStorage setInfo:yesFlag withKey:currentIsDomain];
                NSLog(@"switch exceeded for one day");
            }
        }
    }
    return currentUrl;
}

//http请求+配置重试机制
- (void)requestRetryConfigWithParam:(NSDictionary *)param parameterType:(NSInteger)parameterType url:(NSString *)urlStr timeOut:(float)aTime isAsyn:(BOOL)isAsyn successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    [self requestWithParam:param parameterType:parameterType url:urlStr timeOut:aTime isAsyn:isAsyn successBlock:successBlock failBlock:^(NSDictionary *paraments) {
        int resultCode = [paraments[IDMPResCode] intValue];
        if (resultCode != IDMPNetworkError && resultCode != IDMPPlatformMigrationAccessError) {
            failBlock(paraments);
            return;
        }
        //如果本来就是config接口，则直接返回防止死循环。
        if ([urlStr idmp_containsString:@"/client/getConfigs"] || [urlStr idmp_containsString:@"/log/logReport"]) {
            failBlock(paraments);
            return;
        }
        [IDMPQueryModel getConfigsWithCompletionBlock:^(NSDictionary *paraments) {}];
        failBlock(paraments);
    }];
}


- (void)requestWithParam:(NSDictionary *)param parameterType:(NSInteger)parameterType url:(NSString *)urlStr timeOut:(float)aTime isAsyn:(BOOL)isAsyn successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    NSURL *currentUrl = [self ipDomainSwitchWithUrl:urlStr];
    NSLog(@"start request url(%@)",currentUrl.absoluteString);
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:currentUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:aTime];
    if (parameterType == IDMPHead) {
        request.allHTTPHeaderFields = param;
    } else {
        request.HTTPMethod = @"POST";
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json; encoding=utf-8" forHTTPHeaderField:@"Content-Type"];
        NSData *httpBody = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
        request.HTTPBody = httpBody;
    }
    
    dispatch_semaphore_t semaphore = isAsyn ? nil : dispatch_semaphore_create(0);
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *urlResponse, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)urlResponse;
        NSDictionary *responseDict = nil;
        NSInteger resultCode = 0;
        
        if (parameterType == IDMPHead) {
            responseDict = httpResponse.allHeaderFields;
            resultCode = [[responseDict objectForKey:IDMPResCode] integerValue];
            
        } else {
            if (data) {
                responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                resultCode = [[responseDict objectForKey:IDMPResCode] integerValue];
            }
        }

        NSString *resultString = @"httpNetError";
        if (error) {
            resultString = error.localizedDescription;
        }
        if (httpResponse) {
            resultString = [NSString stringWithFormat:@"%@-%ld",resultString,(long)httpResponse.statusCode];
        }
    
        if (httpResponse.statusCode == 200) {
            
            if (parameterType == IDMPHead) {
                responseDict = httpResponse.allHeaderFields;
                resultCode = [[responseDict objectForKey:IDMPResCode] integerValue];
                
            } else {
                if (data) {
                    responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                    resultCode = [[responseDict objectForKey:IDMPResCode] integerValue];
                }
            }
            NSLog(@"---request url is %@, param is %@, response is %@ error is %@---",request.URL, param, responseDict, error.localizedDescription);

            if (resultCode == 103000) {
                successBlock(responseDict);
            } else {
                if (resultCode == 0) {
                    failBlock(@{IDMPResCode:@"102102",IDMPResStr:resultString});
                } else {
                    NSMutableDictionary *failParam = [NSMutableDictionary dictionaryWithCapacity:0];
                    [failParam setValue:[NSString stringWithFormat:@"%ld",(long)resultCode] forKey:IDMPResCode];
                    [failParam setValue:[responseDict objectForKey:@"Www-Authenticate"] forKey:IDMPResStr];
                    [failParam setValue:[responseDict objectForKey:@"desc"] forKey:@"desc"];
                    failBlock([failParam copy]);
                }
            }
        } else if (httpResponse.statusCode == 302){
            NSString *redirectUrlStr = responseDict[@"Location"];
            if (!redirectUrlStr) {
                failBlock(@{IDMPResCode:@"102102",IDMPResStr:resultString});
                return;
            }
            [self getWapAsynWithHeads:nil urlStr:redirectUrlStr timeOut:aTime isRetry:NO successBlock:successBlock failBlock:failBlock];
        } else {
            if ([[currentUrl host] idmp_isIPAddress]) {
                //如果已经是ip地址则直接失败返回
                [userInfoStorage setInfo:yesFlag withKey:currentIsDomain];
                failBlock(@{IDMPResCode:@"102102",IDMPResStr:resultString});
            } else if ([urlStr idmp_containsString:@"/client/getConfigs"] || [urlStr idmp_containsString:@"/log/logReport"]) {
                //如果是获取配置接口或者日志上报接口则直接失败返回
                failBlock(@{IDMPResCode:@"102102",IDMPResStr:resultString});
            } else {
                //进行域名ip转换，使用ip地址重新请求
                int result=[userInfoStorage setInfo:noFlag withKey:currentIsDomain];
                if(result) {
                    [userInfoStorage setInfo:[NSDate date] withKey:ipSwitchDate];
                }
                NSString *retryUrl= [NSString stringWithFormat:@"%@%@",ipURL,[currentUrl path]];
                NSLog(@"retryUrl is %@",retryUrl);
                [self requestWithParam:param parameterType:parameterType url:retryUrl timeOut:aTime isAsyn:isAsyn successBlock:successBlock failBlock:failBlock];
            }
        }
        if (!isAsyn) {
            dispatch_semaphore_signal(semaphore);   //发送信号
        }

    }];
    [task resume];
    if (!isAsyn) {
        dispatch_semaphore_wait(semaphore,dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)));  //等待
    }

}

//wap域名地址转换
- (NSURL *)urlTransformWithUrlStr:(NSString *)urlStr {
    NSURL *url = [NSURL URLWithString:urlStr];
    if ([urlStr isEqualToString:domainWapURL]) {
        NSString *wapIsNorth = (NSString *)[userInfoStorage getInfoWithKey:currentIsNorth];
        if (![wapIsNorth boolValue]) {
            NSDate *wapswitchdate = (NSDate *)[userInfoStorage getInfoWithKey: wapSwitchDate];
            if (wapswitchdate) {
                double timezoneFix = [NSTimeZone localTimeZone].secondsFromGMT;
                if ((int)(([[NSDate date] timeIntervalSince1970] + timezoneFix)/(86400)) -
                    (int)(([wapswitchdate timeIntervalSince1970] + timezoneFix)/(86400))
                    > 0) {
                    NSLog(@"transform url(%@) to url(%@)",urlStr, NorthForwardwapURL);
                    [userInfoStorage setInfo:yesFlag withKey:currentIsNorth];
                    url = [NSURL URLWithString:NorthForwardwapURL];
                }
            }
        }
        
    }
    return url;
}


- (void)getWapAsynWithHeads:(NSDictionary *)heads urlStr:(NSString *)urlStr timeOut:(float)aTime isRetry:(BOOL)isRetry successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    NSURL *url = nil;
    if (isRetry) {
        url = [self urlTransformWithUrlStr:urlStr];  //url转换
    } else {
        url = [NSURL URLWithString:urlStr];
    }
    self.retryCMCCSocket = isRetry;
    [self getWapAsynWithHeads:heads url:url timeOut:aTime successBlock:successBlock failBlock:^(NSDictionary *parameters){
        self.socketUrl = nil;           //建立循环引用防止被release掉。
        NSDictionary *failDic = [NSDictionary dictionaryWithObjectsAndKeys:parameters[IDMPResCode],IDMPResCode,parameters[@"WWW-Authenticate"]?parameters[@"WWW-Authenticate"]:parameters[IDMPResStr],IDMPResStr, nil];
        failBlock(failDic);
    }];
}

- (void)getWapMobileAsynWithHeads:(NSDictionary *)heads url:(NSURL *)url timeOut:(float)aTime successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    self.isGetMobile = YES;
    [self getWapAsynWithHeads:heads url:url timeOut:aTime successBlock:^(NSDictionary *parameters) {
        self.socketUrl = nil;
        successBlock(parameters);
    } failBlock:failBlock];
}


- (void)getWapAsynWithHeads:(NSDictionary *)heads url:(NSURL *)url timeOut:(float)aTime successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    self.socketHeads = heads;
    self.socketUrl = url;
    self.socketFinishblock = successBlock;
    self.socketErrorblock = failBlock;

    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    self.asyncSocket = [[IDMPGCDAsyncSocket alloc] initWithDelegate:self delegateQueue:mainQueue];
    NSLog(@"socket host is %@,port is %@",[self.socketUrl host],[self.socketUrl port]);
    NSError *error = nil;
    if (![self.asyncSocket connectToHost:[self.socketUrl host] onPort:[self.socketUrl port] != nil ? [[self.socketUrl port] intValue] : 80 withTimeout:aTime error:&error]) {
        NSLog(@"Error connecting: %@", error);
        if (self.socketErrorblock) {
            self.socketErrorblock(@{IDMPResCode:@"102102",IDMPResStr:[NSString stringWithFormat:@"wapNetError-connectFail-%@-%@",error.domain,error.localizedDescription]});
        }
        [self releaseSocket];
    }
}

- (void)retryConnectWithSocketUrl:(NSURL *)url {
    NSError *error = nil;
    self.socketUrl = url;
    [self.asyncSocket setDelegate:nil];
    [self.asyncSocket disconnect];
    [self.asyncSocket setDelegate:self];
    if (![self.asyncSocket connectToHost:[self.socketUrl host] onPort:[self.socketUrl port] != nil ? [[self.socketUrl port] intValue] : 80 withTimeout:20. error:&error]) {
        NSLog(@"Error connecting: %@", error);
        if (self.socketErrorblock) {
            self.socketErrorblock(@{IDMPResCode:@"102102",IDMPResStr:[NSString stringWithFormat:@"wapNetError-302-%@-%@", error.domain, error.localizedDescription]});
        }
        [self releaseSocket];
    }
}

#pragma mark Socket Delegate
- (void)socket:(IDMPGCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"socket:%p didConnectToHost:%@ port:%hu", sock, host, port);
    
    NSString *secHost=[NSString stringWithFormat:@"Host: %@",[self.socketUrl host]];
//    NSString *secHost = @"Host: www.cmpassport.com";
    NSString *Accept=@"Accept: */*";
    NSString *Connection=@"Connection: keep-alive";
    NSString *AcceptLanguage=@"Accept-Language: zh-cn";
    NSString *AcceptEncoding=@"Accept-Encoding: gzip, deflate";
    NSString *UserAgent=@"User-Agent: IDMPMiddleWare-AlfredKing-CMCC/1.0 CFNetwork/808.1.4 Darwin/16.1.0";
    NSString *requestStr = nil;
    if (self.socketHeads) {
        //用于cmcc取号
        NSString *prefix=[NSString stringWithFormat:@"GET %@ HTTP/1.1",[self.socketUrl path]];
        if (!self.isGetMobile) {
            NSString *signature=[NSString stringWithFormat:@"signature: %@",[self.socketHeads objectForKey:ksSignature]];
            NSString *rcData=[NSString stringWithFormat:@"rcData: %@",[self.socketHeads objectForKey:kRC_data]];
            NSString *Authorization=[NSString stringWithFormat:@"Authorization: %@",[self.socketHeads objectForKey:ksAuthorization]];
            requestStr = [NSString stringWithFormat:@"%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n\r\n",prefix,secHost,Accept,Connection,signature,AcceptLanguage,Authorization,AcceptEncoding,UserAgent,rcData];
        } else {
            //用于获取手机号接口
            NSString *encType = [NSString stringWithFormat:@"encType: %@",[self.socketHeads objectForKey:@"encType"]];
            NSString *keyName = [NSString stringWithFormat:@"keyName: %@",[self.socketHeads objectForKey:@"keyName"]];
            requestStr = [NSString stringWithFormat:@"%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n\r\n",prefix,secHost,Accept,Connection,AcceptLanguage,AcceptEncoding,UserAgent,encType,keyName];
        }

    } else {
        //用于非cmcc取号
        NSString *prefix=[NSString stringWithFormat:@"GET %@?%@ HTTP/1.1",[self.socketUrl path], self.socketUrl.query] ;
        requestStr = [NSString stringWithFormat:@"%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n\r\n",prefix,secHost,Accept,Connection,AcceptLanguage,AcceptEncoding,UserAgent];
    }
    
    NSLog(@"requestStr is %@",requestStr);
    NSData *requestData = [requestStr dataUsingEncoding:NSUTF8StringEncoding];
    [sock writeData:requestData withTimeout:20 tag:0];
    NSData *endOfResponse=[NSData dataWithBytes:"\x0D\x0A\x0D\x0A" length:4];
    [sock readDataToData:endOfResponse withTimeout:20 tag:0];
    //用于联调环境调试
//    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"FreeFlowConfigure" ofType:@"plist"];
//    NSDictionary *data = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
//    NSString *phoneNumber = [NSString stringWithFormat:@"x-up-calling-line-id: %@",data[@"phoneNum"]];
    //    NSString *requestStr = [NSString stringWithFormat:@"%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n\r\n",prefix, secHost,Accept,Connection,signature,AcceptLanguage,Authorization,AcceptEncoding,UserAgent,rcData];

}


- (void)socket:(IDMPGCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    NSLog(@"socket:%p didWriteDataWithTag:%ld", sock, tag);
}

- (void)socket:(IDMPGCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSString *httpResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"HTTP Response:\n%@", httpResponse);
    NSArray *params = [httpResponse componentsSeparatedByString:@"\x0D\x0A"];
    NSDictionary *result = [IDMPParseParament dictionaryWithSocketJsonArray:params];
    NSLog(@"result is %@",result);
    
    NSInteger resultCode = [[result objectForKey:IDMPResCode] integerValue];
    int statusCode = [[result objectForKey:@"statusCode"] intValue];
    if (statusCode == 200) {
        //对于移动wap登录，如果重试domainWapURL成功，则设置状态为domainWapURL。
        if ([[self.socketUrl absoluteString] isEqualToString:domainWapURL]) {
            if([userInfoStorage setInfo:noFlag withKey:currentIsNorth]) {
                [userInfoStorage setInfo:[NSDate date] withKey:wapSwitchDate];
            }
        }
        
        if (resultCode == 103000) {
            if (self.socketFinishblock) {
                self.socketFinishblock(result);
            }
            [self releaseSocket];
        } else {
            
            if (self.socketErrorblock) {
                self.socketErrorblock(result);
            }
            [self releaseSocket];
        }

    } else if (statusCode == 302) {
        //对于非移动wap登录，会有重定向
        NSString *redirectUrlStr = result[@"Location"];
        if (!redirectUrlStr) {
            self.socketErrorblock(@{IDMPResCode:@"102102",IDMPResStr:[NSString stringWithFormat:@"wapNetError-302-dismissRedirectUrl"]});
            [self releaseSocket];
            return;
        }
        NSURL *redirectUrl = [NSURL URLWithString:redirectUrlStr];
        [self retryConnectWithSocketUrl:redirectUrl];
        
    } else {
        if (self.retryCMCCSocket && [[self.socketUrl absoluteString] isEqualToString:NorthForwardwapURL]) {
            self.retryCMCCSocket = NO;  //重置retry
            [self retryConnectWithSocketUrl:[NSURL URLWithString:domainWapURL]];    //切换地址重新尝试
        } else {
            if (self.socketErrorblock) {
                self.socketErrorblock(@{IDMPResCode:@"102102",IDMPResStr:[NSString stringWithFormat:@"wapNetError-非200-%d",statusCode]});
            }
            [self releaseSocket];
            return;
        }
        
    }
    
}

- (void)socketDidDisconnect:(IDMPGCDAsyncSocket *)sock withError:(NSError *)err {
    NSLog(@"socketDidDisconnect:%p withError: %@", sock, err);
    if (self.socketErrorblock) {
        self.socketErrorblock(@{IDMPResCode:@"102102",IDMPResStr:[NSString stringWithFormat:@"wapNetError-disconnect-%@-%@",err.domain,err.localizedDescription]});
    }
    [self releaseSocket];
}


#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler {
    NSURLRequest *newRequest = request;
    if (response) {
        newRequest = nil;
    }
    completionHandler(newRequest);
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * __nullable credential))completionHandler{
    OSStatus err;
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    SecTrustResultType  trustResult = kSecTrustResultInvalid;
    NSURLCredential *credential = nil;
    
    //获取服务器的trust object
    SecTrustRef serverTrust = challenge.protectionSpace.serverTrust;

    //通过本地导入的证书来验证服务器的证书是否可信，如果将SecTrustSetAnchorCertificatesOnly设置为NO，则只要通过本地或者系统证书链任何一方认证就行
    SecTrustSetAnchorCertificatesOnly(serverTrust, NO);
    err = SecTrustEvaluate(serverTrust, &trustResult);
    
    NSString *requestHost=challenge.protectionSpace.host;
    if (err == errSecSuccess && (trustResult == kSecTrustResultProceed || trustResult == kSecTrustResultUnspecified)) {
        //认证成功，则创建一个凭证返回给服务器
        disposition = NSURLSessionAuthChallengeUseCredential;
        credential = [NSURLCredential credentialForTrust:serverTrust];
        NSLog(@"err is %d",(int)err);
      
    } else if (err == errSecSuccess&&[requestHost isEqualToString:ipHost]) {
        //认证成功，则创建一个凭证返回给服务器
        disposition = NSURLSessionAuthChallengeUseCredential;
        credential = [NSURLCredential credentialForTrust:serverTrust];
        NSLog(@"ipHost exception");
        NSLog(@"err is %d",(int)err);

    } else {
        disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
    }
    
    //回调凭证，传递给服务器
    if(completionHandler) {
        completionHandler(disposition, credential);
    }
}


-(void)releaseSocket {
    NSLog(@"dealloc called self is %@",self);
    self.socketUrl=nil;
    self.socketFinishblock=nil;
    self.socketErrorblock=nil;
    [_asyncSocket setDelegate:nil];
    [_asyncSocket disconnect];
    _asyncSocket=nil;
}
@end
