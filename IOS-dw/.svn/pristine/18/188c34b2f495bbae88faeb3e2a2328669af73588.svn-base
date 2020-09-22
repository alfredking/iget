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
    char version[2] = {0x00, 0x00};
    strcpy(version, "1");
    unsigned char *token;
    int tokenLen =signkey([userName UTF8String],[appId UTF8String], version, &token);
    if(tokenLen > 128){
        tokenLen = 128;
    }
    NSString *stoken=[IDMPFormatTransform  charToNSHex:token length:tokenLen];
    return stoken;
}


int signkey(char *userName,char *appid, char* version, unsigned char** ptoken)
{
    NSMutableDictionary *user =[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithUTF8String:userName]]];
    NSString *BTID=[user objectForKey: ksBTID];
    g_btid = [BTID UTF8String];
    g_btid_len=[BTID length];
    NSString *KS=[user objectForKey:@"KS"];
    unsigned char *g_ks_temp = [KS UTF8String];
    g_ks= HexStrToByte(g_ks_temp,32);
    NSString *SQN=[user objectForKey:ksSQN];
    NSLog(@"sqn is:%@",SQN);
    NSUInteger ISQN=[SQN integerValue]+1;
    [user setValue:[NSString stringWithFormat:@"%d",ISQN] forKey:ksSQN];
    [[NSUserDefaults standardUserDefaults] setValue:user forKey:[NSString stringWithUTF8String:userName]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSString *SQNAfter=[user objectForKey:ksSQN];
    NSLog(@"sqn+1 is:%@",SQNAfter);
    g_sqn=ISQN;
    sqn_len=4;
    char btid_str[64],encrand[32];
    char* delims={"@"};
    char* temp;
    strcpy(btid_str, g_btid);
    temp= strtok(btid_str, delims);
    strcpy(encrand, temp);
    char* pscene = "gba-me";
    unsigned char *psk = kdf_signkey(pscene, encrand,userName ,appid);
    psk[16]='\0';
    int tokenLen= sign_token(userName, version,ptoken, psk, 16);
    return tokenLen;
}

unsigned char* kdf_signkey(char* pscene, char* rand, char* impi, char* appid)
{
    char* p_array[4];
    p_array[0] = pscene;
    p_array[1] = rand;
    p_array[2] = impi;
    p_array[3] = appid;
    unsigned char* s;
    int s_len;
    unsigned char* psk;
    compose_s(p_array,4, &s, &s_len);
    psk = (unsigned char*)malloc(16);
    memset(psk,'\0',16);
    int g_ks_len = 16;
    hmac_sha256(g_ks, g_ks_len, s, s_len, psk);
    return psk;
}

int sign_token(char* str_name, char  *version, unsigned char** ptoken, unsigned char* psk, int psk_len)
{
    
    int version_len, mac_len;
    version_len =strlen(version);
    mac_len = 32;
    int token_head_len = 9 + version_len + g_btid_len + sqn_len;
    unsigned char* token = malloc(2 + token_head_len + 32 + 3);//Token started with "TT"
    unsigned char* p = token;
    unsigned char* mac;
    //Set "TT" header in front of the token
    memset(p, 0x84, 1);
    memset(p+1, 0x84, 1);
    p += 2;
    //Version_TAG
    memset(p, 0x01, 1);
    p += 1;
    //Version_LENGTH
    memset(p, ((uint16_t)version_len & 0xFF00)>>1, 1);
    memset(p+1, version_len & 0x00FF, 1);
    p += 2;
    //Version_VALUE
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
    print_hex(token+2);
    memcpy(p, mac, mac_len);
    p += mac_len;
    int token_length = p - token;
    *ptoken = token;
    return token_length;
}

+(BOOL) checkToken:(NSString *)Token andAppid:(NSString *)APPID
{
    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:Token,@"token",APPID,@"appid", nil];
    NSLog(@"heads:%@",heads);
    IDMPHttpRequest  *request = [IDMPHttpRequest getHttpByHeads:heads url:tokenUrl successBlock:^{} failBlock:^{}];
    NSLog(@"token request:%@",request.responseHeaders);
    NSLog(@"token request body:%@",request.responseString);
    NSInteger resultCode = [[request.responseHeaders objectForKey:ksResultCode] integerValue];
    if(resultCode==IDMPTokenSuccess)
    {
        
        return YES;
    }
    else
        return NO;
}

@end
