//
//  IDMPLogReportMode.m
//  IDMPCMCC
//
//  Created by wj on 2017/6/29.
//  Copyright © 2017年 zwk. All rights reserved.
//

#import "IDMPLogReportMode.h"
#import "IDMPHttpRequest.h"
#import "IDMPConst.h"
//#import "userInfoStorage.h"
#import "IDMPDateFormatter.h"
#import "IDMPInterfaceLog.h"
#import "IDMPNonce.h"
#import "IDMPMD5.h"
#import "IDMPRSA_Sign_Verify.h"
#import "IDMPDevice.h"
#import "IDMPDate.h"

typedef NS_ENUM(NSInteger, IDMPCacheReportType) {
    IDMPNOTALLOWED = 0,
    IDMPALLOWED  = 1,
    IDMPABANDONED = 2,
};

static NSString *IDMPSeparateStr = @"-IDMP-";
static NSString *IDMPLogDir = @"log/UAlog";
static NSString *IDMPLogFileName = @"IDMPInterfaceLogFile.txt";
static const char* IDMPLogThread = "IDMPLogThread";

static NSUInteger IDMPEachReportCacheLogLengh = 5;                      //缓存日志每次上报的条数
static NSString *IDMPAlreadyRealReportLogCount = @"IDMPAlreadyRealReportLogCount";    //每天已实时上报的条数key
static NSString *IDMPRealReportLogDate = @"IDMPRealReportLogDate";      //上一次实时上报的时间key

static NSString *IDMPReportLogConfig = @"IDMPReportLogConfig";
static NSString *IDMPReportLogTimeLimitStatus = @"timelimit";           //移动网络上传缓存日志时间操作状态key
static NSString *IDMPReportLogSizeLimitStatus = @"sizelimit";           //移动网络上传缓存日志大小操作状态key
static NSString *IDMPReportLogWapSize = @"limitX";                      //移动网络下上传缓存日志大小限制key
static NSString *IDMPReportLogWapTime = @"limitN";                      //移动网络下上传缓存日志时间限制key
static NSString *IDMPDayRealReportLogCount = @"limitM";                 //每天实时上报日志数量key
static NSString *IDMPReportLogConfigCheckTime = @"IDMPReportLogConfigCheckTime";


static NSUInteger IDMPReportLogConfigCheckTimeLimit = 3600;         //one hour

static dispatch_queue_t logQueue;


@interface IDMPLogReportMode()

@property (nonatomic, strong) NSDictionary *header;
@property(nonatomic, strong)IDMPInterfaceLog *interfaceLog;
@property(nonatomic, strong)NSString *path;                     //文件路径

@property(nonatomic, strong)NSArray *logArray;
@property(nonatomic, assign)NSUInteger currentPosition;

@end

@implementation IDMPLogReportMode

#pragma mark - life cycle
- (instancetype)initLogWithrequestType:(NSString *)requestType requestParm:(NSDictionary *)requestParam authType:(int)authType traceId:(NSString *)traceId {
    static dispatch_once_t onceLog;
    if (self = [super init]) {
        NSDateFormatter *dateFormat = [IDMPDateFormatter cachedDateFormatter];
        NSString *requestTime = [dateFormat stringFromDate:[NSDate date]];
        IDMPInterfaceLog *interfaceLog = [[IDMPInterfaceLog alloc] initWithRequestType:requestType requestTime:requestTime requestParam:requestParam networkType:[NSString stringWithFormat:@"%d",authType] traceId:traceId];
        self.interfaceLog = interfaceLog;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name: UIApplicationDidEnterBackgroundNotification object:nil];
        dispatch_once(&onceLog, ^{
            logQueue = dispatch_queue_create(IDMPLogThread, NULL);
        });
    }
    return self;
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)applicationEnterBackground {
    if (self.logArray) {
        [self saveRemainLogWithRawLogArray:self.logArray andPosition:self.currentPosition];
    }
}

