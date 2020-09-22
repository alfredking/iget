//
//  IDMPUPMode.h
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking－cmcc on 14-8-21.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDMPUPMode : NSObject

typedef void (^IDMPBlock)(void);
typedef void (^accessBlock)(NSDictionary *paraments);

- (void)getUPKSWithSipInfo: (NSString *)sipinfo UserName:(NSString *)userName andPassWd:(NSString *)passWd traceId:(NSString *)traceId successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock;


@end
