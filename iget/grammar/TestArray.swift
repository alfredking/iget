//
//  TestArray.swift
//  iget
//
//  Created by alfredking－cmcc on 2019/10/11.
//  Copyright © 2019 alfredking. All rights reserved.
//p28

import UIKit

class TestArray: NSObject {
    func test()
    {
        
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
        
        
        //数组是深拷贝
        var arr=[0,0,0]
        var newArr = arr
        arr[0]=1
        print(arr)
        print(newArr)
        
    }
    

}
