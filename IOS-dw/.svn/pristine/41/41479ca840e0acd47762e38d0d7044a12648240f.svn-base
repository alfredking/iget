//
//  secFileStorage.m
//  IDMPCMCC
//
//  Created by alfredking－cmcc on 16/7/11.
//  Copyright © 2016年 zwk. All rights reserved.
//

#import "secFileStorage.h"
#import "IDMPAES128.h"
#import "KeychainItemWrapper.h"
#include <pthread.h>
#import "IDMPConst.h"


@implementation secFileStorage

pthread_mutex_t rwlock = PTHREAD_MUTEX_INITIALIZER;

+(BOOL)setUserInfo:(NSDictionary *)userInfo
{
  NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                  NSUserDomainMask, YES) objectAtIndex:0];
       
  NSString *plistPath = [rootPath stringByAppendingPathComponent:@"userInfo"];
        
    
    pthread_rwlock_wrlock(&rwlock);
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:AESEncKeysk accessGroup:nil];
    NSString *secrandomkey=[wrapper objectForKey:(id)kSecValueData];
    if(secrandomkey.length<=0)
    {
       
        uint8_t randomBytes[16];
        int result = SecRandomCopyBytes(kSecRandomDefault, 16, randomBytes);
        if(result == 0)
        {
            NSMutableString *AESCBCKey = [[NSMutableString alloc] initWithCapacity:32];
            for(NSInteger index = 0; index < 16; index++)
            {
                [AESCBCKey appendFormat: @"%02x", randomBytes[index]];
                
            }
            NSLog(@"AESCBCKey is %@",AESCBCKey);
            [wrapper setObject:AESCBCKey forKey:(id)kSecValueData];
            
        }
        else
        {
            NSLog(@"SecRandomCopyBytes failed for some reason");
        }
        
        
        
    }
    
   
    NSData *infoData = [NSKeyedArchiver archivedDataWithRootObject:userInfo] ;
    
    
    NSData *EncInfoData=[IDMPAES128 AESEncryptWithKey:secrandomkey andData:infoData];
    
    if ([EncInfoData writeToFile:plistPath atomically:NO])
    {
        
        pthread_rwlock_unlock(&rwlock);
        
        return YES;
    }
    pthread_rwlock_unlock(&rwlock);
    return NO;
    
}



+(NSDictionary *)getUserInfo
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"userInfo"];

    pthread_rwlock_rdlock(&rwlock);
    
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:AESEncKeysk accessGroup:nil];
    NSString *secrandomkey=[wrapper objectForKey:(id)kSecValueData];
    if(secrandomkey.length<=0)
    {
        
        NSLog(@"secrandomkey does exit");
        return nil;
    }
    
    
    NSData *userData = [NSData dataWithContentsOfFile:plistPath];
    
    NSData *decUserData=[IDMPAES128 AESDecryptWithKey:secrandomkey andData:userData];
    
    NSDictionary *users = [NSKeyedUnarchiver unarchiveObjectWithData:decUserData];
    
    pthread_rwlock_unlock(&rwlock);
    return users;
}

@end
