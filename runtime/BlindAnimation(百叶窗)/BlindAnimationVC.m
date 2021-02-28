//
//  BlindAnimationVC.m
//  testbutton
//
//  Created by lmcqc on 2020/10/26.
//  Copyright © 2020 大碗豆. All rights reserved.
//

#import "BlindAnimationVC.h"

#import "BlindUnit.h"
#import "ToolUnit.h"

@interface BlindAnimationVC ()<BlindDelegate>

@property (nonatomic,strong)UIImage *image1;
@property (nonatomic,strong)UIImage *image2;
@end

@implementation BlindAnimationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.image1 = [UIImage imageNamed:@"1"];
    self.image2 = [UIImage imageNamed:@"2"];
    self.view.backgroundColor = [UIColor purpleColor];
    [self test];
    
    [ToolUnit compressImage:self.image2 percent:0.2];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)test{
    
    //    [BlindUnit blindAnimationInSuperView:self.view image:image separate:15 cacheQuality:1 duration:3];
    
    BlindUnit *blindView = [[BlindUnit alloc] init];
    blindView.superView = self.view;
    blindView.image = self.image1;
    blindView.separateCount = 12;
    blindView.cacheQuality = 1;
    blindView.duration = 3;
    blindView.delegate = self;
    [blindView blindAnimation];
}

- (void)blindFinishedAnimation{
    NSLog(@"blindFinishedAnimation");
}
- (void)blindStartAnimation{
    NSLog(@"blindStartAnimation");
}

@end
