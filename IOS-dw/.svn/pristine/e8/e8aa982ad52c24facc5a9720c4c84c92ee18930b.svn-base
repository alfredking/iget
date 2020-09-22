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

static  NSURLSession *session;
static NSOperationQueue *queue;

@interface IDMPHttpRequest ()<NSURLSessionDataDelegate>
@property (nonatomic, strong) NSArray *trustedCerArr;

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
        NSData *data=[IDMPFormatTransform hexStringToNSData:cerString];
        SecCertificateRef certificate = SecCertificateCreateWithData(NULL, (__bridge CFDataRef) data);
        self.trustedCerArr = @[(__bridge_transfer id)certificate];
      });
    }
    return self;
}


- (void)getAsynWithHeads:(NSDictionary *)heads url:(NSString *)urlStr timeOut:(float)aTime  successBlock:(ASIBasicBlock)successBlock failBlock:(ASIBasicBlock)failBlock
{
    
    NSLog(@"getAsynHttp URL = %@",urlStr);
    if ( [userInfoStorage getInfoWithKey:currentIsIP])
    {
        NSDate *ipswitchdate=[userInfoStorage getInfoWithKey:ipSwitchDate];
        if (ipswitchdate)
        {
            double timezoneFix = [NSTimeZone localTimeZone].secondsFromGMT;
            if ((int)(([[NSDate date] timeIntervalSince1970] + timezoneFix)/(86400)) -
                (int)(([ipswitchdate timeIntervalSince1970] + timezoneFix)/(86400))
                > 0)
            {
                NSLog(@"switch exceeded for one day");
                [userInfoStorage setInfo:domainURL withKey:secCurrentURL];
                [userInfoStorage setInfo:domainPort withKey:secCurrentPort];
                [userInfoStorage setInfo:noFlag withKey:currentIsIP];
                
            }
            
        }
        
    }
    
    NSMutableURLRequest * request1 = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:aTime];
    request1.allHTTPHeaderFields = heads;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionTask *task = [session dataTaskWithRequest:request1
                                        completionHandler:^(NSData *data, NSURLResponse *urlResponse, NSError *error)
                              {
                                  NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)urlResponse;
                                  self.responseHeaders = httpResponse.allHeaderFields;
                                  NSLog(@"responseHeaders %@", self.responseHeaders);
                                  NSInteger resultCode = [[self.responseHeaders objectForKey:@"resultCode"] integerValue];
                                  NSLog(@"statusCode is %d",httpResponse.statusCode);
                                  NSLog(@"resultCode %d",resultCode);
                                  
                                  if (httpResponse.statusCode == 200)
                                  {
                                      
                                      if (resultCode == 103000)
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
                                      
                                      if ([(NSString *)[userInfoStorage getInfoWithKey:secCurrentURL ] isEqualToString:ipURL])
                                      {
                                          [userInfoStorage setInfo:domainURL withKey:secCurrentURL];
                                          [userInfoStorage setInfo:domainPort withKey:secCurrentPort];
                                          [userInfoStorage setInfo:noFlag withKey:currentIsIP];
                                          
                                          failBlock();
                                          return;
                                      }
                                      if([(NSString *)[userInfoStorage getInfoWithKey: secCurrentURL] isEqualToString:domainURL])
                                      {
                                          
                                          NSString *oldUrl= [NSString stringWithFormat:@"%@%@", [userInfoStorage getInfoWithKey: secCurrentURL] ,[userInfoStorage getInfoWithKey: secCurrentPort]];
                                          int oldLocation = (int)oldUrl.length;
                                          
                                          [userInfoStorage setInfo:ipURL withKey:secCurrentURL];
                                          [userInfoStorage setInfo:ipPort withKey:secCurrentPort];
                                          int result=[userInfoStorage setInfo:yesFlag withKey:currentIsIP];
                                          
                                          if(result)
                                          {
                                              
                                              
                                              [userInfoStorage setInfo:[NSDate date] withKey:ipSwitchDate];
                                              
                                              
                                          }
                                          NSString *newprefixUrl= [NSString stringWithFormat:@"%@%@",[userInfoStorage getInfoWithKey: secCurrentURL] ,[userInfoStorage getInfoWithKey: secCurrentPort]];
                                          
                                          if(oldLocation<=urlStr.length)
                                          {
                                              
                                              
                                              NSString *suffixUrl = [urlStr substringFromIndex:oldLocation];
                                              NSString *newUrl=[NSString stringWithFormat:@"%@%@",newprefixUrl,suffixUrl];
                                              
                                              [self getAsynWithHeads:heads url:newUrl timeOut:aTime
                                                        successBlock:
                                               ^{
                                                   successBlock();
                                               }
                                                           failBlock:
                                               ^{
                                                   
                                                   failBlock();
                                               }];
                                          }
                                      }
                                      
                                      
                                  }
                              }];
    [task resume];
}

