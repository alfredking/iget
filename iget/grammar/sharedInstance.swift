//
//  sharedInstance.swift
//  iget
//
//  Created by alfredking－cmcc on 2019/9/27.
//  Copyright © 2019 alfredking. All rights reserved.
//

import UIKit

class sharedInstance: NSObject {
    func test()
    {
        //使用方式
        AppManager.sharedInstance
//        var a1 = AppManager() //确保编译不通过
//        var a2 = AppManager() //确保编译不通过
        
    }


}

class AppManager {
    static let sharedInstance = AppManager()
    
    private init() {} // 私有化init方法
}

