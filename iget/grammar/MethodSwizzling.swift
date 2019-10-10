//
//  MethodSwizzling.swift
//  iget
//
//  Created by alfredking－cmcc on 2019/8/18.
//  Copyright © 2019 alfredking. All rights reserved.
//

import Foundation

func  testRuntimeIssues()
{
    var balance = 0
    let fullTimeSalary = 1000, partTimeSalary = 1000
    DispatchQueue.global().async {
        for _ in 1...12
        {
            balance += partTimeSalary
        }
    }
    
    for _ in 1...12 {
        balance += fullTimeSalary
    }
    
    
}
