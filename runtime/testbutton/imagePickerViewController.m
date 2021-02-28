//
//  ViewController.m
//  ImagePicker
//
//  Created by 大碗豆 on 17/3/10.
//  Copyright © 2017年 大碗豆. All rights reserved.
//

#import "imagePickerViewController.h"
#import "DPImagePickerVC.h"
#import <AssetsLibrary/AssetsLibrary.h>

#import "AFNetworking.h"

#import "AnyHTTPRequest.h"

@interface imagePickerViewController ()<DPImagePickerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic ,strong)UIImageView *imageV;
@property (strong, nonatomic)  DPImagePickerVC * Viewasd;
@property (nonatomic ,strong) UIProgressView *progressView;;

@property(nonatomic,strong)CAShapeLayer *shapeLayer;
@property(nonatomic,strong)CAShapeLayer *shapeLayerTwo;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,assign)CGFloat timeD;


@end

@implementation imagePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadNavView];
    
    [self recell];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(20, 200, 250, 250)];
    self.imageV = image;
    [self.view addSubview:image];
    image.backgroundColor = [UIColor redColor];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(50, 50, 100, 30)];
    [btn setTitle:@"选择照片" forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor purpleColor] forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
    
    UIButton *uploadBtn = [[UIButton alloc] initWithFrame:CGRectMake(250, 50, 100, 30)];
    [uploadBtn setTitle:@"上传照片" forState:(UIControlStateNormal)];
    [uploadBtn setTitleColor:[UIColor purpleColor] forState:(UIControlStateNormal)];
    [uploadBtn addTarget:self action:@selector(uploadBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:uploadBtn];
    
    
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(10, 30, 300, 20)];
    [self.view addSubview:self.progressView];
//    self.progressView.backgroundColor = [UIColor redColor];
    self.progressView.progress = 0.5;
    self.progressView.progressTintColor = [UIColor orangeColor];
    self.progressView.trackTintColor = [UIColor cyanColor];
    
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 3.0f);
    self.progressView.transform = transform;//设定宽高
    self.progressView.contentMode = UIViewContentModeScaleAspectFill;
}


- (void)loadNavView{
    
    UIView *stateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    [self.view addSubview:stateView];
    stateView.backgroundColor = [UIColor redColor];
    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 44)];
    [self.view addSubview:navView];
    navView.backgroundColor = [UIColor redColor];
    
//    UIButton *btn = [UIButton new];
//    [navView addSubview:btn];
//    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.leading.equalTo(navView).offset(10);
//        make.bottom.equalTo(navView).offset(-10);
//        make.width.equalTo(@(24));
//    }];
//    [btn setImage:[UIImage imageNamed:@"back"] forState:(UIControlStateNormal)];
//    //    [btn setTitle:@"back" forState:(UIControlStateNormal)];
//    //    [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
//    //    btn.titleLabel.font = [UIFont systemFontOfSize:20];
//    //    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
//    //    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -35, 0, 0);
//    //    btn.backgroundColor = [UIColor purpleColor];
//    
//    [btn addTarget:self action:@selector(btnActionBack) forControlEvents:(UIControlEventTouchUpInside)];
//    
//    UILabel *labTitle = [UILabel new];
//    [navView addSubview:labTitle];
//    [labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(navView);
//        make.centerY.equalTo(navView);
//        make.width.equalTo(@100);
//        make.height.equalTo(@30);
//    }];
//    //    labTitle.backgroundColor = [UIColor redColor];
//    labTitle.textAlignment = NSTextAlignmentCenter;
//    labTitle.text = @"上传照片";
//    labTitle.textColor = [UIColor whiteColor];
//    labTitle.font = [UIFont systemFontOfSize:17];
}

