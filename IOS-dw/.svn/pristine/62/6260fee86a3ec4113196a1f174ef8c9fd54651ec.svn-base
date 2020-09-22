////
////  IDMPSocket.m
////  IDMPCMCCDemo
////
////  Created by wj on 2018/8/9.
////  Copyright © 2018年 alfredking－cmcc. All rights reserved.
////
//
//#import "IDMPSocket.h"
//#import <netdb.h>
//#import <arpa/inet.h>
//#import <sys/socket.h>
//#import <netinet/in.h>
//#import <net/if.h>
//#import "IDMPAuthModel.h"
//#import "NSString+IDMPAdd.h"
//
//#define BUFFER_SIZE 1024
//#define FILE_NAME_MAX_SIZE 512
//
//@interface IDMPSocket()
//
//@property (nonatomic,strong) NSDictionary *socketHeads;
//@property (nonatomic,strong) NSURL *socketUrl;
//
//@end
//
//@implementation IDMPSocket
//
//- (void)test {
//    
//    self.socketUrl = [NSURL URLWithString:@"http://www.cmpassport.com/openapi/NorthForwardServlet"];
//    NSString *clientNonce = [NSString idmp_getClientNonce];
//    NSString *traceId = [[NSString idmp_getClientNonce] uppercaseString];
//    self.socketHeads = [[IDMPAuthModel alloc] initWPWithSipInfo:nil clientNonce:clientNonce traceId:traceId isTmpCache:NO].heads;
//
//    
//    NSString *host = @"www.cmpassport.com";
////    char ip[256];
////
////
////
////    struct addrinfo hints;
////    struct addrinfo *res, *cur;
////    int ret;
////    struct sockaddr_in *addr = NULL;
////    struct sockaddr_in6 *addr6;
////    char ipbuf[100];
////
////    printf("official hostname: %s\n", [host UTF8String]);
////
////    memset(&hints, 0, sizeof(struct addrinfo));
////    hints.ai_family = AF_UNSPEC;    //AF_UNSPEC; /* Allow IPv4 */
////    hints.ai_flags |= AI_ALL;    //AI_ALL;    //AI_CANONNAME;    //AI_PASSIVE; /* For wildcard IP address */
////    hints.ai_protocol = IPPROTO_IP; /* Any protocol */
////    hints.ai_socktype = SOCK_STREAM;
////
////    if ((ret = getaddrinfo([host UTF8String], NULL, &hints, &res)) == -1)
////    {
////        perror("getaddrinfo");
////        return;
////    }
////
////
////    for (cur = res; cur != NULL; cur = cur->ai_next)
////    {
////        memset(ipbuf, 0, sizeof(ipbuf));
////        switch (cur->ai_family)
////        {
////            case AF_INET:
////            {
////                addr = (struct sockaddr_in *)cur->ai_addr;
////                inet_ntop(cur->ai_family, &addr->sin_addr, ipbuf, sizeof(ipbuf));
////                break;
////            }
////            case AF_INET6:
////            {
////                addr6 = (struct sockaddr_in6 *)cur->ai_addr;
////                inet_ntop(cur->ai_family, &addr6->sin6_addr, ipbuf, sizeof(ipbuf));
////                break;
////            }
////            default:
////            {
////                printf("unknown address type\n");
////                break;
////            }
////        }
////
////        strcpy(ip, ipbuf);
////        printf("%s\n", ipbuf);
////    }
////    freeaddrinfo(res);
//    
//
//    
//    NSMutableArray *arr = [IDMPSocket lookupHost:host port:80 error:nil];
//
//    int s = socket(AF_INET, SOCK_STREAM, 0);
//    if (-1 == s) {
//        NSLog(@"fail");
//        return;
//    }
//
//    
////    struct hostent * remoteHostEnt = gethostbyname([host UTF8String]);
////    if (NULL == remoteHostEnt) {
////        close(socketFileDescriptor);
////        NSLog(@"fail to host");
////        return;
////    }
//    
//    
//    
////    struct in_addr * remoteInAddr = (struct in_addr *)remoteHostEnt->h_addr_list[0];
//
////    struct sockaddr_in socketParams;
////    socketParams.sin_family = AF_INET6;
////    socketParams.sin_addr = *remoteInAddr;
////    socketParams.sin_port = htons([port intValue]);
//    
////    addr->sin_port = htons(80);
////    int rett = connect(socketFileDescriptor, (struct sockaddr *)addr, sizeof(struct sockaddr_in));
////    perror("connect: ");
////    if (-1 == rett) {
////        close(socketFileDescriptor);
////        NSLog(@"fail to host");
////        return;
////    }
////    NSLog(@"success");
//    
//    int index = if_nametoindex("pdp_ip0");
//    setsockopt(s, IPPROTO_IP, IP_BOUND_IF, &index, sizeof(index));
//    perror("setsockopt");
//    
//    int result = connect(s, (const struct sockaddr *)[[arr objectAtIndex:1] bytes], (socklen_t)[[arr objectAtIndex:1] length]);
//    
//    perror("connect: ");
//    if (-1 == result) {
//        close(s);
//        NSLog(@"fail to host");
//        return;
//    }
//    NSLog(@"success");
//    
//    
//    
//    NSString *secHost=[NSString stringWithFormat:@"Host: %@",[self.socketUrl host]];
//    //    NSString *secHost = @"Host: www.cmpassport.com";
//    NSString *Accept=@"Accept: */*";
//    NSString *Connection=@"Connection: keep-alive";
//    NSString *AcceptLanguage=@"Accept-Language: zh-cn";
//    NSString *AcceptEncoding=@"Accept-Encoding: gzip, deflate";
//    NSString *UserAgent=@"User-Agent: IDMPMiddleWare-AlfredKing-CMCC/1.0 CFNetwork/808.1.4 Darwin/16.1.0";
//    NSString *requestStr = nil;
//    //用于cmcc取号
//    NSString *prefix=[NSString stringWithFormat:@"GET %@ HTTP/1.1",[self.socketUrl path]] ;
//    NSString *signature=[NSString stringWithFormat:@"signature: %@",[self.socketHeads objectForKey:ksSignature]];
//    NSString *rcData=[NSString stringWithFormat:@"rcData: %@",[self.socketHeads objectForKey:kRC_data]];
//    NSString *Authorization=[NSString stringWithFormat:@"Authorization: %@",[self.socketHeads objectForKey:ksAuthorization]];
//    requestStr = [NSString stringWithFormat:@"%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n\r\n",prefix,secHost,Accept,Connection,signature,AcceptLanguage,Authorization,AcceptEncoding,UserAgent,rcData];
//
//    
//    NSData *requestData = [requestStr dataUsingEncoding:NSUTF8StringEncoding];
//    
//    
//
//    
//    char buffer[UINTPTR_MAX];
////    bzero(buffer,UINTPTR_MAX);
//    strncpy(buffer, [requestData bytes], strlen([requestData bytes])>UINTPTR_MAX?UINTPTR_MAX:strlen([requestData bytes]));
//    //向服务器发送buffer中的数据
//    send(s,buffer,UINTPTR_MAX,0);
//    perror("send::");
//
//    
//    //从服务器接收数据到buffer中
//    bzero(buffer,BUFFER_SIZE);
//    int length = 0;
////    while( length = recv(s,buffer,BUFFER_SIZE,0))
////    {
////
////        bzero(buffer,BUFFER_SIZE);
////    }
//////    printf("Recieve File:\t %s From Server[%s] Finished\n",file_name, argv[1]);
////    
////    //关闭socket
////    close(s);
//    
//    
//
//}
//
//
//+ (NSMutableArray *)lookupHost:(NSString *)host port:(uint16_t)port error:(NSError **)errPtr
//{
//    
//    NSMutableArray *addresses = nil;
//    NSError *error = nil;
//    
//    
//    if ([host isEqualToString:@"localhost"] || [host isEqualToString:@"loopback"])
//    {
//        // Use LOOPBACK address
//        struct sockaddr_in nativeAddr4;
//        nativeAddr4.sin_len         = sizeof(struct sockaddr_in);
//        nativeAddr4.sin_family      = AF_INET;
//        nativeAddr4.sin_port        = htons(port);
//        nativeAddr4.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
//        memset(&(nativeAddr4.sin_zero), 0, sizeof(nativeAddr4.sin_zero));
//        
//        struct sockaddr_in6 nativeAddr6;
//        nativeAddr6.sin6_len        = sizeof(struct sockaddr_in6);
//        nativeAddr6.sin6_family     = AF_INET6;
//        nativeAddr6.sin6_port       = htons(port);
//        nativeAddr6.sin6_flowinfo   = 0;
//        nativeAddr6.sin6_addr       = in6addr_loopback;
//        nativeAddr6.sin6_scope_id   = 0;
//        
//        // Wrap the native address structures
//        
//        NSData *address4 = [NSData dataWithBytes:&nativeAddr4 length:sizeof(nativeAddr4)];
//        NSData *address6 = [NSData dataWithBytes:&nativeAddr6 length:sizeof(nativeAddr6)];
//        
//        
//        addresses = [NSMutableArray arrayWithCapacity:2];
//        [addresses addObject:address4];
//        [addresses addObject:address6];
//    }
//    else
//    {
//        NSString *portStr = [NSString stringWithFormat:@"%hu", port];
//        
//        struct addrinfo hints, *res, *res0;
//        
//        memset(&hints, 0, sizeof(hints));
//        hints.ai_family   = AF_UNSPEC;
//        hints.ai_socktype = SOCK_STREAM;
//        hints.ai_protocol = IPPROTO_TCP;
//        
//        int gai_error = getaddrinfo([host UTF8String], [portStr UTF8String], &hints, &res0);
//        if (gai_error)
//        {
//            error = [NSError errorWithDomain:NSURLErrorDomain code:gai_error userInfo:nil];
//        }
//        else
//        {
//            NSUInteger capacity = 0;
//            for (res = res0; res; res = res->ai_next)
//            {
//                if (res->ai_family == AF_INET || res->ai_family == AF_INET6) {
//                    capacity++;
//                }
//            }
//            
//            addresses = [NSMutableArray arrayWithCapacity:capacity];
//            
//            for (res = res0; res; res = res->ai_next)
//            {
//                if (res->ai_family == AF_INET)
//                {
//
//                
//                    char ipbuf[100];
//                    struct sockaddr_in *addr = (struct sockaddr_in *)res->ai_addr;
//                    inet_ntop(res->ai_family, &addr->sin_addr, ipbuf, sizeof(ipbuf));
//                    printf("address: %s",ipbuf);
//                    //                     Found IPv4 address.
//                    //                     Wrap the native address structure, and add to results.
//                    NSData *address4 = [NSData dataWithBytes:res->ai_addr length:res->ai_addrlen];
//                    [addresses addObject:address4];
//                }
//                else if (res->ai_family == AF_INET6)
//                {
//                    // Fixes connection issues with IPv6
//                    // https://github.com/robbiehanson/CocoaAsyncSocket/issues/429#issuecomment-222477158
//                    
//                    // Found IPv6 address.
//                    // Wrap the native address structure, and add to results.
//
//                    
//                    char ipbuf[100];
//                    struct sockaddr_in6 *addr = (struct sockaddr_in6 *)res->ai_addr;
//                    inet_ntop(res->ai_family, &addr->sin6_addr, ipbuf, sizeof(ipbuf));
//                    printf("address: %s",ipbuf);
//                    
////                    struct sockaddr_in6 *sockaddr = (struct sockaddr_in6 *)res->ai_addr;
////                    in_port_t *portPtr = &sockaddr->sin6_port;
////                    if ((portPtr != NULL) && (*portPtr == 0)) {
////                        *portPtr = htons(port);
////                    }
////                    printf("address: %s\n",res->ai_addr);
//                    NSData *address6 = [NSData dataWithBytes:res->ai_addr length:res->ai_addrlen];
//                    [addresses addObject:address6];
//                }
//            }
//            freeaddrinfo(res0);
//            
//            if ([addresses count] == 0)
//            {
//                error = [NSError errorWithDomain:NSURLErrorDomain code:11 userInfo:nil];
//            }
//        }
//    }
//    
//    if (errPtr) *errPtr = error;
//    return addresses;
//}
//
//
//@end
