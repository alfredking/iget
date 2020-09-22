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
#import "IDMPDevice.h"


@implementation IDMPHttpRequest


- (void)getWithHeads:(NSDictionary *)heads url:(NSString *)urlStr successBlock:(ASIBasicBlock)successBlock failBlock:(ASIBasicBlock)failBlock
{
    NSLog(@"http url=%@",urlStr);
    NSLog(@"http head:%@",heads);
    NSMutableURLRequest * request1 = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
    request1.allHTTPHeaderFields = heads;
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = nil;
    NSData *data= [NSURLConnection sendSynchronousRequest:request1  returningResponse:&urlResponse error:&error];
    NSLog(@"receive data %@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    int statusCode = [urlResponse statusCode];
    NSLog(@"statusCode is %d",statusCode);
    self.responseHeaders  = urlResponse.allHeaderFields;
    NSLog(@"res %@",self.responseHeaders);
    if(statusCode==200)
    {
        NSInteger  resultCode = [[self.responseHeaders objectForKey:@"resultCode"] integerValue];
        if (resultCode == 103000)
        {
            successBlock();
        }
        else if (resultCode == IDMPChangeURL)
        {
            //切换地址
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"action_url"] isEqualToString:@"1"])
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"action_url"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            else
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"action_url"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            [self secondGetHttpByHeads:heads url:urlStr successBlock:successBlock failBlock:failBlock];
        }
        else
        {
            NSLog(@"%@",self.responseHeaders);
            failBlock();
        }
    }
    else
    {
        if ([IDMPDevice getAuthType] > 0)
        {
            //切换地址
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"action_url"] isEqualToString:@"1"])
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"action_url"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            else
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"action_url"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            [self secondGetHttpByHeads:heads url:urlStr successBlock:successBlock failBlock:failBlock];
        }
        else
        {
            NSLog(@"http fail");
            failBlock();
        }
    }
}



- (void)getHttpByHeads:(NSDictionary *)heads url:(NSString *)urlStr successBlock:(ASIBasicBlock)successBlock failBlock:(ASIBasicBlock)failBlock
{
    NSLog(@"http url=%@",urlStr);
    NSLog(@"http head:%@",heads);
    NSString *str = urlStr;
    NSURL *url = [NSURL URLWithString:str];
    NSMutableURLRequest * request1 = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
    request1.allHTTPHeaderFields = heads;
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    NSLog(@"operation queue begins");
    [NSURLConnection sendAsynchronousRequest:request1 queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         if (data == nil)
         {
             NSLog(@"data is null");
             failBlock();
             return ;
         }
         else
         {
             self.responseStr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
         }
         NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
         self.responseHeaders = httpResponse.allHeaderFields;
         NSLog(@"statuscode is %d",httpResponse.statusCode);
         NSLog(@"response:%@",self.responseHeaders);
         if (httpResponse.statusCode == 200)
         {
             NSInteger  resultCode = [[self.responseHeaders objectForKey:@"resultCode"] integerValue];
             if (resultCode == 103000)
             {
                 successBlock();
             }
             else if (resultCode == IDMPChangeURL)
             {
                 //切换地址
                 if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"action_url"] isEqualToString:@"1"])
                 {
                     [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"action_url"];
                     [[NSUserDefaults standardUserDefaults] synchronize];
                 }
                 else
                 {
                     [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"action_url"];
                     [[NSUserDefaults standardUserDefaults] synchronize];
                 }
                 [self secondGetHttpByHeads:heads url:urlStr successBlock:successBlock failBlock:failBlock];
             }
             else
             {
                 failBlock();
             }
         }
         else
         {
             NSLog(@"failBlock %d",httpResponse.statusCode);
             if ([IDMPDevice getAuthType] > 0)
             {
                 //切换地址
                 if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"action_url"] isEqualToString:@"1"])
                 {
                     [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"action_url"];
                     [[NSUserDefaults standardUserDefaults] synchronize];
                 }
                 else
                 {
                     [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"action_url"];
                     [[NSUserDefaults standardUserDefaults] synchronize];
                 }
                 [self secondGetHttpByHeads:heads url:urlStr successBlock:successBlock failBlock:failBlock];
             }
             else
             {
                 failBlock();
             }
         }
     }];
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
    NSLog(@"http head:%@",content);
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
         if (data == nil)
         {
             failBlock();
             return ;
         }
         else
         {
             self.responseStr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
             dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
         }
         NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
         self.responseHeaders = httpResponse.allHeaderFields;
         NSDictionary *header = [dict objectForKey:@"header"];
         if (httpResponse.statusCode == 200)
         {
             if ([[header objectForKey:@"resultcode"]integerValue] == 103000)
             {
                 successBlock();
             }
             else
             {
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
    NSMutableDictionary *body = [NSMutableDictionary dictionaryWithObjectsAndKeys:[dict objectForKey:@"token"],@"token", nil];
    NSDictionary *msg = [NSDictionary dictionaryWithObjectsAndKeys:header,@"header",body,@"body", nil];
    return msg;
}

- (void)secondGetHttpByHeads:(NSDictionary *)heads url:(NSString *)urlStr successBlock:(ASIBasicBlock)successBlock failBlock:(ASIBasicBlock)failBlock
{
    NSLog(@"http url=%@",urlStr);
    NSLog(@"http head:%@",heads);
    NSArray *tempArr = [urlStr componentsSeparatedByString:@"/"];
    NSString *newURLStr = [NSString stringWithFormat:@"%@/%@/%@",nowURL,[tempArr objectAtIndex:[tempArr count]-2],[tempArr lastObject]];
    NSLog(@"newURLStr:%@",newURLStr);
    NSURL *url = [NSURL URLWithString:newURLStr];
    NSMutableURLRequest * request1 = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
    request1.allHTTPHeaderFields = heads;
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    NSLog(@"operation queue begins");
    
    [NSURLConnection sendAsynchronousRequest:request1 queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         if (data == nil)
         {
             NSLog(@"data is null");
             failBlock();
             return ;
         }
         NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
         self.responseHeaders = httpResponse.allHeaderFields;
         NSLog(@"statuscode is %d",httpResponse.statusCode);
         NSLog(@"http response:%@",self.responseHeaders);
         if (httpResponse.statusCode == 200)
         {
             NSInteger  resultCode = [[self.responseHeaders objectForKey:@"resultCode"] integerValue];
             if (resultCode == 103000)
             {
                 successBlock();
             }
             else if (resultCode == IDMPChangeURL)
             {
                 //切换地址
                 if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"action_url"] isEqualToString:@"1"])
                 {
                     [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"action_url"];
                     [[NSUserDefaults standardUserDefaults] synchronize];
                 }
                 else
                 {
                     [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"action_url"];
                     [[NSUserDefaults standardUserDefaults] synchronize];
                 }
                 failBlock();
             }
             else
             {
                 failBlock();
             }
         }
         else
         {
             if ([IDMPDevice getAuthType] > 0)
             {
                 //切换地址
                 if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"action_url"] isEqualToString:@"1"])
                 {
                     [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"action_url"];
                     [[NSUserDefaults standardUserDefaults] synchronize];
                 }
                 else
                 {
                     [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"action_url"];
                     [[NSUserDefaults standardUserDefaults] synchronize];
                 }
                 failBlock();
             }
             else
             {
                 failBlock();
             }
         }
     }];
}

@end
