//
//  IDMPHttpRequest.m
//  httptest
//
//  Created by zwk on 14/11/11.
//  Copyright (c) 2014年 zwk. All rights reserved.
//

#import "IDMPHttpRequest.h"
#import "IDMPConst.h"
#import "IDMPParseParament.h"
#import "userInfoStorage.h"
#import "IDMPFormatTransform.h"
#import "IDMPGCDAsyncSocket.h"
#import "NSTimer+IDMPBlocks.h"
#import "IDMPQueryModel.h"


static  NSURLSession *session;
static NSOperationQueue *queue;

typedef NS_ENUM(NSInteger, IDMPRequestParameterType) {
    IDMPHead = 0,
    IDMPBody
};

@interface IDMPHttpRequest ()<NSURLSessionDataDelegate,IDMPGCDAsyncSocketDelegate>

@property (nonatomic, strong) NSArray *trustedCerArr;
@property (strong, nonatomic) IDMPGCDAsyncSocket *asyncSocket;
@property (strong, nonatomic) NSTimer *socketTimer;



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
      NSString *cerString=@"3082050c308203f4a003020102021002fb84a2c002a12aeedb7580b15fb069300d06092a864886f70d01010b05003044310b300906035504061302555331163014060355040a130d47656f547275737420496e632e311d301b0603550403131447656f54727573742053534c204341202d204733301e170d3135303531383030303030305a170d3137303631363233353935395a308189310b300906035504061302434e310f300d06035504080c06e5b9bfe4b89c310f300d06035504070c06e5b9bfe5b79e312a3028060355040a0c21e6b7b1e59cb3e5b882e5bda9e8aeafe7a791e68a80e69c89e99990e585ace58fb83111300f060355040b0c08554d43205445414d3119301706035504030c102a2e636d70617373706f72742e636f6d30820122300d06092a864886f70d0101 0105000382010f003082010a0282010100a24f76f8aa59ab5994629ee982521b5e89ccfda600e233332ec1d0c23677c1bfd345b6ef528cfdcdfa60b705d24ebe85925a549e15585babf7bb28199b6f4618b044b2a78c5a688fa13b3909ad24f127603724cb5ff996e5f2b996828b2d54d446f6924460be3fbd6f8af93ffc37866c912ea4621db7404abb972f80092a6a091d1f0839ff0e0cced285f96a840b34c9426dbdcf0cd2af0498fe1ae9b1c89b0d59c4123f94de9c5e37834f820f4a5e784f95f512faf7d33a8163d45846c485f5f5432bc47a845732c7eed77bdd03132a7e662ef021ef8288b35d1253f8fd487a5cf529ee38eb013b50abf27bd29b9893184e143da4d18bf4ae57322631861b590203010001a38201b2308201ae302b0603551d110424302282102a2e636d7061737370 6f72742e636f6d820e636d70617373706f72742e636f6d30090603551d1304023000300e0603551d0f0101ff0404030205a0302b0603551d1f042430223020a01ea01c861a687474703a2f2f676e2e73796d63622e636f6d2f676e2e63726c30819d0603551d2004819530819230818f060667810c010202308184303f06082b06010505070201163368747470733a2f2f7777772e67656f74727573742e636f6d2f7265736f75726365732f7265706f7369746f72792f6c6567616c304106082b0601050507020230350c3368747470733a2f2f7777772e67656f74727573742e636f6d2f7265736f75726365732f7265706f7369746f72792f6c6567616c301d0603551d250416301406082b0601050507030106082b06010505070302301f0603551d23041830168014d26ff796f4853f723c 307d23da85789ba37c5a7c305706082b06010505070101044b3049301f06082b060105050730018613687474703a2f2f676e2e73796d63642e636f6d302606082b06010505073002861a687474703a2f2f676e2e73796d63622e636f6d2f676e2e637274300d06092a864886f70d01010b050003820101004a210b8cb074c754a62b463f9e13a66792ef13ece194566a1a60adb4ff51e8c964a9ffaeca68a72c713a0d686fd1b228203892350709fbe545579ebc76f5a23cedb58c3dce5b1a09022d3dce4053fcffd17aacd36c03b98d67876a57cd12813dd758c38e3ece7f32bb04fdc2d51c45f5cb85cdfabbb563e33e5f307e6598775b07744c470361645bb2c34777b522c9d2db913ff595143e06d68b594c62b121a1ad6f05ea9d4d2df7f659b85b2834ff3df8230d299b543d30afff9032 ff78555102fd39499bc093b5b94903d2c72fa1cf2a73eb33c267935a963ca6660370e270ec3baab02017fd218af397632592cd595c0f6ca7d7fb6dc2d54ce33cd1889e15";
    NSData *cerdata=[IDMPFormatTransform hexStringToNSData:cerString];
    SecCertificateRef certificate = SecCertificateCreateWithData(NULL, (__bridge CFDataRef) cerdata);
    self.trustedCerArr = @[(__bridge_transfer id)certificate];
    self.isRetry=NO;
    session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:queue];
        
     });
   }
   return self;
}

