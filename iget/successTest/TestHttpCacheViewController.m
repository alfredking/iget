//
//  TestHttpCacheViewController.m
//  iget
//
//  Created by alfredking－cmcc on 2022/8/13.
//  Copyright © 2022 alfredking. All rights reserved.
//

#import "TestHttpCacheViewController.h"

@interface TestHttpCacheViewController ()

@property (nonatomic,strong) UIImageView *myImage;

@property (nonatomic,strong) NSString *modDate;
@property (nonatomic,strong) NSString *eTag;

@end

@implementation TestHttpCacheViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self startRequest];
    [self.view addSubview:self.myImage];
    UIImageView *testImgView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 200, 100)];
        
        [testImgView setBackgroundColor:[UIColor yellowColor]];
        
        // 阴影颜色
        testImgView.layer.shadowColor = [UIColor blackColor].CGColor;
        // 阴影偏移，默认(0, -3)
        testImgView.layer.shadowOffset = CGSizeMake(0,0);
        // 阴影透明度，默认0
        testImgView.layer.shadowOpacity = 0.5;
        // 阴影半径，默认3
        testImgView.layer.shadowRadius = 5;
        
        [self.view addSubview:testImgView];
}


- (void)startRequest
{
    NSURL *url = [NSURL URLWithString:@"https://wx2.sinaimg.cn/mw690/744bc337ly1gnfwt733zog206o06o4au.gif"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData  timeoutInterval:5.0];
    [request setValue:@"Mon, 08 Jul 2013 18:06:40 GMT" forHTTPHeaderField:@"If-Modified-Since"];
//    [request setValue:@"1-1f48239edefd215dccb00d7e464bac12" forHTTPHeaderField:@"If-None-Match"];
    
    NSURLCache *cache = [NSURLCache sharedURLCache];
    NSCachedURLResponse *cacheResponse = [cache cachedResponseForRequest:request];
    NSLog(@"cacheResponse is %@",cacheResponse.response );
    UIImage *cacheImage = [[UIImage alloc] initWithData:cacheResponse.data];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.myImage.image = cacheImage;
    });
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        UIImage *image = [[UIImage alloc] initWithData:data];
        NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
        NSDictionary *heads = res.allHeaderFields;
        if ([heads objectForKey:@"Last-Modified"]) {
            self.modDate = [heads objectForKey:@"Last-Modified"];
        }
        NSLog(@"response is %@",response);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.myImage.image = image;
        });
    }];
    [dataTask resume];
}


-(UIImageView *)myImage
{
    if (!_myImage) {
        _myImage = [[UIImageView alloc]initWithFrame:CGRectMake(50, 100, 200, 200)];
        
    }
    return _myImage;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
