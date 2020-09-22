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
#import "IDMPFormatTransform.h"
#import "GCDAsyncSocket.h"

static  NSURLSession *session;
static NSOperationQueue *queue;

@interface IDMPHttpRequest ()<NSXMLParserDelegate,NSURLSessionDataDelegate,GCDAsyncSocketDelegate>
{
    NSString *mobilenumber;
    NSString *tempElementName;
    NSMutableDictionary *tempDic;
    accessBlock callBackSuccessBlock;
    accessBlock callBackFailBlock;
}

@property (nonatomic, strong) NSArray *trustedCerArr;
@property (strong, nonatomic) GCDAsyncSocket *asyncSocket;

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
            NSString *cerString = @"3082050c308203f4a003020102021002fb84a2c002a12aeedb7580b15fb069300d06092a864886f70d01010b05003044310b300906035504061302555331163014060355040a130d47656f547275737420496e632e311d301b0603550403131447656f54727573742053534c204341202d204733301e170d3135303531383030303030305a170d3137303631363233353935395a308189310b300906035504061302434e310f300d06035504080c06e5b9bfe4b89c310f300d06035504070c06e5b9bfe5b79e312a3028060355040a0c21e6b7b1e59cb3e5b882e5bda9e8aeafe7a791e68a80e69c89e99990e585ace58fb83111300f060355040b0c08554d43205445414d3119301706035504030c102a2e636d70617373706f72742e636f6d30820122300d06092a864886f70d0101 0105000382010f003082010a0282010100a24f76f8aa59ab5994629ee982521b5e89ccfda600e233332ec1d0c23677c1bfd345b6ef528cfdcdfa60b705d24ebe85925a549e15585babf7bb28199b6f4618b044b2a78c5a688fa13b3909ad24f127603724cb5ff996e5f2b996828b2d54d446f6924460be3fbd6f8af93ffc37866c912ea4621db7404abb972f80092a6a091d1f0839ff0e0cced285f96a840b34c9426dbdcf0cd2af0498fe1ae9b1c89b0d59c4123f94de9c5e37834f820f4a5e784f95f512faf7d33a8163d45846c485f5f5432bc47a845732c7eed77bdd03132a7e662ef021ef8288b35d1253f8fd487a5cf529ee38eb013b50abf27bd29b9893184e143da4d18bf4ae57322631861b590203010001a38201b2308201ae302b0603551d110424302282102a2e636d7061737370 6f72742e636f6d820e636d70617373706f72742e636f6d30090603551d1304023000300e0603551d0f0101ff0404030205a0302b0603551d1f042430223020a01ea01c861a687474703a2f2f676e2e73796d63622e636f6d2f676e2e63726c30819d0603551d2004819530819230818f060667810c010202308184303f06082b06010505070201163368747470733a2f2f7777772e67656f74727573742e636f6d2f7265736f75726365732f7265706f7369746f72792f6c6567616c304106082b0601050507020230350c3368747470733a2f2f7777772e67656f74727573742e636f6d2f7265736f75726365732f7265706f7369746f72792f6c6567616c301d0603551d250416301406082b0601050507030106082b06010505070302301f0603551d23041830168014d26ff796f4853f723c 307d23da85789ba37c5a7c305706082b06010505070101044b3049301f06082b060105050730018613687474703a2f2f676e2e73796d63642e636f6d302606082b06010505073002861a687474703a2f2f676e2e73796d63622e636f6d2f676e2e637274300d06092a864886f70d01010b050003820101004a210b8cb074c754a62b463f9e13a66792ef13ece194566a1a60adb4ff51e8c964a9ffaeca68a72c713a0d686fd1b228203892350709fbe545579ebc76f5a23cedb58c3dce5b1a09022d3dce4053fcffd17aacd36c03b98d67876a57cd12813dd758c38e3ece7f32bb04fdc2d51c45f5cb85cdfabbb563e33e5f307e6598775b07744c470361645bb2c34777b522c9d2db913ff595143e06d68b594c62b121a1ad6f05ea9d4d2df7f659b85b2834ff3df8230d299b543d30afff9032 ff78555102fd39499bc093b5b94903d2c72fa1cf2a73eb33c267935a963ca6660370e270ec3baab02017fd218af397632592cd595c0f6ca7d7fb6dc2d54ce33cd1889e15";
            NSData *cerdata=[IDMPFormatTransform convertHexStringToNSData:cerString];
            SecCertificateRef certificate = SecCertificateCreateWithData(NULL, (__bridge CFDataRef) cerdata);
            self.trustedCerArr = @[(__bridge_transfer id)certificate];
            
            session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:queue];
            
        });
    }
    return self;
}

