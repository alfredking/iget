//
//  NSString2Hex.m
//  IDMPMiddleWare
//
//  Created by alfredking－cmcc on 14-8-1.
//  Copyright (c) 2014年 CMCC. All rights reserved.
//

#import "IDMPFormatTransform.h"

@implementation IDMPFormatTransform




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





@end
