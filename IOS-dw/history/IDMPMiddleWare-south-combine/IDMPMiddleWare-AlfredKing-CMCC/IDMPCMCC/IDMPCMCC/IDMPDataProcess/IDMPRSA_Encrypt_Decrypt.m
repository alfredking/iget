//
//  IDMPRSA_Encrypt_Decrypt.m
//  IDMPMiddleWare
//
//  Created by alfredking－cmcc on 14-8-6.
//  Copyright (c) 2014年 CMCC. All rights reserved.
//

#import "IDMPRSA_Encrypt_Decrypt.h"
#import "IDMPFormatTransform.h"
@implementation IDMPRSA_Encrypt_Decrypt

NSString * formatPublicKey(NSString *publicKey)
{
    
    NSMutableString *result = [NSMutableString string];
    
    [result appendString:@"-----BEGIN PUBLIC KEY-----\n"];
    
    int count = 0;
    
    for (int i = 0; i < [publicKey length]; ++i) {
        
        unichar c = [publicKey characterAtIndex:i];
        if (c == '\n' || c == '\r') {
            continue;
        }
        [result appendFormat:@"%c", c];
        if (++count == 64) {
            [result appendString:@"\n"];
            count = 0;
        }
        
    }
    
    [result appendString:@"\n-----END PUBLIC KEY-----\n"];
    
    return result;
    
}

NSString *formatPrivateKey(NSString *privateKey)
{
    const char *pstr = [privateKey UTF8String];
    int len = (int)[privateKey length];
    NSMutableString *result = [NSMutableString string];
    [result appendString:@"-----BEGIN RSA PRIVATE KEY-----\n"];
    int index = 0;
    int count = 0;
    while (index < len) {
        char ch = pstr[index];
        if (ch == '\r' || ch == '\n') {
            ++index;
            continue;
        }
        [result appendFormat:@"%c", ch];
        if (++count == 64)
        {
            [result appendString:@"\n"];
            count = 0;
        }
        index++;
    }
    [result appendString:@"\n-----END RSA PRIVATE KEY-----"];
    return result;
}

NSString *RSA_encrypt(NSString *sourceString)
{
    static NSLock *locken = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        locken = [[NSLock alloc] init];
        NSLog(@"locken init");
    });
    [locken lock];
    NSString *pubKey=PUBLIC_KEY;
    NSData *data=[sourceString dataUsingEncoding:NSUTF8StringEncoding];
    
    if(!data || !pubKey){
        return nil;
    }
    SecKeyRef keyRef = [IDMPRSA_Encrypt_Decrypt addPublicKey:pubKey];
    if(!keyRef){
        return nil;
    }
    
    const uint8_t *srcbuf = (const uint8_t *)[data bytes];
    size_t srclen = (size_t)data.length;
    
    size_t outlen = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    if(srclen > outlen - 11){
        CFRelease(keyRef);
        return nil;
    }
    void *outbuf = malloc(outlen);
    
    OSStatus status = noErr;
    status = SecKeyEncrypt(keyRef,
                           kSecPaddingPKCS1,
                           srcbuf,
                           srclen,
                           outbuf,
                           &outlen
                           );
    NSData *ret = nil;
    if (status != 0) {
        NSLog(@"SecKeyEncrypt fail. Error Code: %ld", status);
    }else{
        ret =[[IDMPFormatTransform charToNSHex:outbuf length:outlen] lowercaseString];
    }
    free(outbuf);
    CFRelease(keyRef);
    
    [locken unlock];
    return ret;
    
}

NSString *RSA_decrypt(NSString *sourceString)
{
    static NSLock *lockde = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lockde = [[NSLock alloc] init];
        NSLog(@"lockde init");
    });
    [lockde lock];
    
    NSString *privKey=PRIVATE_KEY;
    
    NSData *data=[IDMPFormatTransform hexStringToNSData:sourceString];
    
    const uint8_t *srcbuf = (const uint8_t *)[data bytes];
    size_t srclen = (size_t)data.length;
    if(!data || !privKey)
    {
        [lockde unlock];
        return nil;
    }
    SecKeyRef keyRef = [IDMPRSA_Encrypt_Decrypt addPrivateKey:privKey];
    if(!keyRef)
    {
        [lockde unlock];
        return nil;
    }
    
    
    
    size_t outlen = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    if(srclen != outlen)
    {
        //TODO currently we are able to decrypt only one block!
        CFRelease(keyRef);
        [lockde unlock];
        return nil;
    }
    UInt8 *outbuf = malloc(outlen);
    
    //use kSecPaddingNone in decryption mode
    OSStatus status = noErr;
    status = SecKeyDecrypt(keyRef,
                           kSecPaddingNone,
                           srcbuf,
                           srclen,
                           outbuf,
                           &outlen
                           );
    NSData *result = nil;
    if (status != 0)
    {
        //NSLog(@"SecKeyEncrypt fail. Error Code: %ld", status);
    }
    else
    {
        //the actual decrypted data is in the middle, locate it!
        int idxFirstZero = -1;
        int idxNextZero = (int)outlen;
        for ( int i = 0; i < outlen; i++ ) {
            if ( outbuf[i] == 0 ) {
                if ( idxFirstZero < 0 ) {
                    idxFirstZero = i;
                } else {
                    idxNextZero = i;
                    break;
                }
            }
        }
        
        result = [NSData dataWithBytes:&outbuf[idxFirstZero+1] length:idxNextZero-idxFirstZero-1];
    }
    free(outbuf);
    CFRelease(keyRef);
    [lockde unlock];
    return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    
}