-(void)getWithHeads:(NSDictionary *)heads url:(NSString *)urlStr successBlock:(ASIBasicBlock)successBlock failBlock:(ASIBasicBlock)failBlock
{
    NSLog(@"http url=%@",urlStr);
    NSLog(@"heads:%@",heads);
    NSMutableURLRequest * request1 = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
    request1.allHTTPHeaderFields = heads;
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = nil;
    NSData *data= [NSURLConnection sendSynchronousRequest:request1  returningResponse:&urlResponse error:&error];
    NSLog(@"receive data %@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    int statusCode = (int)[urlResponse statusCode];
    self.responseHeaders  = urlResponse.allHeaderFields;
    NSLog(@"statuscode:%ld",(long)statusCode);
    NSLog(@"responseHeaders:%@",self.responseHeaders);
    NSLog(@"resultCode:%@",[self.responseHeaders objectForKey:@"resultCode"]);
    
    NSString *resultCode = [self.responseHeaders objectForKey:@"resultCode"];
    if(statusCode==200)
    {
        if ([resultCode isEqualToString:@"000"])
        {
            successBlock();
        }
        else if ([resultCode isEqualToString:@"103000"])
        {
            successBlock();
        }
        else
        {
            failBlock();
        }
    }
    else
    {
        NSLog(@"fail statusCode:%ld",(long)statusCode);
        failBlock();
    }
}



- (void)getHttpByHeads:(NSDictionary *)heads url:(NSString *)urlStr successBlock:(ASIBasicBlock)successBlock failBlock:(ASIBasicBlock)failBlock
{
    NSLog(@"http url=%@",urlStr);
    NSLog(@"heads:%@",heads);
    NSURL *requestURL = [NSURL URLWithString:urlStr];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:requestURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
    NSLog(@"asyn request is %@",request);
    request.allHTTPHeaderFields = heads;
    NSURLSessionTask *task = [session dataTaskWithRequest:request
                                        completionHandler:^(NSData *data, NSURLResponse *urlResponse, NSError *error)
                              {
                                  NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)urlResponse;
                                  self.responseHeaders = httpResponse.allHeaderFields;
                                  NSLog(@"self.responseHeaders %@",self.responseHeaders);
                                  if (data != nil)
                                  {
                                      self.responseStr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                  }
                                  NSLog(@"responseStr:%@",self.responseStr);
                                  NSString *resultCode = [self.responseHeaders objectForKey:@"resultCode"] ? [self.responseHeaders objectForKey:@"resultCode"] : [self.responseStr objectForKey:@"resultcode"];
                                  NSLog(@"resultCode is %@",resultCode);
                    
                                  if (httpResponse.statusCode == 200)
                                  {
                                      NSLog(@"200");
                                      if ([resultCode isEqualToString:@"000"])
                                      {
                                          NSLog(@"000");
                                          successBlock();
                                      }
                                      else if ([resultCode isEqualToString:@"103000"])
                                      {
                                          NSLog(@"103000");
                                          successBlock();
                                      }
                                      else
                                      {
                                          NSLog(@"非000、103000");
                                          failBlock();
                                      }
                                  }
                                  else
                                  {
                                      NSLog(@"非200");
                                      failBlock();
                                  }
                              }];
    [task resume];
    
    
//    NSString *str = urlStr;
//    NSURL *url = [NSURL URLWithString:str];
//    NSMutableURLRequest * request1 = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
//    request1.allHTTPHeaderFields = heads;
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    [NSURLConnection sendAsynchronousRequest:request1 queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
//     {
//         if (data == nil)
//         {
//             NSLog(@"data is null");
//             failBlock();
//             return ;
//         }
//         else
//         {
//             self.responseStr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//             NSLog(@"responseStr:%@",self.responseStr);
//         }
//         NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
//         self.responseHeaders = httpResponse.allHeaderFields;
//         NSLog(@"responseHeaders:%@",self.responseHeaders);
//         NSLog(@"httpResponse.statusCode:%ld",httpResponse.statusCode);
//         NSString *resultCode = [self.responseStr objectForKey:@"resultcode"] ? [self.responseStr objectForKey:@"resultcode"] : [self.responseHeaders objectForKey:@"resultcode"];
//         NSLog(@"resultCode:%@",resultCode);
//         if (httpResponse.statusCode == 200)
//         {
//             if ([resultCode isEqualToString:@"000"])
//             {
//                 successBlock();
//             }
//             else if ([resultCode isEqualToString:@"103000"])
//             {
//                 successBlock();
//             }
//             else
//             {
//                 failBlock();
//             }
//         }
//         else
//         {
//             failBlock();
//         }
//     }];
}


- (void)getWapHttpByHeads:(NSDictionary *)heads url:(NSString *)urlStr successBlock:(ASIBasicBlock)successBlock failBlock:(ASIBasicBlock)failBlock
{
    
    NSLog(@"at first self is %@",self);
    NSLog(@"urlStr:%@",urlStr);
    self.socketUrl=[NSURL URLWithString:urlStr];
    self.socketHeads=heads;
    self.socketTimeout=20.0;
    self.socketFinishblock=successBlock;
    self.socketErrorblock=failBlock;
    NSError *error = nil;
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    self.asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:mainQueue];
    NSLog(@"socket host is %@,port is %@",[self.socketUrl host],[self.socketUrl port]);
    if (![self.socketUrl port])
    {
        NSLog(@"port is null");
        if (![self.asyncSocket connectToHost:[self.socketUrl host] onPort:8080 error:&error])
        {
            NSLog(@"Error connecting: %@", error);
            self.socketErrorblock();
        }
        
    }
    else
    {
        NSLog(@"port is not null");
        if (![self.asyncSocket connectToHost:[self.socketUrl host] onPort:[[self.socketUrl port] integerValue] error:&error])
        {
            NSLog(@"Error connecting: %@", error);
            self.socketErrorblock();
        }
    }
}


