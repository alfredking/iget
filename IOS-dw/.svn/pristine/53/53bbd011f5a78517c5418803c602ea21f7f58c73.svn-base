//
//  NSData+IDMPAdd.m
//  IDMPCMCC
//
//  Created by wj on 2018/1/23.
//  Copyright © 2018年 zwk. All rights reserved.
//

#import "NSData+IDMPAdd.h"
#import <CommonCrypto/CommonCrypto.h>
#import "IDMPKeychain.h"

@implementation NSData (IDMPAdd)

- (NSString *)idmp_getMd5String {
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(self.bytes, (CC_LONG)self.length, result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (NSData *)idmp_aesDecryptWithKey:(NSString *)key {
    return [self idmp_aesCryptWithKey:key operation:kCCDecrypt];
}

- (NSData *)idmp_aesEncryptWithKey:(NSString *)key {
    return [self idmp_aesCryptWithKey:key operation:kCCEncrypt];
}

- (NSData *)idmp_aesCryptWithKey:(NSString *)key operation:(CCOperation)operation {
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES128+1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesCrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(operation, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES128,
                                          NULL /* initialization vector (optional) */,
                                          [self bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesCrypted);
    if (cryptStatus == kCCSuccess) {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        NSData* resultData=[NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        return resultData;
        
    }
    
    free(buffer); //free the buffer;
    return nil;
}

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

- (NSString *)idmp_base64Encoding {
    if ([self length] == 0)
        return @"";
    
    char *characters = malloc((([self length] + 2) / 3) * 4);
    if (characters == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (i < [self length])
    {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < [self length])
            buffer[bufferLength++] = ((char *)[self bytes])[i++];
        
        //  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
        characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1)
            characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        else characters[length++] = '=';
        if (bufferLength > 2)
            characters[length++] = encodingTable[buffer[2] & 0x3F];
        else characters[length++] = '=';
    }
    
    return [[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES];
}

- (NSString *)idmp_hexEncodedString {
    unsigned char *char32 = (unsigned char *)[self bytes];
    int length = (int)self.length;
    NSMutableString *result= [[NSMutableString alloc] init];
    for(int i = 0; i < length; i++) {
        [result appendFormat:@"%02X",char32[i]];
    }
    return [result copy];
}


- (NSData *)idmp_signWithPrivateKey:(NSString *)privKey{
    if(!self || !privKey){
        return nil;
    }
    SecKeyRef keyRef = [IDMPKeychain addPrivateKey:privKey];
    if(!keyRef){
        return nil;
    }
    return [self idmp_rsaWithKeyRef:keyRef operatorType:Sign];
}

- (NSData *)idmp_encryptWithPublicKey:(NSString *)pubKey{
    if(!self || !pubKey){
        return nil;
    }
    SecKeyRef keyRef = [IDMPKeychain addPublicKey:pubKey];
    if(!keyRef){
        return nil;
    }
    return [self idmp_rsaWithKeyRef:keyRef operatorType:Encrypt];
}

- (NSData *)idmp_decryptWithPrivateKey:(NSString *)privKey{
    if(!self || !privKey){
        return nil;
    }
    SecKeyRef keyRef = [IDMPKeychain addPrivateKey:privKey];
    if(!keyRef){
        return nil;
    }
    return [self idmp_rsaWithKeyRef:keyRef operatorType:Decrypt];
}


- (NSData *)idmp_rsaWithKeyRef:(SecKeyRef)keyRef operatorType:(IDMPRSAOperatorType)type {
    const uint8_t *srcbuf = (const uint8_t *)[self bytes];
    size_t srclen = (size_t)self.length;
    
    size_t outlen = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    UInt8 *outbuf = malloc(outlen);
    OSStatus status = noErr;
    switch (type) {
        case Encrypt:
            status = SecKeyEncrypt(keyRef, kSecPaddingPKCS1, srcbuf, srclen, outbuf, &outlen);
            break;
        case Decrypt:
            status = SecKeyDecrypt(keyRef, kSecPaddingNone, srcbuf, srclen, outbuf, &outlen);
            break;
        case Sign:
        {
            uint8_t digest[CC_SHA256_DIGEST_LENGTH];
            CC_SHA256((const void *)srcbuf, (CC_LONG)srclen, digest);
            status = SecKeyRawSign(keyRef, kSecPaddingPKCS1SHA256, digest, CC_SHA256_DIGEST_LENGTH, outbuf, &outlen);
        }
            break;
    }
    NSData *ret = nil;
    if (status != 0) {
        NSLog(@"SecKeyEncrypt fail. Error Code: %d", (int)status);
    } else {
        if (type == Decrypt) {
            //the actual decrypted data is in the middle, locate it!
            int idxFirstZero = -1;
            int idxNextZero = (int)outlen;
            for ( int i = 0; i < outlen; i++ ) {
                if (outbuf[i] == 0 ) {
                    if ( idxFirstZero < 0 ) {
                        idxFirstZero = i;
                    } else {
                        idxNextZero = i;
                        break;
                    }
                }
            }
            ret = [NSData dataWithBytes:&outbuf[idxFirstZero+1] length:idxNextZero-idxFirstZero-1];
        } else {
            ret = [NSData dataWithBytes:outbuf length:outlen];
        }
    }
    free(outbuf);
    return ret;
}




@end
