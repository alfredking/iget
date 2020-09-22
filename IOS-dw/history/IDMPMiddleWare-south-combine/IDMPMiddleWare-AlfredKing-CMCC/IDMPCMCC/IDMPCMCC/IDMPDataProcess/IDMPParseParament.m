//
//  IDMPParseParament.m
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking－cmcc on 14-8-28.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import "IDMPParseParament.h"

@implementation IDMPParseParament

+(NSMutableDictionary *) parseParamentFrom:(NSString *)wwwauthenticate
{
    NSArray *params = [wwwauthenticate componentsSeparatedByString:@","];
    NSMutableDictionary *result=[[NSMutableDictionary alloc]init] ;
    for(NSString *object in params)
    {
        NSArray *KV= [object componentsSeparatedByString:@"\""];
        NSString *key=(NSString *)KV[0];
        key=[key substringToIndex:key.length-1];
        NSString *value=(NSString *)KV[1];
        [result setObject: value forKey:key];
    }
    return result;
}

@end
