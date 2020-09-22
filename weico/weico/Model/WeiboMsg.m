//
//  WeiboMsg.m
//  Fenvo
//
//  Created by Caesar on 15/7/19.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "WeiboMsg.h"
#import "WeiboGeoInfo.h"
#import "WeiboUserInfo.h"
#import "WeiboVisibleInfo.h"
#import "WeiboStoreManager.h"
#import "StringFormatTool.h"
#import "WeiboMsgManager.h"

@implementation WeiboMsg

@dynamic attitudes_count;
@dynamic bmiddle_pic;
@dynamic comments_count;
@dynamic created_at;
@dynamic favorited;
@dynamic height;
@dynamic ids;
@dynamic idstr;
@dynamic mid;
@dynamic reposts_count;
@dynamic source;
@dynamic thumbnail_pic;
@dynamic truncated;
@dynamic wbDetail;
@dynamic pic_urls;
@dynamic video_url;
@dynamic pic_ids;
@dynamic original_pic_urls;
@dynamic bmiddle_pic_urls;
@dynamic original_pic;
@dynamic geo;
@dynamic retweeted_status;
@dynamic user;
@dynamic visible;

+ (WeiboMsg *)createByDictionary:(NSDictionary *)dic Option:(BOOL)isSave{
    
    if ([WeiboStoreManager isWeiboStoreExist:[NSNumber numberWithLongLong:[dic[@"id"] longLongValue]]]) {
        WeiboStore *weiboStore = [WeiboStoreManager updateWeiboStore:dic];
        return weiboStore.weiboMsg;
    }
    
    UIApplication *application = [UIApplication sharedApplication];
    id delegate = application.delegate;
    NSManagedObjectContext *managedObjectContext = [delegate managedObjectContext];
    WeiboMsg *weiboMsg = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([WeiboMsg class]) inManagedObjectContext:managedObjectContext];
    
    if ([dic allKeys].count > 0) {
        weiboMsg.ids = [NSNumber numberWithLongLong:[dic[@"id"] longLongValue]];
        weiboMsg.mid = [NSNumber numberWithLongLong:[dic[@"mid"]longLongValue]];
        weiboMsg.idstr = dic[@"idstr"];
        NSString *text = dic[@"text"];
        weiboMsg.wbDetail = text;
        
        //从text中获取视频url，如果有的话
        
        NSString *regexStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:nil];
        
        NSArray * matches = [regex matchesInString:dic[@"text"] options:0 range:NSMakeRange(0, [dic[@"text"] length])];
        
        NSMutableArray *array = [NSMutableArray array];
        
        for (NSTextCheckingResult *match in matches) {
            
            //以正则中的(),划分成不同的匹配部分
            NSString *component = [text substringWithRange:[match rangeAtIndex:1]];
            
            [array addObject:component];
        }
        
        NSLog(@"maches 0 is %@",array);
        
        if(array.count>0)
        {
            weiboMsg.video_url = array[0];
        }
        
        weiboMsg.source = dic[@"source"];
        weiboMsg.favorited = [NSNumber numberWithBool:[dic[@"favorited"]boolValue]];
        weiboMsg.truncated = [NSNumber numberWithBool:[dic[@"truncated"]boolValue]];
        weiboMsg.thumbnail_pic = dic[@"thumbnail_pic"];
        weiboMsg.bmiddle_pic = dic[@"bmiddle_pic"];
        weiboMsg.original_pic = dic[@"original_pic"];
        //
        //NSDictionary *geos = dic[@"geo"];
        //if (geos) {
        //   self.geo = [[WeiboGeoInfo alloc]initWithDictionary:geos];
        // }
        //
        NSDictionary *user = dic[@"user"];
        weiboMsg.user = [WeiboUserInfo createdByDictionary:user];
        //
        NSDictionary *retweeted_weibo = dic[@"retweeted_status"];
        if (retweeted_weibo) {
            weiboMsg.retweeted_status = [WeiboMsg createByDictionary:retweeted_weibo Option:YES];
        }
        // attitudes_count	int	表态数
        weiboMsg.attitudes_count = [NSNumber numberWithInteger:[dic[@"attitudes_count"]integerValue]];
        weiboMsg.reposts_count = [NSNumber numberWithInteger:[dic[@"reposts_count"]integerValue]];
        weiboMsg.comments_count = [NSNumber numberWithInteger:[dic[@"comments_count"]integerValue]];
        //
        NSDictionary *visible = dic[@"visible"];
        weiboMsg.visible = [WeiboVisibleInfo createdByDictionary:visible];
        //
        weiboMsg.pic_ids = dic[@"pic_ids"];
        
        NSArray *pic_url= dic[@"pic_urls"];
        
        weiboMsg.pic_urls = [WeiboMsg getThumbnailUrl:pic_url];
        weiboMsg.original_pic_urls = [WeiboMsg getOriginalPicUrl:weiboMsg.pic_urls];
        weiboMsg.bmiddle_pic_urls = [WeiboMsg getBmiddlePicUrl:weiboMsg.pic_urls];
        
        NSString *timeStr = dic[@"created_at"];
        weiboMsg.created_at = [StringFormatTool getTimeString:timeStr];
        NSString *wbSource = dic[@"source"];
        wbSource = [StringFormatTool getSourceString:wbSource];
        if (wbSource != nil && ![wbSource isEqualToString:@""]) {
            weiboMsg.source = [NSString stringWithFormat:@"来自 %@", wbSource];
        }else{
            weiboMsg.source = @"";
        }
    }
    
    NSError *error;
    if (isSave)[managedObjectContext save:&error];
    
    return weiboMsg;
}

