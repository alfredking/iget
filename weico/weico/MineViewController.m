//
//  mineViewController.m
//  weico
//
//  Created by alfredking－cmcc on 2020/6/15.
//  Copyright © 2020 alfredking－cmcc. All rights reserved.
//

#import "MineViewController.h"
#import  "AppDelegate.h"
@interface MineViewController ()<WBMediaTransferProtocol>

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) WBMessageObject *messageObject;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor greenColor];
    [self requestWBSSOAuthorize];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)requestWBSSOAuthorize
{
    
    //微博认证请求
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI         = kRedirectURI;
    request.scope               = @"all";
    request.userInfo            = @{@"SSO_From": @"AppDelegate",
                                    @"Info": @"Token is not exsit. Request Authorize."};
    
    //发送微博认证请求
    [WeiboSDK sendRequest:request];
}

#pragma mark WBHttpRequestDelegate
- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self alertControllerWithTitle:NSLocalizedString(@"收到网络回调", nil) message:[NSString stringWithFormat:@"%@",result] cancelBtnTitle:NSLocalizedString(@"确定", nil) sureBtnTitle:nil];
    });
}


-(void)messageShare
{
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = kRedirectURI;
    authRequest.scope = @"all";
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:_messageObject authInfo:authRequest access_token:myDelegate.wbtoken];
    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
    [_indicatorView stopAnimating];
}

- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error;
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self alertControllerWithTitle:NSLocalizedString(@"请求异常", nil) message:[NSString stringWithFormat:@"%@",error] cancelBtnTitle:NSLocalizedString(@"确定", nil) sureBtnTitle:nil];
    });
}

#pragma WBMediaTransferProtocol
-(void)wbsdk_TransferDidReceiveObject:(id)object
{
    if (![NSThread isMainThread])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_indicatorView stopAnimating];
            [self messageShare];
        });
    }else{
        [_indicatorView stopAnimating];
        [self messageShare];
    }
    
}

-(void)wbsdk_TransferDidFailWithErrorCode:(WBSDKMediaTransferErrorCode)errorCode andError:(NSError*)error
{
    if (![NSThread isMainThread])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_indicatorView stopAnimating];
            [self errorAlertDisplayWithErrorCode:errorCode];
        });
    }else{
        [_indicatorView stopAnimating];
        [self errorAlertDisplayWithErrorCode:errorCode];
    }
}


-(void)errorAlertDisplayWithErrorCode:(WBSDKMediaTransferErrorCode)errorCode
{
    NSString *strTitle = nil;
    if (errorCode==WBSDKMediaTransferAlbumPermissionError) {
        strTitle =@"请打开相册权限";
    }
    if (errorCode==WBSDKMediaTransferAlbumAssetTypeError) {
        strTitle =@"资源类型错误";
    }
    if (errorCode==WBSDKMediaTransferAlbumWriteError) {
        strTitle =@"相册写入错误";
    }
    [self alertControllerWithTitle:@"错误提示" message:strTitle cancelBtnTitle:@"确定" sureBtnTitle:nil];
    
}

-(void)alertControllerWithTitle:(NSString *)title message:(NSString*)message cancelBtnTitle:(NSString*)cancelBtnTitle sureBtnTitle:(NSString*)sureBtnTitle
{
    if (!cancelBtnTitle && !sureBtnTitle) {
        return;
    }
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if (cancelBtnTitle.length > 0)
    {
        [controller addAction:[UIAlertAction actionWithTitle:cancelBtnTitle style:UIAlertActionStyleCancel handler:nil]];
    }
    if (sureBtnTitle.length > 0)
    {
        [controller addAction:[UIAlertAction actionWithTitle:sureBtnTitle style:UIAlertActionStyleDefault handler:nil]];
    }
    
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark Getter&&Setter
-(UIActivityIndicatorView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _indicatorView.center = self.view.center;
        [self.view addSubview:_indicatorView];
        _indicatorView.color = [UIColor blueColor];
    }
    return _indicatorView;
}

@end
