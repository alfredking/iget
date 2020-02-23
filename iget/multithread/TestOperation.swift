//
//  TestOperation.swift
//  iget
//
//  Created by alfredking－cmcc on 2019/10/27.
//  Copyright © 2019 alfredking. All rights reserved.
//p164

import UIKit

class TestOperation: NSObject {

    func test()
    {
        testOperation()
        
        //cancel测试
        let operationTest : OperationTest = OperationTest.init()
        operationTest.testCancel()
        
        


        
    }
    
    
    func testOperation()
    {
        //        let multiTasks = BlockOperation()
        //        multiTasks.completionBlock = {
        //            print("所有任务完成")
        //        }
        //
        //        multiTasks.addExecutionBlock {
        //            print("任务1开始")  ;
        //            sleep(1)
        //        }
        //
        //        multiTasks.addExecutionBlock {
        //            print("任务2开始")  ;
        //            sleep(2)
        //        }
        //
        //        multiTasks.addExecutionBlock {
        //            print("任务3开始")  ;
        //            sleep(3)
        //        }
        //
        //        multiTasks.start();
        //
        
        let multiTaskQueue = OperationQueue()
        multiTaskQueue.addOperation {
            print("任务1开始")  ;
            sleep(1)
        }
        
        multiTaskQueue.addOperation {
            print("任务2开始")  ;
            sleep(2)
        }
        multiTaskQueue.addOperation {
            print("任务3开始")  ;
            sleep(3)
        }
        //阻塞当前线程直到所有操作完成
        multiTaskQueue.waitUntilAllOperationsAreFinished()
    }
}