#pragma mark - public method
//上报日志
- (void)reportLogWithRepsonseParam:(NSDictionary *)responseParam {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSDateFormatter *dateFormat = [IDMPDateFormatter cachedDateFormatter];
        NSString *responseTime = [dateFormat stringFromDate:[NSDate date]];
        [self.interfaceLog setResponseTime:responseTime responseParam:responseParam];
        NSDictionary *interfaceLogDic = [self.interfaceLog dictionary];
        NSString *net = [IDMPDevice GetCurrntNet];
        if (!net || ![self isAllowRealReportWithNet:net]) {
            NSLog(@"not allowed real report");
            [self appendLog:[self dictionaryToJson:interfaceLogDic]];
        } else {
            NSLog(@"start real log report");
            [self requestReportLog:[self dictionaryToJson:interfaceLogDic] successBlock:^(NSDictionary *paraments) {
                //存储上报的次数
                NSNumber *reportLogCount = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:IDMPAlreadyRealReportLogCount];
                [[NSUserDefaults standardUserDefaults] setObject:@([reportLogCount integerValue] + 1) forKey:IDMPAlreadyRealReportLogCount];
                NSLog(@"report real log success and number is %@",reportLogCount);
            } failBlock:^(NSDictionary *paraments) {
                NSLog(@"report real log fail");
                //保存日志到本地
                [self appendLog:[self dictionaryToJson:interfaceLogDic]];
            }];
        }
        //    //上报缓存日志
        [self reportCacheLogWithNet:net];
    });
}
#pragma mark - private method
//上报缓存日志
- (void)reportCacheLogWithNet:(NSString *)net {
    NSLog(@"start report cache log");
    if (!net) {
        NSLog(@"no net and end");
        return;
    }
    if (!logQueue) {
        logQueue= dispatch_queue_create(IDMPLogThread, NULL);
    }
    //同步执行上报日志操作
    dispatch_sync(logQueue, ^{
        if (!self.path) {
            NSLog(@"cache log path is nil");
            return;
        }
        
        //无日志直接返回
        NSString *allLog=[NSString stringWithContentsOfFile:self.path encoding:NSUTF8StringEncoding error:nil];
        if ([allLog isEqualToString:@""] || allLog == nil) {
            NSLog(@"cache log is nil");
            return;
        }
        //计算需要上传的次数
        self.logArray = [allLog componentsSeparatedByString:IDMPSeparateStr];
        NSUInteger logCount = self.logArray.count - 1;       //最后一个为空，需要排除
        NSUInteger lastReportLogLength = (logCount % IDMPEachReportCacheLogLengh == 0) ? IDMPEachReportCacheLogLengh : logCount % IDMPEachReportCacheLogLengh;
        NSUInteger allNeedReportCount = (lastReportLogLength == IDMPEachReportCacheLogLengh) ? logCount / IDMPEachReportCacheLogLengh : logCount / IDMPEachReportCacheLogLengh + 1;
        //分次上传
        self.currentPosition = 0;               //记录数组中的当前上传位置
        BOOL isReportAll = NO;                  //是否全部上传完成
        
        NSDictionary *config = (NSDictionary *)[[NSUserDefaults standardUserDefaults] objectForKey:IDMPReportLogConfig];
        NSInteger reportlogWapSize = [config[IDMPReportLogWapSize] integerValue] * 1024 * 1024;
        __block NSInteger outLogSize = allLog.length - reportlogWapSize;
        NSLog(@"all cache log size is %d bit, log count is %d and need report count is %D",allLog.length, logCount, allNeedReportCount);

        for (int i = 0; i < allNeedReportCount; i++) {
            // 根据位置取出相应的部分日志信息
            self.currentPosition = i * IDMPEachReportCacheLogLengh;
            NSUInteger length = (i == allNeedReportCount - 1) ? lastReportLogLength : IDMPEachReportCacheLogLengh;
            NSLog(@"start prepare the reporting log, position of cache log is %d and the length is %d",self.currentPosition,length);
            NSArray *subArr = [self.logArray subarrayWithRange:NSMakeRange(self.currentPosition, length)];
            
            NSString *subLog = [subArr componentsJoinedByString:@"\r\n"];
            NSLog(@"start query whether allow report cache log");
            IDMPCacheReportType reportType = [self isAllowReportCacheLogWithSubLog:subArr withOutLogSize:outLogSize withNet:net];
            if (reportType == IDMPNOTALLOWED) {
                [self saveRemainLogWithRawLogArray:self.logArray andPosition:self.currentPosition];
                NSLog(@"query resut is not allow report cache log and end");
                return;
            } else if (reportType == IDMPABANDONED){
                NSLog(@"query result is abandon cache log and start abandon");
                [self saveRemainLogWithRawLogArray:self.logArray andPosition:self.currentPosition];
                return;
            }
            
            __block BOOL reportSuccess = NO;    //是否本次上传成功
            
            // 上传日志
            [self requestReportLog:subLog successBlock:^(NSDictionary *paraments) {
                reportSuccess = YES;
                outLogSize = outLogSize - subLog.length - reportlogWapSize;
                NSLog(@"report cache log success (第%d次), net is %@",i+1, net);
            } failBlock:^(NSDictionary *paraments) {
                NSLog(@"report cache log fail(第%d次), net is %@",i+1, net);
            }];
            
            if (!reportSuccess) {
                // 上报失败后不再上传
                NSLog(@"report cache log fail and stop report");
                break;
            }
            
            if (i == allNeedReportCount - 1) {
                //全部上传完
                isReportAll = YES;
                break;
            }
        }
        
        if (isReportAll) {
            // 全部上报完成，把日志文件清空
            NSLog(@"report cache log all and clear all cache log");
            NSString *remainLogStr = @"";
            [self updateCacheLog:remainLogStr];
        } else {
            NSLog(@"report remain cache log");
            [self saveRemainLogWithRawLogArray:self.logArray andPosition:self.currentPosition];
        }
    });
}

