//
//  PickImageVC.m
//  testbutton
//
//  Created by lmcqc on 2020/10/26.
//  Copyright © 2020 大碗豆. All rights reserved.
//

#import "PickImageVC.h"

@interface PickImageVC ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property(nonatomic,strong)UIImageView *imag;
@end

@implementation PickImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imag = [[UIImageView alloc] initWithFrame:CGRectMake(120, 100, 100, 100)];
    imag.image = [UIImage imageNamed:@"rp"];
    [self.view addSubview:imag];
    self.imag = imag;
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake(20, STATUS_NAV_HEIGHT, 80, 50);
    btn.backgroundColor = [UIColor orangeColor];
    [btn setTitle:@"选择照片" forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(pickImage) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
}
#pragma 选取照片
/**
 选取照片
 */
- (void)pickImage{
    
//    UIImagePickerController *imagePicker=[[UIImagePickerController alloc] init];
//    imagePicker.delegate=self;
//    //    imagePicker.view.frame=s
//    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
//        imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
//
//    }
//    // imagePicker.allowsEditing=YES;
//    //    [self.view addSubview:imagePicker.view];
//    [self presentViewController:imagePicker animated:YES completion:^{
//
//    }];
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        picker.videoQuality = UIImagePickerControllerQualityTypeMedium; //录像质量
        picker.videoMaximumDuration = 600.0f; //录像最长时间
        picker.mediaTypes = [NSArray arrayWithObjects:@"public.movie", nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"当前设备不支持录像功能" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    //跳转到拍摄页面
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"%@",info);
    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
    
    self.imag.image=image;
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
