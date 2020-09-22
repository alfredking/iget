//
//  secFileStorage.m
//  IDMPCMCC
//
//  Created by alfredking－cmcc on 16/7/11.
//  Copyright © 2016年 zwk. All rights reserved.
//

#import "secFileStorage.h"
#import "IDMPAES128.h"
#include <pthread.h>
#import "IDMPConst.h"
#import "IDMPKDF.h"
#import "IDMPFormatTransform.h"



@implementation secFileStorage

pthread_rwlock_t rwlock = PTHREAD_RWLOCK_INITIALIZER;
NSString *secrandomkey;

+(BOOL)setUserInfo:(NSDictionary *)userInfo withError: (NSError **)fileError
{
    
    
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"userInfo"];
    NSLog(@"plistPath path is %@",plistPath);
    pthread_rwlock_wrlock(&rwlock);
   
    if(secrandomkey.length<=0)
    {
       
        secrandomkey=[self getEncrptKey];
        
    }
    
   
    NSData *infoData = [NSKeyedArchiver archivedDataWithRootObject:userInfo] ;
    
    NSData *EncInfoData=[IDMPAES128 AESEncryptWithKey:secrandomkey andData:infoData];
    
    if ([EncInfoData writeToFile:plistPath options:NSDataWritingAtomic error:fileError])
    {
        NSLog(@"first store");
        pthread_rwlock_unlock(&rwlock);
        
        return YES;
    }
    else if ([EncInfoData writeToFile:plistPath options:NSDataWritingAtomic error:fileError])
    {
        NSLog(@"second store");
        pthread_rwlock_unlock(&rwlock);
        return YES;
    }
    else if ([EncInfoData writeToFile:plistPath options:NSDataWritingAtomic error:fileError])
    {
         NSLog(@"third store");
        pthread_rwlock_unlock(&rwlock);
        
        return YES;
    }
    NSLog(@"file store error:%@", *fileError);
    pthread_rwlock_unlock(&rwlock);
    return NO;
    
}



+(NSDictionary *)getUserInfoWithError: (NSError **)fileError
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"userInfo"];
    
    NSLog(@"plistPath path is %@",plistPath);
      pthread_rwlock_wrlock(&rwlock);
    
    if(secrandomkey.length<=0)
    {
        
        secrandomkey=[self getEncrptKey];
        
    }
    
    NSData *userData = [NSData dataWithContentsOfFile:plistPath options:NSDataReadingMappedIfSafe  error:fileError];
    NSLog(@"fileError is %@",*fileError);
    if (*fileError)
    {
        NSLog(@"first read error %@",*fileError);
        userData = [NSData dataWithContentsOfFile:plistPath options:NSDataReadingMappedIfSafe  error:fileError];
        if (*fileError)
        {
            NSLog(@"second read error %@",*fileError);
            userData = [NSData dataWithContentsOfFile:plistPath options:NSDataReadingMappedIfSafe  error:fileError];
            NSLog(@"third read error %@",*fileError);
        }
    }
    
     NSLog(@"first read");

    if (!*fileError)
    {
        if (userData.length==0)
        {
            NSLog(@"userdata is null");
            userData = [NSData dataWithContentsOfFile:plistPath options:NSDataReadingMappedIfSafe  error:fileError];
            NSLog(@"second read userdata %@,error  %@",userData,*fileError);
            if (userData.length==0)
            {
                userData = [NSData dataWithContentsOfFile:plistPath options:NSDataReadingMappedIfSafe  error:fileError];
                NSLog(@"third read userdata %@,error  %@",userData,*fileError);
            }

        }
        NSData *decUserData=[IDMPAES128 AESDecryptWithKey:secrandomkey andData:userData];
        
        NSDictionary *users = [NSKeyedUnarchiver unarchiveObjectWithData:decUserData];
        
        pthread_rwlock_unlock(&rwlock);
        return users;

    }
    else
    {
        
        NSLog(@"file read error:%@", *fileError );
        NSLog(@"userdata before decrypt is null");
        pthread_rwlock_unlock(&rwlock);
        return nil;

    }
    
   }

+(NSString *)getEncrptKey
{
    NSString *deviceId=[[UIDevice currentDevice].identifierForVendor UUIDString];
    double   PI= M_PI;
    double LOG2E=M_LOG2E;
    NSString *pi = [NSDecimalNumber numberWithDouble:M_PI].description;
    NSString *log2e=(NSString *)[NSDecimalNumber numberWithDouble:M_LOG2E].description;
    NSLog(@"deviceId is %@,pi is %@,log2e is %@",deviceId,pi,log2e);
    
    unsigned char *enckey=kdf_sms((unsigned char *)[deviceId UTF8String],(char *)[pi UTF8String],(char *)[log2e UTF8String]);
    NSString *enkey=[IDMPFormatTransform charToNSHex:enckey length:16];
    free(enckey);
    enckey=NULL;
    
    
    NSLog(@"enkey is %@",enkey);
    return enkey;

}

@end
