//
//  IDMPToken.m
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking－cmcc on 14-9-10.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import "IDMPToken.h"
#import "IDMPKDF.h"
#import "IDMPConst.h"
#import "IDMPDevice.h"
#import "IDMPFormatTransform.h"
#import "hmac_sha256.h"
#import "IDMPHttpRequest.h"

@implementation IDMPToken

unsigned char *g_ks ;
unsigned char *g_btid;
int g_sqn;
int g_btid_len;
int sqn_len;
#define TRAN32(X) ((((uint32_t)(X)&0xff000000)>>24) | (((uint32_t)(X)&0x00ff0000)>>8) | (((uint32_t)(X)&0x0000ff00)<<8) | (((uint32_t)(X) & 0x000000ff) << 24))

+(NSString *)getTokenWithUserName:(NSString *)userName andAppId:(NSString *)appId
{
    static NSLock *lock = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lock = [[NSLock alloc] init];
    });
    [lock lock];

       char version[2] = {0x00, 0x00};
       strcpy(version, "2");
       unsigned char *token;
       int tokenLen =signkey((char *)[userName UTF8String],(char *)[appId UTF8String], version, &token);
       if(tokenLen > 128){
           tokenLen = 128;
       }
       NSString *stoken=[IDMPFormatTransform  charToNSHex:token length:tokenLen];
       free(token);
       token=NULL;
    [lock unlock];
    return stoken;
}


int signkey(char *userName,char *appid, char* version, unsigned char** ptoken)
{
    NSMutableDictionary *user =[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithUTF8String:userName]]];
    
    NSString *BTID=[user objectForKey:ksBTID];
    g_btid = (unsigned char *)[BTID UTF8String];
    g_btid_len=(int)[BTID length];
    NSString *KS=[user objectForKey:@"KS"];
    unsigned char *g_ks_temp = (unsigned char *)[KS UTF8String];
    g_ks= HexStrToByte((const char*)g_ks_temp,32);
    NSString *SQN=[user objectForKey:ksSQN];
    NSUInteger ISQN=[SQN integerValue]+1;
    [user setValue:[NSString stringWithFormat:@"%d",(int)ISQN] forKey:ksSQN];
    
    [[NSUserDefaults standardUserDefaults] setValue:user forKey:[NSString stringWithUTF8String:userName]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    g_sqn=(int)ISQN;
    sqn_len=4;
    char encrand[32];
    char btid_str[128];
    char* p;
    char* delims={"@"};
    strcpy(btid_str, (const char *)g_btid);
    p = strtok(btid_str, delims);
    strcpy(encrand, p);
    strtok(NULL, delims);
    char* pscene = "gba-me";
    unsigned char *psk = kdf_signkey(pscene, encrand,userName ,appid);
    
    psk[16]='\0';
    int tokenLen= sign_token(userName, version,appid,ptoken, psk, 16);
    free(psk);
    psk=NULL;
    return tokenLen;
}

unsigned char* kdf_signkey(char* pscene, char* rand, char* impi, char* appid)
{
    
    char* p_array[4];
    p_array[0] = pscene;
    p_array[1] = rand;
    p_array[2] = impi;
    p_array[3] = appid;
    printf("@kdf_signkey 1   %s    @2   %s   @3   %s   @4    %s \n",pscene,rand,impi,appid);
    unsigned char* s;
    int s_len;
    unsigned char* psk;
    compose_s(p_array,4, &s, &s_len);
    psk = (unsigned char*)malloc(32);
    memset(psk,'\0',32);
    int g_ks_len = 16;
    hmac_sha256(g_ks, g_ks_len, s, s_len, psk);
    free(g_ks);
    g_ks=NULL;
    free(s);
    s=NULL;
    return psk;
}

int sign_token(char* str_name, char  *version,char* str_sourceid, unsigned char** ptoken, unsigned char* psk, int psk_len)
{
    
    int version_len, mac_len,sourceid_len;
    version_len =(int)strlen(version);
    mac_len = 32;
    sourceid_len = (int)strlen(str_sourceid);
    int token_head_len = 12 + version_len + g_btid_len + sqn_len+sourceid_len;
    unsigned char* token = malloc(2 + token_head_len + 32 + 3);
    unsigned char* p = token;
    unsigned char* mac;
    memset(p, 0x84, 1);
    memset(p+1, 0x84, 1);
    p += 2;
    memset(p, 0x01, 1);
    p += 1;
    memset(p, ((uint16_t)version_len & 0xFF00)>>1, 1);
    memset(p+1, version_len & 0x00FF, 1);
    p += 2;
    memcpy(p, version, version_len);
    p += version_len;
    //B-TID_TAG
    memset(p, 0x02, 1);
    p += 1;
    //B-TID_LENGTH
    memset(p, ((uint16_t)g_btid_len & 0xFF00)>>1, 1);
    memset(p+1, g_btid_len & 0x00FF, 1);
    p += 2;
    //B-TID_VALUE
    memcpy(p, g_btid, g_btid_len);
    p += g_btid_len;
    //SQN_TAG
    memset(p, 0x03, 1);
    p += 1;
    //SQN_LENGTH
    memset(p, ((uint16_t)sqn_len & 0xFF00)>>1, 1);
    memset(p+1, (uint16_t)sqn_len & 0x00FF, 1);
    p += 2;
    //SQN_VALUE
    uint32_t rev_sqn = TRAN32(g_sqn);
    memcpy(p, &rev_sqn, sqn_len);
    p += sqn_len;
    
    //SOURCEID_TAG
    memset(p, 0x04, 1);
    p += 1;
    //SOURCEID_LENGTH
    memset(p, ((uint16_t)sourceid_len & 0xFF00)>>1, 1);
    memset(p+1, sourceid_len & 0x00FF, 1);
    p += 2;
    //SOURCEID_VALUE
    memcpy(p, str_sourceid, sourceid_len);
    p += sourceid_len;
    
    //MAC_TAG
    memset(p, 0xFF, 1);
    p += 1;
    //MAC_LENGTH
    memset(p, ((uint16_t)mac_len & 0xFF00)>>1, 1);
    memset(p+1, (uint16_t)mac_len & 0x00FF, 1);
    p += 2;
    //calculate mac
    mac = malloc(mac_len);
    memset(mac, 0, mac_len);
    hmac_sha256(psk, psk_len, token+2, token_head_len, mac);
    memcpy(p, mac, mac_len);
    
    
    p += mac_len;
    free(mac);
    mac=NULL;
    int token_length = (int)(p - token);
    *ptoken = token;
    return token_length;
}


@end