- (void)dealloc {
    [self.socketTimer invalidate];
    self.socketTimer = nil;
}

- (void)postAsynWithBody:(NSDictionary *)body url:(NSString *)urlStr timeOut:(float)aTime successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    [self requestRetryConfigWithParam:body parameterType:IDMPBody url:urlStr timeOut:aTime isAsyn:YES successBlock:successBlock failBlock:failBlock];
}


- (void)postSynWithBody:(NSDictionary *)body url:(NSString *)urlStr timeOut:(float)aTime successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    [self requestRetryConfigWithParam:body parameterType:IDMPBody url:urlStr timeOut:aTime isAsyn:NO successBlock:successBlock failBlock:failBlock];
}

- (void)getAsynWithHeads:(NSDictionary *)heads url:(NSString *)urlStr timeOut:(float)aTime  successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    [self requestRetryConfigWithParam:heads parameterType:IDMPHead url:urlStr timeOut:aTime isAsyn:YES successBlock:successBlock failBlock:failBlock];
}


- (NSURL *)ipDomainSwitchWithUrl:(NSString *)urlStr {
    NSURL *currentUrl=[NSURL URLWithString:urlStr];
    if ([IDMPFormatTransform checkIsIp:[currentUrl host]]) {
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
    [self domainIpSwithrequestWithParam:param parameterType:parameterType url:urlStr timeOut:aTime isAsyn:isAsyn successBlock:successBlock failBlock:^(NSDictionary *paraments) {
        int resultCode = [paraments[@"resultCode"] intValue];
        if (resultCode != IDMPNetworkError && resultCode != IDMPPlatformMigrationAccessError) {
            failBlock(paraments);
            return;
        }
        //如果本来就是config接口，则直接返回防止死循环。
        if ([urlStr containsString:@"/client/getConfigs"]) {
            failBlock(paraments);
            return;
        }
        [IDMPQueryModel getConfigsWithCompletionBlock:^(NSDictionary *paraments) {
            if ([paraments[@"resultCode"] intValue] == 103000) {
                [self domainIpSwithrequestWithParam:param parameterType:parameterType url:urlStr timeOut:aTime isAsyn:isAsyn successBlock:successBlock failBlock:failBlock];
            } else {
                //获取配置失败或者配置没变。
                failBlock(@{@"resultCode":@"102102"});
            }
        }];
    }];
}


- (void)domainIpSwithrequestWithParam:(NSDictionary *)param parameterType:(NSInteger)parameterType url:(NSString *)urlStr timeOut:(float)aTime isAsyn:(BOOL)isAsyn successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    NSURL *currentUrl = [self ipDomainSwitchWithUrl:urlStr];
    [self requestWithParam:param parameterType:parameterType url:currentUrl timeOut:aTime isAsyn:isAsyn successBlock:successBlock failBlock:^(NSDictionary *paraments) {
        if ([paraments[@"resultCode"] intValue] == -200) {
            NSLog(@"url host is %@",[currentUrl host]);
            if ([IDMPFormatTransform checkIsIp:[currentUrl host]] || [[currentUrl path] containsString:@"/log/logReport"]) {
                [userInfoStorage setInfo:yesFlag withKey:currentIsDomain];
                failBlock(@{@"resultCode":@"102102"});
            } else {
                int result=[userInfoStorage setInfo:noFlag withKey:currentIsDomain];
                if(result) {
                    [userInfoStorage setInfo:[NSDate date] withKey:ipSwitchDate];
                }
                NSString *retryUrlStr = [NSString stringWithFormat:@"%@%@",ipURL,[currentUrl path]];
                NSLog(@"retryUrl is %@",retryUrlStr);
                NSURL *retryUrl = [NSURL URLWithString:retryUrlStr];
                [self requestWithParam:param parameterType:parameterType url:retryUrl timeOut:aTime isAsyn:isAsyn successBlock:successBlock failBlock:failBlock];
            }
        } else {
            failBlock(paraments);
        }
    }];

    
}

