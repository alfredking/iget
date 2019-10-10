//
//  Father.m
//  iget
//
//  Created by alfredking－cmcc on 2019/8/3.
//  Copyright © 2019 alfredking. All rights reserved.
//

#import "Father.h"


@interface Father()
{
    //NSMutableString *testStringB;

}

@property (nonatomic,strong)NSMutableString *testStringA;
@property (nonatomic,strong)NSMutableString *testStringB;
//@property (nonatomic,strong)NSString *title;
//@property (nonatomic,weak)NSString *title;
@property (nonatomic,copy)NSString *title;

@end

@implementation Father

-(void )testcopy
{
    
    NSMutableString *string = [NSMutableString stringWithFormat:@"name"];
    NSLog(@"原始string的地址:%p",string);
    _testStringA = string;
    NSLog(@"A对象string的地址:%p",_testStringA);
    _testStringB = string ;
    NSLog(@"B对象string的地址:%p",_testStringB);


    NSMutableString *copyString = [string copy];
    //发生了深拷贝，但是确是不可变的
    NSLog(@"拷贝string的地址:%p",copyString);

    //[copyString appendString:@"test"];


    
    NSString *stringb = [NSString stringWithFormat:@"test"];
    NSLog(@"原始string的地址:%p",stringb);
    
    NSString *copyStringb = [stringb copy];
    //发生了浅拷贝，是不可变的，字符串是@"name"的时候，与copyString是同一个对象
    NSLog(@"拷贝string的地址:%p",copyStringb);
    
    self.title = @"title"; //成员变量不能用.的方法
    NSLog(@"self.title is %@",self.title);
    NSMutableString *mutableTitleA = [@"mutableTitleA" mutableCopy];
    NSMutableString *mutableTitleB = [@"mutableTitleB" mutableCopy];
    
    NSMutableString *mutable =mutableTitleA;

    
    
    
    self.title = mutable;
    
    NSLog(@"self.title is %@",self.title);
    
    mutable = mutableTitleB; //如果self.title是weak属性的时候，@"title"指向的内存在mutableTitle不再指向的时候会被销毁，值为null
    //mutableTitle = [@"test" mutableCopy];
    //[mutableTitle appendString:@" wawawa"];
    
    //self.title只有在strong属性的时候会变化
    NSLog(@"self.title is %@",self.title);
    
    
}
@end
