//
//  binSearch.swift
//  iget
//
//  Created by alfredking－cmcc on 2018/12/31.
//  Copyright © 2018 alfredking. All rights reserved.
//

import UIKit


func binarySearch(_ nums : [Int],_ target : Int)->Bool
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

func binarySearch(nums : [Int],target : Int)->Bool
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
        
        if nums[mid] >= nums[left]
        {
            if nums[mid]>target&&target>=nums[left]
            {
                right = mid-1
            }
            else
            {
                left = mid+1
            }
        }
        else
        {
            if nums[mid]<target&&target <= nums[right]
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
let number = [8, 9, 10, 11]
let result = hasAnyMatches(list: number, condition: lessThanTen)


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

func testnews()
{
    
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

