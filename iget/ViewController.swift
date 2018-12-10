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

fileprivate func _reverse<T>(_ chars: inout [T],_ start: Int,_ end : Int)
{
    var start = start,end = end
    while start<end
    {
        _swap(&chars,start,end)
        start+=1
        end-=1
    }
    
}

fileprivate func _swap<T>(_ chars :inout [T],_ p:Int,_ q:Int)
{
    (chars[p],chars[q])=(chars[q],chars[p])
}

func _reverseWords(_ s:String?)->String?
{
    guard let s=s else
    {
        return nil
    }
    var chars = Array(s),start=0
    _reverse(&chars, 0, chars.count-1)
    print(chars)
    
    for i in 0..<chars.count
    {
        print(i)
        if i==chars.count-1||chars[i+1]==" "
        {
            _reverse(&chars, start, i)
            start=i+2
        }
    }
    
    return String(chars)
    
}

class ListNode
{
    var val:Int
    var next:ListNode?
    
    init(_ val:Int)
    {
        self.val=val
        self.next=nil
    }
}

class List
{
    var head:ListNode?
    var tail:ListNode?
    
    func appendToTail(_ val:Int)
    {
        if tail==nil
        {
            tail=ListNode(val)
            head=tail
        }
        else
        {
            tail!.next=ListNode(val)
            tail=tail!.next
        }
    }
    
    func appendToHead(_ val:Int)
    {
        if head==nil
        {
            head=ListNode(val)
            tail=head
            
            
        }
        else
        {
            let temp=ListNode(val)
            temp.next=head
            head=temp
        }
    }
    
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
        
        let str="3"
        let num=Int(str)
        let number=3
        let string=String(number)
        print(str,num!,string,number)
        
        let len=str.count
        print(len)
        
        let char=str[str.index(str.startIndex, offsetBy: 0)]
        print(char)
        
        var mstr="123"
        mstr.remove(at:str.index(str.startIndex, offsetBy: 1))
        mstr.append("c")
        mstr+="hello WORLD"
        print(mstr)
        
        func isStrNum(str:String)->Bool
        {
            return Int(str) != nil
        }
        
        let re=isStrNum(str:mstr)
        print(re)
        
        
        let hello=_reverseWords("hello alfred king")
        print(hello!)
        
        
        
        
        
        
        
        
    }


}

