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
    unsigned char *signature=(char*)calloc(sizeof(char*),length);
    char Temp[3];
    int i;
    for(i = 0;i<length; i++)
    {
        sprintf(Temp, "%02X", (unsigned char) str[i]);
        memcpy( &(signature[i * 2]), Temp, 2 );
    }
    signature[2*i]=NULL;
    return signature;
}
+(NSString*) charToNSHex:(unsigned char *)str length:(int)length
{
   NSString *result;
   NSMutableString* Result= [[NSMutableString alloc] init];
   for(int i = 0; i < length; i++)
   {
      [Result appendFormat:@"%02X",str[i]];
   }
   result = Result;
   return result;
}


void print_hex(char* buff)
{
    for (int i=0;buff[i];i++)
        printf("%02x",(unsigned char)buff[i]);
    printf("\n");
}

unsigned char * HexStrToByte(const char* source,int sourceLen)
{
    int i,j;
    unsigned char *dest=(char*)calloc(sizeof(char*),sourceLen);
    unsigned char highByte, lowByte;
    for (i = 0; i < sourceLen; i += 2)
    {
        highByte = toupper(source[i]);
        lowByte  = toupper(source[i + 1]);
        
        
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

@end
