//
//  TestPropertyInversion.swift
//  iget
//
//  Created by alfredking－cmcc on 2019/10/29.
//  Copyright © 2019 alfredking. All rights reserved.
//

import UIKit

class TestPropertyInversion: NSObject {
    
    func test()
    {
        let highPriorityQueue = DispatchQueue.global(qos: .userInitiated)
        let lowPriorityQueue = DispatchQueue.global(qos: .utility)
        
        let semaphore = DispatchSemaphore(value: 1)
        semaphore.wait() //放在这里可以改变顺序
        lowPriorityQueue.async {
            //semaphore.wait() 放这里不改变顺序
            for i in 0...10{
                print(i)
            }
            semaphore.signal()
        }
        
        highPriorityQueue.async {
            semaphore.wait()
            for i in 11...20{
                print(i)
            }
            semaphore.signal()
        }
        
        
        
    }

}
