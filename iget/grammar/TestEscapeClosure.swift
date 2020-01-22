//
//  TestEscapeClosure.swift
//  iget
//
//  Created by alfredking－cmcc on 2019/10/29.
//  Copyright © 2019 alfredking. All rights reserved.
//

import UIKit

class TestEscapeClosure: NSObject {

    
    func test()
    {
        //https://blog.csdn.net/super_niuxinhuai/article/details/81361958
        changedMap { (source) in
            print("逃逸闭包拿到的结果是\(source)")
        }
    }
    
    //逃逸闭包的例子
    func changedMap(block: @escaping (_ result: Int) ->Swift.Void){
        DispatchQueue.global().async {
            print("逃逸闭包异步的走\(Thread.current)")
            DispatchQueue.main.async {
                print("逃逸闭包主线程的走\(Thread.current)")
                block(99)
            }
        }
        print("逃逸闭包结束了的走")
    }
}