+ (WeiboMsg *)createdInCoreData {
    UIApplication *application = [UIApplication sharedApplication];
    id delegate = application.delegate;
    NSManagedObjectContext *managedObjectContext = [delegate managedObjectContext];
    WeiboMsg *weiboMsg = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([WeiboMsg class]) inManagedObjectContext:managedObjectContext];
    
    return weiboMsg;
}


//------------------数据转换部分--------------------



+ (NSString *) getThumbnailUrl:(NSArray *)pic_urls {
    
    NSString *thumbailUrl = @"";
    
    for (int i = 0; i < pic_urls.count; i++) {
        NSDictionary *dict = pic_urls[i];
        NSString *pic_url = dict[@"thumbnail_pic"];
        
        if (i == pic_urls.count - 1)
            thumbailUrl = [thumbailUrl stringByAppendingString:pic_url];
        else
            thumbailUrl = [NSString stringWithFormat:@"%@,",[thumbailUrl stringByAppendingString:pic_url]];
        
    }
    
    return [thumbailUrl copy];
}

+ (NSString *) getOriginalPicUrl:(NSString *)thumbnail_pic_urls{
    
    NSString *url = thumbnail_pic_urls;
    url = [url stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"large"];
    
    return [url copy];
}

+ (NSString *) getBmiddlePicUrl:(NSString *)thumbnail_pic_urls{
    
    NSString *url = thumbnail_pic_urls;
    url = [url stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
    
    return [url copy];
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.attitudes_count = [aDecoder decodeObjectForKey:SimpleDataKey_AttitudesCount];
        self.bmiddle_pic = [aDecoder decodeObjectForKey:SimpleDataKey_BmiddlePic];
        self.comments_count = [aDecoder decodeObjectForKey:SimpleDataKey_CommentCount];
        self.created_at = [aDecoder decodeObjectForKey:SimpleDataKey_CreatedAt];
        self.ids = [aDecoder decodeObjectForKey:SimpleDataKey_ID];
        self.idstr = [aDecoder decodeObjectForKey:SimpleDataKey_IDStr];
        self.mid = [aDecoder decodeObjectForKey:SimpleDataKey_Mid];
        self.reposts_count = [aDecoder decodeObjectForKey:SimpleDataKey_RepostsCount];
        self.source = [aDecoder decodeObjectForKey:SimpleDataKey_Source];
        self.truncated = [aDecoder decodeObjectForKey:SimpleDataKey_Truncated];
        self.wbDetail = [aDecoder decodeObjectForKey:SimpleDataKey_Status];
        self.original_pic = [aDecoder decodeObjectForKey:SimpleDataKey_OriginalPic];
        self.original_pic_urls = [aDecoder decodeObjectForKey:SimpleDataKey_OriginalPicUrls];
        self.bmiddle_pic = [aDecoder decodeObjectForKey:SimpleDataKey_BmiddlePic];
        self.bmiddle_pic_urls = [aDecoder decodeObjectForKey:SimpleDataKey_BmiddlePicUrls];
        self.thumbnail_pic = [aDecoder decodeObjectForKey:SimpleDataKey_ThumbnailPic];
        self.pic_urls = [aDecoder decodeObjectForKey:SimpleDataKey_PicUrls];
        self.video_url = [aDecoder decodeObjectForKey:SimpleDataKey_VideoUrl];
        self.geo = [aDecoder decodeObjectForKey:CustomDataKey_Geo];
        NSNumber *retweeted_status_ID = [aDecoder decodeObjectForKey:CustomDataKey_RetweetedStatus];
        self.retweeted_status = [WeiboMsgManager queryObject:retweeted_status_ID];
        NSNumber *userID = [aDecoder decodeObjectForKey:CustomDataKey_User];
        self.visible = [aDecoder decodeObjectForKey:CustomDataKey_Visible];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
}
@end