- (IDMPCacheReportType)isAllowReportCacheLogWithSubLog:(NSArray *)subLogArr withOutLogSize:(NSInteger)outLogSize withNet:(NSString *)net{
    if ([net isEqualToString:@"wifi"]) {
        NSLog(@"net is wifi and allow report cache log");
        return IDMPALLOWED;
    }
    //4g环境下
    NSDictionary *config = (NSDictionary *)[[NSUserDefaults standardUserDefaults] objectForKey:IDMPReportLogConfig];
    if (config) {
        NSString *isTimeAllowed = (NSString *)config[IDMPReportLogTimeLimitStatus];
        if ([isTimeAllowed isEqualToString:@"1"]) {
            NSLog(@"config allow report cache log when exceed time");
            int limitTime = [config[IDMPReportLogWapTime] intValue] * 24 * 3600;
            int timezoneFix = (int)[NSTimeZone localTimeZone].secondsFromGMT;
            int timeNow = ([[NSDate date] timeIntervalSince1970] + timezoneFix);
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[subLogArr[0] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
            if (dic) {
                NSDateFormatter *dateFormat = [IDMPDateFormatter cachedDateFormatter];
                int requestDate = (int)[[dateFormat dateFromString:dic[@"requestTime"]] timeIntervalSince1970];
                NSLog(@"time now(%d) - requestdate(%d) equal %d, limit time is %d", timeNow, requestDate, (timeNow  - requestDate), limitTime);
                if (timeNow - requestDate > limitTime) {
                    //在移动网络下,时间超限允许上传。
                    NSLog(@"time now - requestdate date > limittime, and allow report");
                    return IDMPALLOWED;
                }
            } else {
                NSLog(@"异常日志");
                return IDMPABANDONED;
            }
        }
        
        NSString *isSizeAllowed = (NSString *)config[IDMPReportLogSizeLimitStatus];  //0不做处理 //1允许上传 //2清除
        if ([isSizeAllowed isEqualToString:@"1"]) {
            NSLog(@"config allow report cache log when exceed size, outlogsize is %d", outLogSize);
            if (outLogSize > 0) {
                NSLog(@"out log size is > 0 and allow report cache log");
                //在移动网络下，大小超限允许上传。
                return IDMPALLOWED;
            }
        } else if ([isSizeAllowed isEqualToString:@"2"]) {
            NSLog(@"config allow allow cache log when exceed size");
            if (outLogSize > 0) {
                NSLog(@"out log size is %d, and abandon cache log",outLogSize);
                return IDMPABANDONED;
            }
        }
    }
    return IDMPNOTALLOWED;
}

//只上传部分，把剩余日志重新保存
- (void)saveRemainLogWithRawLogArray:(NSArray *)rawLogArray andPosition:(NSUInteger)position {
    if (position == 0 || !rawLogArray || rawLogArray.count == 0) {
        return;
    }
    NSInteger remainLength = rawLogArray.count -  position - 1;
    if (remainLength < 0) {
        return;
    }
    NSArray *remainLogArray = [rawLogArray subarrayWithRange:NSMakeRange(position, remainLength)];
    NSString *remainLogStr = [remainLogArray componentsJoinedByString:IDMPSeparateStr];
    NSLog(@"save remain log to cache, remain log size is %d", remainLogStr.length);
    [self updateCacheLog:remainLogStr];
}

//网络请求上报日志
- (void)requestReportLog:(NSString *)log successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    NSDictionary *config = (NSDictionary *)[[NSUserDefaults standardUserDefaults] objectForKey:IDMPReportLogConfig];
    if (config && [config[@"norlog"] isEqualToString:@"0"]) {
        NSLog(@"not allowed report cache log by config");
        double timezoneFix = [NSTimeZone localTimeZone].secondsFromGMT;
        NSDate *configCheckDate = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:IDMPReportLogConfigCheckTime];
        if ((int)([[NSDate date] timeIntervalSince1970] + timezoneFix) -
            (int)([configCheckDate timeIntervalSince1970] + timezoneFix)
            < IDMPReportLogConfigCheckTimeLimit) {
            NSLog(@"force check not exceed one hour");
            failBlock(@{@"resultCode":[NSString stringWithFormat:@"%d",IDMPLogReportNotAllowed]});
            return;
        }
        NSLog(@"force check exceed one hour & report log");
    }
    NSDictionary *bodyParam = @{@"header":self.header, @"body":@{@"log":log}};
    IDMPHttpRequest *request = [IDMPHttpRequest new];
    [request postSynWithBody:bodyParam url:logReportUrl timeOut:15 successBlock:^(NSDictionary *parameters) {
        //save config
        NSDictionary *config = parameters[@"config"];
        if (config) {
            [[NSUserDefaults standardUserDefaults] setObject:config forKey:IDMPReportLogConfig];
            [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:IDMPReportLogConfigCheckTime];
        }
        successBlock(parameters);
    } failBlock:failBlock];
}

