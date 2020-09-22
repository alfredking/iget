//
//  ImageScrollView.m
//  Fenvo
//
//  Created by Caesar on 15/5/28.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "AppDelegate.h"
#import "ImageScrollView.h"
#import "ImageScaleDown.h"
#import "UIImageView+WebCache.h"
#import "AFHTTPRequestOperationManager.h"
#import "JSONKit.h"
#import "MJRefresh.h"

#define COORDINATE_X_LEFT 5
#define COORDINATE_X_MIDDLE MY_WIDTH/3 + 5
#define COORDINATE_X_RIGHT MY_WIDTH/3 * 2 + 5
#define PAGESIZE 12
#define WBAPIURL_ORIGINALWEIBO

@interface ImageScrollView(){
    float _leftColumHeight;
    float _midColumHeight;
    float _rightColumHeight;
    
    NSMutableDictionary *_imgTagDic;
    NSMutableDictionary *_loadedImageDic;
    NSMutableArray *_loadedImageArray;
    NSMutableArray *_loadedImageUrlsArray;
    
    NSInteger _imgTag;
    NSInteger _imgIndex;
    NSInteger _loadCount;
    BOOL _isOnce;
    
    ImageScaleDown *_imageScaleDown;
    
    //已获取微博数量
    long _weiboPage;
    
    //
    NSMutableArray *_weiboMsgArray;
    
    //刷新微博
    //下次返回比since_id晚的微博
    long long _since_id;
    //根据max_id返回比max_id早的微博
    long long _max_id;
    //next_cursor、previous_cursor指定返回的之后、之前的游标值。暂未支持
    long long _next_cursor;
    long long _previous_cursor;
    
}
@end


@implementation ImageScrollView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.delegate = self;
        self.backgroundColor = [UIColor whiteColor];
        self.pagingEnabled = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        [self addRefreshViewController];
        
        _isOnce = YES;
        _loadedImageArray = [[NSMutableArray alloc]init];
        _loadedImageUrlsArray = [[NSMutableArray alloc]init];
        _loadedImageDic = [[NSMutableDictionary alloc]init];
        _imgTagDic = [[NSMutableDictionary alloc]init];
        
        _weiboMsgArray = [[NSMutableArray alloc]init];
        
        _leftColumHeight = 3.0f;
        _midColumHeight = 3.0f;
        _rightColumHeight = 3.0f;
        
        _imgTag = 0;
        _imgIndex = 0;
        _weiboPage = 0;
        _loadCount = 1;
        
        _since_id = 0;
        _max_id = 0;
        
        [self initWithImageBox];
    }
    
    return self;
}

- (void)addRefreshViewController{
    [self addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(getMoreWeibo)];
    //
    self.footer.font = [UIFont systemFontOfSize:15];
    self.footer.textColor = TEXT_COLOR;
    //
    [self.footer setTitle:@"没骗你释放马上帮你刷" forState:MJRefreshFooterStateNoMoreData];
    [self.footer setTitle:@"客官您稍等，我马上拉给你 " forState:MJRefreshFooterStateRefreshing];
}

//将scrollView界面分为大小相等的3个部分，每个部分为一个UIView, 并设置每一个UIView的tag
- (void)initWithImageBox {
    UIView *leftView = [[UIView alloc] initWithFrame:
                        CGRectMake(0,
                                   0,
                                   IPHONE_SCREEN_WIDTH/3,
                                   self.frame.size.height)];
    UIView *middleView = [[UIView alloc] initWithFrame:
                        CGRectMake(leftView.frame.origin.x + IPHONE_SCREEN_WIDTH/3,
                                   0,
                                   IPHONE_SCREEN_WIDTH/3,
                                   self.frame.size.height)];
    UIView *rightView = [[UIView alloc] initWithFrame:
                         CGRectMake(middleView.frame.origin.x + IPHONE_SCREEN_WIDTH/3,
                                    0,
                                    IPHONE_SCREEN_WIDTH/3,
                                    self.frame.size.height)];
    
    leftView.tag = 100;
    middleView.tag = 101;
    rightView.tag = 102;
    
    [leftView setBackgroundColor:[UIColor clearColor]];
    [middleView setBackgroundColor:[UIColor clearColor]];
    [rightView setBackgroundColor:[UIColor clearColor]];
    
    [self addSubview:leftView];
    [self addSubview:middleView];
    [self addSubview:rightView];
    
    _imageScaleDown = [ImageScaleDown shareImageScaleDown];
    [self adjustContentSize:NO];
}

