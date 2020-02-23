//
//  ViewController.m
//  shiyan
//
//  Created by liu on 2017/8/18.
//  Copyright © 2017年 liu. All rights reserved.
//p110 https://www.jianshu.com/p/244dbc17d011
#import "ViewController.h"
#import "NSObject+Person.h"


@interface ViewController ()

@end

@implementation ViewController



- (void)viewDidLoad {
    NSObject *objc = [[NSObject alloc] init];
    objc.name = @"almost";
    NSLog(@"%@", objc.name);
    NSLog(@"-.-");
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
