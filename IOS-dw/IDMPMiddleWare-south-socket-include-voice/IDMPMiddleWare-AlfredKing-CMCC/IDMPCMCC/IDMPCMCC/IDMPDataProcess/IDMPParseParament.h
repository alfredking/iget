//
//  IDMPParseParament.h
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking－cmcc on 14-8-28.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDMPParseParament : NSObject

+(NSDictionary *) parseParamentFrom:(NSString *)wwwauthenticate;
+(NSDictionary *) updateParseParamentFrom:(NSString *)wwwauthenticate;
+(void)changeDataStorage;
+ (NSDictionary *)dicionaryWithjsonString:(NSString *)jsonString;
@end
