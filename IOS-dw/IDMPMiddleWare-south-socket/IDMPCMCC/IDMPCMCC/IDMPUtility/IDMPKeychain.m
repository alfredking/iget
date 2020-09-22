//
//  IDMPKeychain.m
//  IDMPCMCC
//
//  Created by wj on 2018/1/23.
//  Copyright © 2018年 zwk. All rights reserved.
//

#import "IDMPKeychain.h"

#define IDMPKeychainService @"com.zyhy.secidmp"


@implementation IDMPKeychain

+ (NSObject *)getDataForAccount:(NSString *)account {
    return [self getDataForAccount:account service:IDMPKeychainService];
}

+ (NSObject *)getDataForAccount:(NSString *)account service:(NSString *)service {
    if (!service || !account) {
        return nil;
    }
    NSMutableDictionary *query = [self getQueryForAccount:account service:service];
    [query setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];
    [query setObject:(__bridge_transfer id)kSecMatchLimitOne forKey:(__bridge_transfer id)kSecMatchLimit];
    
    CFDataRef keyDataRef = NULL;
    OSStatus status = SecItemCopyMatching((CFDictionaryRef)query, (CFTypeRef *)&keyDataRef);
    
    NSObject *ret = nil;
    if (status == errSecSuccess) {
        ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge_transfer NSData *)keyDataRef];
    }
    return ret;
}

+ (BOOL)setData:(NSObject *)data account:(NSString *)account {
    return [self setData:data account:account service:IDMPKeychainService];
}

+ (BOOL)setData:(NSObject *)data account:(NSString *)account service:(NSString *)service {
    if (!account || !data || !service) {
        return NO;
    }
    NSMutableDictionary *query = [self getQueryForAccount:account service:service];
    [query setObject:(__bridge id)kSecAttrAccessibleAlwaysThisDeviceOnly forKey:(__bridge id)kSecAttrAccessible];
    CFTypeRef dataTypeRef = nil;
    OSStatus status = SecItemCopyMatching((CFDictionaryRef)query,&dataTypeRef);
    if (status == errSecSuccess) {
        NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:data];
        NSMutableDictionary *changeDic = [NSMutableDictionary dictionaryWithDictionary:@{(__bridge id)kSecValueData:archiveData}];
        status = SecItemUpdate((__bridge CFDictionaryRef)query,(__bridge CFDictionaryRef)changeDic);
        if (dataTypeRef) {
            CFRelease(dataTypeRef);
        }
        return status == errSecSuccess ? YES : NO;
    } else {
        [query setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge_transfer id)kSecValueData];
        status = SecItemAdd((__bridge CFDictionaryRef)query, NULL);
        if (dataTypeRef) {
            CFRelease(dataTypeRef);
        }
        return status == errSecSuccess ? YES : NO;
    }
}

+ (BOOL)deleteDataForAccount:(NSString *)account {
    return [self deleteDataForAccount:account service:IDMPKeychainService];
}

+ (BOOL)deleteDataForAccount:(NSString *)account service:(NSString *)service {
    if (!account || !service) {
        return NO;
    }
    NSMutableDictionary *query = [self getQueryForAccount:account service:service];
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)query);
    NSLog(@"remove status %d",(int)status);
    if (status == errSecSuccess || status == errSecItemNotFound) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSMutableDictionary *)getQueryForAccount:(NSString *)account service:(NSString *)service{
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutableDic setObject:(__bridge_transfer id)kSecClassGenericPassword forKey:(__bridge_transfer id)kSecClass];
    [mutableDic setObject:service forKey:(__bridge_transfer id)kSecAttrService];
    [mutableDic setObject:account forKey:(__bridge_transfer id)kSecAttrAccount];
    return mutableDic;
    
}

static NSData *base64_decode(NSString *str){
    NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return data;
}


