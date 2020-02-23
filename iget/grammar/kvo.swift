//
//  kvo.swift
//  iget
//
//  Created by alfredking－cmcc on 2019/9/29.
//  Copyright © 2019 alfredking. All rights reserved.
//p173 kvo

import UIKit

class kvo: NSObject {
    
    func test()  {
        let user = KvoUser(email: "user@hotmail.com")
        let observation = user.observe(\.email){(user,change) in
            print("user's new email:\(user.email)")
        }
        
        user.email = "user@outlook.com"
        
        
    }

}

@objcMembers class KvoUser:NSObject{
    //dynamic 关键词对observe的闭包来说是必须的
    dynamic var email :String
    
     init(email: String) {
        self.email = email
    }
}
