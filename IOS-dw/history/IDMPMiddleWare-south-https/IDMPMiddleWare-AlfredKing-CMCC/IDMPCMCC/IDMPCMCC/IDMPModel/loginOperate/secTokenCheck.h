//
//  secTokenCheck.h
//  IDMPCMCC
//
//  Created by alfredking－cmcc on 16/9/26.
//  Copyright © 2016年 zwk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^callBackBlock)(NSDictionary *dic);

@interface secTokenCheck : NSObject

@property(nonatomic,strong)  NSOperationQueue *queue;

-(void)checkToken:(NSString *)Token successBlock:(callBackBlock)success failBlock:(callBackBlock)fail;


@end
