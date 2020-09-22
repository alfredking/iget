//
//  secFileStorage.m
//  IDMPCMCC
//
//  Created by alfredking－cmcc on 16/7/11.
//  Copyright © 2016年 zwk. All rights reserved.
//

#import "secFileStorage.h"
#import "NSData+IDMPAdd.h"
#include <pthread.h>
#import "IDMPKDF.h"
#import "NSString+IDMPAdd.h"


@implementation secFileStorage

pthread_rwlock_t rwlock = PTHREAD_RWLOCK_INITIALIZER;

NSString *secrandomkey;

+(BOOL)setUserInfo:(NSDictionary *)userInfo withError: (NSError **)fileError
{
    
    
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"userInfo"];
    
    pthread_rwlock_wrlock(&rwlock);
    
   
    if(secrandomkey.length<=0)
    {
       
        secrandomkey=[self getEncrptKey];
        
    }
    
    NSData *infoData = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
    
    NSData *EncInfoData = [infoData idmp_aesEncryptWithKey:secrandomkey];
    
    if ([EncInfoData writeToFile:plistPath options:NSDataWritingAtomic error:fileError])
    {
        NSLog(@"first store to file success");
        pthread_rwlock_unlock(&rwlock);
        return YES;
    }
    else if ([EncInfoData writeToFile:plistPath options:NSDataWritingAtomic error:fileError])
    {
        NSLog(@"second store to file success");
        pthread_rwlock_unlock(&rwlock);
        
        return YES;
    }
    else if ([EncInfoData writeToFile:plistPath options:NSDataWritingAtomic error:fileError])
    {
         NSLog(@"third store to file success");
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
    
    
    pthread_rwlock_wrlock(&rwlock);
    
    
    if(secrandomkey.length<=0)
    {
        
        secrandomkey=[self getEncrptKey];

    }
    NSLog(@"start read file");
    NSData *userData = [NSData dataWithContentsOfFile:plistPath options:NSDataReadingMappedIfSafe  error:fileError];

    if (*fileError)
    {
        NSLog(@"first read file error with code %ld",(long)(*fileError).code);
        userData = [NSData dataWithContentsOfFile:plistPath options:NSDataReadingMappedIfSafe  error:fileError];
        if (*fileError)
        {
            NSLog(@"second read file error with code %ld",(long)(*fileError).code);
            userData = [NSData dataWithContentsOfFile:plistPath options:NSDataReadingMappedIfSafe  error:fileError];
            NSLog(@"third read file error with code %ld",(long)(*fileError).code);
        }
    }
    

    if (!*fileError)
    {
        NSLog(@"has readed file");
        if (userData.length==0)
        {
            NSLog(@"userdata is null and try read file again");
            userData = [NSData dataWithContentsOfFile:plistPath options:NSDataReadingMappedIfSafe  error:fileError];
            NSLog(@"second read userdata %@,error %@",userData,*fileError);
            if (userData.length==0)
            {
                NSLog(@"userdata is null and try read file again again");
                userData = [NSData dataWithContentsOfFile:plistPath options:NSDataReadingMappedIfSafe  error:fileError];
                NSLog(@"third read userdata %@,error  %@",userData,*fileError);
            }

        }
        
        if (userData.length==0)
        {
            pthread_rwlock_unlock(&rwlock);
            return nil;
        }
        else
        {
            NSData *decUserData = [userData idmp_aesDecryptWithKey:secrandomkey];
            if (decUserData.length==0)
            {
                NSLog(@"decrypt file data is null");
                pthread_rwlock_unlock(&rwlock);
                return nil;
            }
            else
            {
                NSLog(@"decrypt file data is exsit and return");
                NSDictionary *users = [NSKeyedUnarchiver unarchiveObjectWithData:decUserData];
                
                pthread_rwlock_unlock(&rwlock);
                return users;
            }
            
        }

    }
    else
    {
        
        NSLog(@"file read error:%ld", (long)(*fileError).code);
        NSLog(@"userdata before decrypt is null");
        pthread_rwlock_unlock(&rwlock);
        return nil;

    }
    
}

+(NSString *)getEncrptKey
{
    NSString *deviceId=[[UIDevice currentDevice].identifierForVendor UUIDString];
    NSString *pi = [NSDecimalNumber numberWithDouble:M_PI].description;
    NSString *log2e=(NSString *)[NSDecimalNumber numberWithDouble:M_LOG2E].description;
    NSLog(@"deviceId is %@,pi is %@,log2e is %@",deviceId,pi,log2e);
    
    unsigned char *enckey=kdf_sms((unsigned char *)[deviceId UTF8String],(char *)[pi UTF8String],(char *)[log2e UTF8String]);
    NSString *enkey=[NSString idmp_hexStringWithChar:enckey length:16];
    free(enckey);
    enckey=NULL;
    
    
//    NSLog(@"enkey is %@",enkey);
    return enkey;

}

@end
