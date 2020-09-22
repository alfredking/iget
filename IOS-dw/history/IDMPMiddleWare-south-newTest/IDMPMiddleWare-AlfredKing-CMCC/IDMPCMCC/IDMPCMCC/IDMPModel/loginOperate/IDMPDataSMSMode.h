//
//  IDMPDataSMSMode.h
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking－cmcc on 14-10-16.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDMPDataSMSMode : NSObject

typedef void (^accessBlock)(NSDictionary *paraments);

+ (void)getDataSmsMobileNumberWithAppid:(NSString *)appid appkey:(NSString *)appkey userName:(NSString *)userName SuccessBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock;

@end
