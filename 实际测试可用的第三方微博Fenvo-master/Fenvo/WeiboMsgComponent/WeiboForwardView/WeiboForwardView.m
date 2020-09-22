//
//  WeiboCommentView.m
//  Fenvo
//
//  Created by Caesar on 15/6/2.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "WeiboForwardView.h"
#import "WeiboLabel.h"
#import "AFHTTPRequestOperationManager.h"
#import "AppDelegate.h"
#import "JSONKit.h"
#import "KVNProgress.h"
#import "CheckBox.h"
#import "UIImage+FontAwesome.h"

#define WEIBO_REPOSTURL @"https://api.weibo.com/2/statuses/repost.json"

@interface WeiboForwardView() <UITextViewDelegate>{
    UIWindow *_window;
    UIView *_containView;
    UIView *_mainView;
    UITextView *_forward;
    UIButton *_emoijBtn;
    UIButton *_atBtn;
    UIButton *_sentBtn;
    CheckBox *_ifComment;
    UILabel *_ifCommentText;
    UILabel *_remainText;
    
    
    int _remainTextNum;
    int _keyboardHeight;
    
    long long _weiboID;
    //
    NSNotification *_keyboardNotice;
}
@end

@implementation WeiboForwardView
+ (WeiboForwardView *)sharedWeiboForwardView {
    static WeiboForwardView *weiboForwardView;
    @synchronized(self){
        if (!weiboForwardView) {
            weiboForwardView = [[self alloc]init];
        }
    }
    return weiboForwardView;
}

- (void)showForwardView:(long long)weiboID withComment:(NSString *)wbDetail andUserName:(NSString *)userName{
    [self initComponent: weiboID withComment:wbDetail andUserName: userName];
    
    //增加监听，当键盘出现或改变时收出消息
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    UITapGestureRecognizer *tap_closeView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeForwardView:)];
    [_mainView addGestureRecognizer:tap_closeView];
    [_forward becomeFirstResponder];
}

- (void)initComponent:(long long)weiboID withComment:(NSString *)wbDetail andUserName:(NSString *)username{
    
    _weiboID = weiboID;
    _remainTextNum = 140;
    _window = [UIApplication sharedApplication].keyWindow;
    
    _mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, IPHONE_SCREEN_HEIGHT)];
    _mainView.backgroundColor = RGBACOLOR(0, 0, 0, 0.2);
    [_window addSubview:_mainView];
    
    _containView = [[UIView alloc]init];
    _containView.backgroundColor = RGBACOLOR(230, 230, 230, 1);
    [_mainView addSubview:_containView];
    
    _forward = [[UITextView alloc]initWithFrame:CGRectMake(5, 5, IPHONE_SCREEN_WIDTH - 10, 80)];
    _forward.backgroundColor = [UIColor whiteColor];
    _forward.textAlignment = NSTextAlignmentLeft;
    if (![wbDetail  isEqual: @""]) {
        _forward.text = [NSString stringWithFormat:@"//@%@:%@",username,wbDetail];
    }
    [_forward setDelegate:self];
    
    
    _remainText = [[UILabel alloc]initWithFrame:CGRectMake(IPHONE_SCREEN_WIDTH - 140,CGRectGetMaxY(_forward.frame) + 3, 140, 15)];
    _remainText.textColor = [UIColor lightGrayColor];
    _remainText.text = [NSString stringWithFormat:@"可输入字数剩余: %d",_remainTextNum];
    _remainText.font = [UIFont systemFontOfSize:12.0];
    
    [_containView addSubview:_remainText];
    [_containView addSubview: _forward];
    
    _ifComment = [[CheckBox alloc]initWithFrame:CGRectMake(5,
                                                           CGRectGetMaxY(_remainText.frame) + 10, 25, 25)];
    _ifCommentText = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_ifComment.frame)+5, CGRectGetMaxY(_remainText.frame) + 10, 120, 25)];
    _ifCommentText.textColor = [UIColor lightGrayColor];
    _ifCommentText.text = @"顺便评论?";
    _ifCommentText.font = [UIFont systemFontOfSize:11];
    [_containView addSubview:_ifCommentText];
    [_containView addSubview:_ifComment];
    
    _sentBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    _sentBtn.frame = CGRectMake(IPHONE_SCREEN_WIDTH - 60, CGRectGetMaxY(_remainText.frame) + 10, 50, 30);
    _sentBtn.backgroundColor = RGBACOLOR(30, 40, 50, 1);
    _sentBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    _sentBtn.layer.cornerRadius = 3.0;
    _sentBtn.layer.masksToBounds = YES;
    [_sentBtn setTitle:@"Sent" forState:UIControlStateNormal];
    
    _atBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _atBtn.frame = CGRectMake(CGRectGetMinX(_sentBtn.frame) - 35, CGRectGetMaxY(_remainText.frame) + 10, 40, 30);
    [_atBtn setImage:[UIImage imageWithIcon:@"fa-at" backgroundColor:[UIColor clearColor] iconColor:[UIColor orangeColor] andSize:CGSizeMake(20, 20)] forState:UIControlStateNormal];
    
    _emoijBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _emoijBtn.frame = CGRectMake(CGRectGetMinX(_atBtn.frame) - 35, CGRectGetMaxY(_remainText.frame) + 10, 40, 30);
    [_emoijBtn setImage:[UIImage imageWithIcon:@"fa-smile-o" backgroundColor:[UIColor clearColor] iconColor:[UIColor orangeColor] andSize:CGSizeMake(20, 20)] forState:UIControlStateNormal];
    
    [_containView addSubview:_emoijBtn];
    [_containView addSubview:_atBtn];
    [_containView addSubview:_sentBtn];
    
    float height = CGRectGetMaxY(_sentBtn.frame) + 10;
    _containView.frame = CGRectMake(0, IPHONE_SCREEN_HEIGHT - height, IPHONE_SCREEN_WIDTH, height);
    
    [_sentBtn addTarget:self action:@selector(forwardWeibo) forControlEvents:UIControlEventTouchUpInside];
    
}


