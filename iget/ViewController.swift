//
//  ViewController.swift
//  iget
//
//  Created by alfredking on 2018/11/28.
//  Copyright © 2018年 alfredking. All rights reserved.
//

import UIKit


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


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //在 Arrays.swift 中,主要定义了 Array, ContiguousArray 和ArraySlice 三种public 类型,它们具有相同的接口,而且结构和行为也很类似
        let say="hello swift"
        print(say)
        let nums=[1,2,3]
        print(nums)
        let nums1=[Int](repeating:0,count:5)
        print(nums1)
        var nums2=[3,1,2,4,6,7,1,2,8,9]
        print(nums2)
        nums2.append(4)
        print(nums2)
        
        nums2.sort()
        print(nums2)
        
        nums2.sort(by: >)
        print(nums2)
        
        let anotherNums=Array(nums2[0..<nums2.count-1])
        print(anotherNums)
        let result=Dictionary("hello".map { ($0, 2) }, uniquingKeysWith: +)
        print(result)
        
        

        let test=twoSum(nums: [3,1,2,4,6,7,1,2,8,9],target:5)
        print(test)
        
        
        
        
        
    }


}