+ (SecKeyRef)addPublicKey:(NSString *)key{
    SecKeyRef keyRef = nil;
    //    OSStatus status=nil;
    //    status = SecItemCopyMatching((__bridge CFDictionaryRef)publicKey, (CFTypeRef *)&keyRef);
    //    if(status == noErr){
    //    return keyRef;;
    //    }
    
    
    
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
    data = [IDMPRSA_Encrypt_Decrypt stripPublicKeyHeader:data];
    if(!data){
        return nil;
    }
    
    //a tag to read/write keychain storage
    NSString *tag = @"RSAUtil_PubKey";
    NSData *d_tag = [NSData dataWithBytes:[tag UTF8String] length:[tag length]];
    
    // Delete any old lingering key with the same tag
    NSMutableDictionary *publicKey = [[NSMutableDictionary alloc] init];
    [publicKey setObject:(__bridge id) kSecClassKey forKey:(__bridge id)kSecClass];
    [publicKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [publicKey setObject:d_tag forKey:(__bridge id)kSecAttrApplicationTag];
    //	SecItemDelete((__bridge CFDictionaryRef)publicKey);
    
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
    if ((status != noErr) && (status != errSecDuplicateItem)) {
        return nil;
    }
    
    [publicKey removeObjectForKey:(__bridge id)kSecValueData];
    [publicKey removeObjectForKey:(__bridge id)kSecReturnPersistentRef];
    [publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    [publicKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    
    // Now fetch the SecKeyRef version of the key
    
    status = SecItemCopyMatching((__bridge CFDictionaryRef)publicKey, (CFTypeRef *)&keyRef);
    if(status != noErr){
        return nil;
    }
    return keyRef;
}

+ (SecKeyRef)addPrivateKey:(NSString *)key{
    NSRange spos = [key rangeOfString:@"-----BEGIN RSA PRIVATE KEY-----"];
    NSRange epos = [key rangeOfString:@"-----END RSA PRIVATE KEY-----"];
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
    //	data = [IDMPRSA_Encrypt_Decrypt stripPrivateKeyHeader:data];
    //	if(!data){
    //        NSLog(@"header fail");
    //		return nil;
    //	}
    
    //a tag to read/write keychain storage
    NSString *tag = @"RSAUtil_PrivKey";
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
    if ((status != noErr) && (status != errSecDuplicateItem)) {
        return nil;
    }
    
    [privateKey removeObjectForKey:(__bridge id)kSecValueData];
    [privateKey removeObjectForKey:(__bridge id)kSecReturnPersistentRef];
    [privateKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    [privateKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    
    // Now fetch the SecKeyRef version of the key
    SecKeyRef keyRef = nil;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)privateKey, (CFTypeRef *)&keyRef);
    if(status != noErr){
        return nil;
    }
    return keyRef;
}

//static NSString *base64_encode(NSData *data){
//    data = [data base64EncodedDataWithOptions:0];
//    NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    return ret;
//}

static NSData *base64_decode(NSString *str){
    NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return data;
}

+ (NSData *)stripPublicKeyHeader:(NSData *)d_key{
    // Skip ASN.1 public key header
    if (d_key == nil) return(nil);
    
    unsigned long len = [d_key length];
    if (!len) return(nil);
    
    unsigned char *c_key = (unsigned char *)[d_key bytes];
    unsigned int  idx	 = 0;
    
    if (c_key[idx++] != 0x30) return(nil);
    
    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;
    
    // PKCS #1 rsaEncryption szOID_RSA_RSA
    static unsigned char seqiod[] =
    { 0x30,   0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01,
        0x01, 0x05, 0x00 };
    if (memcmp(&c_key[idx], seqiod, 15)) return(nil);
    
    idx += 15;
    
    if (c_key[idx++] != 0x03) return(nil);
    
    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;
    
    if (c_key[idx++] != '\0') return(nil);
    
    // Now make a new NSData from this buffer
    return([NSData dataWithBytes:&c_key[idx] length:len - idx]);
}

//credit: http://hg.mozilla.org/services/fx-home/file/tip/Sources/NetworkAndStorage/CryptoUtils.m#l1036
+ (NSData *)stripPrivateKeyHeader:(NSData *)d_key{
    // Skip ASN.1 private key header
    if (d_key == nil) return(nil);
    
    unsigned long len = [d_key length];
    NSLog(@"key 长度 %d",len);
    if (!len) return(nil);
    
    unsigned char *c_key = (unsigned char *)[d_key bytes];
    printf("char key is %s\n",c_key);
    print_hex(c_key);
    unsigned int  idx	 = 22; //magic byte at offset 22
    NSLog(@"non asn.1 header");
    if (0x04 != c_key[idx++]) return nil;
    NSLog(@"asn.1 header");
    
    //calculate length of the key
    unsigned int c_len = c_key[idx++];
    int det = c_len & 0x80;
    if (!det) {
        c_len = c_len & 0x7f;
    } else {
        int byteCount = c_len & 0x7f;
        if (byteCount + idx > len) {
            //rsa length field longer than buffer
            return nil;
        }
        unsigned int accum = 0;
        unsigned char *ptr = &c_key[idx];
        idx += byteCount;
        while (byteCount) {
            accum = (accum << 8) + *ptr;
            ptr++;
            byteCount--;
        }
        c_len = accum;
    }
    
    // Now make a new NSData from this buffer
    return [d_key subdataWithRange:NSMakeRange(idx, c_len)];
}

@end