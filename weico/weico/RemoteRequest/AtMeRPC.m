//
//  AtMeRPC.m
//  Fenvo
//
//  Created by Caesar on 15/8/9.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "AtMeRPC.h"
#import "AppDelegate.h"
#import "JSONKit.h"
#import "WeiboMsg.h"
#import "WeiboAtMeStore.h"
#import "AFHTTPRequestOperationManager.h"

@implementation AtMeRPC

+ (void)getAtMeWithSinceId:(NSNumber *)since_id orMaxId:(NSNumber *)max_id atMeType:(AtMeType)atMeType success:(requestAtMeSuccessBlock)success failure:(requestAtMeFailureBlock)failure {
    
    NSMutableArray *atMeArray = [[NSMutableArray alloc]init];
    
    //http请求头应该添加text/plain。接受类型内容无text/plain
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[AFJSONResponseSerializer alloc]init];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    
    NSString *requestUrl;
    switch (atMeType) {
        case AtMeType_FromAll:
            requestUrl = AtMe_FromAll;
            break;
            
        default:
            break;
    }
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSDictionary *dict;
    if (since_id == nil && max_id == nil) {
        dict = @{@"access_token":WEIBO_TOKEN};
    }else if(since_id != nil && max_id == nil){
        dict = @{@"access_token":WEIBO_TOKEN, @"since_id":since_id};
    }else if(since_id == nil && max_id != nil){
        dict = @{@"access_token":WEIBO_TOKEN, @"max_id":max_id};
    }
    
    
    [manager GET:requestUrl
      parameters:dict
         success:^(AFHTTPRequestOperation *operation, id responserObject){
             NSError *error;
             NSData *jsonDatas = [responserObject
                                  JSONDataWithOptions:NSJSONWritingPrettyPrinted
                                  error:&error];
             NSString *jsonStrings = [[NSString alloc]
                                      initWithData:jsonDatas
                                      encoding:NSUTF8StringEncoding];
             
             NSDictionary *dict = [jsonStrings objectFromJSONString];
             long long max_id = [dict[@"max_id"] longLongValue];
             
             jsonStrings = [self getNormalJSONString:jsonStrings];
             
             
             NSArray *weiboMsgDictionary = [jsonStrings objectFromJSONString];
             if (weiboMsgDictionary.count > 0) {
                 
                 for (int i = 0; i < weiboMsgDictionary.count; i ++) {
                     NSDictionary *dict = weiboMsgDictionary[i];
                     WeiboMsg *weiboMsg = [WeiboMsg createByDictionary:dict Option:YES];
                     WeiboAtMeStore *atMe = [WeiboAtMeStore createByWeiboMsg:weiboMsg];
                     [atMeArray addObject:atMe];
                     
                 }
             }
             
             success([atMeArray copy], @(max_id));
             
             
         }failure:^(AFHTTPRequestOperation *operation, NSError *error){
             failure(@"Get home timeline failure . %d",error);
         }];
}



#pragma mark - 对微博API返回的数据进行截断

+ (NSString *)getNormalJSONString:(NSString *)jsonStrings{
    
        NSString *str1;
        NSRange rangeLeft = [jsonStrings rangeOfString:@"\"statuses\":"];
        str1 = [jsonStrings substringFromIndex:rangeLeft.location+rangeLeft.length];
        
        NSRange rangeRight = [str1 rangeOfString:@"\"total_n"];
        if (rangeRight.length > 0) {
            jsonStrings = [str1 substringToIndex:rangeRight.location - 4];
        }
        
        return jsonStrings;
    }

@end
