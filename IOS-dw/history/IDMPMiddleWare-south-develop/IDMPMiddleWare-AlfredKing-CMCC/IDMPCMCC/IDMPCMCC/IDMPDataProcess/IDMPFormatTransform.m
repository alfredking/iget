//
//  NSString2Hex.m
//  IDMPMiddleWare
//
//  Created by alfredking－cmcc on 14-8-1.
//  Copyright (c) 2014年 CMCC. All rights reserved.
//

#import "IDMPFormatTransform.h"

@implementation IDMPFormatTransform

char * charToHex(char *str,int length)
{
    unsigned char *signature=(unsigned char*)calloc(length,sizeof(unsigned char));
    char Temp[3];
    int i;
    for(i = 0;i<length; i++)
    {
        sprintf(Temp, "%02X", (unsigned char) str[i]);
        memcpy( &(signature[i * 2]), Temp, 2 );
    }
    signature[2*i] = NULL;
    return (char *)signature;
}
+(NSString*) charToNSHex:(unsigned char *)str length:(int)length
{
    
    NSMutableString* Result= [[NSMutableString alloc] init];
    for(int i = 0; i < length; i++)
    {
        [Result appendFormat:@"%02X",str[i]];
    }
    NSString *result=Result;
    return result;
}


void print_hex(char* buff)
{
    for (int i=0;buff[i];i++)
        printf("%02x",(unsigned char)buff[i]);
    printf("\n");
}

unsigned char * HexStrToByte(const char* sourceString,int sourceLen)
{
    if(sourceString==NULL)
    {
        return NULL;
    }
    
    int i,j;
    unsigned char *dest=calloc(sourceLen,sizeof(unsigned char));
    unsigned char highByte, lowByte;
    for (i = 0; i < sourceLen; i += 2)
    {
        highByte = toupper(sourceString[i]);
        lowByte  = toupper(sourceString[i + 1]);
        
        
        if (highByte > 0x39)
            highByte -= 0x37;
        else
            highByte -= 0x30;
        
        
        if (lowByte > 0x39)
            lowByte -= 0x37;
        else
            lowByte -= 0x30;
        
        j=i/2;
        dest[j] = (highByte << 4) | lowByte;
    }
    return dest;
}


+ (NSData *)hexStringToNSData:(NSString *)hexStr
{
    hexStr = [hexStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableData *data= [[NSMutableData alloc] init];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    for (int i = 0; i < ([hexStr length] / 2); i++) {
        byte_chars[0] = [hexStr characterAtIndex:i*2];
        byte_chars[1] = [hexStr characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    //NSLog(@"%@", data);
    return data ;
}

+(BOOL)checkNSStringisNULL:(NSString *)string
{
    if (string == nil || string == NULL)
    {
        return YES;
    
    }
    else if ([string isKindOfClass:[NSString class]]&&string.length==0)
    {
        NSLog(@"string");
       
           return YES;

    }
    else if ([string isKindOfClass:[NSNull class]])
    {
               return YES;
    }
    else if ( [string isKindOfClass:[NSString class]] && [string isEqualToString:@"<null>"])
    {
        
        return YES;
       
    }
    
    else if ( [string isKindOfClass:[NSString class]] && [string isEqualToString:@"(null)"])
    {
       
        return YES;
        
    }
    else
    {
        return NO;
    }

}
+(BOOL)checkIsIp:(NSString *)url
{
    NSLog(@"url is %@",url);
//    NSString*ipurl=@"((25[0-5])|(2[0-4]\d)|(1\d\d)|([1-9]\d)|\d)(\.((25[0-5])|(2[0-4]\d)|(1\d\d)|([1-9]\d)|\d)){3}";
    
    NSString*ipurl=@"\\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\b";
    NSPredicate *urlCheck = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",ipurl];
    NSLog(@"is ip %d",[urlCheck evaluateWithObject:url]);
    return [urlCheck evaluateWithObject:url];

}

@end