- (void)closeForwardView:(UITapGestureRecognizer *)tap{
    [_forward resignFirstResponder];
    UIView *mainView = tap.view;
    [UIView animateWithDuration:0.3 animations:^{
        mainView.alpha = 0;
    }completion:^(BOOL finished){
        [mainView removeFromSuperview];
        
    }];
}

- (void)closeForwardView {
    [UIView animateWithDuration:0.3 animations:^{
        _mainView.alpha = 0;
    }completion:^(BOOL finished){
        [_mainView removeFromSuperview];
        
    }];
}

- (void)forwardWeibo {
    NSString *repostText;
    if (_forward.text != nil) {
        repostText = @"转发微博";
    }
    else {
        repostText = _forward.text;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [[AFJSONResponseSerializer alloc]init];
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
        NSDictionary *dict = [[NSDictionary alloc]init];
        AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
        NSNumber *ids = [NSNumber numberWithLongLong:_weiboID];
        NSNumber *is_comment = [NSNumber numberWithBool:_ifComment.isSelected];
        dict = @{@"access_token":delegate.wbtoken,@"id":ids,@"status":repostText,@"is_comment":is_comment};
        [manager POST:WEIBO_REPOSTURL
           parameters:dict
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  [KVNProgress showSuccess];
                  [self closeForwardView];
              }failure:^(AFHTTPRequestOperation *operation, NSError *error){
                  NSLog(@"Comment failure");
                  [KVNProgress showError];
                  
              }];
        
    });
}






#pragma mark - UITextFieldDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length >= 140) {
        textView.text = [textView.text substringToIndex:140];
    }
    else {
        NSString *existString = textView.text;
        int existTextNum = (int)[existString length];
        _remainTextNum = 140 - existTextNum;
        _remainText.text = [NSString stringWithFormat:@"可输入字数剩余: %d",_remainTextNum];
    }
}



- (void)keyboardWillShow:(NSNotification *)aNotification
{
    _keyboardNotice = aNotification;
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    _keyboardHeight = keyboardRect.size.height;
    
    NSTimeInterval animationDuration = 0.30f;
    
    CGRect frame = _mainView.frame;
    
    frame.origin.y -= _keyboardHeight;
    
    frame.size.height += _keyboardHeight;
    
    _mainView.frame = frame;
    
    [UIView beginAnimations:@"ResizeView"context:nil];
    
    [UIView setAnimationDuration:animationDuration];
    
    _mainView.frame = frame;
    
    [UIView commitAnimations];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    int height = _keyboardHeight;
    
    NSTimeInterval animationDuration = 0.50f;
    
    CGRect frame = _mainView.frame;
    
    frame.origin.y += _keyboardHeight;
    
    frame.size. height -= _keyboardHeight;
    
    _mainView.frame = frame;
    
    //self.view移回原位置
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         _mainView.frame = frame;
                     } completion:^(BOOL finished) {
                          [_sentBtn resignFirstResponder];
                     }];
    
    //[UIView beginAnimations:@"ResizeView"context:nil];
    
    //[UIView setAnimationDuration:animationDuration];
    
    
    
    //[UIView commitAnimations];
    
   
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
