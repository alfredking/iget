//
//  IDMPCellularData.m
//  IDMPCMCC
//
//  Created by wj on 07/06/2017.
//  Copyright © 2017 zwk. All rights reserved.
//

#import "IDMPCellularData.h"

static IDMPCellularData *_instance = nil;
@implementation IDMPCellularData

+(id)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[IDMPCellularData alloc] init];
    });
    return _instance;
}

- (void)dealloc {
    
}

@end