#pragma mark -set weiboData
- (void)setAccess_token{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    _access_token = delegate.wbtoken;
    [self downWeiboData];
    
}

//根据原创微博数据整理图片以及图片对应的微博ID
- (void)getImageUrlsArrays{
    _loadedImageUrlsArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < _weiboMsgArray.count; i++) {
        WeiboMsg *weiboMsg = _weiboMsgArray[i];
        if(weiboMsg.thumbnail_pic && ![weiboMsg.thumbnail_pic isEqualToString:@""]){
        NSArray *imageUrls = [self getPicUrls:weiboMsg.pic_urls];
        for (int j = 0; j < imageUrls.count; j++) {
            NSDictionary *dict = @{@"imageUrl":imageUrls[j],@"ID":[NSString stringWithFormat:@"%lld",weiboMsg.ids.longLongValue]};
            [_loadedImageUrlsArray addObject:dict];
        }
        }
    }
    [self getImagesArray];
}

- (void)getImagesArray {
    long count = _loadedImageUrlsArray.count;
    for(long i = _imgIndex; i < count; i++) {
        NSDictionary *imageInfo = _loadedImageUrlsArray[i];
        [[SDWebImageManager sharedManager]  downloadWithURL:[NSURL URLWithString:imageInfo[@"imageUrl"]] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize,NSInteger expectedSize) {
        } completed:^(UIImage *aImage, NSError *error, SDImageCacheType cacheType, BOOL finished) {
            UIImageView *imgView = [_imageScaleDown compressImage:IPHONE_SCREEN_WIDTH/3 andImage:aImage];
            [self addImage:imgView];
            [self checkImageIsVisible];
        }];
    }
    _imgIndex += count;
}

/*调整scrollview*/
- (void)adjustContentSize:(BOOL)isEnd{
    UIView *leftView = [self viewWithTag:100];
    UIView *middleView = [self viewWithTag:101];
    UIView *rightView = [self viewWithTag:102];
    
    if(_leftColumHeight >= _midColumHeight && _leftColumHeight >= _rightColumHeight){
        self.contentSize = leftView.frame.size;
    }else{
        if(_midColumHeight >= _rightColumHeight){
            self.contentSize = middleView.frame.size;
        }else{
            self.contentSize = rightView.frame.size;
        }
    }
}

/*
 得到最短列的高度
 */
- (float)getTheShortColum{
    if(_leftColumHeight <= _midColumHeight && _leftColumHeight <= _rightColumHeight){
        return _leftColumHeight;
    }else{
        if(_midColumHeight <= _rightColumHeight){
            return _midColumHeight;
        }else{
            return _rightColumHeight;
        }
    }
}

/*
 添加一张图片
 规则：根据每一列的高度来决定，优先加载列高度最短的那列
 重新设置图片的x,y坐标
 imageView:图片视图
 imageName:图片名
 */
- (void)addImage:(UIImageView *)imageView{
    
    [self imageTagWithAction:imageView];
    
    float width = imageView.frame.size.width;
    float height = imageView.frame.size.height;
    //判断哪一列的高度最低
    if(_leftColumHeight <= _midColumHeight && _leftColumHeight <= _rightColumHeight){
        UIView *leftView = [self viewWithTag:100];
        [leftView addSubview:imageView];
        //重新设置坐标
        [imageView setFrame:CGRectMake(2, _leftColumHeight, width, height)];
        _leftColumHeight = _leftColumHeight + height + 3;
        [leftView setFrame:CGRectMake(0, 0, IPHONE_SCREEN_WIDTH/3, _leftColumHeight)];
        
        self.contentSize = CGSizeMake(IPHONE_SCREEN_WIDTH, _leftColumHeight);
        
    }else{
        if(_midColumHeight <= _rightColumHeight){
            UIView *middleView = [self viewWithTag:101];
            [middleView addSubview:imageView];
            
            [imageView setFrame:CGRectMake(2, _midColumHeight, width, height)];
            _midColumHeight = _midColumHeight + height + 3;
            [middleView setFrame:CGRectMake(IPHONE_SCREEN_WIDTH/3, 0, IPHONE_SCREEN_WIDTH/3, _midColumHeight)];
            self.contentSize = CGSizeMake(IPHONE_SCREEN_WIDTH, _midColumHeight);
        }else{
            UIView *rightView = [self viewWithTag:102];
            [rightView addSubview:imageView];
            
            [imageView setFrame:CGRectMake(2, _rightColumHeight, width, height)];
            _rightColumHeight = _rightColumHeight + height + 3;
            [rightView setFrame:CGRectMake(2 * IPHONE_SCREEN_WIDTH/3, 0, IPHONE_SCREEN_WIDTH/3, _rightColumHeight)];
            self.contentSize = CGSizeMake(IPHONE_SCREEN_WIDTH, _rightColumHeight);
        }
    }

}

