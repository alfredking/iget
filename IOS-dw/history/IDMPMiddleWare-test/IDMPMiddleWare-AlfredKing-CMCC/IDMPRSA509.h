//
//  IDMPRSA509.h
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking on 15/11/12.
//  Copyright © 2015年 alfredking－cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDMPRSA509 : NSObject

{
    SecKeyRef publicKey;
    SecCertificateRef certificate;
    SecPolicyRef policy;
    SecTrustRef trust;
    size_t maxPlainLen;
}

- (NSData *) encryptWithData:(NSData *)content;
- (NSData *) encryptWithString:(NSString *)content;


@end
