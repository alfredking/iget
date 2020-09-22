//
//  IDMPToken.h
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking－cmcc on 14-9-10.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^callBackBlock)(NSDictionary *dic);
@interface IDMPToken : NSObject

+ (NSString *)getTokenWithUserName:(NSString *)userName andAppId:(NSString *)appId;


int signkey(char *userName,char *appid, char* version, unsigned char** ptoken);

+ (void)checkToken:(NSString *)Token successBlock:(callBackBlock)success failBlock:(callBackBlock)fail;

@end
