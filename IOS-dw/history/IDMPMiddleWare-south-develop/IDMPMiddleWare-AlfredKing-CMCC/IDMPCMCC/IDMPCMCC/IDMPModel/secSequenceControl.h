//
//  secSequenceControl.h
//  IDMPCMCC
//
//  Created by alfredking－cmcc on 16/8/2.
//  Copyright © 2016年 zwk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface secSequenceControl : NSObject

-(void)semaphoreExecuteFirst;
-(void)semaphoreExecuteNext;

@end
