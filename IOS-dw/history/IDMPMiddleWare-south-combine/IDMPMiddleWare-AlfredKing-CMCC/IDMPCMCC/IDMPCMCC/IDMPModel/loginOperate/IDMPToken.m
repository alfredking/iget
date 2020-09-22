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
#import "IDMPHttpRequest.h"
#import "userInfoStorage.h"
#import "IDMPOpensslDigest.h"

@implementation IDMPToken

unsigned char *g_ks ;
unsigned char *g_btid;
int g_sqn;
int g_btid_len;
int sqn_len;
#define TRAN32(X) ((((uint32_t)(X)&0xff000000)>>24) | (((uint32_t)(X)&0x00ff0000)>>8) | (((uint32_t)(X)&0x0000ff00)<<8) | (((uint32_t)(X) & 0x000000ff) << 24))

+ (NSString *)getTokenWithUserName:(NSString *)userName andAppId:(NSString *)appId
{
    static NSLock *lock = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lock = [[NSLock alloc] init];
        NSLog(@"lock init");
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
    NSMutableDictionary *user =[NSMutableDictionary dictionaryWithDictionary:[userInfoStorage getInfoWithKey:[NSString stringWithUTF8String:userName]]];
    NSLog(@"Mutableuser address %d",user);
    NSLog(@"iutableuser address %d",[userInfoStorage getInfoWithKey:[NSString stringWithUTF8String:userName]]);
    
    NSString *BTID=[user objectForKey:ksBTID];
    g_btid = (unsigned char *)[BTID UTF8String];
    g_btid_len=(int)[BTID length];
    NSString *KS=[user objectForKey:@"KS"];
    unsigned char *g_ks_temp = (unsigned char *)[KS UTF8String];
    g_ks= HexStrToByte((const char*)g_ks_temp,32);
    NSString *SQN=[user objectForKey:ksSQN];
    NSLog(@"sqn from user is %@",SQN);
    NSUInteger ISQN=[SQN integerValue]+1;
    NSLog(@"add sqn is %d",ISQN);
    [user setValue:[NSString stringWithFormat:@"%d",(int)ISQN] forKey:ksSQN];
    NSLog(@"user signkey is %@",user);
    
    [userInfoStorage setInfo:user withKey:[NSString stringWithUTF8String:userName]];
    
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
//    psk = (unsigned char*)malloc(32);
//    memset(psk,'\0',32);
    int g_ks_len = 16;
    psk=sha256WithKeyAndData(g_ks,g_ks_len,s,s_len);
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
    mac=sha256WithKeyAndData(psk, psk_len,token+2, token_head_len);
    memcpy(p, mac, mac_len);
    
    
    p += mac_len;
    free(mac);
    mac=NULL;
    int token_length = (int)(p - token);
    *ptoken = token;
    return token_length;
}

+ (void)checkToken:(NSString *)Token successBlock:(callBackBlock)success failBlock:(callBackBlock)fail
{
    NSString *sourceId = [userInfoStorage getInfoWithKey:sourceIdsk];
    NSLog(@"sourceid is %@",sourceId);
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyyMMddHHmmssSSS"];
    NSString *currentDateStr = [dateFormat stringFromDate:[NSDate date]];
    NSMutableDictionary *head = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1.0",@"version",@"5",@"apptype",currentDateStr,@"systemtime",@"abcde",@"msgid",sourceId,@"sourceid" , nil];
    NSMutableDictionary *body = [NSMutableDictionary dictionaryWithObjectsAndKeys:Token,@"token", nil];
    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:head,@"header",body,@"body", nil];
    NSURL *url = [NSURL URLWithString:tokenUrl];
    NSLog(@"token url is %@",tokenUrl);
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
    NSData *Body = [NSJSONSerialization dataWithJSONObject:heads options:NSJSONWritingPrettyPrinted error:nil];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json; encoding=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:Body];
    NSLog(@"body is %@",heads);
    NSLog(@"token request is %@",request);
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionTask *task = [session dataTaskWithRequest:request
                                        completionHandler:^(NSData *data, NSURLResponse *urlResponse, NSError *error)
                              {
                                  NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)urlResponse;
                                  NSLog(@"error:%@",error.description);
                                  if (httpResponse.statusCode == 200)
                                  {
                                      NSDictionary *responseDict =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                                      NSDictionary *header = [responseDict objectForKey:@"header"];
                                      
                                      if ([[header objectForKey:@"resultcode"]integerValue] == 103000)
                                      {
                                          success(responseDict);
                                      }
                                      else
                                      {
                                          fail(responseDict);
                                      }
                                  }
                                  else
                                  {
                                      NSLog(@"failBlock");
                                      NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:@"102102",@"resultCode", nil];
                                      
                                      fail(result);
                                  }
                              }];
    [task resume];
}


- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * __nullable credential))completionHandler{
    
    NSLog(@"challenge start");
    NSLog(@"challenge is %@",challenge);
    
    NSString *cerString=@"3082035f30820247a0030201020204595b531d300d06092a864886f70d01010b 05003060310b300906035504061302636e3111300f060355040813087a68656a69616e67 3111300f0603550407130868 616e677a686f75310d300b060355040a1304636d6363310d 300b060355040b1304636d6363310d300b06035504031304636d6363301e170d31363037 31323032323031315a170d3236303731303032323031315a3060310b30090603 5504061302636e3111300f060355040813087a68656a69616e673111300f0603 550407130868616e677a686f75310d300b060355040a1304636d6363310d300b 060355040b1304636d6363310d300b06035504031304636d636330820122300d 06092a864886f70d01010105000382010f003082010a0282010100a3afd55eba 9409b001e181dfda2a3c65aa017432f69cb13e5a9a756224cd3b7037c22e1299 d942e4e86d82cfed49af6c9b008f4361c2a9f3e63665281db69f254a39fb3ba4 10e771092175248d7d2713145fcda5576ee8132de326d602cf626afc648dee30 120bcd7b0432be8c451713e19e4d09dab4e394efcf38f9cdf25f04be43b8ab76 585bd0d446690287af92bcbd400a718051e4519bc490025589082342847ff1ce 67acebec1581fad0c8d6a34c9e5f9b4e7442aa45907b69fcb2e8660bf0d08d47 cfdea920ea6b570b77003b91cd341bc918231a598345c4e2ddf110c8f2bccad8 bb18843b55afdd4665631827ddccb3b942b2767b35b523340cf4db0203010001 a321301f301d0603551d0e04160414981a75efe1024efd13305001b9b2cbdb74 a1688f300d06092a864886f70d01010b0500038201010052847e9d73842ae394 84dbd51da1c415436efd54f16005f560a02f3dc3c98101d754e10ba5c94486ed 00fac731952e9f1910bda7f45df3651575f0ee6bdfd20816d9d4da091af52ae4 a1feed24f250eb6f00b8037e27e453e2cb4ff48cc308f8793c265113a73db6df c0b11e0f736720874999fe31d0a56b61d89a6ecf4829acac4e67ba54ee8196a8 1be234b0a804f7aae986f275aea68afcfb6db985bca5786fdc9bb75f189675ac 740fbac27b5679af0e2c7ff23ea1cc6f1b5ff0e6ac4fa0029f7fc2e1080b109a 2a5ae0b0911a7bff797a881dc38141711cf3baf05bbfc29e69f56ff3515b52d0 128768e12b9d992bf960fca93f1eb6ad9e9bd8451a38b3";
    
    
    NSData *data=[IDMPFormatTransform hexStringToNSData:cerString];
    SecCertificateRef certificate = SecCertificateCreateWithData(NULL, (__bridge CFDataRef) data);
    NSArray *trustedCerArr= @[(__bridge_transfer id)certificate];
    OSStatus err;
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    SecTrustResultType  trustResult = kSecTrustResultInvalid;
    NSURLCredential *credential = nil;
    
    //获取服务器的trust object
    SecTrustRef serverTrust = challenge.protectionSpace.serverTrust;
    NSLog(@"challenge serverTrust is %@",challenge.protectionSpace.serverTrust);
    //将读取的证书设置为serverTrust的根证书
    err = SecTrustSetAnchorCertificates(serverTrust, (__bridge CFArrayRef)trustedCerArr);
    
    if(err == noErr)
    {
        //通过本地导入的证书来验证服务器的证书是否可信，如果将SecTrustSetAnchorCertificatesOnly设置为NO，则只要通过本地或者系统证书链任何一方认证就行
        err = SecTrustEvaluate(serverTrust, &trustResult);
        
        NSLog(@"no error");
    }
    
    if (err == errSecSuccess && (trustResult == kSecTrustResultProceed || trustResult == kSecTrustResultUnspecified))
    {
        //认证成功，则创建一个凭证返回给服务器
        disposition = NSURLSessionAuthChallengeUseCredential;
        credential = [NSURLCredential credentialForTrust:serverTrust];
        NSLog(@"认证成功");
    }
    else
    {
        disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
        NSLog(@"认证失败");
    }
    
    //回调凭证，传递给服务器
    if(completionHandler)
    {
        NSLog(@"回传给服务器");
        completionHandler(disposition, credential);
    }
}


@end
