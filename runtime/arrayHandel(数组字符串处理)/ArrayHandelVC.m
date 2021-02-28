//
//  ArrayHandelVC.m
//  testbutton
//
//  Created by lmcqc on 2020/10/22.
//  Copyright © 2020 大碗豆. All rights reserved.
//

#import "ArrayHandelVC.h"

@interface ArrayHandelVC ()

@end

@implementation ArrayHandelVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self testThree];
    
    NSString *string1 = @"ABCDEFGHIJKL\nMNOPQRSTUVsWXYZ";
    NSLog(@"%@~~~~~~~~~",string1);
    
    //取出两个数组中相同的元素
    NSArray *arr1 = @[@"1",@"2",@"2",@"1",@"3",@"4",@"5",@"2",@"1",@"2",@"5",@"3",@"2",@"3",@"4",@"5",@"6",@"7",@"8"];
    NSArray *arr2 = @[@"13",@"2",@"2",@"1",@"31",@"42",@"52",@"22",@"12",@"2",@"54",@"3",@"2",@"13",@"4",@"5",@"6",@"7",@"8"];
    
    NSArray *selectTure = [arr1 filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF in %@", arr2]];
    
    NSLog(@"%@~~~~~~~~~",selectTure);
    
    //    这样arrayContent过滤出来的就是不包含 arrayFilter中的所有item了。
    NSArray *arrayFilter = [NSArray arrayWithObjects:@"abc1", @"abc2", nil];
    
    NSArray *arrayContent = [NSArray arrayWithObjects:@"a1", @"abc1", @"abc4", @"abc2", nil];
    
    NSPredicate *thePredicate = [NSPredicate predicateWithFormat:@"NOT (SELF in %@)", arrayFilter];
    
    NSArray *selectTure22 = [arrayContent filteredArrayUsingPredicate:thePredicate];
    NSLog(@"%@",selectTure22);
    
    //    NSString *a = @"12wertyu";
    //   NSString *b =  [a substringWithRange:NSMakeRange(0, 1)];
    //    NSLog(@"%@",b);
    //
    //   NSString *c = [a substringWithRange:NSMakeRange(3, 2)];
    //
    //    NSLog(@"%@",c);
    
    
    NSString *string =@"01234￥56789";
    NSRange range = [string rangeOfString:@"￥"];
    string = [string substringFromIndex:range.location+1];//截取掉下标7之前的字符串
    //    NSLog(@"截取的值为：%@",string);
    
    //    NSRange range = [string rangeOfString:@":"]; //现获取要截取的字符串位置
    //    NSString * result = [string substringFromIndex:range.location+1]; //截取字符串
    //    NSLog(@"截取的值为：%@",result);
    //
    ////    string = [string substringFromIndex:1];//截取掉下标2之后的字符串
    //    NSLog(@"截取的值为：%@",result);
    
    //    NSRange range = [str rangeOfString:@"aaa"]; //现获取要截取的字符串位置
    //    NSString * result = [str substringFromIndex:range.location]; //截取字符串
}


/**
 *   使用stringByTrimmingCharactersInSet函数过滤字符串中的特殊符号。
 */
-(void)testThree{
    
    //1:有字符串“A~B^C_D>E"，拆分出单个字母:
    
    NSString *str =@"      \nA~B^C_D>E       ";
    
    //去掉前边和后边的空格和换行符,中间部分无效.
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSCharacterSet * charSet = [NSCharacterSet characterSetWithCharactersInString:@"^~_>"];
    NSArray *arr = [str componentsSeparatedByCharactersInSet:charSet];
    
    //输出看效果
    [arr enumerateObjectsUsingBlock:^(id obj,NSUInteger idx,BOOL *stop) {
        
        NSLog(@"A~B^C_D->[%@]", obj);
        
    }];
    NSLog(@"arr %@",[arr componentsJoinedByString:@""]);//arr ABCDE
    
}

@end