- (void)btnActionBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)btnAction{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
#if TARGET_IPHONE_SIMULATOR
        //模拟器
        UIAlertView *alerView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"请真机测试！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alerView show];
#elif TARGET_OS_IPHONE
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:([UIColor colorWithRed:231.0/255.0 green:56.0/255.0 blue:32.0/255.0 alpha:1.0]),NSForegroundColorAttributeName, nil];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickerController animated:YES completion:^{}];
#endif
        
        
    }];
    UIAlertAction *confirm2 = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        DPImagePickerVC *vc = [[DPImagePickerVC alloc]init];
        vc.delegate = self;
        vc.isDouble = YES;
//        [self.navigationController pushViewController:vc animated:YES];
        [self presentViewController:vc animated:YES completion:nil];
        
        
    }];
    [alertVc addAction:cancle];
    [alertVc addAction:confirm];
    [alertVc addAction:confirm2];
    [self presentViewController:alertVc animated:YES completion:nil];
    
    
}

- (void)imagePickerController: (UIImagePickerController *)picker didFinishPickingMediaWithInfo: (NSDictionary *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    [picker dismissViewControllerAnimated:YES completion:^{
        //        [self.navigationController popViewControllerAnimated:YES];
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
            [assetsLibrary writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)image.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error) {
                if (error) {
                }else{
                    NSData *date = UIImageJPEGRepresentation(image, 1.0);
                    self.imageV.image = [UIImage imageWithData:date];
                }
            }];
        }
    }];
}

#pragma mark -- DPImagePickerDelegate
- (void)getCutImage:(UIImage *)image{
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    self.imageV.image = image;
    
}

- (void)getImageArray:(NSMutableArray *)arrayImage{
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"------------------%ld",(unsigned long)arrayImage.count);
    if (arrayImage.count !=0) {
        self.imageV.image = nil;
        self.imageV.image = arrayImage[0];
    }
    
}

- (void)uploadBtn{
    
    
//    NSData *imageData = UIImageJPEGRepresentation(_imageV.image, 0.1);
//    
//    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    //        // 设置时间格式
//    formatter.dateFormat = @"yyyyMMddHHmmss";
//    NSString *str = [formatter stringFromDate:[NSDate date]];
//    NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
//    
//     NSString *path = @"http://192.168.10.112:8080/whmgServer/upload.up";
//    
////    NSString *strUrl = [URL stringByAppendingString:@"assetDetail/list.do"];
//    NSDictionary *dicParams = @{@"photoFile":imageData};
//    
//    [AnyHTTPRequest POST:path parameters:dicParams flag:@"123" progress:^(NSProgress *progress){
//        
//    }success:^(NSURLSessionDataTask *task, NSArray *arrModels) {
//        
//        NSLog(@"%@",arrModels);
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        
//        NSLog(@"%@",error.localizedDescription);
//    }];
    
    
    
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *path = @"http://192.168.10.112:8080/whmgServer/upload.up";
    
    NSData *imageData = UIImageJPEGRepresentation(_imageV.image, 0.1);
//    Byte *testByte = (Byte *)[imageData bytes];
    
    
    NSDictionary *dicParams = @{@"photoFile":imageData};;
    
//    @{@"photoFile":imageData};
    
    NSMutableSet *set = [NSMutableSet setWithSet:manager.responseSerializer.acceptableContentTypes];
    [set addObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = [set copy];
    
    NSLog(@"%@", manager.responseSerializer.acceptableContentTypes);
    
    [manager POST:path parameters:dicParams constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // FormData: 还是需要我们自己拼接的
        //[formData appendPartWithFormData:<#(nonnull NSData *)#> name:<#(nonnull NSString *)#>];
        
        
        //要上传的数据
        
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"vlc_mac_2.2.3.dmg" ofType:nil];
//        NSData *data = [NSData dataWithContentsOfFile:path];
        
        NSData *imageData = UIImageJPEGRepresentation(self->_imageV.image, 0.1);
        // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
        // 要解决此问题，
        // 可以在上传时使用当前的系统事件作为文件名
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];


        /*
         此方法参数
         1. 要上传的[二进制数据]
         2. 我这里的imgFile是对应后台给你url里面的图片参数，别瞎带。
         3. 要保存在服务器上的[文件名]
         4. 上传文件的[mimeType]
         */
        
        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"multipart/form-data"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"%f", uploadProgress.fractionCompleted);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.progressView.progress = uploadProgress.fractionCompleted;
            
            float Intervaltime = 0.5;
                self.timer = [NSTimer scheduledTimerWithTimeInterval:Intervaltime target:self selector:@selector(circleAnimation) userInfo:nil repeats:YES];
            
            self.timeD = 1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
        });
        
        //打印下上传进度
        NSLog(@"%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *arr = responseObject;
        
        //请求成功
        NSLog(@"%lu", (unsigned long)arr.count);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求失败
        NSLog(@"%@", error.localizedDescription);
    }];
    
    
    
   
    
    /*
    
    NSString *fileName = @"hmt";
     //  确定需要上传的文件(假设选择本地的文件)
     NSURL *filePath = [[NSBundle mainBundle] URLForResource:fileName withExtension:@"png"];
     NSDictionary *parameters = @{@"name":@"额外的请求参数"};
     AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
     [requestManager POST:@"http://192.168.10.18:8080/AFNetworkingServer/upload" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
     
     
     *  appendPartWithFileURL   //  指定上传的文件
     *  name                    //  指定在服务器中获取对应文件或文本时的key
     *  fileName                //  指定上传文件的原始文件名
     *  mimeType                //  指定商家文件的MIME类型
     
    [formData appendPartWithFileURL:filePath name:@"file" fileName:[NSString stringWithFormat:@"%@.png",fileName] mimeType:@"image/png" error:nil];
     
     } success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    [[[UIAlertView alloc] initWithTitle:@"上传结果" message:[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]  delegate:self cancelButtonTitle:@"" otherButtonTitles:nil] show];
    
} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    NSLog(@"获取服务器响应出错");
    
}];

*/

}