- (void)getWapAsynWithHeads:(NSDictionary *)heads url:(NSString *)urlStr timeOut:(float)aTime  successBlock:(ASIBasicBlock)successBlock failBlock:(ASIBasicBlock)failBlock
{
    
    
    NSLog(@"getWapHttp URL = %@",urlStr);
    
    if ([urlStr isEqualToString:domainWapURL]) {
        NSDate *wapswitchdate=[userInfoStorage getInfoWithKey: wapSwitchDate];
        if (wapswitchdate)
        {
            double timezoneFix = [NSTimeZone localTimeZone].secondsFromGMT;
            if ((int)(([[NSDate date] timeIntervalSince1970] + timezoneFix)/(86400)) -
                (int)(([wapswitchdate timeIntervalSince1970] + timezoneFix)/(86400))
                > 0)
            {
                
                [userInfoStorage setInfo:NorthForwardwapURL withKey:secwapURL];
            }
        }
        
    }
    NSMutableURLRequest * request1 = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    
    request1.allHTTPHeaderFields = heads;
    NSLog(@"request is %@",request1);
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionTask *task = [session dataTaskWithRequest:request1
                                        completionHandler:^(NSData *data, NSURLResponse *urlResponse, NSError *error)
                              {
                                  NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)urlResponse;
                                  self.responseHeaders = httpResponse.allHeaderFields;
                                  NSLog(@"responseHeaders %@", self.responseHeaders);
                                  NSInteger resultCode = [[self.responseHeaders objectForKey:@"resultCode"] integerValue];
                                  NSLog(@"resultCode %d",resultCode);
                                  
                                  if (httpResponse.statusCode == 200)
                                  {
                                      if (resultCode == 103000)
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
                                      if([urlStr isEqualToString:NorthForwardwapURL])
                                      {
                                          
                                          [self getAsynWithHeads:heads url:domainWapURL timeOut:aTime
                                                    successBlock:
                                           ^{
                                               successBlock();
                                               int result=[userInfoStorage setInfo:domainWapURL withKey:secwapURL];
                                               if(result)
                                               {
                                                   [userInfoStorage setInfo:[NSDate date] withKey:wapSwitchDate ];
                                               }
                                               
                                           }
                                                       failBlock:
                                           ^{
                                               
                                               failBlock();
                                           }];
                                          
                                          
                                      }
                                      else if ([urlStr isEqualToString:domainWapURL])
                                      {
                                          failBlock();
                                      }
                                  }
                                  
                              }];
    [task resume];
    
}




#pragma mark - NSURLSessionDelegate
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * __nullable credential))completionHandler{
    
    NSLog(@"challenge start");
    NSLog(@"challenge is %@",challenge);
    
    
    OSStatus err;
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    SecTrustResultType  trustResult = kSecTrustResultInvalid;
    NSURLCredential *credential = nil;
    
    //获取服务器的trust object
    SecTrustRef serverTrust = challenge.protectionSpace.serverTrust;
    NSLog(@"challenge serverTrust is %@",challenge.protectionSpace.serverTrust);
    //将读取的证书设置为serverTrust的根证书
    err = SecTrustSetAnchorCertificates(serverTrust, (__bridge CFArrayRef)self.trustedCerArr);
    
    if(err == noErr)
    {
        //通过本地导入的证书来验证服务器的证书是否可信，如果将SecTrustSetAnchorCertificatesOnly设置为NO，则只要通过本地或者系统证书链任何一方认证就行
        err = SecTrustEvaluate(serverTrust, &trustResult);
        
        NSLog(@"no error");
    }
    
    if (err == errSecSuccess && (trustResult == kSecTrustResultProceed || trustResult == kSecTrustResultUnspecified))
    {
        //认证成功，则创建一个凭证返回给服务器
        disposition = NSURLSessionAuthChallengeUseCredential;
        credential = [NSURLCredential credentialForTrust:serverTrust];
        NSLog(@"认证成功");
    }
    else
    {
        disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
        NSLog(@"认证失败");
    }
    
    //回调凭证，传递给服务器
    if(completionHandler)
    {
        NSLog(@"回传给服务器");
        completionHandler(disposition, credential);
    }
}


@end