- (void)requestWithParam:(NSDictionary *)param parameterType:(NSInteger)parameterType url:(NSURL *)url timeOut:(float)aTime isAsyn:(BOOL)isAsyn successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:aTime];
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
        NSInteger resultCode = -1;
        if (parameterType == IDMPHead) {
            responseDict = httpResponse.allHeaderFields;
            resultCode = [[responseDict objectForKey:@"resultCode"] integerValue];

        } else {
            if (data) {
                responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                resultCode = [[responseDict objectForKey:@"resultCode"] integerValue];
            }
        }
        
        NSLog(@"---request url is %@, param is %@, response is %@---",request.URL, param, responseDict);
    
        if (httpResponse.statusCode == 200) {
            
            if (resultCode == 103000) {
                successBlock(responseDict);
            } else {
                if (resultCode == 0) {
                    failBlock(@{@"resultCode":@"102102"});
                } else {
                    failBlock(@{@"resultCode":[NSString stringWithFormat:@"%ld",(long)resultCode]});
                }
            }
        } else {
            failBlock(@{@"resultCode":@"-200"});
            
        }
        if (!isAsyn) {
            dispatch_semaphore_signal(semaphore);   //发送信号
        }

    }];
    [task resume];
    if (!isAsyn) {
        dispatch_semaphore_wait(semaphore,DISPATCH_TIME_FOREVER);  //等待
    }

}

- (void)getWapAsynWithHeads:(NSDictionary *)heads url:(NSString *)urlStr timeOut:(float)aTime  successBlock:(ASIBasicBlock)successBlock failBlock:(ASIBasicBlock)failBlock
{
    
    NSLog(@"at first self is %@",self);
    self.socketUrl=[NSURL URLWithString:urlStr];
    if ([urlStr isEqualToString:domainWapURL])
    {
        NSString *wapIsNorth = (NSString *)[userInfoStorage getInfoWithKey:currentIsNorth];
        if (![wapIsNorth boolValue])
        {
            

            NSDate *wapswitchdate = (NSDate *)[userInfoStorage getInfoWithKey: wapSwitchDate];
            if (wapswitchdate)
            {
                double timezoneFix = [NSTimeZone localTimeZone].secondsFromGMT;
                if ((int)(([[NSDate date] timeIntervalSince1970] + timezoneFix)/(86400)) -
                    (int)(([wapswitchdate timeIntervalSince1970] + timezoneFix)/(86400))
                    > 0)
                {
                    
                    [userInfoStorage setInfo:yesFlag withKey:currentIsNorth];
                    self.socketUrl=[NSURL URLWithString:NorthForwardwapURL];
                }
            }
        }
        
    }
    NSLog(@"self.socketUrl is %@",self.socketUrl);
    self.socketHeads=heads;
    self.socketTimeout=aTime;
    self.socketFinishblock=successBlock;
    self.socketErrorblock=failBlock;
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.socketTimer = [NSTimer scheduledTimerWithTimeInterval:20 block:^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (strongSelf.socketErrorblock) {
                strongSelf.socketErrorblock();
            }
            [strongSelf releaseSocket];
        } repeats:NO];
    });


    NSError *error = nil;
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    self.asyncSocket = [[IDMPGCDAsyncSocket alloc] initWithDelegate:self delegateQueue:mainQueue];
    NSLog(@"socket host is %@,port is %@",[self.socketUrl host],[self.socketUrl port]);
    if (![self.socketUrl port])
    {
        NSLog(@"port is null");
        if (![self.asyncSocket connectToHost:[self.socketUrl host] onPort:80 error:&error])
        {
            NSLog(@"Error connecting: %@", error);
            if (self.socketErrorblock)
            {
                self.socketErrorblock();
                
            }
        }
        
    }
    else
    {
        NSLog(@"port is not null");
        if (![self.asyncSocket connectToHost:[self.socketUrl host] onPort:[[self.socketUrl port] integerValue] error:&error])
        {
            NSLog(@"Error connecting: %@", error);
            if (self.socketErrorblock)
            {
                self.socketErrorblock();
                
            }
        }
    }
}





