//
//  IDMPTokenCheckHelper.m
//  IDMPCMCCDemo
//
//  Created by wj on 2018/1/16.
//  Copyright © 2018年 alfredking－cmcc. All rights reserved.
//


#import "IDMPTokenCheckHelper.h"
#import "IDMPDemoConst.h"

static  NSURLSession *tokenSession;

static const NSString *kRandomAlphabet = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

@interface IDMPTokenCheckHelper()<NSURLSessionDelegate>

@end

@implementation IDMPTokenCheckHelper

-(instancetype)init
{
    self = [super init];
    static dispatch_once_t tokenPredicate;
    dispatch_once(&tokenPredicate, ^{
        if (self)
        {
            self->_queue =  [[NSOperationQueue alloc]init];
            
            tokenSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:self->_queue];
            
        }
    });
    return self;
}

- (void)httpsTestWithUrlStr:(NSString *)urlStr heads:(NSDictionary *)heads successBlock:(callBackBlock)success failBlock:(callBackBlock)fail {
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
    [request setHTTPMethod:@"get"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json; encoding=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setAllHTTPHeaderFields:heads];
    NSURLSessionTask *task = [tokenSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *urlResponse, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)urlResponse;
        NSLog(@"error:%@",error.description);
        if (httpResponse.statusCode == 200) {
            NSDictionary *headers = httpResponse.allHeaderFields;
            success(headers);
        } else {
            NSLog(@"failBlock");
            NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:@"102102",@"resultCode", nil];
            
            fail(result);
        }
    }];
    [task resume];
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler{
//    if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
//        if([challenge.protectionSpace.host isEqualToString:@"www.quhao.cmpassport.com"]){
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
//        } else {
//            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
//        }
//    }
}




-(void)checkToken:(NSString *)Token successBlock:(callBackBlock)success failBlock:(callBackBlock)fail
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat: @"yyyyMMddHHmmssSSS"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSMutableString *randomString = [NSMutableString stringWithCapacity:16];
    for (int i = 0; i < 16; i++) {
        [randomString appendFormat: @"%C", [kRandomAlphabet characterAtIndex:arc4random_uniform((u_int32_t)[kRandomAlphabet length])]];
    }
    NSString *msgid = [randomString copy];
    NSMutableDictionary *head = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1.0",@"version",@"5",@"apptype",currentDateStr,@"systemtime",msgid,@"msgid",sourceid,@"sourceid" , sourcekey, @"sourcekey", nil];
    NSMutableDictionary *body = [NSMutableDictionary dictionaryWithObjectsAndKeys:Token,@"token",nil];
    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:head,@"header",body,@"body", nil];
    
    NSURL *url = [NSURL URLWithString:checkTokenUrl];
//    NSLog(@"token url is %@",checkTokenUrl);
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
    NSData *Body = [NSJSONSerialization dataWithJSONObject:heads options:NSJSONWritingPrettyPrinted error:nil];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json; encoding=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:Body];
    NSLog(@"body is %@",heads);
    
    NSURLSessionTask *task = [tokenSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *urlResponse, NSError *error)
                              {
                                  NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)urlResponse;
                                  NSLog(@"error:%@",error.description);
                                  if (httpResponse.statusCode == 200)
                                  {
                                      NSDictionary *responseDict =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                                      NSDictionary *header = [responseDict objectForKey:@"header"];
                                      
                                      if ([[header objectForKey:@"resultcode"]integerValue] == 103000)
                                      {
                                          success(responseDict);
                                      }
                                      else
                                      {
                                          fail(responseDict);
                                      }
                                  }
                                  else
                                  {
                                      NSLog(@"failBlock");
                                      NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:@"102102",@"resultCode", nil];
                                      
                                      fail(result);
                                  }
                              }];
    [task resume];
}


//- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
// completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * __nullable credential))completionHandler{
//
//    NSLog(@"challenge start");
//    NSLog(@"challenge is %@",challenge);
//
//
//    OSStatus err;
//    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
//    SecTrustResultType  trustResult = kSecTrustResultInvalid;
//    NSURLCredential *credential = nil;
//
//    //获取服务器的trust object
//    SecTrustRef serverTrust = challenge.protectionSpace.serverTrust;
//    NSLog(@"challenge serverTrust is %@",challenge.protectionSpace.serverTrust);
//
//    SecTrustSetAnchorCertificates(serverTrust, NO);
//    err = SecTrustEvaluate(serverTrust, &trustResult);
//
//    NSLog(@"no error");
//
//    if ((err == errSecSuccess) && (trustResult == kSecTrustResultProceed || trustResult == kSecTrustResultUnspecified))
//    {
//        //认证成功，则创建一个凭证返回给服务器
//        disposition = NSURLSessionAuthChallengeUseCredential;
//        credential = [NSURLCredential credentialForTrust:serverTrust];
//        NSLog(@"认证成功");
//    }
//    else
//    {
//        disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
//        NSLog(@"认证失败");
//    }
//
//    //回调凭证，传递给服务器
//    if(completionHandler)
//    {
//        NSLog(@"回传给服务器");
//        completionHandler(disposition, credential);
//    }
//}

@end
