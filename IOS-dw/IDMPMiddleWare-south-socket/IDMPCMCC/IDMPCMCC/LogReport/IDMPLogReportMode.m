//
//  IDMPLogReportMode.m
//  IDMPCMCC
//
//  Created by wj on 2017/6/29.
//  Copyright © 2017年 zwk. All rights reserved.
//

#import "IDMPLogReportMode.h"
#import "IDMPHttpRequest.h"
#import "IDMPInterfaceLog.h"
#import "IDMPDevice.h"
#import "IDMPDate.h"
#import "NSString+IDMPAdd.h"
#import "userInfoStorage.h"


typedef NS_ENUM(NSInteger, IDMPCacheReportType) {
    IDMPNOTALLOWED = 0,
    IDMPALLOWED  = 1,
    IDMPABANDONED = 2,
};

static NSString *IDMPSeparateStr = @"-IDMP-";
static NSString *IDMPLogDir = @"log/UAlog";
static NSString *IDMPLogFileName = @"IDMPInterfaceLogFile.txt";
static const char* IDMPLogThread = "com.cmcc.IDMPLogThread";

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

@property(nonatomic, strong)NSDictionary *header;
@property(nonatomic, strong)IDMPInterfaceLog *interfaceLog;
@property(nonatomic, strong)NSString *path;                     //文件路径

@property(nonatomic, strong)NSArray *logArray;
@property(nonatomic, assign)NSUInteger currentPosition;

@property(nonatomic, strong)NSDictionary *config;
@property(nonatomic, strong)NSDate *lastReportCheckDate;
@property(nonatomic, strong)NSNumber *hasRealReportCount;
@property(nonatomic, strong)NSDate *lastRealReportDate;

@end

@implementation IDMPLogReportMode

#pragma mark - life cycle
- (instancetype)initLogWithrequestType:(NSString *)requestType requestParm:(NSDictionary *)requestParam authType:(int)authType traceId:(NSString *)traceId {
    return [self initLogWithrequestType:requestType requestParm:requestParam appid:appidString appkey:appkeyString authType:authType traceId:traceId];
    
}

- (instancetype)initLogWithrequestType:(NSString *)requestType requestParm:(NSDictionary *)requestParam  appid:(NSString *)appid appkey:(NSString *)appkey authType:(int)authType traceId:(NSString *)traceId {
    static dispatch_once_t onceLog;
    if (self = [super init]) {
        NSDateFormatter *dateFormat = [IDMPDate cachedDateFormatter];
        NSString *requestTime = [dateFormat stringFromDate:[NSDate date]];
        IDMPInterfaceLog *interfaceLog = [[IDMPInterfaceLog alloc] initWithRequestType:requestType requestTime:requestTime requestParam:requestParam appid:appid appkey:appkey networkType:[NSString stringWithFormat:@"%d",authType] traceId:traceId];
        self.interfaceLog = interfaceLog;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name: UIApplicationDidEnterBackgroundNotification object:nil];
        dispatch_once(&onceLog, ^{
            logQueue = dispatch_queue_create(IDMPLogThread, NULL);
            
        });
    }
    return self;
}

