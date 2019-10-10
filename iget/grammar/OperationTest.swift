//
//  OperationTest.swift
//  iget
//
//  Created by alfredking－cmcc on 2019/9/16.
//  Copyright © 2019 alfredking. All rights reserved.
//

import UIKit

class OperationTest: NSObject {
    
    func testCancel() {
        let queue = OperationQueue()
        let sumOperation = ArraySumOperation(nums: Array(1...1000))
        
        //一旦加入Operationqueue中，operation就开始执行
        queue.addOperation(sumOperation)
        
        
        for num in 1...100 {
            print(num)
        }
        sumOperation.cancel()
        
        sumOperation.completionBlock = {print(sumOperation.sum)}
        
        
    }

}

class ArraySumOperation: Operation {
    
    let nums:[Int]
    var sum:Int
    
    init(nums:[Int])
    {
        self.nums = nums
        self.sum = 0
        super.init()
    }
    
    override func main() {
        for num in nums {
            if isCancelled
            {
                return
            }
            sum += num
        }
    }
    
    
    
}
