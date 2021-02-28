//
//  TestModel.m
//  testbutton
//
//  Created by lmcqc on 2020/11/17.
//  Copyright © 2020 大碗豆. All rights reserved.
//

#import "TestModel.h"


@implementation TestModel

//注意： forwardInvocation:方法只有在消息接收对象中无法正常响应消息时才会被调用。 所以，如果我们希望一个对象将testMethod消息转发给其它对象，则这个对象不能有testMethod方法。否则，forwardInvocation:将不可能会被调用。
-(NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
    {
      if (aSelector == @selector(testMethod))
      {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
       }
      return nil;
  }

-(void)forwardInvocation:(NSInvocation *)anInvocation
 {
    if (anInvocation.selector == @selector(testMethod))
    {
        TestModelHelper1 *h1 = [[TestModelHelper1 alloc] init];
        TestModelHelper2 *h2 = [[TestModelHelper2 alloc] init];
        [anInvocation invokeWithTarget:h1];
        [anInvocation invokeWithTarget:h2];
    }
 }

//- (void)forwardInvocation:(NSInvocation *)anInvocation
//{
//    if ([self respondsToSelector:
//         [anInvocation selector]]){
//
//        [anInvocation invokeWithTarget:self];
//    } else{
//        TestModelHelper1 *h1 = [[TestModelHelper1 alloc] init];
//        [anInvocation invokeWithTarget:h1];
//    }
//}
//
//- (NSMethodSignature*)methodSignatureForSelector:(SEL)selector
//{
//    NSMethodSignature* signature = [super methodSignatureForSelector:selector];
//    if (!signature) {
//        TestModelHelper1 *h1 = [[TestModelHelper1 alloc] init];
//        signature = [h1 methodSignatureForSelector:selector];
//    }
//    return signature;
//}
@end




@implementation TestModelHelper1
-(void)testMethod
{
    NSLog(@"i am TestModelHelper1");
}
@end



@implementation TestModelHelper2
-(void)testMethod
{
    NSLog(@"i am TestModelHelper2");
}
@end
