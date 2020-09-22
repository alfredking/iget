//
//  userInfoStorage.m
//  IDMPCMCC
//
//  Created by alfredking－cmcc on 16/7/12.
//  Copyright © 2016年 zwk. All rights reserved.
//

#import "userInfoStorage.h"
#import "secFileStorage.h"
#include <pthread.h>
#import "IDMPConst.h"
#import "IDMPFormatTransform.h"

@implementation userInfoStorage
pthread_rwlock_t sglock = PTHREAD_RWLOCK_INITIALIZER;

+(BOOL)setInfo:(NSObject *)userInfo withKey:(NSString *)key
{
    if ([IDMPFormatTransform checkNSStringisNULL:key])
    {
        return NO;
    }
    pthread_rwlock_wrlock(&sglock);
    
    BOOL result= [self setAppInfo:userInfo withKey:key];
    
    NSError *fileGetError=nil;
    NSMutableDictionary *user=[secFileStorage  getUserInfoWithError:&fileGetError];
    if (!fileGetError||fileGetError.code==NSFileReadNoSuchFileError)
    {
        if (user)
        {
            
            [user setObject:userInfo forKey:key];
        }
        else
        {
            
            user=[NSMutableDictionary dictionaryWithObjectsAndKeys:userInfo,key, nil];
        }
        
        if ([secFileStorage setUserInfo:user withError:&fileGetError])
        {
            
            pthread_rwlock_unlock(&sglock);
            return YES;
        }
        else
        {
            NSLog(@"file set error:%@", fileGetError );
            pthread_rwlock_unlock(&sglock);
            if (result)
            {
                return YES;
            }
            else
            {
                return NO;
            }
            
        }

    }
    else
    {
        NSLog(@"file set error:%@", fileGetError );
        pthread_rwlock_unlock(&sglock);
        if (result)
        {
            return YES;
        }
        else
        {
            return NO;
        }

    }

}
+(NSObject *)getInfoWithKey:(NSString *)key
{
   
    if ([IDMPFormatTransform checkNSStringisNULL:key])
    {
        return nil;
    }
    
    pthread_rwlock_wrlock(&sglock);
    NSError *fileSetError=nil;
    NSDictionary *user=[secFileStorage getUserInfoWithError:&fileSetError];
    NSLog(@"user is %@,key is %@",user,key);
    NSObject *result=nil;
    if (!fileSetError)
    {
      result=[user objectForKey:key];
      if (!result)
      {
        result=[self getAppInfoWithKey:key];
      }
      pthread_rwlock_unlock(&sglock);
    }
    else
    {
        NSLog(@"file get error:%@", fileSetError );
        result=[self getAppInfoWithKey:key];
        pthread_rwlock_unlock(&sglock);
    }
    return result;
    
}

+(BOOL)removeInfoWithKey:(NSString *)key

{
    if ([IDMPFormatTransform checkNSStringisNULL:key])
    {
        return NO;
    }
    
    pthread_rwlock_wrlock(&sglock);
    
    if(![self removeAppInfoWithKey:key])
    {
        pthread_rwlock_unlock(&sglock);
        return NO;
        
    }
    NSError *fileRemoveError=nil;
    NSMutableDictionary *user=[secFileStorage  getUserInfoWithError:&fileRemoveError];
    if (!fileRemoveError||fileRemoveError==NSFileReadNoSuchFileError)
    {
        [user removeObjectForKey:key];
        if ([secFileStorage setUserInfo:user withError:&fileRemoveError])
        {
            
            pthread_rwlock_unlock(&sglock);
            return YES;
        }
        else
        {
            pthread_rwlock_unlock(&sglock);
            return NO;
        }
    }
    else
    {
        NSLog(@"file remove error:%@", fileRemoveError );
        pthread_rwlock_unlock(&sglock);
        return NO;
    }


}


