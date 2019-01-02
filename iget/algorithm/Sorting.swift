//
//  Sorting.swift
//  iget
//
//  Created by alfredking－cmcc on 2018/12/30.
//  Copyright © 2018 alfredking. All rights reserved.
//

import UIKit
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
    
    //遍历排序之后的原数组，并与结果数组归并
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
