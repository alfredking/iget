//
//  testKVOViewController.m
//  iget
//
//  Created by alfredking－cmcc on 2022/1/7.
//  Copyright © 2022 alfredking. All rights reserved.
//

#import "testKVOViewController.h"
#import "KVOPerson.h"
#import "QLPerson.h"
#import "TestPerson.h"
@interface testKVOViewController ()

@property (nonatomic, strong) KVOPerson *person1;

@property (nonatomic, strong) KVOPerson *person2;

@end

@implementation testKVOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.person1 = [[KVOPerson alloc] init];

    self.person1.age = 10;

    self.person2 = [[KVOPerson alloc] init];

    self.person2.age = 11;

    // 给person1对象添加KVO监听

    [self.person1 addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@"111"];
    
//    [self testKVC];
//
//    NSDictionary *dict = @{@"name":@"jack",@"age":@"18",@"height":@"178"};
//
//    TestPerson *person = [TestPerson personFromDict:dict];
//
//    NSLog(@"name:%@ age:%d height:%d",person.name, person.age, person.height);
    [self.person1 willChangeValueForKey:@"age"];
//    [self.person1 didChangeValueForKey:@"age"];
    //一定要两个同时调用才会触发kvo,估计是为了记录old和new的值
   
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.person1.age = 20;

    self.person2.age = 21;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"监听到%@对象%@值改变: %@ %@", object, keyPath, change, context);
}

- (void)dealloc
{
    [self.person1 removeObserver:self forKeyPath:@"age"];
}

-(void)testKVC
{
    @autoreleasepool {
    QLPerson *person = [[QLPerson alloc] init];

    [person setValue:@10 forKey:@"age"];

    [person setValue:@20 forKeyPath:@"height"];

    // setValue:forKeyPath:可以给person对象里面的student对象的score属性赋值

    person.student = [[QLStudent alloc] init];

    [person setValue:@99 forKeyPath:@"student.score"];

    // valueForKeyPath:可以从person对象里面的student对象的score属性取值

    NSLog(@"age:%@ height:%@ student.score:%@", [person valueForKey:@"age"], [person valueForKeyPath:@"height"], [person valueForKeyPath:@"student.score"]);

    }

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