//是否允许实时上报
- (BOOL)isAllowRealReportWithNet:(NSString *)net {
    NSString *currentNet = net;
    NSDate *lastDate = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:IDMPRealReportLogDate];
    NSDate *dateNow = [NSDate date];
    if (!lastDate || ![IDMPDate isSameDay:lastDate date2:dateNow]) {  //如果没有时间数据，或者两次时间间隔超过一天，重置本天的上报计数为0
        NSLog(@"date nil or is not same day, init totay, reset real report log count 0");
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:IDMPRealReportLogDate];
        [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:IDMPAlreadyRealReportLogCount];
        return YES;
    } else {
        //如果是wifi，可以无限上报
        if ([currentNet isEqualToString:@"wifi"]) {
            NSLog(@"net is wifi and can real report");
            return YES;
        }
        if ([currentNet isEqualToString:@"4g"]) {
            //如果一天内上报量不大于限制，允许上报
            NSNumber *reportLogCount = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:IDMPAlreadyRealReportLogCount];
            NSDictionary *config = (NSDictionary *)[[NSUserDefaults standardUserDefaults] objectForKey:IDMPReportLogConfig];
            
            if (config && [reportLogCount integerValue] <= [config[IDMPDayRealReportLogCount] integerValue]) {
                NSLog(@"wap real report(<limit)");
                return YES;
            }
        }
        
    }
    return NO;
}

