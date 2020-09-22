//
//  WeiboCommentView.m
//  Fenvo
//
//  Created by Caesar on 15/6/2.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "WeiboCommentView.h"
#import "WeiboLabel.h"
#import "AFHTTPRequestOperationManager.h"
#import "AppDelegate.h"
#import "JSONKit.h"
#import "KVNProgress.h"
#import "CheckBox.h"
#import "UIImage+FontAwesome.h"

#define WEIBO_COMMENTURL @"https://api.weibo.com/2/comments/create.json"

@interface WeiboCommentView() <UITextViewDelegate>{
    UIWindow *_window;
    UIView *_containView;
    UIView *_mainView;
    UITextView *_comment;
    UIButton *_emoijBtn;
    UIButton *_atBtn;
    UIButton *_sentBtn;
    CheckBox *_ifForward;
    UILabel *_ifForwardText;
    UILabel *_remainText;
    
    int _remainTextNum;
    int _keyboardHeight;
    
    long long _weiboID;
    //
    NSNotification *_keyboardNotice;
}
@end

@implementation WeiboCommentView
+ (WeiboCommentView *)sharedWeiboCommentView {
    static WeiboCommentView *weiboCommentView;
    @synchronized(self){
        if (!weiboCommentView) {
            weiboCommentView = [[self alloc]init];
        }
    }
    return weiboCommentView;
}

- (void)showCommentView:(long long)weiboID {
    [self initComponent: weiboID];
   
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
    
    UITapGestureRecognizer *tap_closeView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeCommentView:)];
    [_mainView addGestureRecognizer:tap_closeView];
    
    [_comment becomeFirstResponder];
}

- (void)initComponent:(long long)weiboID {
    
    _weiboID = weiboID;
    _remainTextNum = 140;
    _window = [UIApplication sharedApplication].keyWindow;
    
    _mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, IPHONE_SCREEN_HEIGHT)];
    _mainView.backgroundColor = RGBACOLOR(0, 0, 0, 0.2);
    [_window addSubview:_mainView];
    
    _containView = [[UIView alloc]init];
    _containView.backgroundColor = RGBACOLOR(230, 230, 230, 1);
    [_mainView addSubview:_containView];
    
    _comment = [[UITextView alloc]initWithFrame:CGRectMake(5, 5, IPHONE_SCREEN_WIDTH - 10, 80)];
    _comment.backgroundColor = [UIColor whiteColor];
    _comment.textAlignment = NSTextAlignmentLeft;
    [_comment setDelegate:self];
    
    _remainText = [[UILabel alloc]initWithFrame:CGRectMake(IPHONE_SCREEN_WIDTH - 140,CGRectGetMaxY(_comment.frame) + 3, 140, 15)];
    _remainText.textColor = [UIColor lightGrayColor];
    _remainText.text = [NSString stringWithFormat:@"可输入字数剩余: %d",_remainTextNum];
    _remainText.font = [UIFont systemFontOfSize:12.0];
    
    [_containView addSubview:_remainText];
    [_containView addSubview: _comment];
    
    _ifForward = [[CheckBox alloc]initWithFrame:CGRectMake(5,
                                                          CGRectGetMaxY(_remainText.frame) + 10, 25, 25)];
    _ifForwardText = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_ifForward.frame)+5, CGRectGetMaxY(_remainText.frame) + 10, 120, 25)];
    _ifForwardText.textColor = [UIColor lightGrayColor];
    _ifForwardText.text = @"评论原微博?";
    _ifForwardText.font = [UIFont systemFontOfSize:11];
    [_containView addSubview:_ifForwardText];
    [_containView addSubview:_ifForward];
    
    
    _sentBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    _sentBtn.frame = CGRectMake(IPHONE_SCREEN_WIDTH - 60, CGRectGetMaxY(_remainText.frame) + 10, 50, 30);
    _sentBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    _sentBtn.backgroundColor = RGBACOLOR(30, 40, 50, 1);
    _sentBtn.layer.cornerRadius = 3.0;
    _sentBtn.layer.masksToBounds = YES;
    [_sentBtn setTitle:@"Sent" forState:UIControlStateNormal];
    
    _atBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _atBtn.frame = CGRectMake(CGRectGetMinX(_sentBtn.frame) - 40, CGRectGetMaxY(_remainText.frame) + 10, 40, 30);
    [_atBtn setImage:[UIImage imageWithIcon:@"fa-at" backgroundColor:[UIColor clearColor] iconColor:[UIColor orangeColor] andSize:CGSizeMake(20, 20)] forState:UIControlStateNormal];
    
    _emoijBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _emoijBtn.frame = CGRectMake(CGRectGetMinX(_atBtn.frame) - 40, CGRectGetMaxY(_remainText.frame) + 10, 40, 30);
    [_emoijBtn setImage:[UIImage imageWithIcon:@"fa-smile-o" backgroundColor:[UIColor clearColor] iconColor:[UIColor orangeColor] andSize:CGSizeMake(20, 20)] forState:UIControlStateNormal];
    
    [_containView addSubview:_emoijBtn];
    [_containView addSubview:_atBtn];
    [_containView addSubview:_sentBtn];
    
    float height = CGRectGetMaxY(_sentBtn.frame) + 10;
    _containView.frame = CGRectMake(0, IPHONE_SCREEN_HEIGHT - height, IPHONE_SCREEN_WIDTH, height);
    
    [_sentBtn addTarget:self action:@selector(sentComment) forControlEvents:UIControlEventTouchUpInside];
    
}


- (void)closeCommentView:(UITapGestureRecognizer *)tap{
    [_comment resignFirstResponder];
    UIView *mainView = tap.view;
    [UIView animateWithDuration:0.3 animations:^{
        mainView.alpha = 0;
    }completion:^(BOOL finished){
        [mainView removeFromSuperview];
        
    }];
}

- (void)closeCommentView {
    [UIView animateWithDuration:0.3 animations:^{
        _mainView.alpha = 0;
    }completion:^(BOOL finished){
        [_mainView removeFromSuperview];
        
    }];
}

- (void)sentComment {
    NSString *commentText = _comment.text;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [[AFJSONResponseSerializer alloc]init];
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
        NSDictionary *dict = [[NSDictionary alloc]init];
        AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
        NSNumber *ids = [NSNumber numberWithLongLong:_weiboID];
        NSNumber *comment_ori = [NSNumber numberWithBool: _ifForward.isSelected];
        dict = @{@"access_token":delegate.wbtoken,@"id":ids,@"comment":commentText,@"comment_ori":comment_ori};
        [manager POST:WEIBO_COMMENTURL
           parameters:dict
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  [KVNProgress showSuccess];
                  [self closeCommentView];
              }failure:^(AFHTTPRequestOperation *operation, NSError *error){
                  NSLog(@"Comment failure");
                  [KVNProgress showError];

              }];
        
    });
}






#pragma mark - UITextFieldDelegate
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
    NSInteger height = _keyboardHeight;
    
    NSTimeInterval animationDuration = 0.30f;
    
    CGRect frame = _mainView.frame;
    
    frame.origin.y += _keyboardHeight;
    
    frame.size. height -= _keyboardHeight;
    
    _mainView.frame = frame;
    
    //self.view移回原位置
    
    [UIView beginAnimations:@"ResizeView"context:nil];
    
    [UIView setAnimationDuration:animationDuration];
    
    _mainView.frame = frame;
    
    [UIView commitAnimations];
    
    [_sentBtn resignFirstResponder];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
