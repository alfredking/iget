//
//  Log.h
//  IDMPCMCC
//
//  Created by zeng yingpei on 15/8/6.
//  Copyright (c) 2015年 zwk. All rights reserved.
//
// http://stackoverflow.com/questions/7271528/how-to-nslog-into-a-file
// Add the replacement of printf as well.

#import <Foundation/Foundation.h>


#define NSLog(args...) _Log(@"DEBUG ", __FILE__,__LINE__,__PRETTY_FUNCTION__,args);

//#define printf(args...) _Log_printf(@"DEBUG ", __FILE__,__LINE__,__PRETTY_FUNCTION__,args);

// This method works as well.
//#define printf(format, ...) _Log(@"DEBUG ", __FILE__,__LINE__,__PRETTY_FUNCTION__, [NSString stringWithCString:format encoding:NSUTF8StringEncoding], ##__VA_ARGS__);

@interface Log : NSObject
void _Log(NSString *prefix, const char *file, int lineNumber, const char *funcName, NSString *format,...);
void _Log_printf(NSString *prefix, const char *file, int lineNumber, const char *funcName, char* format,...);
@end
