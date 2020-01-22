//
//  Sorting.swift
//  iget
//
//  Created by alfredking－cmcc on 2018/12/30.
//  Copyright © 2018 alfredking. All rights reserved.
//p54

import UIKit

//让左右两部分有序，然后合并，递归
//https://www.cnblogs.com/agui521/p/6918229.html
func mergeSort(_ array :[Int])->[Int]
{
    var helper = Array(repeating : 0, count : array.count)
    var array = array
    mergeSort(&array,&helper,0,array.count-1)
    return array
    
}

func mergeSort(_ array :inout [Int], _ helper :inout [Int],_ low : Int,_ high : Int)
{
    guard low < high
    else
    {
        return
        
    }
    
    let middle = (high-low)/2 + low
    mergeSort(&array,&helper,low,middle)
    mergeSort(&array,&helper,middle+1,high)
    merge(&array,&helper,low,middle,high)
    
}

func merge(_ array :inout [Int], _ helper :inout [Int],_ low : Int,_ middle : Int,_ high : Int)
{
    // copy both halves into a helper array
    print("merge begin")
    print(array[low...high])
    for i in low ... high
    {
        helper[i]=array[i]
    }
    
    var helperLeft = low
    var helperRight = middle+1
    var current = low
    
    //iterate through helper array and copy the right one to the original array
    while helperLeft<=middle && helperRight <= high
    {
        if helper[helperLeft] <= helper[helperRight]
        {
            array[current] = helper[helperLeft]
            helperLeft+=1
        }
        else
        {
            array[current] = helper[helperRight]
            helperRight+=1
        }
        current+=1
    }
    //handle the rest
    guard middle - helperLeft >= 0
    else
    {
        return
    }
    
    for i in 0 ... middle-helperLeft
    {
        array[current+i]=helper[helperLeft+i] //如果是右侧的话已经提前存储了
    }
    
}

//传统快速排序方法讲解https://www.runoob.com/w3cnote/quick-sort.html
func quicksort(_ array:[Int])->[Int]{
    guard array.count > 1 else {
        return array
    }
    let pivot = array[array.count/2]
    let left = array.filter{ $0 < pivot}
    let middle = array.filter{ $0 == pivot }
    let right = array.filter{ $0 > pivot}
    
    return quicksort(left) + middle + quicksort(right)
    
    
}


//解题思路https://www.jianshu.com/p/70e08f1a95c6
//p59
public class MeetingTime
{
    public var start:Int
    public var end:Int
    public init(_ start:Int,_ end:Int)
    {
        self.start=start
        self.end=end
    }
}


func mergeTime(_ meetingTimes: inout [MeetingTime])->[MeetingTime]
{
    guard meetingTimes.count>1
    else
    {
        return meetingTimes
    }
    
    //先对开始时间进行升序排列，如果它们相同，就比较结束时间。
        meetingTimes.sort() {
        if $0.start != $1.start
        {
            return $0.start < $1.start
        }
        else
        {
            return $0.end < $1.end
        }
    }
    
    var res = [MeetingTime]()
    res.append(meetingTimes[0])
    print(res[0].start)
    print(res[0].end)
    print("first element")
    
 //遍历排序之后的原数组，并与结果数组归并，每次比较原数组（排序后）当前会议时间与结果数组
 //中当前的会议时间，假如它们有重叠，则归并；如果没有，则直接添加进结果数组之中
    for i in 1...meetingTimes.count-1
    {
        let last = res[res.count-1]
        let current = meetingTimes[i]
        if current.start>last.end
        {
            res.append(current)
            print(current.start)
            print(current.end)
            print("next")
        }
        else
        {
            last.end=max(last.end, current.end)
            
            print(last.start)
            print(last.end)
            print("extended")
        }
        
    }
    return res
}
