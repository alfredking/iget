//
//  userInfoStorage.m
//  IDMPCMCC
//
//  Created by alfredking－cmcc on 16/7/12.
//  Copyright © 2016年 zwk. All rights reserved.
//

#import "secFileStorage.h"
#include <pthread.h>
#import "NSString+IDMPAdd.h"
#import "IDMPKeychain.h"
#import "IDMPUtility.h"
#import "userInfoStorage.h"


@implementation userInfoStorage
pthread_rwlock_t sglock = PTHREAD_RWLOCK_INITIALIZER;
static NSMutableDictionary *user=nil;

+(BOOL)setInfo:(NSObject *)userInfo withKey:(NSString *)key {
    if ([IDMPUtility checkNSStringisNULL:key] || userInfo == nil) {
        NSLog(@"userinfo or key is null");
        return NO;
    }
    
    pthread_rwlock_wrlock(&sglock);
    
    //保存信息到keychain
    BOOL result=[IDMPKeychain setData:userInfo account:key];
    
    NSError *fileGetError=nil;
    if (!user || user.allKeys == 0) {
        //获取缓存的总的用户信息表
        user= [NSMutableDictionary dictionaryWithDictionary:[secFileStorage  getUserInfoWithError:&fileGetError]];
    }

    //如果获取文件缓存成功或者不存在
    if (!fileGetError||fileGetError.code==NSFileReadNoSuchFileError) {
        //设置信息
        if (user) {
            [user setObject:userInfo forKey:key];
        } else {
            user=[NSMutableDictionary dictionaryWithObjectsAndKeys:userInfo,key, nil];
        }
        //保存信息到文件
        if ([secFileStorage setUserInfo:user withError:&fileGetError]) {
            //保存成功
            pthread_rwlock_unlock(&sglock);
            return YES;
        }
    }
    
    //保存到文件失败
    pthread_rwlock_unlock(&sglock);
    if (result) {
        //如果keychain保存成功，依旧返回成功
        return YES;
    } else {
        //如果keychain也保存失败，返回失败
        NSLog(@"keychain set error");
        return NO;
    }

}

+ (NSObject *)getInfoWithKey:(NSString *)key {
    if ([IDMPUtility checkNSStringisNULL:key]) {
        return nil;
    }
    pthread_rwlock_wrlock(&sglock);
    if (user) {
        NSObject *cacheResult=[user objectForKey:key];
        if (cacheResult) {
            pthread_rwlock_unlock(&sglock);
            return cacheResult;
        }
    }
    NSLog(@"memory cache does not exist key is %@",key);
    NSError *fileError=nil;
    NSDictionary *cacheuser=[secFileStorage getUserInfoWithError:&fileError];
    NSObject *result=nil;
    if (fileError == nil && cacheuser) {
        NSLog(@"read file no error");
        //读取文件的缓存
        user = [NSMutableDictionary dictionaryWithDictionary:cacheuser];
        result = [user objectForKey:key];
        if (result) {
            pthread_rwlock_unlock(&sglock);
            return result;
        }
    }
    
    NSLog(@"file get error:%@", fileError);
    //读取keychain缓存
    result=[IDMPKeychain getDataForAccount:key];
    pthread_rwlock_unlock(&sglock);
    return result;
}

+ (BOOL)removeInfoWithKey:(NSString *)key {
    if ([IDMPUtility checkNSStringisNULL:key]) {
        return NO;
    }
    pthread_rwlock_wrlock(&sglock);
    //删除keychain缓存
    BOOL result=[IDMPKeychain deleteDataForAccount:key];
    if (user) {
        [user removeObjectForKey:key];
    }
    NSError *fileRemoveError=nil;
    NSDictionary *cacheuser = [secFileStorage getUserInfoWithError:&fileRemoveError];
    
    if (!fileRemoveError) {
        user = [NSMutableDictionary dictionaryWithDictionary:cacheuser];
        [user removeObjectForKey:key];
        if ([secFileStorage setUserInfo:user withError:&fileRemoveError]) {
            pthread_rwlock_unlock(&sglock);
            if (result) {
                return YES;
            } else {
                return NO;
            }
        } else {
            pthread_rwlock_unlock(&sglock);
            return NO;
        }
    } else if (fileRemoveError.code==NSFileReadNoSuchFileError) {
        NSLog(@"file remove error:%@", fileRemoveError );
        user = [NSMutableDictionary dictionaryWithDictionary:cacheuser];
        pthread_rwlock_unlock(&sglock);
        if (result) {
            return YES;
        } else {
            return NO;
        }
    } else {
        NSLog(@"file remove error:%@", fileRemoveError );
        pthread_rwlock_unlock(&sglock);
        return NO;
    }
}