// 保存更新本地日志
- (void)updateCacheLog:(NSString *)remainLog {
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:self.path];
    @try {
        NSData *remainData = [remainLog dataUsingEncoding:NSUTF8StringEncoding];
        [handle seekToFileOffset:0];
        [handle writeData:remainData];
        [handle truncateFileAtOffset:remainData.length];
    } @catch (NSException *exception) {
        fprintf(stderr,"Catch exception in IDMPLogReportMode.m's update: %s",[[exception description] UTF8String]);
    } @finally {
        [handle closeFile];
    }
}

// 添加日志到缓存日志末尾
- (void)appendLog:(NSString *)interfaceLog {
    NSLog(@"save log to the end of cache log");
    NSString *separateLog = [NSString stringWithFormat:@"%@%@",interfaceLog,IDMPSeparateStr];
    
    if (!logQueue) {
        logQueue= dispatch_queue_create(IDMPLogThread, NULL);
    }
    dispatch_sync(logQueue, ^{
        // create if needed
        if (![[NSFileManager defaultManager] fileExistsAtPath:self.path]) {
            fprintf(stderr,"Creating file at %s",[self.path UTF8String]);
            [[NSData data] writeToFile:self.path atomically:YES];
        }
        // append
        NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:self.path];
        @try{
            [handle seekToEndOfFile];
            [handle writeData:[separateLog dataUsingEncoding:NSUTF8StringEncoding]];
        }@catch (NSException* e) {
            fprintf(stderr,"Catch exception in IDMPLogReportMode.m's append: %s",[[e description] UTF8String]);
        }@finally {
            NSLog(@"close file");
            [handle closeFile];
        }
    });
}

#pragma mark - util methond
- (NSString*)dictionaryToJson:(NSDictionary *)dic {
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

#pragma mark - lazy load
- (NSDictionary *)header {
    if (!_header) {
        NSDateFormatter *dateFormat = [IDMPDateFormatter cachedDateFormatter];
        NSString *time = [dateFormat stringFromDate:[NSDate date]];
        NSString *msgid = [IDMPNonce getClientNonce];
        NSString *rawSignData = [NSString stringWithFormat:@"%@@%@",msgid,time];
        NSString *sign = [[[IDMPMD5 alloc] init] getMd5_32Bit_String:[secRSA_EVP_Sign(rawSignData) uppercaseString]];
        NSDictionary *head = [NSDictionary dictionaryWithObjectsAndKeys:time,@"systemtime",msgid,@"msgid",sign,@"sign", nil];
        _header = head;
    }
    return _header;
}

- (NSString *)path {
    if (!_path) {
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString* lLogDir = [documentsDirectory stringByAppendingPathComponent:IDMPLogDir];
        NSString *path = [lLogDir stringByAppendingPathComponent:IDMPLogFileName];
        NSFileManager *manager = [NSFileManager defaultManager];
        if(![manager fileExistsAtPath:lLogDir isDirectory:NULL]) {
            NSError* lError = nil;
            [manager createDirectoryAtPath:lLogDir withIntermediateDirectories:YES attributes:NULL error:&lError];
        }
        _path = path;
    }
    return _path;
}

@end

