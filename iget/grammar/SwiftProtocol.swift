//
//  SwiftProtocol.swift
//  iget
//
//  Created by alfredking－cmcc on 2019/8/14.
//  Copyright © 2019 alfredking. All rights reserved.
//p102

import UIKit


@objc protocol SomeProtocol
{
    func requiredFunc()
    @objc optional func optionalFunc()
}


//p103该协议只能由class实现，不能由struct和enum实现
protocol anotherProtocol:class
{
    func requiredFunc()
    func optionalFunc()
}
//
//相当于给出一个默认实现
//extension anotherProtocol
//{
//    func optionalFunc()
//    {
//
//        print("Dumb Implementation")
//    }
//}

class SwiftProtocol: SomeProtocol {
    
    
    func requiredFunc() {
        print("Only need to implement the required")
    }
    
}


// p105演示swift初始化方法 https://www.jianshu.com/p/95ba207b729e
class Person {
    var name:String
    var age:Int
    var sex:Bool
    
    //Designated Initializers参数最多的那个初始化方法一般就是指定初始化方法
    init(name:String, age:Int, sex:Bool) {
        self.name = name
        self.age = age
        self.sex = sex
    }

//    //Convenience Initializers
//    convenience init(name:String) {
//        self.init(name:name, age:18, sex:true)
//    }
    
    //Failable initializer
//    可选初始化方法是一种可能会返回nil的初始化方法，它的关键字是在init后边加一个可选符号？。下面的例子展示了一个可选初始化方法，当创建的实例的年龄为负数时，显然是不符合实际情况的，这时候返回nil。
//    init?(name:String, age:Int, sex:Bool) {
//        self.name = name
//        self.age = age
//        self.sex = sex
//
//        if age < 0 {
//            return nil
//        }
//    }
}


class Student: Person {
    
    var score:CGFloat
    //指定初始化方法必须调用父类的指定初始化方法（如果有父类的话）
    init(name:String, age:Int, sex:Bool, score:CGFloat) {
        self.score = score
        super.init(name: name, age: age, sex: sex)
    }
    
    func sayHello() {
        print("I am a student, name:\(name), age:\(age)")
    }
}


func testinit()
{
//  let stu = Student(name: "stu", age: 10, sex: true)
//  stu.sayHello()
////I am a student, name:stu, age:10
//required初始化方法必须被重写
    
    let stu = Student(name: "stu", age: 10, sex: true, score: 99)
    stu.sayHello()
}


