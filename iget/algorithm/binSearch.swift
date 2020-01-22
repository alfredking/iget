//
//  binSearch.swift
//  iget
//
//  Created by alfredking－cmcc on 2018/12/31.
//  Copyright © 2018 alfredking. All rights reserved.
//p57

import UIKit

class binSearch: NSObject
{
func test()
{
    
    let number = [8, 9, 10, 11]
    let result = hasAnyMatches(list: number, condition: lessThanTen)
    print(result)
    
    print("inser index is ")
    let singleNews = News("new",Date())
    let news1 = News("new",Date(timeIntervalSinceNow: -5 * 60))
    let news2 = News("new",Date(timeIntervalSinceNow: 5 * 60))
    var news = [News]()
    news.append(news1)
    news.append(news2)
    for ne in news
    {
        print(ne.date)
    }
    let insertIdx = news.indexForInsertingObject(object:singleNews){(a,b)->Int in
        let newsA = a as! News
        let newsB = b as! News
        return newsA.compareDate(newsB)
        
    }
    print("inser index is ")
    news.insert(singleNews,at:insertIdx)
    
    for ne in news
    {
        print(ne.date)
    }
    
    
}




//p61寻找版本崩溃伪代码不需要实现
//func findFirstBadVersion(version: n) -> Int {
//    // 处理特殊情况
//    guard n >= 1 else {
//        return -1
//    }
//
//    var left = 1, right = n, mid = 0
//
//    while left < right {
//        mid = (right - left) / 2 + left
//        if isBadVersion(mid) {
//            right = mid
//        } else {
//            left = mid + 1
//        }
//    }
//
//    return left    // return right 同样正确
//}




func hasAnyMatches(list:[Int], condition:(Int) -> Bool) ->Bool {
    for item in list {
        if condition(item) {
            return true;
        }
    }
    return false;
}


func lessThanTen(number: Int) ->Bool {
    return number < 10
}


}

//p64新闻类按照时间顺序插入
extension Array
{
    func indexForInsertingObject(object: AnyObject, compare: ((AnyObject,AnyObject) -> Int)) ->Int
    {
        var left = 0
        var right = self.count
        var mid = 0
        print("right is")
        print(right)
        while left<right
        {
            mid = (right-left)/2+left
            
            if compare(self[mid] as AnyObject,object)<0
            {
                left = mid+1
            }
            else
            {
                right=mid
            }
        }
        
        return left
    }
}

class News: NSObject
{
    let message : String
    let date : Date
    init(_ mes:String,_ date:Date)
    {
        self.message=mes
        self.date=date
    }
}

extension News
{
    func compareDate( _ news:News)->Int
    {
        if self.date > news.date
        {
            return 1
        }
        else
        {
            return -1
        }
    }
}


func binarySearchInt(_ nums : [Int],_ target : Int)->Bool
{
    var left = 0,mid = 0,right = nums.count-1
    
    while left <= right
    {
        mid = (right-left)/2+left
        
        if nums[mid]==target
        {
            return true
        }
        else if nums[mid]<target
        {
            left = mid+1
        }
        else
        {
            right = mid - 1
        }
    }
    return false
}

//递归实现二分搜索
func binarySearchIntRecusive(nums : [Int],target : Int)->Bool
{
    return binarySearch(nums: nums, target:target,left:0,right:nums.count-1)
}

func binarySearch(nums:[Int],target:Int,left:Int,right:Int)->Bool
{
    guard left <= right
        else
    {
        return false
    }
    
    let mid = (right-left)/2+left
    
    if nums[mid] == target
    {
        return true
    }
    else if nums[mid] < target
    {
        return binarySearch(nums: nums, target: target, left: mid+1, right: right)
    }
    else
    {
        return binarySearch(nums: nums, target: target, left: left, right: mid-1)
    }
    
}


//p62搜索旋转有序数组，旋转之后大部分还是有序的，本质上还是判断旋转之后数据增加的方向
//据此判断怎么更新left、right的值
func search(_ nums:[Int],_ target:Int)->Int
{
    var (left,mid,right) = (0,0,nums.count-1)
    
    while left <= right
    {
        mid = (right-left)/2 + left
        
        print(left)
        print(mid)
        print(right)
        if nums[mid] == target
        {
            return mid
        }
        
        if nums[mid] >= nums[left]  //左边有序
        {
            if nums[mid]>target&&target>=nums[left] //target落在mid左边
            {
                right = mid-1
            }
            else
            {
                left = mid+1
            }
        }
        else  //右边有序
        {
            if nums[mid]<target&&target <= nums[right] //target落在右边
            {
                left = mid+1
            }
            else
            {
                right = mid-1
            }
        }
    }
    return -1
}
