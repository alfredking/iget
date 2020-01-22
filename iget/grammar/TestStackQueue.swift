//
//  TestStackQueue.swift
//  iget
//
//  Created by alfredking－cmcc on 2019/10/19.
//  Copyright © 2019 alfredking. All rights reserved.
//p29 p40

import UIKit

class TestStackQueue: NSObject {
    
    func test()
    {
        print("**************队列栈测试*********************")
        var teststack=MyStack()
        teststack.push(object: 3)
        teststack.push(object: 5)
        teststack.push(object: 7)
        teststack.push(object: 9)
        
        print(teststack)
        print((teststack.peak)!)
        teststack.push(object: 34)
        teststack.push(object: 10)
        print((teststack.pop())!)
        print(teststack)
        print((teststack.peak)!)
        
        print(simplifyPath("/a/./b/../../home/"))
        print(simplifyPath("/a/./b/c/123/home/"))
        
    }

}

//https://www.jianshu.com/p/a2a2fbe4ca29#

//associatedtype字面上来理解，就是相关类型。意思也就是被associatedtype关键字修饰的
//变量，于一个占位符，而不能表示具体的类型。具体的类型需要让实现的类来指定。
protocol Stack
{
    associatedtype Element
    var isEmpty :Bool {get}
    var size:Int {get}
    var peak: Element? {get}
    
    mutating func push(_ newElement: Element)
    mutating func pop()->Element?
    
}

struct integerStack:Stack
{
    typealias Element = Int
    var isEmpty: Bool { return stack.isEmpty }
    var size: Int {return stack.count}
    var peak: Element? {return stack.last}
    private var stack = [Element]()
    
    mutating func push(_ newElement: Element)
    {
        stack.append(newElement)
    }
    
    mutating func pop() -> Element?
    {
        return stack.popLast()
    }
    
}

protocol Queue
{
    associatedtype Element
    var isEmpty : Bool {get}
    var size : Int {get}
    var peak : Element? {get}
    
    mutating func enqueue(_ newElement :Element)
    mutating func dequeue()->Element?
    
}

//一个数组right入队，一个反转right之后的left数组出队
struct integerQueue:Queue
{
    typealias Element = Int
    
    private var left=[Element]()
    private var right=[Element]()
    
    var isEmpty: Bool {return left.isEmpty&&right.isEmpty}
    var size: Int {return left.count+right.count}
    var  peak:  Element? {return left.isEmpty ? right.first : left.last}
    
    mutating func enqueue(_ newElement: Element)
    {
        right.append(newElement)
    }
    
    mutating func dequeue() -> Element?
    {
        if left.isEmpty
        {
            left=right.reversed()
            right.removeAll()
        }
        return left.popLast()
    }
    
    
    
    
    
}

func simplifyPath(_ path : String)->String
{
    var pathStack = [String]()
    let paths = path.components(separatedBy: "/")
    
    for path in paths
    {
        guard path != "."
            else
        {
            continue
        }
        
        if path == ".."
        {
            if(pathStack.count>0)
            {
                pathStack.removeLast()
            }
        }
        else if (path != "")
        {
            pathStack.append(path)
        }
    }
    
    
    print(pathStack)
    
    //难道是闭包编程？
    let res = pathStack.reduce(""){total,dir in "\(total)/\(dir)"}
    
    print(res)
    
    return res.isEmpty ? "/" : res
    
    
}


struct MyQueue
{
    var stackA : integerStack
    var stackB : integerStack
    
    var isEmpty : Bool
    {
        return stackA.isEmpty && stackB.isEmpty
    }
    
    var peak : Any?
    {
        mutating get
        {
            shift()
            return stackB.peak
        }
        
    }
    
    var size : Int
    {
        get
        {
            return stackA.size+stackB.size
        }
    }
    
    init()
    {
        stackA=integerStack()
        stackB=integerStack()
    }
    
    mutating func enqueue (object : Any)
    {
        stackA.push(object as! integerStack.Element)
    }
    
    mutating func dequeue() -> Any?
    {
        shift()
        return stackB.pop()
    }
    
    fileprivate mutating func shift()
    {
        if stackB.isEmpty
        {
            while !stackA.isEmpty
            {
                stackB.push(stackA.pop()!)
            }
        }
    }
    
    
}


//出栈的时候把A队列的元素出队到B只留一个，完成之后从B恢复恢复到A
struct MyStack
{
    var queueA : integerQueue
    var queueB : integerQueue
    
    init()
    {
        queueA=integerQueue()
        queueB=integerQueue()
    }
    
    var isEmpty : Bool
    {
        return queueA.isEmpty && queueB.isEmpty
    }
    
    var peak : Any?
    {
        mutating get
        {
            shift()
            let peakObj = queueA.peak
            queueB.enqueue(queueA.dequeue()!)
            swap()
            return peakObj
            
        }
    }
    
    var size :Int
    {
        return queueA.size
    }
    
    mutating func push(object : Any)
    {
        queueA.enqueue(object as! integerQueue.Element)
    }
    
    mutating func pop() -> Any?
    {
        shift()
        let popObject = queueA.dequeue()
        swap()
        return popObject
        
    }
    
    private mutating func shift()
    {
        while queueA.size != 1
        {
            queueB.enqueue(queueA.dequeue()!)
        }
    }
    
    private mutating func swap()
    {
        (queueA,queueB) = (queueB,queueA) //swift元组
    }
    
}

