//
//  TestMultiThread.swift
//  iget
//
//  Created by alfredking－cmcc on 2019/10/27.
//  Copyright © 2019 alfredking. All rights reserved.
//p154 串行并行

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
        
        
        
        //串行队列同步执行
        //        serialQueue.sync {
        //            print("\(Thread.current)========1==== sAdd = \(sAdd)===== mAdd = \(mAdd)")
        //        }
        //        print("\(Thread.current)========2")
        //        serialQueue.sync {
        //            print("\(Thread.current)========3")
        //        }
        //        print("\(Thread.current)========4")
        //结果是1234顺序来
        
        
        
        //串行队列异步执行
        //        serialQueue.async {
        //            print("\(Thread.current)========1==== sAdd = \(sAdd)===== mAdd = \(mAdd)")
        //        }
        //        print("\(Thread.current)========2")
        //        serialQueue.async {
        //            print("\(Thread.current)========3")
        //        }
        //        print("\(Thread.current)========4")
        //结果是2在4前面，1在3前面
        
        
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
        
        
        //        //串行异步中嵌套同步会造成死锁
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
                concurrentQueue.sync {
                    print(1)
                }
                print(2)
                concurrentQueue.sync {
                    print(3)
                }
                print(4)
        //结果是1234顺序执行
        
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
        //2在4前，1和3顺序不确定
        
        //并行异步中嵌套同步
        // 同步不会创建新线程，异步创建新线程，串行创建一个线程，并行创建多个线程
        //https://www.jianshu.com/p/6d394e5ca6aa
//                print("并行异步中嵌套同步")
//                print(1)
//                print("\(Thread.current)========1")
//
//
//                concurrentQueue.async {
//                    print(2)
//
//                     print("\(Thread.current)========2")
//                    concurrentQueue.sync {
//                        print(3)
//                         print("\(Thread.current)========3")
//                    }
//                    print(4)
//                     print("\(Thread.current)========4")
//                }
//                print(5)
//                 print("\(Thread.current)========5")
//
        
                //并行同步中嵌套异步
                print("并行异步中嵌套同步")
                print(1)
                print("\(Thread.current)========1")
                concurrentQueue.sync {
                    print(2)
                    print("\(Thread.current)========2")
                    concurrentQueue.async {
                        print(3)
                        print("\(Thread.current)========3")
                    }
                    print(4)
                    print("\(Thread.current)========4")
                }
                print(5)
                print("\(Thread.current)========5")
    }
}
