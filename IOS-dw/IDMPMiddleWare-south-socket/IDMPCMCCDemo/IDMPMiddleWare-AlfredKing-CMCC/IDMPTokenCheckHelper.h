//
//  IDMPTokenCheckHelper.h
//  IDMPCMCCDemo
//
//  Created by wj on 2018/1/16.
//  Copyright © 2018年 alfredking－cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^callBackBlock)(NSDictionary *dic);


@interface IDMPTokenCheckHelper : NSObject

@property(nonatomic,strong)  NSOperationQueue *queue;


-(void)checkToken:(NSString *)Token successBlock:(callBackBlock)success failBlock:(callBackBlock)fail;

- (void)httpsTestWithUrlStr:(NSString *)urlStr heads:(NSDictionary *)heads successBlock:(callBackBlock)success failBlock:(callBackBlock)fail;

@end
