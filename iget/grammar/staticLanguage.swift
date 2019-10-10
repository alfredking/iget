//
//  staticLanguage.swift
//  iget
//
//  Created by alfredking－cmcc on 2019/8/16.
//  Copyright © 2019 alfredking. All rights reserved.
//

import UIKit


protocol Chef {
//    func makeFood()
    
}

extension Chef {
    func makeFood()
    {
        print("make food")
        
    }
    
}

struct SeafoodChef :Chef{
    func makeFood()
    {
        print("cook sea food")
        
    }
    
}


func testStaticLanguage()
{
    let chefOne :Chef = SeafoodChef()
    
    let chefTwo :SeafoodChef = SeafoodChef()
    
    //swift中协议是动态派发，扩展中是静态派发，协议中如果有方法声明，那么方法会根据对象的实际类型进行调用，如果protocol中没有声明make food方法，那么会输出make food和cook seafood
    chefOne.makeFood()
    chefTwo.makeFood()
}



class staticLanguage: NSObject {

}
