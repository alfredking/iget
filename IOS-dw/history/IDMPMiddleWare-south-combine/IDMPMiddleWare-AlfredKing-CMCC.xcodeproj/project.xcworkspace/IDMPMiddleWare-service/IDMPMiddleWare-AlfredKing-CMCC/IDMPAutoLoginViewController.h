//
//  IDMPAutoLoginViewController.h
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking－cmcc on 14-9-15.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDMPDataSMSMode.h"
#import "IDMPUPViewController.h"
#import "IDMPTempSmsViewController.h"
#import "IDMPWapMode.h"
#import "IDMPDevice.h"
#import "sim.h"
@interface IDMPAutoLoginViewController :IDMPDataSMSMode

-(int )getAuthType;

@end
