//
//  POP.swift
//  iget
//
//  Created by alfredking－cmcc on 2019/9/29.
//  Copyright © 2019 alfredking. All rights reserved.
//

import UIKit

class POP: NSObject {
    
    func test()
    {
//    struct MyStruct:SomethingHandleable {
//
//    }
            struct MyStruct:SomethingHandleable {
            func handleSomething() {
            print("Called in struct")
            }
            }
    let myStruct = MyStruct.init()   //输出： Called
        myStruct.handleSomething()
    

//    MyStruct.handleSomething()    //输出： Called in struct
    }
    
    

}

extension Array where Element:Comparable{
    public var isSorted:Bool{
        var previousIndex = startIndex
        var currentIndex = startIndex+1
        
        while currentIndex != endIndex {
            if(self[previousIndex]>self[currentIndex]){
            return false
        }
        
        previousIndex = currentIndex
        currentIndex = currentIndex + 1
        
        
    }
    return true
}
}

func binarySearch<T: Comparable>(sortedElements: [T],for element: T)->Bool{
    //确保输入数组是按序排列的
    assert(sortedElements.isSorted)
    
    var lo = 0 ,hi = sortedElements.count - 1
    
    while lo <= hi {
        let mid  = lo + (hi - lo)/2
        
        if sortedElements[mid] == element{
            return true
        }else if sortedElements[mid] < element{
            lo = mid + 1
        } else {
            hi = mid - 1
        }
        
        
    }
    return false
}

protocol SomethingHandleable {
    func handleSomething()
}

//POP相比OOP更加灵活 在Swift2以后，我们可以对一个已有的protocol进行扩展。而扩展中实现的方法作为“实现扩展的类型”的“默认实现”
// 通过提供protocol的extension,我们为protocol提供了默认实现，这相当于“变相”将protocol中的方法设定为了optional
extension SomethingHandleable{
    func handleSomething(){
        // 实现
        print("Called")    }
}


//POP相比OOP可以减少依赖
protocol Request {
    func send(request:Info)
}

protocol Info {
    
}

class UserRequest: Request {
    
    func send(request:Info)  {
        //实现
    }
}

class Userinfo: Info {
    
}

class MockUserRequest: Request {
    func send(request: Info) {
        
    }
}

func testUserRequest() {
    let userRequest = MockUserRequest()
    userRequest.send(request: Userinfo())
    
}

//POP相比OOP可以消除动态派发的风险 swift必须实现所有方法，否则报错


//pop优化代码
protocol Animal {
    
    //associatedtype就是关联类型，实际上是一个类型的占位符，可以让dog和cat来指定foodtype到底是什么类型
    associatedtype FoodType:Food
    
    func greet(other: Self)
    func eat(food: FoodType)
    //func eat(food: Food) 没法编译通过
}

protocol Food {
    
}

struct Fish:Food {
    
}

struct Bone:Food {
    
}

struct Dog:Animal {
    func eat(food: Bone) {
        
    }
    
    func greet(other: Dog) {
        print("汪～")
    }
}

struct Cat:Animal {
    func eat(food:Fish)  {
        
    }
    
    func greet(other: Cat) {
        print("喵～")
    }
}
