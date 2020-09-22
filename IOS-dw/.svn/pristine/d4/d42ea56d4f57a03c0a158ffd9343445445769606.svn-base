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
#import "IDMPAutoLoginViewController.h"

@implementation IDMPHttpRequest


-(void)getWithHeads:(NSDictionary *)heads url:(NSString *)urlStr successBlock:(ASIBasicBlock)successBlock failBlock:(ASIBasicBlock)failBlock
{
    NSLog(@"http URL:%@",urlStr);
    NSMutableURLRequest * request1 = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
    request1.allHTTPHeaderFields = heads;
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = [[NSError alloc] init];
    NSData *data= [NSURLConnection sendSynchronousRequest:request1  returningResponse:&urlResponse error:&error];
    NSLog(@"getWithHeads receive data %@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    int statusCode = [urlResponse statusCode];
    NSLog(@"statusCode is %d",statusCode);
    self.responseHeaders  = urlResponse.allHeaderFields;
    NSLog(@"res %@",self.responseHeaders);
    if(statusCode==200)
    {
        if ([[self.responseHeaders objectForKey:@"resultCode"]integerValue] == 103000) {
            successBlock();
        }else{
            NSLog(@"%@",self.responseHeaders);
            failBlock();
        }
        
    }
    else
    {
        NSLog(@"http fail");
        failBlock();
    }
}

- (void)getHttpByHeads:(NSDictionary *)heads url:(NSString *)urlStr successBlock:(ASIBasicBlock)successBlock failBlock:(ASIBasicBlock)failBlock
{
    NSLog(@"http URL:%@",urlStr);
    NSString *str = urlStr;
    NSURL *url = [NSURL URLWithString:str];
    NSMutableURLRequest * request1 = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
    request1.allHTTPHeaderFields = heads;
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:request1 queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
    {
        if (data == nil) {
//            self.responseStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            failBlock();
            return ;
        }else{
            
            self.responseStr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        }
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        self.responseHeaders = httpResponse.allHeaderFields;
        NSLog(@"get responseHeader:%@",self.responseHeaders);
        if (httpResponse.statusCode == 200) {
            if ([[self.responseHeaders objectForKey:@"resultCode"]integerValue] == 103000) {
                successBlock();
            }else{
                NSLog(@"%@",self.responseHeaders);
                failBlock();
            }
             NSLog(@"请求成功 %ld",httpResponse.statusCode);
        }
        else
        {
            NSLog(@"failBlock %ld",httpResponse.statusCode);
            failBlock();
        }
    }];
}

//+ (IDMPHttpRequest *)getHttpWithDict:(NSDictionary *)content url:(NSString *)urlStr successBlock:(ASIBasicBlock)successBlock failBlock:(ASIBasicBlock)failBlock
//{
//    IDMPHttpRequest *request = [[IDMPHttpRequest alloc]init];
//    [request getHttpWithDict:content url:urlStr successBlock:successBlock failBlock:failBlock];
//    return request;
//}

- (void)getHttpWithDict:(NSDictionary *)content url:(NSString *)urlStr successBlock:(ASIBasicBlock)successBlock failBlock:(ASIBasicBlock)failBlock
{
    NSLog(@"http URL:%@",urlStr);
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
         NSDictionary *dict = nil;
//         self.responseStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
         if (data == nil) {
             failBlock();
             return ;
         }else{
             self.responseStr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
             dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
         }
         NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
         self.responseHeaders = httpResponse.allHeaderFields;
         NSDictionary *header = [dict objectForKey:@"header"];
         if (httpResponse.statusCode == 200) {
             if ([[header objectForKey:@"resultcode"]integerValue] == 103000) {
                 successBlock();
             }else{
                 NSLog(@"%@",self.responseHeaders);
                 failBlock();
             }

         }
         else
         {
             NSLog(@"failBlock");
             failBlock();
         }
     }];
}


+ (NSDictionary *)dictToJSON:(NSDictionary *)dict
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyyMMddHHmmssSSS"];
    NSString *currentDateStr = [dateFormat stringFromDate:[NSDate date]];
    NSMutableDictionary *header = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1.0",@"version",@"5",@"apptype",currentDateStr,@"systemtime",@"abcde",@"msgid",  nil];
    [header setValue:[dict objectForKey:@"sourceId"] forKey:@"sourceid"];
    NSMutableDictionary *body = [NSMutableDictionary dictionaryWithObjectsAndKeys:[dict objectForKey:@"token"],@"token",[dict objectForKey:@"hmac"],@"hmac", nil];
    NSDictionary *msg = [NSDictionary dictionaryWithObjectsAndKeys:header,@"header",body,@"body", nil];
    return msg;
}



@end