//+(BOOL)setAppInfo:(NSObject *)info withKey:(NSString *)key
//{
//    if ([key isOverAllNULL])
//    {
//        return NO;
//    }
//    if (info)
//    {
//        NSMutableDictionary* query = [NSMutableDictionary dictionary];
//        [query setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
//        [query setObject:[key dataUsingEncoding:NSUTF8StringEncoding] forKey:(id)kSecAttrAccount];
//        [query setObject:IDMPKeychainService forKey:(__bridge id)kSecAttrService];
//        
//        CFTypeRef dataTypeRef = nil;
//        OSStatus queryStatus = SecItemCopyMatching((CFDictionaryRef)query,&dataTypeRef );
//        
//        if (dataTypeRef != nil){
//            CFRelease(dataTypeRef);
//        }
//        NSLog(@"back up query status is %d",queryStatus);
//        
//        if(queryStatus == noErr)
//        {
//            NSMutableDictionary * updateQuery = query;
//            [updateQuery setObject:(__bridge id)kSecAttrAccessibleAlwaysThisDeviceOnly forKey:(__bridge id)kSecAttrAccessible];
//            NSData *dataOnObject = [NSKeyedArchiver archivedDataWithRootObject:info];
//            NSMutableDictionary *changes = [NSMutableDictionary dictionaryWithDictionary:@{
//                                             (__bridge id)kSecValueData:dataOnObject,}];
//            // this item exists in the keychain already, update it
//            OSStatus updateStatus = SecItemUpdate((__bridge CFDictionaryRef)updateQuery,(__bridge CFDictionaryRef)changes);
//            NSLog(@"back up status updateStatus is %d",updateStatus);
//            
//            if(updateStatus == noErr)
//            {
//                return YES;
//            }
//            else
//            {
//                return NO;
//            }
//
//        }
//        else
//        {
//            NSMutableDictionary* addinfo = [[NSMutableDictionary alloc] init];
//            [addinfo setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
//            [addinfo setObject:key forKey:(__bridge id)kSecAttrAccount];
//            [addinfo setObject:IDMPKeychainService forKey:(__bridge id)kSecAttrService];
//            NSData *dataOnObject = [NSKeyedArchiver archivedDataWithRootObject:info];
//            [addinfo setObject:dataOnObject forKey:(__bridge id)kSecValueData];
//            [addinfo setObject:(__bridge id)kSecAttrAccessibleAlwaysThisDeviceOnly forKey:(__bridge id)kSecAttrAccessible];
//            OSStatus addStatus = SecItemAdd((__bridge CFDictionaryRef)addinfo, NULL);
//            NSLog(@"back up status addStatus is %d",addStatus);
//            
//            if(addStatus == noErr)
//            {
//                return YES;
//            }
//            else
//            {
//                return NO;
//            }
//
//        }
//        
//    }
//    else
//    {
//        return NO;
//    }
//}
//
//+(NSObject *)getAppInfoWithKey: (NSString *)key
//{
//    
//    if ([key isOverAllNULL])
//    {
//        return nil;
//    }
//    
//    NSMutableDictionary* dic1 = [NSMutableDictionary dictionary];
//    [dic1 setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
//    [dic1 setObject:[key dataUsingEncoding:NSUTF8StringEncoding] forKey:(id)kSecAttrAccount];
//    [dic1 setObject:IDMPKeychainService forKey:(__bridge id)kSecAttrService];
//    [dic1 setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
//
//    CFTypeRef dataTypeRef = nil;
//    OSStatus s = SecItemCopyMatching((CFDictionaryRef)dic1,&dataTypeRef );
//    NSLog(@"keychain search status %d",s);
//    if (s==noErr)
//    {
//        NSData *data = (__bridge NSData *)dataTypeRef;
//        NSObject *result = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//        if (dataTypeRef != nil){
//            CFRelease(dataTypeRef);
//        }
//        return result;
//
//    }
//    else
//    {
//       
//        
//        
//        if (dataTypeRef != nil){
//            CFRelease(dataTypeRef);
//        }
//        return nil;
//    }
//}

//+(BOOL)removeAppInfoWithKey:(NSString *)key
//
//{
//    if ([key isOverAllNULL])
//    {
//        return NO;
//    }
//    NSMutableDictionary* dic1 = [NSMutableDictionary dictionary];
//    [dic1 setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
//    [dic1 setObject:[key dataUsingEncoding:NSUTF8StringEncoding] forKey:(id)kSecAttrAccount];
//    [dic1 setObject:IDMPKeychainService forKey:(__bridge id)kSecAttrService];
//
//    
//    OSStatus s = SecItemDelete((CFDictionaryRef)dic1);
//    NSLog(@"remove status %d",s);
//    
//    if (s==noErr||s==errSecItemNotFound)
//    {
//        return YES;
//    } else {
//        return NO;
//    }
//   
//}

@end