- (void)recell{
    //创建出CAShapelasyer
    self.shapeLayer = [CAShapeLayer layer];
    //填充颜色
    self.shapeLayer.fillColor = [UIColor clearColor].CGColor;
    //设置线条的宽度和颜色
    self.shapeLayer.lineWidth = 4.0f;
    self.shapeLayer.strokeColor = [UIColor orangeColor].CGColor;
    //画贝塞尔曲线//画出一个园
    UIBezierPath *path = [[UIBezierPath alloc] init];
    //moveToPoint:去设置初始线段的起点
    [path moveToPoint:CGPointMake(250, 100)];
    [path addArcWithCenter:CGPointMake(200, 100) radius:50 startAngle:0 endAngle:2*M_PI clockwise:YES];
    self.shapeLayerTwo = [CAShapeLayer layer];
    self.shapeLayerTwo.fillColor = [UIColor clearColor].CGColor;
    //设置第二条背景线条的宽度和颜色
    self.shapeLayerTwo.lineWidth = 4.0f;
    self.shapeLayerTwo.strokeColor = [UIColor redColor].CGColor;
    //设置第一条第一条曲线与设定的贝塞尔曲线相同，所以在设定两条曲线的时候，可以不需要设置大小与位置
    self.shapeLayerTwo.path = path.CGPath;
    self.shapeLayer.path = path.CGPath;
    //设置起始点.保证圈不被显示出来
    self.shapeLayer.strokeStart = 0;
    self.shapeLayer.strokeEnd = 0;
    //加载
    [self.view.layer addSublayer:self.shapeLayerTwo];
    [self.view.layer addSublayer:self.shapeLayer];
}


//定时器每次时间到了执行
- (void)circleAnimation{
    _timeD = 0.5;
    //利用定时器控制始位置的方式做动画。
    self.shapeLayer.strokeEnd += _timeD;
    if (self.shapeLayer.strokeEnd == 1) {
        //停止计时器
        [self.timer invalidate];
        self.timer = nil;
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
