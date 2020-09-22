//
//  userInfoStorage.m
//  IDMPCMCC
//
//  Created by alfredking－cmcc on 16/7/12.
//  Copyright © 2016年 zwk. All rights reserved.
//

#import "userInfoStorage.h"
#import "secFileStorage.h"

@implementation userInfoStorage


+(BOOL)setInfo:(NSDictionary *)userInfo withKey:(NSString *)key
{
//    [[NSUserDefaults standardUserDefaults] setValue:userInfo forKey:key];
//    int synchronizeResult=[[NSUserDefaults standardUserDefaults] synchronize];
//    NSLog(@"setInfo result %d",synchronizeResult);
//    if(!synchronizeResult)
//    {
//        NSLog(@"synchronize retry");
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        return YES;
//    }
//    return YES;
    
    NSMutableDictionary *user=[secFileStorage  getUserInfo];
    
    if (user)
    {
        [user setObject:userInfo forKey:key];
    }
    else
    {
        user=[NSMutableDictionary dictionaryWithObjectsAndKeys:userInfo,key, nil];
    }
    
    
    
    if ([secFileStorage setUserInfo:user]) {
        return YES;
    }
    else
    {
        return NO;
    }
    
    

}
+(NSDictionary *)getInfoWithKey:(NSString *)key
{
   
//    return  [[NSUserDefaults standardUserDefaults]objectForKey:key];
    NSDictionary *user=[secFileStorage getUserInfo];
//    NSLog(@"getinfo user is %@",user);
    NSDictionary *result=[user objectForKey:key];
    return result;
    
}

+(BOOL)removeInfoWithKey:(NSString *)key

{
    //      [[NSUserDefaults standardUserDefaults]removeObjectForKey:key];
    //      return YES;
        NSMutableDictionary *user=[secFileStorage  getUserInfo];
        [user removeObjectForKey:key];
        if ([secFileStorage setUserInfo:user]) {
            return YES;
        }
        else
        {
            return NO;
        }


}

@end