#pragma mark Socket Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)socket:(IDMPGCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"socket:%p didConnectToHost:%@ port:%hu", sock, host, port);
    
    // Connected to normal server (HTTP)
    NSString *prefix=[NSString stringWithFormat:@"GET %@ HTTP/1.1",[self.socketUrl path]] ;
    NSString *secHost=[NSString stringWithFormat:@"Host: %@",[self.socketUrl host]];
    NSString *Accept=@"Accept: */*";
    NSString *Connection=@"Connection: keep-alive";
    NSString *signature=[NSString stringWithFormat:@"signature: %@",[self.socketHeads objectForKey:ksSignature]];
//    NSString *rcData=[NSString stringWithFormat:@"rcData: %@",[self.socketHeads objectForKey:kRC_data]];
    NSString *AcceptLanguage=@"Accept-Language: zh-cn";
    NSString *Authorization=[NSString stringWithFormat:@"Authorization: %@",[self.socketHeads objectForKey:ksAuthorization]];
    NSString *AcceptEncoding=@"Accept-Encoding: gzip, deflate";
    NSString *UserAgent=@"User-Agent: IDMPMiddleWare-AlfredKing-CMCC/1.0 CFNetwork/808.1.4 Darwin/16.1.0";
    NSString *requestStr = [NSString stringWithFormat:@"%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n\r\n",prefix, secHost,Accept,Connection,signature,AcceptLanguage,Authorization,AcceptEncoding,UserAgent];
    
    NSLog(@"requestStr is %@",requestStr);
    NSData *requestData = [requestStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [sock writeData:requestData withTimeout:20 tag:0];
    NSData *endOfResponse=[NSData dataWithBytes:"\x0D\x0A\x0D\x0A" length:4];
    [sock readDataToData:endOfResponse withTimeout:20 tag:0];
    
    
    
}


- (void)socket:(IDMPGCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"socket:%p didWriteDataWithTag:%ld", sock, tag);
}

- (void)socket:(IDMPGCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"socket:%p didReadData:withTag:%ld", sock, tag);
    NSString *httpResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"HTTP Response:\n%@", httpResponse);
    NSArray *params = [httpResponse componentsSeparatedByString:@"\x0D\x0A"];
    NSLog(@"params is %@",params);
    NSMutableDictionary *result=[[NSMutableDictionary alloc]init] ;
    NSArray *httpresponse=[params[0] componentsSeparatedByString:@" "];
    NSString *code=httpresponse[1];
    [result setObject:code forKey:@"statusCode"];
    for(NSString *object in params)
    {
        NSArray *KV= [object componentsSeparatedByString:@": "];
        NSString *key=(NSString *)KV[0];
        NSLog(@"key is %@",key);
        if ([key isEqualToString:@"resultCode"]||[key isEqualToString:@"mobile"]||[key isEqualToString:@"WWW-Authenticate"]||[key isEqualToString:@"mac"]) {
            NSString *value=(NSString *)KV[1];
            [result setObject: value forKey:key];
        }
        
    }
    
    NSLog(@"result is %@",result);
    self.responseHeaders = result;
    
    NSLog(@"self.responseHeaders %@",self.responseHeaders);
    
    NSInteger resultCode = [[self.responseHeaders objectForKey:@"resultCode"] integerValue];
    NSLog(@"resultCode is %d",resultCode);
    
    NSLog(@"at second self is %@",self);
    
    if ([[result objectForKey:@"statusCode"] isEqualToString: @"200"])
    {
        NSLog(@"http success");
        
        if (resultCode == 103000)
        {
            NSLog(@"enter success block");
            if (self.socketFinishblock)
            {
                self.socketFinishblock();
            }
            [self releaseSocket];
            
            
        }
        else
        {
            NSLog(@"enter fail block");
            if (self.socketErrorblock)
            {
                self.socketErrorblock();
                
            }
            [self releaseSocket];
        }
    }
    else
    {
        NSLog(@"status code is not 200");
        if([[self.socketUrl absoluteString] isEqualToString:NorthForwardwapURL])
        {
            
            if (!self.isRetry)
            {
                self.wapReTryRequest = [[IDMPHttpRequest alloc]init];
                self.wapReTryRequest.isRetry=YES;
                __weak IDMPHttpRequest *weakSelf = self;
                [self.wapReTryRequest getWapAsynWithHeads:self.socketHeads url:domainWapURL timeOut:self.socketTimeout
                successBlock:
                 ^{
                     NSLog(@"%@",self);
                     weakSelf.responseHeaders=weakSelf.wapReTryRequest.responseHeaders;
                     if (weakSelf.socketFinishblock)
                     {
                         weakSelf.socketFinishblock();
                     }
                     [weakSelf releaseSocket];
                     int result=[userInfoStorage setInfo:noFlag withKey:currentIsNorth];
                     if(result)
                     {
                         [userInfoStorage setInfo:[NSDate date] withKey:wapSwitchDate ];
                     }
                     
                 }
                 failBlock:
                 ^{
                     if (weakSelf.socketErrorblock)
                     {
                         weakSelf.socketErrorblock();
                     }
                     [weakSelf releaseSocket];
                 }];
            }
            else
            {
                if (self.socketErrorblock)
                {
                    self.socketErrorblock();
                    
                }
                [self releaseSocket];
            }
            
            
            
            
        }
        else
        {
            if (self.socketErrorblock)
            {
                self.socketErrorblock();
                
            }
            [self releaseSocket];
        }
    }
    
}

