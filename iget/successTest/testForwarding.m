////
////  testForwarding.m
////  iget
////
////  Created by alfredking－cmcc on 2021/1/24.
////  Copyright © 2021 alfredking. All rights reserved.
////
//
//#import <Foundation/Foundation.h>
//#include <stdio.h>
//int main(int argc, char * argv[]) {
//    __block int val = 0;
//
//    printf("&val:%p, val:%d \n", &val, val);
//    
//    void (^blk)(void) = ^{
//        printf("inBlock    &val:%p, val:%d \n", &val, val);
//        ++val;
//    };
//    
//    printf("&val:%p, val:%d \n", &val, val);
//    blk();
//    printf("&val:%p, val:%d \n", &val, val);
//    ++val;
//    printf("&val:%p, val:%d \n", &val, val);
//    return 0;
//}
