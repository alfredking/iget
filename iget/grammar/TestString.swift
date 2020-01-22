//
//  TestString.swift
//  iget
//
//  Created by alfredking－cmcc on 2019/10/19.
//  Copyright © 2019 alfredking. All rights reserved.
//p32

import UIKit

class TestString: NSObject {
    func test()
    {
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
        
        let hello=_reverseWords("hello alfred king")
        print(hello!)
        
        let re=isStrNum(str:mstr)
        print(re)
    }
    
    func isStrNum(str:String)->Bool
    {
        return Int(str) != nil
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
    

}