+ (IDMPHttpRequest *)getHttpWithDict:(NSDictionary *)content url:(NSString *)urlStr successBlock:(ASIBasicBlock)successBlock failBlock:(ASIBasicBlock)failBlock
{
    IDMPHttpRequest *request = [[IDMPHttpRequest alloc]init];
    [request getHttpWithDict:content url:urlStr successBlock:successBlock failBlock:failBlock];
    return request;
}


- (void)getHttpWithDict:(NSDictionary *)content url:(NSString *)urlStr successBlock:(ASIBasicBlock)successBlock failBlock:(ASIBasicBlock)failBlock
{
    NSLog(@"http url=%@",urlStr);
    NSLog(@"heads:%@",content);
    NSString *str = urlStr;
    NSURL *url = [NSURL URLWithString:str];
    NSMutableURLRequest * request1 = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
    NSData *msg = [NSJSONSerialization dataWithJSONObject:content options:NSJSONWritingPrettyPrinted error:nil];
    [request1 setHTTPMethod:@"POST"];
    [request1 setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request1 setValue:@"application/json; encoding=utf-8" forHTTPHeaderField:@"Content-Type"];
    //    [request1 setValue:[NSString stringWithFormat:@"%d", [msg length]] forHTTPHeaderField:@"Content-Length"];
    
    [request1 setHTTPBody: msg];
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:request1 queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         NSLog(@"error:%@",connectionError.description);
         if (data == nil)
         {
             failBlock();
             return ;
         }
         else
         {
             self.responseStr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
             NSLog(@"responseStr:%@",self.responseStr);
         }
         NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
         self.responseHeaders = httpResponse.allHeaderFields;
         NSDictionary *header = [self.responseStr objectForKey:@"header"];
         NSLog(@"responseHeaders:%@",self.responseHeaders);
         
         if (httpResponse.statusCode == 200)
         {
             if ([[header objectForKey:@"resultcode"] isEqualToString:@"000"] || [[header objectForKey:@"resultcode"] isEqualToString:@"103000"])
             {
                 successBlock();
             }
             else
             {
                 failBlock();
             }
         }
         else
         {
             NSLog(@"fail statusCode:%ld",(long)httpResponse.statusCode);
             failBlock();
         }
     }];
}


- (void)xmlHttpRequestWithXml:(NSString *)xml url:(NSString *)urlStr successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock{
    
    callBackSuccessBlock = successBlock;
    callBackFailBlock = failBlock;
    
    NSLog(@"http url=%@",urlStr);
    NSLog(@"http xml=%@",xml);
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:20.f];
    
    [request addValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *postBody = [NSMutableData data];
    [postBody appendData:[xml dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:postBody];
    
    NSHTTPURLResponse *ulrResponse;
    
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&ulrResponse error:&error];

    NSLog(@"http response code:%ld",(long)[ulrResponse statusCode]);
    //NSLog(@"result:%@",result);
    
    if (data)
    {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
        parser.delegate = self;
        [parser parse];
    }
    else
    {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"102101",@"resultCode", nil];
        if (failBlock)
        {
            failBlock(dic);
        }
    }
}

