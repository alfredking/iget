//
//  IDMPWapMode.h
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking－cmcc on 14-8-21.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDMPWapMode : NSObject

typedef void (^IDMPBlock)(void);

-(void)getWapKSWithSuccessBlock:(IDMPBlock)successBlock failBlock:(IDMPBlock)failBlock ;

@end