- (void)dealloc {
    [[NSUserDefaults standardUserDefaults] setObject:self.config forKey:IDMPReportLogConfig];
    [[NSUserDefaults standardUserDefaults] setObject:self.lastReportCheckDate forKey:IDMPReportLogConfigCheckTime];
    [[NSUserDefaults standardUserDefaults] setObject:self.hasRealReportCount forKey:IDMPAlreadyRealReportLogCount];
    [[NSUserDefaults standardUserDefaults] setObject:self.lastRealReportDate forKey:IDMPRealReportLogDate];
    [[NSUserDefaults standardUserDefaults] synchronize];

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
    NSLog(@"start report log");
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{

    dispatch_async(logQueue, ^{
        //配置获取
        self.config = (NSDictionary *)[[NSUserDefaults standardUserDefaults] objectForKey:IDMPReportLogConfig];
        self.lastReportCheckDate = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:IDMPReportLogConfigCheckTime];
        self.hasRealReportCount = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:IDMPAlreadyRealReportLogCount];
        self.lastRealReportDate = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:IDMPRealReportLogDate];
        
        //生成最终日志
        NSDateFormatter *dateFormat = [IDMPDate cachedDateFormatter];
        NSString *responseTime = [dateFormat stringFromDate:[NSDate date]];
        [self.interfaceLog setResponseTime:responseTime responseParam:responseParam];
        NSDictionary *interfaceLogDic = [self.interfaceLog dictionary];
        
        //上报日志
        NetworkStatus networkStatus = [IDMPDevice GetCurrntNet];
        if (networkStatus == NotReachable || ![self isAllowRealReportWithNet:networkStatus]) {
            NSLog(@"not allowed real report");
            [self appendLog:[self dictionaryToJson:interfaceLogDic]];
        } else {
            NSLog(@"start real log report");
            [self requestReportLog:@[[self dictionaryToJson:interfaceLogDic]] successBlock:^(NSDictionary *paraments) {
                //存储上报的次数
                self.hasRealReportCount = @([self.hasRealReportCount integerValue] + 1);
                NSLog(@"report real log success and number is %@",self.hasRealReportCount);
            } failBlock:^(NSDictionary *paraments) {
                NSLog(@"report real log fail");
                //保存日志到本地
                [self appendLog:[self dictionaryToJson:interfaceLogDic]];
            }];

        }

        //根据网络上报缓存日志
        [self reportCacheLogWithNet:networkStatus];

    });
}
#pragma mark - private method
//上报缓存日志
- (void)reportCacheLogWithNet:(NetworkStatus)networkStatus {
    NSLog(@"start report cache log");
    if (networkStatus == NotReachable) {
        NSLog(@"no net and end");
        return;
    }

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
    
//    NSDictionary *config = (NSDictionary *)[[NSUserDefaults standardUserDefaults] objectForKey:IDMPReportLogConfig];
    NSInteger reportlogWapSize = [self.config[IDMPReportLogWapSize] integerValue] * 1024 * 1024;
    __block NSInteger outLogSize = allLog.length - reportlogWapSize;
    NSLog(@"all cache log size is %lu bit, log count is %lu and need report count is %lu",(unsigned long)allLog.length, (unsigned long)logCount, (unsigned long)allNeedReportCount);

    for (int i = 0; i < allNeedReportCount; i++) {
        // 根据位置取出相应的部分日志信息
        self.currentPosition = i * IDMPEachReportCacheLogLengh;
        NSUInteger length = (i == allNeedReportCount - 1) ? lastReportLogLength : IDMPEachReportCacheLogLengh;
        NSLog(@"start prepare the reporting log, position of cache log is %lu and the length is %lu",(unsigned long)self.currentPosition,(unsigned long)length);
        NSArray *subArr = [self.logArray subarrayWithRange:NSMakeRange(self.currentPosition, length)];
        
//        NSString *subLog = [subArr componentsJoinedByString:@"\r\n"];
        NSLog(@"start query whether allow report cache log");
        IDMPCacheReportType reportType = [self isAllowReportCacheLogWithSubLog:subArr withOutLogSize:outLogSize withNet:networkStatus];
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
        [self requestReportLog:subArr successBlock:^(NSDictionary *paraments) {
            reportSuccess = YES;
            NSLog(@"report cache log success (第%d次), net is %ld",i+1, (long)networkStatus);
        } failBlock:^(NSDictionary *paraments) {
            NSLog(@"report cache log fail(第%d次), net is %ld",i+1, (long)networkStatus);
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
}

//是否允许实时上报
- (BOOL)isAllowRealReportWithNet:(NetworkStatus)networkStatus {
    NSDate *dateNow = [NSDate date];
    if (!self.lastRealReportDate || ![IDMPDate isSameDay:self.lastRealReportDate date2:dateNow]) {  //如果没有时间数据，或者两次时间间隔超过一天，重置本天的上报计数为0
        NSLog(@"date nil or is not same day, init totay, reset real report log count 0");
        self.lastRealReportDate = [NSDate date];
        self.hasRealReportCount = @(0);
        return YES;
    } else {
        //如果是wifi，可以无限上报
        if (networkStatus == ReachableViaWiFi) {
            NSLog(@"net is wifi and can real report");
            return YES;
        }
        if (networkStatus == ReachableViaWWAN) {
            //如果一天内上报量不大于限制，允许上报
            if (self.config && [self.hasRealReportCount integerValue] <= [self.config[IDMPDayRealReportLogCount] integerValue]) {
                NSLog(@"wap real report(<limit)");
                return YES;
            }
        }
        
    }
    return NO;
}

//是否允许上报缓存日志
- (IDMPCacheReportType)isAllowReportCacheLogWithSubLog:(NSArray *)subLogArr withOutLogSize:(NSInteger)outLogSize withNet:(NetworkStatus)networkStatus{
    if (networkStatus == ReachableViaWiFi) {
        NSLog(@"net is wifi and allow report cache log");
        return IDMPALLOWED;
    }
    //4g环境下
    if (self.config) {
        NSString *isTimeAllowed = (NSString *)self.config[IDMPReportLogTimeLimitStatus];
        if ([isTimeAllowed isEqualToString:@"1"]) {
            NSLog(@"config allow report cache log when exceed time");
            int limitTime = [self.config[IDMPReportLogWapTime] intValue] * 24 * 3600;
            int timezoneFix = (int)[NSTimeZone localTimeZone].secondsFromGMT;
            int timeNow = ([[NSDate date] timeIntervalSince1970] + timezoneFix);
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[subLogArr[0] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
            if (dic) {
                NSDateFormatter *dateFormat = [IDMPDate cachedDateFormatter];
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
        
        NSString *isSizeAllowed = (NSString *)self.config[IDMPReportLogSizeLimitStatus];  //0不做处理 //1允许上传 //2清除
        if ([isSizeAllowed isEqualToString:@"1"]) {
            NSLog(@"config allow report cache log when exceed size, outlogsize is %ld", (long)outLogSize);
            if (outLogSize > 0) {
                NSLog(@"out log size is > 0 and allow report cache log");
                //在移动网络下，大小超限允许上传。
                return IDMPALLOWED;
            }
        } else if ([isSizeAllowed isEqualToString:@"2"]) {
            NSLog(@"config allow allow cache log when exceed size");
            if (outLogSize > 0) {
                NSLog(@"out log size is %ld, and abandon cache log",(long)outLogSize);
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
    NSLog(@"save remain log to cache, remain log size is %lu", (unsigned long)remainLogStr.length);
    [self updateCacheLog:remainLogStr];
}

//网络请求上报日志
- (void)requestReportLog:(NSArray *)log successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    if (self.config && [self.config[@"norlog"] isEqualToString:@"0"]) {
        NSLog(@"not allowed report cache log by config");
        double timezoneFix = [NSTimeZone localTimeZone].secondsFromGMT;
        if ((int)([[NSDate date] timeIntervalSince1970] + timezoneFix) -
            (int)([self.lastReportCheckDate timeIntervalSince1970] + timezoneFix)
            < IDMPReportLogConfigCheckTimeLimit) {
            NSLog(@"force check not exceed one hour");
            failBlock(@{IDMPResCode:[NSString stringWithFormat:@"%d",IDMPLogReportNotAllowed]});
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
            self.config = config;
            self.lastReportCheckDate = [NSDate date];
        }
        successBlock(parameters);
    } failBlock:^(NSDictionary *parameters) {
        if (failBlock) {
            failBlock(parameters);
        }
    }];
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
    NSLog(@"save log to the end of cache log:%@",interfaceLog);
    NSString *separateLog = [NSString stringWithFormat:@"%@%@",interfaceLog,IDMPSeparateStr];
    
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
        NSDateFormatter *dateFormat = [IDMPDate cachedDateFormatter];
        NSString *time = [dateFormat stringFromDate:[NSDate date]];
        NSString *msgid = [NSString idmp_getClientNonce];
        NSString *rawSignData = [NSString stringWithFormat:@"%@@%@",msgid,time];
        NSString *sign = [[[rawSignData idmp_RSASign] uppercaseString] idmp_getMd5String];
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