/*
 将图片tag保存，以及为UIImageView添加事件响应
 */
- (void)imageTagWithAction:(UIImageView *)imageView{
    //将要显示图片的tag保存
    imageView.tag = _imgTag;
    [_imgTagDic setObject:imageView.image forKey:[NSString stringWithFormat:@"%ld", imageView.tag]];
    _imgTag++;
    
    //图片添加事件响应
    /*
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClickWithTag:)];
    tapRecognizer.delegate = self;
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:tapRecognizer];
     */
}



/*
 //若三列中最短列距离底部高度超过30像素，则请求加载新的图片
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //可视检查
    [self checkImageIsVisible];
    if((self.contentOffset.y + self.frame.size.height) - [self getTheShortColum] > 30){
        [self pullRefreshImages];
    }
}
*/

- (void)pullRefreshImages{
    
    long imgNum = _loadedImageUrlsArray.count;
    
    if(_imgIndex == imgNum - 1){
        [self downWeiboData];
        //图片加载完毕
        [self adjustContentSize:YES];
        //
        
    }else{
        if((imgNum - _imgIndex) > PAGESIZE){
            for (int i = 0; i < PAGESIZE; i++) {
                UIImage *img = _loadedImageArray[_imgIndex + i];
                UIImageView *imgView = [_imageScaleDown compressImage:IPHONE_SCREEN_WIDTH/3 andImage:img];
                [self addImage:imgView];
                [self checkImageIsVisible];
            }
            _imgIndex += PAGESIZE;
        }else{
            for (NSInteger i = _imgIndex; i < imgNum; i++) {
                UIImage *img = _loadedImageArray[i];
                UIImageView *imgView = [_imageScaleDown compressImage:IPHONE_SCREEN_WIDTH/3 andImage:img];
                [self addImage:imgView];
                [self checkImageIsVisible];
            }
            _imgIndex = imgNum - 1;
        }
        
    }
    
    [self adjustContentSize:NO];
}


- (void)downWeiboData{
    //下载微博数据
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [[AFJSONResponseSerializer alloc]init];
        manager.responseSerializer.acceptableContentTypes =
        [manager.responseSerializer.acceptableContentTypes
         setByAddingObject:@"text/plain"];
        NSString *getPublicWeiboTmp = WBAPIURL_MYWEIBOS;
        NSDictionary *dict0 = [[NSDictionary alloc]init];
        NSNumber *since_id = [NSNumber numberWithLongLong:_since_id];
        dict0= @{@"access_token":_access_token, @"since_id":since_id};
        //
        [manager GET:getPublicWeiboTmp
          parameters:dict0
             success:^(AFHTTPRequestOperation *operation, id responserObject){
                 NSError *error;
                 NSData *jsonDatas = [responserObject
                                      JSONDataWithOptions:NSJSONWritingPrettyPrinted
                                      error:&error];
                 NSString *jsonString = [[NSString alloc] initWithData:jsonDatas encoding:NSUTF8StringEncoding];
                 
                 jsonString = [self getNormalJSONString:jsonString];
                 
                 
                 NSArray *weiboMsgDictionary = [jsonString objectFromJSONString];
                 if (weiboMsgDictionary.count > 0) {
                     
                     for (int i = 0; i < weiboMsgDictionary.count; i ++) {
                         NSDictionary *dict = weiboMsgDictionary[i];
                         WeiboMsg *weiboMsg = [WeiboMsg createByDictionary:dict Option:YES];
                         [_weiboMsgArray addObject:weiboMsg];
                         
                     }
                     [self getFlagMsg:_weiboMsgArray];
                 
                     [self getImageUrlsArrays];
                     }
             }failure:^(AFHTTPRequestOperation *operation, NSError *error){
                 
             }];
    });

}

