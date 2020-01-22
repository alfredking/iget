//
//  TestDictionarySet.swift
//  iget
//
//  Created by alfredking－cmcc on 2019/10/19.
//  Copyright © 2019 alfredking. All rights reserved.
//p30

import UIKit

class TestDictionarySet: NSObject {
    
    func test()
    {
        
        let primeNums: Set = [3, 5, 7, 11, 13]
        let oddNums: Set = [1, 3, 5, 7, 9]
        
        //交集、并集、差集
        let primeAndOddNum = primeNums.intersection(oddNums)
        print(primeAndOddNum)
        
        let primeOrOddNum = primeNums.union(oddNums)
        print(primeOrOddNum)
        
        let oddNotPrimNum = oddNums.subtracting(primeNums)
        print(oddNotPrimNum)
        
        
        
        let result=Dictionary("hello".map { ($0, 2) }, uniquingKeysWith: +)
        print(result)
        
        let test=twoSum(nums: [3,1,2,4,6,7,1,2,8,9],target:5)
        print(test)
    }
    
    
    func twoSumSet(nums: [Int], target: Int) -> [Int]
    {
        var dict = [Int: Int]()
        
        for (i, num) in nums.enumerated()
        {
            if let lastIndex = dict[target - num]
            {
                return [lastIndex, i]
            }
            else
            {
                dict[num] = i
                print([i,num])
            }
        }
        
        fatalError("No valid output!")
    }
    
    func twoSum(nums: [Int], target: Int) -> Bool {
        var set = Set<Int>()
        
        for num in nums {
            if set.contains(target - num) {
                return true
            }
            
            set.insert(num)
        }
        
        return false
    }
    
}
