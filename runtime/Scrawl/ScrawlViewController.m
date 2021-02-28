//
//  ScrawlViewController.m
//  testbutton
//
//  Created by 大豌豆 on 18/12/25.
//  Copyright © 2018年 大碗豆. All rights reserved.
//

#import "ScrawlViewController.h"
#import "OriginalView.h"

@interface ScrawlViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) OriginalView *orview;

@property (nonatomic, strong) NSMutableArray *allScrArray;

@end

@implementation ScrawlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"涂鸦";
    self.view.backgroundColor = [UIColor cyanColor];
    
    OriginalView *orview = [[OriginalView alloc] initWithFrame:CGRectMake(10, 70, 400, 500)];
//    orview.center = CGPointMake(40, 50);
    orview.backgroundColor = [UIColor purpleColor];
    self.orview = orview;
    [self.view addSubview:orview];
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushtoDetailVC:)];
    tapGesture.numberOfTouchesRequired=1;
    tapGesture.numberOfTapsRequired=1;
    tapGesture.delegate = self;
    [orview addGestureRecognizer:tapGesture];
    
    self.allScrArray = [[NSMutableArray alloc] init];
    
    UIButton *saveImageButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    saveImageButton.frame = CGRectMake(20, 580, 50, 30);
    [saveImageButton setTitle:@"保存" forState:(UIControlStateNormal)];
    [saveImageButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    saveImageButton.backgroundColor = [UIColor purpleColor];
    [saveImageButton addTarget:self action:@selector(saveBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:saveImageButton];
    
}

- (void)saveBtnAction:(UIButton *)btn{
    
    UIImageView *lastView = [[UIImageView alloc] initWithFrame:CGRectMake(80, 600, 300, 100)];
    [self.view addSubview:lastView];
    
    UIGraphicsBeginImageContext(self.orview.frame.size);
    [self.orview.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    lastView.image = viewImage;
}


-(void)pushtoDetailVC:(UITapGestureRecognizer *)Recognizer{
    
    CGPoint point = [Recognizer locationInView:self.orview];
    CGRect rect = CGRectMake(point.x-20, point.y-20, 40, 40);
    NSLog(@"%@", NSStringFromCGPoint(point));
    
    for (NSDictionary *dic in self.allScrArray) {
        CGRect rectTmp = CGRectFromString(dic[@"rect"]);
        BOOL contains = CGRectContainsPoint(rectTmp, point);
        if (contains) {
            [self.allScrArray removeObject:dic];
            self.orview.imageArray = self.allScrArray;
            return;
        }
    }
    
    NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc] init];
    
    NSString *imgPoint = NSStringFromCGPoint(point);
    NSString *imgRect = NSStringFromCGRect(rect);
    
    [tmpDic setValue:imgRect forKey:@"rect"];
    [tmpDic setValue:imgPoint forKey:@"Point"];
    
    if (point.x < 200) {
        [tmpDic setValue:@"qwas.png" forKey:@"imageName"];
    }else{
        [tmpDic setValue:@"rp.png" forKey:@"imageName"];
    }
    
    
//    NSMutableArray *tmpArr = [NSMutableArray array];
//    [tmpArr addObject:tmpDic];
    [self.allScrArray addObject:tmpDic];
    
    
    self.orview.imageArray = self.allScrArray;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
