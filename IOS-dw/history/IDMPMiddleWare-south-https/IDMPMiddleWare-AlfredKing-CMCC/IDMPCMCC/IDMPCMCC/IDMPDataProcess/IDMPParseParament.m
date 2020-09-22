//
//  IDMPParseParament.m
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking－cmcc on 14-8-28.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import "IDMPParseParament.h"
#import "IDMPConst.h"
#import "userInfoStorage.h"

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

+(void)changeDataStorage
{
    
    NSMutableArray *users=[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:userList]];
    if (users.count)
    {
        NSLog(@"user count is %d",users.count);
        for (int i=0; i<users.count; i++)
        {
            if ([users[i]isKindOfClass:[NSDictionary class]])
            {
                NSString *name = [users[i] objectForKey:@"userName"];
                NSLog(@"username is %@",name);
                NSMutableDictionary *user =[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:name]];
                
                [userInfoStorage setInfo:user withKey:name];
            }
        }
    }

    
    NSArray *storageKey=[[NSArray alloc] initWithObjects:IDMP_APPIDsk,IDMP_APPKEYsk,userList,deviceIdsk,hasCheckedsk,isSipAppsk,ksUpdateDate,nowLoginUser,secDataSmsHttpTimesk,secwapURL,sourceIdsk,nil];

        for (int i=0; i<storageKey.count; i++)
        {
            
          NSLog(@"storageKey count is %d",storageKey.count);
            NSLog(@"storageKey %d is %@",i,storageKey[i]);
          id tempParaments=[[NSUserDefaults standardUserDefaults]objectForKey:storageKey[i]];
             if ([tempParaments isKindOfClass:[NSString class]])
             {
                 if ([tempParaments length]>0)
                     
                     NSLog(@"tempParaments is %@",tempParaments);
                 [userInfoStorage setInfo:tempParaments withKey:storageKey[i]];
            }
            else if ([tempParaments isKindOfClass:[NSDictionary class]])
            {
                if ([tempParaments count]>0)
                {
                    
                   NSLog(@"tempParaments is %@",tempParaments);
                   [userInfoStorage setInfo:tempParaments withKey:storageKey[i]];
                }
            }
            else
            {
                if ([tempParaments count]>0)
                {
                    
                    NSLog(@"tempParaments is %@",tempParaments);
                [userInfoStorage setInfo:tempParaments withKey:storageKey[i]];
                }
            }
           
        }
   
    
}

@end
