//
//  NewWeiboVC.m
//  Fenvo
//
//  Created by Caesar on 15/6/23.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "NewWeiboVC.h"
#import "KVNProgress.h"
#import "WBImagePickerVC.h"
#import "StyleOfRemindSubviews.h"
#import "MutiImageView.h"

@interface NewWeiboVC ()<UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,WBImagePickerControllerDelegate>
{
    UIActionSheet *_selection;
    UIScrollView *_scrollView;
    //image arr
    NSMutableArray *arr;
    
    //MutiImageView arr
    NSMutableArray *_imageArray;
    
    //select image in gallery
    WBImagePickerVC *imagePickVC;
}
@end

@implementation NewWeiboVC



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    self.title = @"New Weibo";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:@"Sent"
                                              style:UIBarButtonItemStyleDone
                                              target:self
                                              action:@selector(send)];
    
    [self initSubviews];
    //add delete imgae observer
    NSNotificationCenter *defult = [NSNotificationCenter defaultCenter];
    [defult removeObserver:self name:@"deleteImage" object:nil];
    [defult addObserver:self selector:@selector(deleteImage:) name:@"deleteImage" object:nil];
    
    //init image array and image view array
    _imageArray = [[NSMutableArray alloc]init];
    arr = [[NSMutableArray alloc]init];
    
}

- (void)initSubviews
{
    _scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.contentSize = CGSizeMake(IPHONE_SCREEN_WIDTH, IPHONE_SCREEN_HEIGHT + 100);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    CGFloat spacing = [StyleOfRemindSubviews componentSpacing];
    
    _wbDetail = [[UITextView alloc]initWithFrame:CGRectMake(spacing, spacing, IPHONE_SCREEN_WIDTH - 2 *spacing, 180)];
    _wbDetail.backgroundColor = [StyleOfRemindSubviews lightGreyColor];
    _wbDetail.font = [StyleOfRemindSubviews largeFont];
    _wbDetail.textColor = [StyleOfRemindSubviews deepBlackColor];
    _wbDetail.layer.cornerRadius = 10.0;
    _wbDetail.layer.masksToBounds = YES;
    _wbDetail.delegate = self;
    [_scrollView addSubview:_wbDetail];
    
    _addImg = [UIButton buttonWithType:UIButtonTypeCustom];
    _addImg.frame = CGRectMake(8, CGRectGetMaxY(_wbDetail.frame) + 8, 80, 80);
    [_addImg setImage:[UIImage imageNamed:@"btn_add_photo"] forState:UIControlStateNormal];
    [_addImg setImage:[UIImage imageNamed:@"btn_add_photo_hl"] forState:UIControlStateHighlighted];
    [_addImg addTarget:self action:@selector(openMenu) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_addImg];

    [_wbDetail becomeFirstResponder];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyboard:)];
    [_scrollView addGestureRecognizer:tap];
}

- (void)openMenu {
    _selection = [[UIActionSheet alloc]initWithTitle:@"Open From?"
                                                          delegate:self
                                                 cancelButtonTitle:@"Cancel"
                                            destructiveButtonTitle:nil
                                                 otherButtonTitles:@"Camera",@"Gallery", nil];
    [_selection showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == _selection.cancelButtonIndex) {
        [_selection removeFromSuperview];
        return ;
    }
    switch (buttonIndex) {
        case 0:
            [self takePhoto];
            break;
        case 1:
            [self openGallery];
            break;
        default:
            break;
    }
}

- (void)takePhoto {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = sourceType;
            picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
            [self.navigationController pushViewController:picker animated:YES];

    }
    //if camera is unavailable
    else {
        [KVNProgress showErrorWithStatus:@"Camera is unavialable"];
    }
}

- (void)openGallery {
    if (imagePickVC == nil) {
        
        imagePickVC = [[WBImagePickerVC alloc]init];
        imagePickVC.delegate = self;
        imagePickVC.allowsMultipleSelection = YES;
        imagePickVC.limitsMaximumNumberOfSelection = YES;
        imagePickVC.maximumNumberOfSelection = 9;
    }
    [self.navigationController pushViewController:imagePickVC animated:YES];
}

#pragma mark - WBImagePickerViewControllerDelegate