- (void)socketDidDisconnect:(IDMPGCDAsyncSocket *)sock withError:(NSError *)err
{
   
    if(!self.wapReTryRequest&&self.isRetry==NO)
    {
        
        NSLog(@"socketDidDisconnect:%p withError: %@", sock, err);
        if (self.socketErrorblock)
        {
            NSLog(@"is not null");
            self.socketErrorblock();
            
        }
        [self releaseSocket];
    }
    

    
}


#pragma mark - NSURLSessionDelegate
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * __nullable credential))completionHandler{
    
    
    OSStatus err;
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    SecTrustResultType  trustResult = kSecTrustResultInvalid;
    NSURLCredential *credential = nil;
    
    //获取服务器的trust object
    SecTrustRef serverTrust = challenge.protectionSpace.serverTrust;
    
    NSLog(@"serverTrust is %@",serverTrust);
        //将读取的证书设置为serverTrust的根证书
    err = SecTrustSetAnchorCertificates(serverTrust, (__bridge CFArrayRef)self.trustedCerArr);
    NSLog(@"err is %@",err);

    if(err == noErr)
    {
        //通过本地导入的证书来验证服务器的证书是否可信，如果将SecTrustSetAnchorCertificatesOnly设置为NO，则只要通过本地或者系统证书链任何一方认证就行
        SecTrustSetAnchorCertificatesOnly(serverTrust, NO);
        err = SecTrustEvaluate(serverTrust, &trustResult);
         NSLog(@"通过本地导入的证书来验证服务器的证书是否可信err is %@",err);
        NSLog(@"通过本地导入的证书来验证服务器的证书是否可信%d",trustResult);
        
      
    }
    NSString *requestHost=challenge.protectionSpace.host;
    if (err == errSecSuccess && (trustResult == kSecTrustResultProceed || trustResult == kSecTrustResultUnspecified))

    {
        //认证成功，则创建一个凭证返回给服务器
        disposition = NSURLSessionAuthChallengeUseCredential;
        credential = [NSURLCredential credentialForTrust:serverTrust];
        NSLog(@"err is %@",err);
      
    }
    else if (err == errSecSuccess&&[requestHost isEqualToString:ipHost])
    {
        
        //认证成功，则创建一个凭证返回给服务器
        disposition = NSURLSessionAuthChallengeUseCredential;
        credential = [NSURLCredential credentialForTrust:serverTrust];
        NSLog(@"ipHost exception");
        NSLog(@"err is %@",err);

    }
    else
    {
        disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
    }
    
    //回调凭证，传递给服务器
    if(completionHandler)
    {
        NSLog(@"传递给服务器");
        completionHandler(disposition, credential);
    }
}


-(void)releaseSocket
{
    NSLog(@"dealloc called self is %@",self);
    self.socketUrl=nil;
    self.socketFinishblock=nil;
    self.socketErrorblock=nil;
    [_asyncSocket setDelegate:nil];
    [_asyncSocket disconnect];
    _asyncSocket=nil;
}
@end
