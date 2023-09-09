//
//  UIViewController+Tracking.m
//  iget
//
//  Created by alfredking－cmcc on 2021/1/30.
//  Copyright © 2021 alfredking. All rights reserved.
//

#import "UIViewController+Tracking.h"
#import <objc/runtime.h>
#import "IgetUtils.h"
@implementation UIViewController(Tracking)
//http://satanwoo.github.io/2017/11/27/KVO-Swizzle/?hmsr=toutiao.io&utm_campaign=toutiao.io&utm_medium=toutiao.io&utm_source=toutiao.io
+ (void)load {
    
    NSLog(@"Tracking load function called");
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        Class class = [self class];
//        // When swizzling a class method, use the following:
//        // Class class = object_getClass((id)self);
//        SEL originalSelector = @selector(viewWillAppear:);
//        SEL swizzledSelector = @selector(track_viewWillAppear:);
//        Method originalMethod = class_getInstanceMethod(class, originalSelector);
//        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
//        BOOL didAddMethod = class_addMethod(class,
//                originalSelector,
//                method_getImplementation(swizzledMethod),
//                method_getTypeEncoding(swizzledMethod));
//        if (didAddMethod) {
//            class_replaceMethod(class,
//                swizzledSelector,
//                method_getImplementation(originalMethod),
//                method_getTypeEncoding(originalMethod));
//        } else {
//            method_exchangeImplementations(originalMethod, swizzledMethod);
//        }
//    });
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        iget_swizzleSelector([self class], @selector(viewDidLoad), @selector(wzq_viewDidLoad:));
//        iget_swizzleSelector([self class], @selector(initWithNibName:bundle:), @selector(wzq_initWithNibName:bundle:));
//        iget_swizzleSelector([self class], @selector(initWithCoder:), @selector(wzq_initWithCoder:));
        iget_swizzleSelector([self class], @selector(init), @selector(wzq_init));
       
    });
}

//+(void)initialize
//{
//    NSLog(@"self:%@  Tracking initialize called",[self class]);
//}

#pragma mark - Method Swizzling
- (void)track_viewWillAppear:(BOOL)animated {
    [self track_viewWillAppear:animated];
    NSLog(@"alfredking custom viewWillAppear: %@", self);
}


//- (void)wzq_viewDidLoad
//{
//    NSDate *date = [NSDate date];
//    [self wzq_viewDidLoad];
//
//    NSTimeInterval duration = [[NSDate date] timeIntervalSinceDate:date];
//    NSLog(@"Page %@ cost %f in viewDidLoad", [self class], duration);
//}

-(instancetype)wzq_init
{
    [self wzq_init];
    NSLog(@"wzq_init called");
    NSString *identifier = [NSString stringWithFormat:@"wzq_%@", [[NSProcessInfo processInfo] globallyUniqueString]];
    [self addObserver:[NSObject new] forKeyPath:identifier options:NSKeyValueObservingOptionNew context:nil];
    // NSKVONotifying_ViewController
    Class kvoCls = object_getClass(self);
    // ViewController
    Class originCls = class_getSuperclass(kvoCls);

    // 获取原来实现的encoding
    const char *originViewDidLoadEncoding = method_getTypeEncoding(class_getInstanceMethod(originCls, @selector(viewDidLoad)));
    const char *originViewDidAppearEncoding = method_getTypeEncoding(class_getInstanceMethod(originCls, @selector(viewDidAppear:)));
    const char *originViewWillAppearEncoding = method_getTypeEncoding(class_getInstanceMethod(originCls, @selector(viewWillAppear:)));

    // 重点，添加方法。
    class_addMethod(kvoCls, @selector(viewDidLoad), (IMP)wzq_viewDidLoad, originViewDidLoadEncoding);
//    class_addMethod(kvoCls, @selector(viewDidAppear:), (IMP)wzq_viewDidAppear, originViewDidAppearEncoding);
//    class_addMethod(kvoCls, @selector(viewWillAppear:), (IMP)wzq_viewWillAppear, originViewWillAppearEncoding);
    return self;
}

static void wzq_viewDidLoad(UIViewController *kvo_self, SEL _sel)
{
    Class kvo_cls = object_getClass(kvo_self);
    Class origin_cls = class_getSuperclass(kvo_cls);

    // 注意点
    IMP origin_imp = method_getImplementation(class_getInstanceMethod(origin_cls, _sel));
    assert(origin_imp != NULL);

    void(*func)(UIViewController *, SEL) =  (void(*)(UIViewController *, SEL))origin_imp;

    NSDate *date = [NSDate date];

    func(kvo_self, _sel);

    NSTimeInterval duration = [[NSDate date] timeIntervalSinceDate:date];
    NSLog(@"Class %@ cost %g in viewDidLoad", [kvo_self class], duration);
}

@end
