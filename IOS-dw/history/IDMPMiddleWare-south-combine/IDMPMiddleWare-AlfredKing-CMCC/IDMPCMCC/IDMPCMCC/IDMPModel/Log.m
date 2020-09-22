//
//  Log.m
//  IDMPCMCC
//
//  Created by zeng yingpei on 15/8/6.
//  Copyright (c) 2015年 zwk. All rights reserved.
//  Redirect NSLog and printf in this project into a file.
//  http://stackoverflow.com/questions/7271528/how-to-nslog-into-a-file
//  Add the replacement of printf as well.
//  Fix encoding problem (avoid using %s).
//

#import "Log.h"
@implementation Log

void append(NSString *msg){
    // get path to Documents/somefile.txt
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager* manager = [NSFileManager defaultManager];
    NSString* lLogDir = [documentsDirectory stringByAppendingPathComponent:@"log/UAlog"];
    if(![manager fileExistsAtPath:lLogDir isDirectory:NULL])
    {
        NSError* lError = nil;
        [manager createDirectoryAtPath:lLogDir withIntermediateDirectories:YES attributes:NULL error:&lError];
    }
    NSString *path = [lLogDir stringByAppendingPathComponent:@"IDMPLogFile.txt"];
    // create if needed
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        fprintf(stderr,"Creating file at %s",[path UTF8String]);
        [[NSData data] writeToFile:path atomically:YES];
    }
    // append
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:path];
    @try{
        [handle seekToEndOfFile];
        [handle writeData:[msg dataUsingEncoding:NSUTF8StringEncoding]];
    }@catch (NSException* e)
    {
        fprintf(stderr,"Catch exception in Log.m's append: %s",[[e description] UTF8String]);
    }@finally
    {
        [handle closeFile];
    }
}

/*
 * Add a function with va_list parameter for handoff
 * http://c-faq.com/varargs/handoff.html
 */
void _Logv(NSString *prefix, const char *file, int lineNumber, const char *funcName, NSString *format, va_list ap)
{
    format = [format stringByAppendingString:@"\n"];
    NSDate* lDate = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss:SSS"];
    NSString* date = [formatter stringFromDate:lDate];
    NSString *msg = [[NSString alloc] initWithFormat:[NSString stringWithFormat:@"%@",format] arguments:ap];
    fprintf(stdout,"%s %s%50s:%3d - %s",[date UTF8String],[prefix UTF8String], funcName, lineNumber, [msg UTF8String]);
    NSString* lFullMsg = [NSString stringWithFormat:@"%@ %@%50s:%3d - %@", date, prefix, funcName, lineNumber, msg];
    if ([NSThread isMainThread])
    {
        append(lFullMsg);
    }else{
        dispatch_sync(dispatch_get_main_queue(), ^{
            append(lFullMsg);
        });
    }
}

void _Log(NSString *prefix, const char *file, int lineNumber, const char *funcName, NSString *format,...) {
    va_list ap;
    va_start (ap, format);
    _Logv(prefix, file, lineNumber, funcName, format, ap);
    va_end (ap);
}

void _Log_printf(NSString *prefix, const char *file, int lineNumber, const char *funcName, char* format,...)
{
    va_list ap;
    va_start (ap, format);
    _Logv(prefix, file, lineNumber, funcName, [NSString stringWithCString:format encoding:NSUTF8StringEncoding], ap);
    va_end (ap);
}
@end