- (void)imagePickerController:(WBImagePickerVC *)imagePickerController didFinishPickingMediaWithInfo:(id)info {
    NSArray *mediaInfoArray = (NSArray *)info;

    //get the selected image array
    for (int i = 0 ; i < mediaInfoArray.count; i++) {
        NSDictionary *mediaInfo = mediaInfoArray[i];
        UIImage *image = mediaInfo[@"UIImagePickerControllerOriginalImage"];
        [arr addObject:image];
    }
    
    for (int i = 0; i < arr.count; i++) {
        
        if (i < _imageArray.count) {
            continue;
        }
        //adjust the frame of the image view
        if (i < 2 || (i > 2 && i < 5) || (i > 5 && i < 8)) {
            
            float width = 88.0f;
            
            NSTimeInterval animationDuration = 0.30f;
            
            CGRect frame = _addImg.frame;
            
            //replace the addImage Button with imageView;
            dispatch_async(dispatch_get_main_queue(), ^{
                MutiImageView *img;
                img = [[MutiImageView alloc]initWithImageArray:_imageArray AndTag:i];
                [self.view addSubview:img];
                img.frame = frame;
                img.image = arr[i];
                [_imageArray addObject:img];
            });
            
            frame.origin.x += width;
            _addImg.frame = frame;
            
            //self.view移回原位置
            [UIView beginAnimations:@"ResizeView"context:nil];
            [UIView setAnimationDuration:animationDuration];
            
            _addImg.frame = frame;
            
            [UIView commitAnimations];
            
        }else if (i == 2 || i == 5) {
            float height = 88.0f;
            NSTimeInterval animationDuration = 0.30f;
            
            CGRect frame = _addImg.frame;
            
            //replace the addImage Button with imageView;
            dispatch_async(dispatch_get_main_queue(), ^{
                MutiImageView *img;
                img = [[MutiImageView alloc]initWithImageArray:_imageArray AndTag:i];
                [self.view addSubview:img];
                img.frame = frame;
                img.image = arr[i];
                [_imageArray addObject:img];
            });
            
            frame.origin.y += height;
            frame.origin.x = 8.0f;
            
            //frame.size.height += height;
            
            _addImg.frame = frame;
            
            //self.view移回原位置
            
            [UIView beginAnimations:@"ResizeView"context:nil];
            [UIView setAnimationDuration:animationDuration];
            
            _addImg.frame = frame;
            
            [UIView commitAnimations];
            
        }else if(i == 8){
            
            CGRect frame = _addImg.frame;
            
            //replace the addImage Button with imageView;
            dispatch_async(dispatch_get_main_queue(), ^{
                MutiImageView *img;
                img = [[MutiImageView alloc]initWithImageArray:_imageArray AndTag:i];
                [self.view addSubview:img];
                img.frame = frame;
                img.image = arr[i];
                [_imageArray addObject:img];
            });
            
            [_addImg setHidden:YES];
        }
        
        //control the number of arr is 9
        imagePickVC.maximumNumberOfSelection = 9 - arr.count;
    }
    
    //reset the imageArray and the tag of every MutiImageView
    for (long i = 0; i < _imageArray.count; i ++) {
        MutiImageView *img = _imageArray[i];
        [img setImageArray:_imageArray andTag:i];
    }
    
    [self.navigationController popToViewController:self animated:YES];
}

- (void)imagePickerControllerDidCancel:(WBImagePickerVC *)imagePickerController
{
    NSLog(@"Cancelled");
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (NSString *)descriptionForDeselectingAllAssets:(WBImagePickerVC *)imagePickerController {
    return @"DeSelect All";
}

- (NSString *)descriptionForSelectingAllAssets:(WBImagePickerVC *)imagePickerController {
    return @"Select All";
}

- (NSString *)imagePickerController:(WBImagePickerVC *)imagePickerController descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos numberOfVideos:(NSUInteger)numberOfVideos {
    return [NSString stringWithFormat:@" %ld Photos And %ld Videos",numberOfPhotos, numberOfVideos];
}

- (NSString *)imagePickerController:(WBImagePickerVC *)imagePickerController descriptionForNumberOfVideos:(NSUInteger)numberOfVideos {
    return [NSString stringWithFormat:@" %ld Videos",numberOfVideos];
}

- (NSString *)imagePickerController:(WBImagePickerVC *)imagePickerController descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos {
     return [NSString stringWithFormat:@" %ld Photos",numberOfPhotos];
}

#pragma mark - delete image methods

- (void)deleteImage:(NSNotification *)notice {
    long image_tag = [notice.object longValue];
    MutiImageView *delete_img_view = _imageArray[image_tag];
    CGRect frame = delete_img_view.frame;
    
    //if the deleted image is the last one
    if(image_tag == _imageArray.count - 1){
        
        //let the button replace it
        _addImg.frame = frame;
        
        //remove the imageView
        [delete_img_view removeFromSuperview];
        [_imageArray removeObjectAtIndex:image_tag];
        
        //if the original _imageArray.count == 9
        //that's say the button is hidden now, let it become visible.
        if ([_addImg isHidden]==YES) {
            [_addImg setHidden:NO];
        }
        return;
    }
    
    //if the deleted image is not the last one
    //replace the image one by one
    for (long i = image_tag + 1; i < _imageArray.count; i ++) {
        MutiImageView *img = _imageArray[i];
        CGRect frame_tmp = img.frame;
        img.frame = frame;
        frame = frame_tmp;
    }
    
    //if the original _imageArray.count == 9
    //that's say the button is hidden now, let it become visible.
    if ([_addImg isHidden]==YES) {
        [_addImg setHidden:NO];
    }
    _addImg.frame = frame;
    
    //remove the deleted image view
    [delete_img_view removeFromSuperview];
    [_imageArray removeObjectAtIndex:image_tag];
    
    
    //reset the imageArray and the tag of every MutiImageView
    for (long i = 0; i < _imageArray.count; i ++) {
        MutiImageView *img = _imageArray[i];
        [img setImageArray:_imageArray andTag:i];
    }
}


#pragma mark - UIImagePickerControllerDelegate

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)closeKeyboard: (UITapGestureRecognizer *)tap
{
    [_wbDetail resignFirstResponder];
}
@end