- (void)getMoreWeibo{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [[AFJSONResponseSerializer alloc]init];
        //http请求头应该添加text/plain。接受类型内容无text/plain
        manager.responseSerializer.acceptableContentTypes =
        [manager.responseSerializer.acceptableContentTypes
         setByAddingObject:@"text/plain"];
        NSString *getPublicWeiboTmp = WBAPIURL_MYWEIBOS;
        NSDictionary *dict0 = [[NSDictionary alloc]init];
        NSNumber *max_id = [NSNumber numberWithLongLong:_max_id];
        dict0= @{@"access_token":_access_token, @"max_id":max_id};
        //
        [manager GET:getPublicWeiboTmp
          parameters:dict0
             success:^(AFHTTPRequestOperation *operation, id responserObject){
                 NSError *error;
                 NSData *jsonDatas = [responserObject
                                      JSONDataWithOptions:NSJSONWritingPrettyPrinted
                                      error:&error];
                 NSString *jsonString = [[NSString alloc] initWithData:jsonDatas encoding:NSUTF8StringEncoding];
                 
                 jsonString = [self getNormalJSONString:jsonString];
                 
                 
                 NSArray *weiboMsgDictionary = [jsonString objectFromJSONString];
                 if (weiboMsgDictionary.count > 0) {
                     
                     for (int i = 1; i < weiboMsgDictionary.count; i ++) {
                         NSDictionary *dict = weiboMsgDictionary[i];
                         WeiboMsg *weiboMsg = [WeiboMsg createByDictionary:dict Option:YES];
                         [_weiboMsgArray addObject:weiboMsg];
                         
                     }
                     //提取since_id、max_id的值
                     [self getFlagMsg:_weiboMsgArray];
                 }
                 dispatch_async(dispatch_get_main_queue(), ^{
                     NSLog(@"%lld",_max_id);
                     [self getImageUrlsArrays];
                     [self.footer endRefreshing];
                 });
                 
                 
             }failure:^(AFHTTPRequestOperation *operation, NSError *error){
                 [self.footer endRefreshing];
             }];
    });
}



/*
 检查图片是否可见，如果不在可见视线内，则把图片替换为nil
 */
- (void)checkImageIsVisible{
    for (int i = 0; i < [_loadedImageArray count]; i++) {
        UIImageView *imgView = [_loadedImageArray objectAtIndex:i];
        
        if((self.contentOffset.y - imgView.frame.origin.y) > imgView.frame.size.height ||
           imgView.frame.origin.y > (self.frame.size.height + self.contentOffset.y)){
            //不显示图片
            imgView.image = nil;
        }else{
            //重新根据tag值显示图片
            NSString *imageName = [_imgTagDic objectForKey:[NSString stringWithFormat:@"%ld", imgView.tag]];
            if((NSNull *)imageName == [NSNull null]){
                return;
            }
            UIImageView *view = [_imageScaleDown compressImage:IPHONE_SCREEN_WIDTH/3 andImage:imgView.image];
            imgView.image = view.image;
        }
    }
}
/*
//点击图片事件响应
- (void)imageClickWithTag:(UITapGestureRecognizer *)sender{
    UIImageView *view = (UIImageView *)sender.view;
    NSString *imageName = [self.imgTagDic objectForKey:[NSString stringWithFormat:@"%d", view.tag]];
    
    PhotoViewController *photoView = [[PhotoViewController alloc] init];
    photoView.imageName = imageName;
    [self addSubview:photoView.view];
}
*/

#pragma mark - 微博API返回的数据不是标准的json格式数据。我们需要返回的String类型JSON数据进行一定的处理

- (NSString *)getNormalJSONString:(NSString *)jsonStrings{
    NSString *str1;
    NSRange rangeLeft = [jsonStrings rangeOfString:@"\"statuses\":"];
    str1 = [jsonStrings substringFromIndex:rangeLeft.location+rangeLeft.length];
    NSLog(@"%@",str1);
    //
    NSRange rangeRight = [str1 rangeOfString:@"\"total_n"];
    if (rangeRight.length > 0) {
        jsonStrings = [str1 substringToIndex:rangeRight.location - 4];
        NSLog(@"%@",jsonStrings);
    }
    
    return jsonStrings;
}
- (void)getFlagMsg:(NSArray *)weiboArray {
    WeiboMsg *weibo = weiboArray[0];
    _since_id = weibo.ids.longLongValue;
    weibo = weiboArray.lastObject;
    _max_id = weibo.ids.longLongValue;
    NSLog(@"%lld  %lld",_since_id, _max_id);
}


//获得图片URL数组
- (NSArray *)getPicUrls:(NSString *)url {
    return [url componentsSeparatedByString:@","];
}
@end
