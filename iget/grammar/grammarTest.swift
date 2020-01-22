//
//  grammarTest.swift
//  iget
//
//  Created by alfredking－cmcc on 2019/7/30.
//  Copyright © 2019 alfredking. All rights reserved.
//

import Foundation


//p87
func test_copy_on_write()
{
    print("test_copy_on_write")
    
    let arrayA = [1,2,3]
    
    print(UnsafeRawPointer(arrayA))
    
    var arrayB = arrayA
    
    print(UnsafeRawPointer(arrayB))
    
    arrayB.append(4)
    
    print(UnsafeRawPointer(arrayB))
    
}



//p87
func test_property_observer()
{
    var title : String = "test"  //此处必须赋初始值，要不然会报错
    {
        willSet
        {
            print("将标题从\(title)设置到\(newValue)")
        }
        
        didSet
        {
            print("已将标题从\(oldValue)设置到\(title)")
        }
    }
    
    title = "first title"
}


//p88 MARK: - 在结构体中修改成员变量的方法
protocol Pet
{
    var name : String {get set}
    
}

struct MyDog : Pet
{
    var name: String
    
    mutating func changeName(name:String)  //mutating表示方法会修改结构体中的成员变量，类不存在这个问题，因为类可以随意修改自己的成员变量
    {
        self.name = name
    }
}

//p88 MARK: - @autoclosure 用swift实现或操作
//_表示不需要显式指定参数 https://www.jianshu.com/p/e78e9d12dba1
func or1(_ value1: Bool, _ value2: Bool) -> Bool
{
    if value1 {
        return true
    }
    if value2 {
        return true
    }
    
    return false
}


func or2(_ value1: Bool, _ value2: () -> Bool) -> Bool
{
    if value1
    {
        return true
    }
    return value2()
}


func or3(_ value1: Bool, _ value2: @autoclosure() -> Bool) -> Bool
{
    if value1
    {
        return true
    }
    return value2()
}

func testOr()
{
    //let vLeft = 31 < 12    // 代表操作符左侧的值
    let vLeft = 31 > 12    // 代表操作符左侧的值
    // 代表操作符右侧的值
    func getRightRes() -> Bool {
        print("getting the right value...")
        return 2 < 10
    }
    
    let result1 = vLeft||getRightRes()
    print("result1 is \(result1) ")
    
    let result2 = or1(vLeft,getRightRes())
    print("result2 is \(result2) ")
    
    
    var result3 = or2(vLeft) { () -> Bool in
        return getRightRes()
    }
    print("result3 is \(result3) ")
    
    
    result3 = or2(vLeft) {
        getRightRes()
    }
    print("result3 is \(result3) ")


    
    let result4 = or3(vLeft, getRightRes())
    print("result4 is \(result4) ")
    

}


//p89 MARK: - swift 柯里化currying
func add(_ num:Int)->(Int)->Int
{
     print("num is \(num)")
    return {val in
        return num+val;
    }
    
   
}

func testCurrying()
{
let addTwo = add(2)
let resultAddTwo = addTwo(3)
print("addTwo result is \(resultAddTwo)")
}

//p90MARK: - 函数式编程
func testFunc()
{

  //求0到100中为偶数且恰好是其他数字平方的数字
    let res =  (0...10).map { $0*$0 }.filter {$0 % 2 == 0}

 print("res is \(res)")
    
}
