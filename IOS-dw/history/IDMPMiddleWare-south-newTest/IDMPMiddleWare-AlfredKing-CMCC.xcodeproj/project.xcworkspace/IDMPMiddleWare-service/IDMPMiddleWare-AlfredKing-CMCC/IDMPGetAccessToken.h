//
//  IDMPGetAccessToken.h
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking－cmcc on 14/10/23.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDMPGetAccessToken : NSObject

-(NSDictionary *) getAccessTokenByAppid: (NSString *)appid andAppKey:(NSString *) appkey andUserName:(NSString *) username andLoginType:(NSString *) loginType;
-(BOOL)getUPKSByUserName:(NSString *)userName andPassWd:(NSString *)passWd;

@end