#pragma mark
#pragma mark NSXMLParserDelegate
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    //NSLog(@"%@", elementName);
    tempElementName = elementName;
    
    
    if ([elementName isEqualToString:@"MobileDecodeResponse"] || [elementName isEqualToString:@"UAVerifyTokenResponse"] || [elementName isEqualToString:@"SendSMSCodeResponse"] || [elementName isEqualToString:@"CheckSMSCodeResponse"])
    {
        tempDic = [NSMutableDictionary dictionaryWithCapacity:0];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (![tempDic objectForKey:tempElementName] && ![tempElementName isEqualToString:@"MobileDecodeResponse"] && ![tempElementName isEqualToString:@"UAVerifyTokenResponse"] && ![tempElementName isEqualToString:@"SendSMSCodeResponse"] && ![tempElementName isEqualToString:@"CheckSMSCodeResponse"])
    {
        [tempDic setObject:[NSString stringWithFormat:@"%@",string] forKey:tempElementName];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    //NSLog(@"%@", elementName);
}

- (void)parserDidEndDocument:(NSXMLParser *)parser{
    NSLog(@"解析结束dic:%@",tempDic);
    if (tempDic)
    {
        NSString *resultCode = [tempDic objectForKey:@"resultCode"];
        if ([resultCode isEqualToString:@"000"])
        {
            if (callBackSuccessBlock)
            {
                callBackSuccessBlock(tempDic);
            }
        }
        else
        {
            if (callBackFailBlock)
            {
                callBackFailBlock(tempDic);
            }
        }
    }
}

#pragma mark
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
        err = SecTrustEvaluate(serverTrust, &trustResult);
        NSLog(@"通过本地导入的证书来验证服务器的证书是否可信err is %@",err);
        NSLog(@"通过本地导入的证书来验证服务器的证书是否可信%d",trustResult);
        
        
    }
//    NSString *requestHost=challenge.protectionSpace.host;
    if (err == errSecSuccess && (trustResult == kSecTrustResultProceed || trustResult == kSecTrustResultUnspecified))
        
    {
        //认证成功，则创建一个凭证返回给服务器
        disposition = NSURLSessionAuthChallengeUseCredential;
        credential = [NSURLCredential credentialForTrust:serverTrust];
        NSLog(@"err is %@",err);
        
    }
//    else if (err == errSecSuccess&&[requestHost isEqualToString:ipHost])
//    {
//        
//        //认证成功，则创建一个凭证返回给服务器
//        disposition = NSURLSessionAuthChallengeUseCredential;
//        credential = [NSURLCredential credentialForTrust:serverTrust];
//        NSLog(@"ipHost exception");
//        NSLog(@"err is %@",err);
//        
//    }
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


#pragma mark
#pragma mark Socket Delegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"socket:%p didConnectToHost:%@ port:%hu", sock, host, port);
    
    // Connected to normal server (HTTP)
    NSString *prefix=[NSString stringWithFormat:@"GET %@ HTTP/1.1",[self.socketUrl path]] ;
    NSString *secHost=[NSString stringWithFormat:@"Host: %@",[self.socketUrl host]];
    NSString *Accept=@"Accept: */*";
    NSString *Connection=@"Connection: keep-alive";
    NSString *AcceptLanguage=@"Accept-Language: zh-cn";
    NSString *Authorization=[NSString stringWithFormat:@"Authorization: %@",[self.socketHeads objectForKey:ksAuthorization]];
    NSString *AcceptEncoding=@"Accept-Encoding: gzip, deflate";
    NSString *UserAgent=@"User-Agent: IDMPMiddleWare-AlfredKing-CMCC/1.0 CFNetwork/808.1.4 Darwin/16.1.0";
    NSString *requestStr = [NSString stringWithFormat:@"%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n\r\n",prefix, secHost,Accept,Connection,AcceptLanguage,Authorization,AcceptEncoding,UserAgent];
    
    NSLog(@"requestStr is %@",requestStr);
    NSData *requestData = [requestStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [sock writeData:requestData withTimeout:20 tag:0];
    NSData *endOfResponse=[NSData dataWithBytes:"\x0D\x0A\x0D\x0A" length:4];
    [sock readDataToData:endOfResponse withTimeout:20 tag:0];
}


- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"socket:%p didWriteDataWithTag:%ld", sock, tag);
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
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
            self.socketFinishblock();
            [self releaseSocket];
        }
        else
        {
            NSLog(@"enter fail block");
            self.socketErrorblock();
            [self releaseSocket];
        }
    }
    else
    {
        NSLog(@"status code is not 200");
        self.socketErrorblock();
        [self releaseSocket];
    }
    
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"socketDidDisconnect:%p withError: %@", sock, err);
}

-(void)releaseSocket
{
    NSLog(@"dealloc called");
    self.socketUrl=nil;
    self.socketFinishblock=nil;
    self.socketErrorblock=nil;
    [_asyncSocket setDelegate:nil];
    [_asyncSocket disconnect];
    _asyncSocket=nil;
}

@end
