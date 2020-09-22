//
//  IDMPUPMode.m
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking－cmcc on 14-8-21.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import "IDMPUPMode.h"
#import "NSString+IDMPAdd.h"
#import "IDMPFormatTransform.h"
#import "IDMPHttpRequest.h"
#import "userInfoStorage.h"
#import "IDMPAuthModel.h"
#import "IDMPCheckKS.h"
#import "IDMPRusultHandler.h"

@implementation IDMPUPMode

- (void)getUPKSWithSipInfo:(NSString *)sipinfo UserName:(NSString *)userName andPassWd:(NSString *)passWd traceId:(NSString *)traceId successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    NSString *clientNonce = [NSString idmp_getClientNonce];
    IDMPAuthModel *authModel = [[IDMPAuthModel alloc] initUPWithUserName:userName password:passWd sipInfo:sipinfo clientNonce:clientNonce traceId:traceId];
    NSDictionary *heads = authModel.heads;
    IDMPHttpRequest *request = [[IDMPHttpRequest alloc]init];
    [request getAsynWithHeads:heads url:requestUrl timeOut:20 successBlock:^(NSDictionary *parameters){
        @autoreleasepool {
            NSDictionary *wwwauthenticate = [IDMPCheckKS checkUPKSIsValid:parameters clientNonce:clientNonce userName:userName passWd:passWd];
            [IDMPRusultHandler getRusultByHandlerWWWAuthenticate:wwwauthenticate userName:userName authType:IDMPUP sipinfo:sipinfo traceId:traceId isTmpCache:NO successBlock:successBlock failBlock:failBlock];
        }
    } failBlock:^(NSDictionary *parameters){
         if (failBlock) {
             failBlock(parameters);
         }
     }];
    
}


@end
