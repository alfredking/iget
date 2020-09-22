//
//  IDMPParseParament.m
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking－cmcc on 14-8-28.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import "IDMPParseParament.h"
#import "NSString+IDMPAdd.h"
#import "userInfoStorage.h"

@implementation IDMPParseParament

+(NSDictionary *)parseParamentFrom:(NSString *)wwwauthenticate
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
   return [result copy];
}

+(NSDictionary *)updateParseParamentFrom:(NSString *)wwwauthenticate
{
    NSArray *params = [wwwauthenticate componentsSeparatedByString:@","];
    NSMutableDictionary *result=[[NSMutableDictionary alloc]init] ;
    NSString *KSRTYPE=@"null";
    for(NSString *object in params)
    {
        NSArray *KV= [object componentsSeparatedByString:@"\""];
        NSString *key=(NSString *)KV[0];
        key=[key substringToIndex:key.length-1];
        if ([key idmp_containsString:@"Nonce"])
        {
            NSArray *ksType = [key componentsSeparatedByString:@" "];
            NSLog( @"array is %@",ksType);
            KSRTYPE=[ksType objectAtIndex:0];
            key=@"Nonce";
        }
        NSString *value=(NSString *)KV[1];
        [result setObject: value forKey:key];
    }
    [result setObject: KSRTYPE forKey:@"KSRTYPE"];
    return [result copy];
}

+ (NSDictionary *)dicionaryWithjsonString:(NSString *)jsonString {
    if (!jsonString) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    if (!jsonData) {
        return nil;
    }
    NSError *error;
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        NSLog(@"json serialization error is %@", error);
        return nil;
    }
    return jsonDic;
}

+ (NSDictionary *)dictionaryWithSocketJsonArray:(NSArray *)jsonArray {
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *allcode = (NSString *)jsonArray[0];
    NSArray *codeArr = [allcode componentsSeparatedByString:@" "];
    NSString *code = nil;
    if(codeArr.count >= 2) {
        code = codeArr[1];
    }
    if (code) {
        [result setObject:code forKey:@"statusCode"];
    }
    for(NSString *object in jsonArray) {
        NSArray *KV= [object componentsSeparatedByString:@": "];
        if (KV.count == 2) {
            NSString *key=(NSString *)KV[0];
            NSString *value=(NSString *)KV[1];
            [result setObject: value forKey:key];
        }

    }
    return [result copy];
}

+(void)changeDataStorage
{
    //所有user defaults存储要加上重试机制
    NSMutableArray *users=[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:userList]];
    NSLog(@"user count is %lu",(unsigned long)users.count);
    if (users.count)
    {
        NSMutableArray *encUsers=[NSMutableArray arrayWithArray:(NSArray *)[userInfoStorage getInfoWithKey:userList]];
        if (encUsers.count==0)
        {
            
            BOOL changeSucess=YES;
            int i=0,j=0;
            for (i=0; i<users.count; i++)
            {
                if ([users[i]isKindOfClass:[NSDictionary class]])
                {
                    NSString *name = [users[i] objectForKey:IDMPUserName];
                    NSLog(@"username is %@",name);
                    NSMutableDictionary *user =[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:name]];
                    
                    if (![userInfoStorage setInfo:user withKey:name])
                    {
                        changeSucess=NO;
                    }
                }
            }
            
            NSArray *storageKey=[[NSArray alloc] initWithObjects:isChecked,userList,IDMP_APPIDsk,IDMP_APPKEYsk,sourceIdsk,nil];
            
            for (j=0; j<storageKey.count; j++)
            {
                
                NSLog(@"storageKey count is %lu",(unsigned long)storageKey.count);
                NSLog(@"storageKey %d is %@",i,storageKey[i]);
                id tempParaments=[[NSUserDefaults standardUserDefaults]objectForKey:storageKey[i]];
                if ([tempParaments isKindOfClass:[NSString class]])
                {
                    if ([tempParaments length]>0)
                        
                    NSLog(@"tempParaments is %@",tempParaments);
                    if (! [userInfoStorage setInfo:tempParaments withKey:storageKey[i]]) {
                        changeSucess=NO;
                    }
                   
                }
                else
                {
                    if ([tempParaments count]>0)
                    {
                        
                        NSLog(@"tempParaments is %@",tempParaments);
                        if (! [userInfoStorage setInfo:tempParaments withKey:storageKey[i]]) {
                            changeSucess=NO;
                        }
                    }
                }
                
            }
            if (changeSucess&&i==users.count&&j==storageKey.count)
            {
                [users removeAllObjects];
                [[NSUserDefaults standardUserDefaults]setObject:users forKey:userList];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
        }
        else
        {
            [users removeAllObjects];
            [[NSUserDefaults standardUserDefaults]setObject:users forKey:userList];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
    }
}

@end
