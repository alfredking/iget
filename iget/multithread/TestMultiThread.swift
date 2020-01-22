//
//  TestMultiThread.swift
//  iget
//
//  Created by alfredking－cmcc on 2019/10/27.
//  Copyright © 2019 alfredking. All rights reserved.
//

import UIKit

class TestMultiThread: NSObject {
    
    func test()
    {
        testSerial()
        testConcurrent()
        
    }

    
    //https://www.jianshu.com/p/745ef335e8cc 比较好的解释
    func testSerial()
    {
        let serialQueue = DispatchQueue(label: "dispatch_demo.tsaievan.com")
        let mainQueue = DispatchQueue.main
        let sAdd = String(format: "%p", serialQueue)
        let mAdd = String(format: "%p", mainQueue)
        //        serialQueue.sync {
        //            print("\(Thread.current)========1==== sAdd = \(sAdd)===== mAdd = \(mAdd)")
        //        }
        //        print("\(Thread.current)========2")
        //        serialQueue.sync {
        //            print("\(Thread.current)========3")
        //        }
        //        print("\(Thread.current)========4")
        
        
        
        //        serialQueue.async {
        //            print("\(Thread.current)========1==== sAdd = \(sAdd)===== mAdd = \(mAdd)")
        //        }
        //        print("\(Thread.current)========2")
        //        serialQueue.async {
        //            print("\(Thread.current)========3")
        //        }
        //        print("\(Thread.current)========4")
        //
        
        
        //        //串行同步
        //        serialQueue.sync{
        //            print(1)
        //        }
        //
        //        print(2)
        //
        //        serialQueue.sync{
        //            print(3)
        //        }
        //        print(4)
        
        
        //        //串行异步
        serialQueue.async {
            sleep(3)
            print(1)
        }
        
        print(2)
        serialQueue.async {
            print(3)
        }
        print(4)
        
        
        //        //串行异步中嵌套同步
        //        print(1)
        //        serialQueue.async {
        //            print(2)
        //            serialQueue.sync {
        //                print(3)
        //            }
        //            print(4)
        //        }
        //
        //        print(5)
        
        
        //串行同步中嵌套异步
        //        print(1)
        //        serialQueue.sync {
        //            print(2)
        //            serialQueue.async {
        //                print(3)
        //            }
        //            print(4)
        //        }
        //        print(5)
    }
    
    
    func testConcurrent()
    {
        let concurrentQueue = DispatchQueue(label: "com.leo.concurrentQueue",
                                            attributes:.concurrent)
        
        //并行同步
        //        concurrentQueue.sync {
        //            print(1)
        //        }
        //        print(2)
        //        concurrentQueue.sync {
        //            print(3)
        //        }
        //        print(4)
        
        //并行异步
        //        concurrentQueue.async {
        //            //增加延时操作可以让3出现在1之前，串行队列中无法实现
        //            sleep(3)
        //            print(1)
        //        }
        //        print(2)
        //        concurrentQueue.async {
        //            print(3)
        //
        //        }
        //        print(4)
        
        //并行异步中嵌套同步
        //        print(1)
        //        print("\(Thread.current)========1")
        //        concurrentQueue.async {
        //            print(2)
        //
        //             print("\(Thread.current)========2")
        //            concurrentQueue.sync {
        //                print(3)
        //                 print("\(Thread.current)========3")
        //            }
        //            print(4)
        //             print("\(Thread.current)========4")
        //        }
        //        print(5)
        //         print("\(Thread.current)========5")
        //        //并行同步中嵌套异步
        //        print(1)
        //        print("\(Thread.current)========1")
        //        concurrentQueue.sync {
        //            print(2)
        //            print("\(Thread.current)========2")
        //            concurrentQueue.async {
        //                print(3)
        //                print("\(Thread.current)========3")
        //            }
        //            print(4)
        //            print("\(Thread.current)========4")
        //        }
        //        print(5)
        //        print("\(Thread.current)========5")
    }
}