+ (SecKeyRef)addPublicKey:(NSString *)key{
    static SecKeyRef secPublicKeyRef = nil;
    static NSString *savedPublicKey=nil;
    if([key isEqualToString:savedPublicKey] && secPublicKeyRef!=nil) {
        NSLog(@"PublicKeyRef cache exist");
        return secPublicKeyRef;
    }
    savedPublicKey=key;
    NSRange spos = [key rangeOfString:@"-----BEGIN PUBLIC KEY-----"];
    NSRange epos = [key rangeOfString:@"-----END PUBLIC KEY-----"];
    if(spos.location != NSNotFound && epos.location != NSNotFound){
        NSUInteger s = spos.location + spos.length;
        NSUInteger e = epos.location;
        NSRange range = NSMakeRange(s, e-s);
        key = [key substringWithRange:range];
    }
    key = [key stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@" "  withString:@""];
    
    // This will be base64 encoded, decode it.
    NSData *data = base64_decode(key);
    if(!data){
        return nil;
    }
    
    //a tag to read/write keychain storage
    NSString *tag = PublicKeyTag;
    NSData *d_tag = [NSData dataWithBytes:[tag UTF8String] length:[tag length]];
    
    // Delete any old lingering key with the same tag
    NSMutableDictionary *publicKey = [[NSMutableDictionary alloc] init];
    [publicKey setObject:(__bridge id) kSecClassKey forKey:(__bridge id)kSecClass];
    [publicKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [publicKey setObject:d_tag forKey:(__bridge id)kSecAttrApplicationTag];
    SecItemDelete((__bridge CFDictionaryRef)publicKey);
    
    // Add persistent version of the key to system keychain
    [publicKey setObject:data forKey:(__bridge id)kSecValueData];
    [publicKey setObject:(__bridge id) kSecAttrKeyClassPublic forKey:(__bridge id)
     kSecAttrKeyClass];
    [publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)
     kSecReturnPersistentRef];
    
    CFTypeRef persistKey = nil;
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)publicKey, &persistKey);
    if (persistKey != nil){
        CFRelease(persistKey);
    }
    if ((status != errSecSuccess) && (status != errSecDuplicateItem)) {
        return nil;
    }
    
    [publicKey removeObjectForKey:(__bridge id)kSecValueData];
    [publicKey removeObjectForKey:(__bridge id)kSecReturnPersistentRef];
    [publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    [publicKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    
    // Now fetch the SecKeyRef version of the key
    SecKeyRef keyRef = nil;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)publicKey, (CFTypeRef *)&keyRef);
    if(status != errSecSuccess){
        return nil;
    }
    secPublicKeyRef = keyRef;
    return keyRef;
}

+ (SecKeyRef)addPrivateKey:(NSString *)key{
    static SecKeyRef secPrivateKeyRef = nil;
    static NSString *savedPrivateKey=nil;
    if([key isEqualToString:savedPrivateKey] &&secPrivateKeyRef!=nil) {
        NSLog(@"PrivateKeyRef cache exist");
        return secPrivateKeyRef;
    }
    
    savedPrivateKey=key;

    NSRange spos;
    NSRange epos;
    spos = [key rangeOfString:@"-----BEGIN RSA PRIVATE KEY-----"];
    if(spos.length > 0){
        epos = [key rangeOfString:@"-----END RSA PRIVATE KEY-----"];
    }else{
        spos = [key rangeOfString:@"-----BEGIN PRIVATE KEY-----"];
        epos = [key rangeOfString:@"-----END PRIVATE KEY-----"];
    }
    if(spos.location != NSNotFound && epos.location != NSNotFound){
        NSUInteger s = spos.location + spos.length;
        NSUInteger e = epos.location;
        NSRange range = NSMakeRange(s, e-s);
        key = [key substringWithRange:range];
    }
    key = [key stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@" "  withString:@""];
    
    // This will be base64 encoded, decode it.
    NSData *data = base64_decode(key);
//    data = [self stripPrivateKeyHeader:data];
    if(!data){
        return nil;
    }
    
    //a tag to read/write keychain storage
    NSString *tag = PrivateKeyTag;
    NSData *d_tag = [NSData dataWithBytes:[tag UTF8String] length:[tag length]];
    
    // Delete any old lingering key with the same tag
    NSMutableDictionary *privateKey = [[NSMutableDictionary alloc] init];
    [privateKey setObject:(__bridge id) kSecClassKey forKey:(__bridge id)kSecClass];
    [privateKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [privateKey setObject:d_tag forKey:(__bridge id)kSecAttrApplicationTag];
    SecItemDelete((__bridge CFDictionaryRef)privateKey);
    
    // Add persistent version of the key to system keychain
    [privateKey setObject:data forKey:(__bridge id)kSecValueData];
    [privateKey setObject:(__bridge id) kSecAttrKeyClassPrivate forKey:(__bridge id)
     kSecAttrKeyClass];
    [privateKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)
     kSecReturnPersistentRef];
    
    CFTypeRef persistKey = nil;
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)privateKey, &persistKey);
    if (persistKey != nil){
        CFRelease(persistKey);
    }
    if ((status != errSecSuccess) && (status != errSecDuplicateItem)) {
        return nil;
    }
    
    [privateKey removeObjectForKey:(__bridge id)kSecValueData];
    [privateKey removeObjectForKey:(__bridge id)kSecReturnPersistentRef];
    [privateKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    [privateKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    
    // Now fetch the SecKeyRef version of the key
    SecKeyRef keyRef = nil;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)privateKey, (CFTypeRef *)&keyRef);
    if(status != errSecSuccess){
        return nil;
    }
    secPrivateKeyRef = keyRef;
    return keyRef;
}

@end