+(BOOL)setAppInfo:(NSObject *)info withKey:(NSString *)key
{
    
    
    
    if ([IDMPFormatTransform checkNSStringisNULL:key])
    {
        return NO;
    }
    if (info)
    {
        NSMutableDictionary* query = [NSMutableDictionary dictionary];
        [query setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
        [query setObject:[key dataUsingEncoding:NSUTF8StringEncoding] forKey:(id)kSecAttrAccount];
        [query setObject:IDMPKeychainService forKey:(__bridge id)kSecAttrService];
        
        CFTypeRef dataTypeRef = nil;
        OSStatus queryStatus = SecItemCopyMatching((CFDictionaryRef)query,&dataTypeRef );
        
        if (dataTypeRef != nil){
            CFRelease(dataTypeRef);
        }
        NSLog(@"back up query status is %d",queryStatus);
        
        if(queryStatus == noErr)
        {
            NSLog(@"Item already exist %d",queryStatus);
            
            
            NSMutableDictionary * updateQuery = query;
            [updateQuery setObject:(__bridge id)kSecAttrAccessibleAlwaysThisDeviceOnly forKey:(__bridge id)kSecAttrAccessible];
            NSData *dataOnObject = [NSKeyedArchiver archivedDataWithRootObject:info];
            NSMutableDictionary *changes = @{
                                             (__bridge id)kSecValueData:dataOnObject,};
            // this item exists in the keychain already, update it
            OSStatus updateStatus = SecItemUpdate((__bridge CFDictionaryRef)updateQuery,(__bridge CFDictionaryRef)changes);
            NSLog(@"back up status updateStatus is %d",updateStatus);
            
            if(updateStatus == noErr)
            {
                return YES;
            }
            else
            {
                return NO;
            }

        }
        else
        {
            NSMutableDictionary* addinfo = [[NSMutableDictionary alloc] init];
            [addinfo setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
            [addinfo setObject:key forKey:(__bridge id)kSecAttrAccount];
            [addinfo setObject:IDMPKeychainService forKey:(__bridge id)kSecAttrService];
            NSData *dataOnObject = [NSKeyedArchiver archivedDataWithRootObject:info];
            [addinfo setObject:dataOnObject forKey:(__bridge id)kSecValueData];
            [addinfo setObject:(__bridge id)kSecAttrAccessibleAlwaysThisDeviceOnly forKey:(__bridge id)kSecAttrAccessible];
            OSStatus addStatus = SecItemAdd((__bridge CFDictionaryRef)addinfo, NULL);
            NSLog(@"back up status addStatus is %d",addStatus);
            
            if(addStatus == noErr)
            {
                return YES;
            }
            else
            {
                return NO;
            }

        }
        
    }
    else
    {
        return NO;
    }
}

+(NSObject *)getAppInfoWithKey: (NSString *)key
{
    
    if ([IDMPFormatTransform checkNSStringisNULL:key])
    {
        return nil;
    }
    
    NSMutableDictionary* dic1 = [NSMutableDictionary dictionary];
    [dic1 setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    [dic1 setObject:[key dataUsingEncoding:NSUTF8StringEncoding] forKey:(id)kSecAttrAccount];
    [dic1 setObject:IDMPKeychainService forKey:(__bridge id)kSecAttrService];
    [dic1 setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];

    CFTypeRef dataTypeRef = nil;
    OSStatus s = SecItemCopyMatching((CFDictionaryRef)dic1,&dataTypeRef );
    NSLog(@"getAppInfo search status %d",s);
    NSData *data = (__bridge NSData *)dataTypeRef;
    NSObject *result = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (dataTypeRef != nil){
        CFRelease(dataTypeRef);
    }
    NSLog(@"result is %@",result);

    return result;
}

+(BOOL)removeAppInfoWithKey:(NSString *)key

{
    if ([IDMPFormatTransform checkNSStringisNULL:key])
    {
        return NO;
    }
    NSMutableDictionary* dic1 = [NSMutableDictionary dictionary];
    [dic1 setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    [dic1 setObject:[key dataUsingEncoding:NSUTF8StringEncoding] forKey:(id)kSecAttrAccount];
    [dic1 setObject:IDMPKeychainService forKey:(__bridge id)kSecAttrService];

    
    OSStatus s = SecItemDelete((CFDictionaryRef)dic1);
    NSLog(@"remove status %d",s);
    if (s==noErr||s==errSecItemNotFound)
    {
        return YES;
    } else {
        return NO;
    }
   
}

@end
